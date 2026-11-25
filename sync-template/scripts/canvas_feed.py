#!/usr/bin/env python3
"""Fetch the Canvas calendar feed and save upcoming assignments to canvas.json for ZERØ GAP.

The feed link comes from the CANVAS_FEED_URL repository secret and is never printed.
Only assignments from 3 days ago to 45 days ahead are kept. The file is rewritten only
when the assignments change, so the app knows when there is something new.
"""
import datetime as dt
import json
import os
import re
import sys
import urllib.request
from zoneinfo import ZoneInfo

FEED = os.environ.get("CANVAS_FEED_URL", "").strip()
OUT = os.environ.get("CANVAS_OUT", "canvas.json")


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
    previous = None
    if os.path.exists(OUT):
        try:
            with open(OUT, encoding="utf-8") as handle:
                previous = json.load(handle).get("events")
        except Exception:
            previous = None
    if previous == items:
        print(f"No changes ({len(items)} assignments).")
        return 0
    with open(OUT, "w", encoding="utf-8") as handle:
        json.dump({"at": now.strftime("%Y-%m-%dT%H:%M:%SZ"), "events": items}, handle, ensure_ascii=False, indent=1)
        handle.write("\n")
    print(f"Saved {len(items)} assignments.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
