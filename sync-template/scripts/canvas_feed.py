#!/usr/bin/env python3
"""Fetch the Canvas calendar feed and save upcoming assignments to canvas.json for ZERØ GAP.

The feed link comes from the CANVAS_FEED_URL repository secret and is never printed.
Only assignments from 3 days ago to 45 days ahead are kept. The file is rewritten only
when something changes, so the app knows when there is something new.

Optional: with a Canvas access token in the CANVAS_TOKEN secret, it also saves each
class's name and current grade, which assignments you already submitted (the app marks
those done), missing work, recent announcements (as plain text) and when the token
runs out. The token is never printed.
"""
import datetime as dt
import hashlib
import html.parser
import json
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from zoneinfo import ZoneInfo

FEED = os.environ.get("CANVAS_FEED_URL", "").strip()
TOKEN = os.environ.get("CANVAS_TOKEN", "").strip()
OUT = os.environ.get("CANVAS_OUT", "canvas.json")
API = os.environ.get("CANVAS_API", "").strip()  # only for tests; normally taken from the feed link


def unescape(value):
    return value.replace("\\n", " ").replace("\\N", " ").replace("\\,", ",").replace("\\;", ";").replace("\\\\", "\\").strip()


def parse_start(value, params):
    value = value.strip()
    if re.fullmatch(r"\d{8}", value):
        y, m, d = int(value[0:4]), int(value[4:6]), int(value[6:8])
        return {"date": f"{value[0:4]}-{value[4:6]}-{value[6:8]}"}, dt.datetime(y, m, d, 12, tzinfo=dt.timezone.utc)
    match = re.fullmatch(r"(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})?(Z?)", value)
    if not match:
        return None, None
    y, mo, d, h, mi, s, z = match.groups()
    naive = dt.datetime(int(y), int(mo), int(d), int(h), int(mi), int(s or 0))
    if z:
        when = naive.replace(tzinfo=dt.timezone.utc)
    else:
        tzid = re.search(r"TZID=([^;:]+)", params)
        try:
            when = naive.replace(tzinfo=ZoneInfo(tzid.group(1).strip('"'))) if tzid else naive.replace(tzinfo=dt.timezone.utc)
        except Exception:
            when = naive.replace(tzinfo=dt.timezone.utc)
    utc = when.astimezone(dt.timezone.utc)
    return {"dateTime": utc.strftime("%Y-%m-%dT%H:%M:%SZ")}, utc


def short_code(text):
    return re.sub(r"[^A-Za-z0-9_-]", "", str(text or "").split(".")[0])[:40]


def short_name(name, fallback):
    """A name that fits on a chip: 'College Algebra', or the course code like 'SLS 1122' when the name is long."""
    name = str(name or "")
    clean = re.sub(r"\b\d{4,}(\.\d+)?\b", " ", name)
    clean = re.sub(r"\b(fall|spring|summer|winter)\b\s*\d{0,4}", " ", clean, flags=re.I)
    clean = re.sub(r"[\s_|:()\[\]]+", " ", clean).strip(" -.")
    code = re.search(r"\b([A-Z]{3})\s?(\d{4}[A-Z]?)\b", name)
    bare = re.sub(r"\b[A-Z]{3}\s?\d{4}[A-Z]?\b", " ", clean)
    tidy = lambda t: re.sub(r"\s+", " ", re.sub(r"-(?=\s|$)|(?<=\s)-|^-", " ", t)).strip(" -.")
    clean = tidy(bare) or tidy(clean)
    if clean and len(clean) <= 24:
        return clean
    if code:
        return f"{code.group(1)} {code.group(2)}"
    return (clean[:24].rsplit(" ", 1)[0] if clean else fallback)[:24]


def api_get(base, path, params):
    """GET every page of a Canvas API list. Returns None if the token is rejected."""
    url = base + path + "?" + urllib.parse.urlencode(params, doseq=True)
    out, pages = [], 0
    while url and pages < 15:
        request = urllib.request.Request(url, headers={"Authorization": "Bearer " + TOKEN, "Accept": "application/json", "User-Agent": "zero-gap-canvas-sync"})
        try:
            response = urllib.request.urlopen(request, timeout=30)
        except urllib.error.HTTPError as exc:
            if exc.code in (401, 403):
                return None
            raise
        data = json.loads(response.read().decode("utf-8"))
        out.extend(data if isinstance(data, list) else [data])
        match = re.search(r'<([^>]+)>;\s*rel="next"', response.headers.get("Link", ""))
        url, pages = (match.group(1) if match else None), pages + 1
    return out


class _Text(html.parser.HTMLParser):
    """Announcement bodies are HTML. Keep only the words; links, images and scripts are dropped."""
    BLOCK = {"p", "div", "br", "li", "tr", "h1", "h2", "h3", "h4", "h5", "h6"}

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.parts, self.skip = [], 0

    def handle_starttag(self, tag, attrs):
        if tag in ("script", "style"):
            self.skip += 1
        elif tag in self.BLOCK:
            self.parts.append("\n")

    def handle_endtag(self, tag):
        if tag in ("script", "style") and self.skip:
            self.skip -= 1
        elif tag in self.BLOCK:
            self.parts.append("\n")

    def handle_data(self, data):
        if not self.skip:
            self.parts.append(data)


def plain_text(markup, limit=1500):
    parser = _Text()
    try:
        parser.feed(str(markup or ""))
        parser.close()
    except Exception:
        return ""
    text = re.sub(r"[ \t\u00a0]+", " ", "".join(parser.parts))
    text = re.sub(r"\s*\n\s*", "\n", text).strip()
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text[:limit].rstrip() + ("…" if len(text) > limit else "")


def token_expiry(base):
    """When the token runs out, from Canvas if it says; otherwise None."""
    secret = TOKEN.split("~", 1)[-1]
    for hint in dict.fromkeys([secret[:5], TOKEN[:5]]):
        try:
            data = api_get(base, "/users/self/tokens/" + urllib.parse.quote(hint, safe=""), {})
        except Exception:
            continue
        if data and isinstance(data[0], dict) and data[0].get("expires_at"):
            return data[0]["expires_at"]
    return None


def pick_score(enrollment):
    if enrollment.get("multiple_grading_periods_enabled") and enrollment.get("current_period_computed_current_score") is not None:
        return enrollment.get("current_period_computed_current_score"), enrollment.get("current_period_computed_current_grade")
    return enrollment.get("computed_current_score"), enrollment.get("computed_current_grade")


def school_data(items, now):
    """Course names, grades, submitted assignments and missing work, from the Canvas API."""
    host = urllib.parse.urlparse(FEED).netloc
    base = API or (f"https://{host}/api/v1" if host else "")
    if not TOKEN or not base:
        return None
    try:
        courses = api_get(base, "/courses", {"enrollment_type": "student", "enrollment_state": "active", "include[]": ["total_scores", "current_grading_period_scores"], "per_page": 100})
    except Exception as exc:
        print(f"Could not reach the Canvas API ({type(exc).__name__}). Assignments still came from the feed.")
        return {"error": "network"}
    if courses is None:
        print("Canvas did not accept the CANVAS_TOKEN secret (expired or deleted?). Make a new token in Canvas and update the secret.")
        return {"error": "token"}
    codes = {}
    for item in items:  # the feed says which course id goes with which [code]
        ctx = re.search(r"include_contexts=course_(\d+)", item.get("htmlLink", ""))
        tag = re.search(r"\[([^\]]+)\]\s*$", item.get("summary", ""))
        if ctx and tag:
            codes[ctx.group(1)] = short_code(tag.group(1))
    low, high = now - dt.timedelta(days=30), now + dt.timedelta(days=45)
    result, status, missing = [], {}, []
    for course in courses:
        if not isinstance(course, dict) or not course.get("id") or course.get("access_restricted_by_date"):
            continue
        cid = str(course["id"])
        mine = [e for e in course.get("enrollments") or [] if "student" in str(e.get("type", "")).lower()]
        if not mine:
            continue
        score, grade = pick_score(mine[0])
        code = codes.get(cid) or short_code(course.get("course_code")) or cid
        entry = {"id": cid, "code": code, "name": str(course.get("name") or "")[:80], "short": short_name(course.get("name"), code),
                 "score": round(score, 1) if isinstance(score, (int, float)) else None, "grade": grade or None, "missing": 0,
                 "url": f"https://{host}/courses/{cid}/grades" if host else ""}
        try:
            assignments = api_get(base, f"/courses/{cid}/assignments", {"include[]": "submission", "order_by": "due_at", "per_page": 100}) or []
        except Exception:
            assignments = []
        for a in assignments:
            due = a.get("due_at")
            sub = a.get("submission") or {}
            if not due:
                continue
            when = dt.datetime.fromisoformat(due.replace("Z", "+00:00"))
            if sub.get("missing") and not sub.get("excused"):
                entry["missing"] += 1
                missing.append({"title": str(a.get("name") or "")[:140], "code": code, "due": due, "url": a.get("html_url") or ""})
            if not low <= when <= high:
                continue
            done = bool(sub.get("submitted_at")) or bool(sub.get("excused")) or (sub.get("workflow_state") == "graded" and (sub.get("score") or 0) > 0)
            status["event-assignment-" + str(a.get("id"))] = {"done": done, "at": sub.get("submitted_at"), "missing": bool(sub.get("missing")), "late": bool(sub.get("late")), "excused": bool(sub.get("excused"))}
        result.append(entry)
    result.sort(key=lambda c: c["name"].lower())
    missing.sort(key=lambda m: m["due"])
    news = []
    if result:
        try:
            posts = api_get(base, "/announcements", {"context_codes[]": ["course_" + c["id"] for c in result], "start_date": (now - dt.timedelta(days=21)).strftime("%Y-%m-%dT%H:%M:%SZ"), "end_date": now.strftime("%Y-%m-%dT%H:%M:%SZ"), "active_only": "true", "per_page": 50}) or []
        except Exception:
            posts = []
        code_of = {c["id"]: c["code"] for c in result}
        for post in posts:
            if not isinstance(post, dict) or not post.get("id"):
                continue
            cid = str(post.get("context_code", "")).replace("course_", "")
            news.append({"id": str(post["id"]), "code": code_of.get(cid, ""), "title": str(post.get("title") or "")[:200],
                         "text": plain_text(post.get("message")), "at": post.get("posted_at") or "", "url": post.get("html_url") or ""})
        news.sort(key=lambda a: a["at"], reverse=True)
    school = {"courses": result, "status": status, "missing": missing[:20], "announcements": news[:20],
              "token": hashlib.sha256(TOKEN.encode()).hexdigest()[:8]}
    expires = token_expiry(base)
    if expires:
        school["tokenExpires"] = expires
    print("Token expiry: " + (expires[:10] if expires else "Canvas did not say (the app counts 30 days from when it first sees this token)."))
    return school


def main():
    if not FEED:
        print("The CANVAS_FEED_URL secret is not set. Add it under Settings > Secrets and variables > Actions.")
        return 1
    request = urllib.request.Request(FEED, headers={"User-Agent": "zero-gap-canvas-sync"})
    try:
        raw = urllib.request.urlopen(request, timeout=30).read().decode("utf-8", "replace")
    except Exception as exc:  # never echo the URL, it works like a password
        print(f"Could not download the Canvas feed ({type(exc).__name__}). Check the CANVAS_FEED_URL secret.")
        return 1
    lines = re.sub(r"\r?\n[ \t]", "", raw.replace("\r\n", "\n")).split("\n")
    now = dt.datetime.now(dt.timezone.utc)
    low, high = now - dt.timedelta(days=3), now + dt.timedelta(days=45)
    events, current = [], None
    for line in lines:
        if line == "BEGIN:VEVENT":
            current = {}
            continue
        if line == "END:VEVENT":
            if current is not None:
                events.append(current)
            current = None
            continue
        if current is None or ":" not in line:
            continue
        head, value = line.split(":", 1)
        key, params = head.split(";")[0].upper(), head.upper()
        if key in ("UID", "SUMMARY", "URL"):
            current[key] = value.strip()
        elif key == "DTSTART":
            current["START"] = parse_start(value, params)
    found = []
    for event in events:
        uid, start = event.get("UID", ""), event.get("START")
        if "assignment" not in uid or not start or not start[0] or not low <= start[1] <= high:
            continue
        item = {"id": uid, "summary": unescape(event.get("SUMMARY", "")), "start": start[0]}
        if event.get("URL", "").startswith("https://"):
            item["htmlLink"] = event["URL"]
        found.append((start[1], item))
    found.sort(key=lambda pair: pair[0])
    items = [item for _, item in found]
    data = {"events": items}
    previous = None
    if os.path.exists(OUT):
        try:
            with open(OUT, encoding="utf-8") as handle:
                previous = json.load(handle)
                previous.pop("at", None)
        except Exception:
            previous = None
    school = school_data(items, now)
    if school and "error" in school:
        # keep the last grades we had, marked as not current, so the app can say what to fix
        for key in ("courses", "status", "missing", "announcements", "token", "tokenExpires", "tokenSince"):
            if previous and key in previous:
                data[key] = previous[key]
        data["schoolError"] = school["error"]
        school = None
    elif school:
        data.update(school)
        # remember when this token first showed up, for the renew reminder
        data["tokenSince"] = previous.get("tokenSince") if previous and previous.get("token") == school["token"] and previous.get("tokenSince") else now.strftime("%Y-%m-%dT%H:%M:%SZ")
    extra = f", {len(school['courses'])} classes with grades" if school else ""
    if previous == data:
        print(f"No changes ({len(items)} assignments{extra}).")
        return 0
    with open(OUT, "w", encoding="utf-8") as handle:
        json.dump(dict({"at": now.strftime("%Y-%m-%dT%H:%M:%SZ")}, **data), handle, ensure_ascii=False, indent=1)
        handle.write("\n")
    print(f"Saved {len(items)} assignments{extra}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
