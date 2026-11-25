# ZERØ GAP

A personal task app for ADHD brains, styled like a covert-ops console: ops board, notes, a Proton Calendar schedule, guided stretch routines, a focus timer and a ledger of everything you closed.

It installs to your phone's home screen and works with no internet. Your data stays on your device and never goes to this repo or any server.

**Open it:** https://marinvanastrea.github.io/zero-gap/

## Install on your phone

- **iPhone (Safari):** open the link → Share → **Add to Home Screen**.
- **Android (Chrome):** open the link → ⋮ menu → **Install app** (or **Add to Home screen**).

Open it once while online. After that it runs offline. Everyone who opens the link gets their own blank copy; nobody can see anyone else's data.

## Why it matters

Every op shows which part of your life it moves forward (School, Career, Money, Health, Home, People, Peace of mind), how big a win it is, and what finishing it does for you. Suggestions come from the title, offline; tap one to make it yours. LEDGER adds up your results per area each week and compares them to last week.

## FLEX: stretch routines

Eight guided routines, 3 to 5 minutes each: morning wake-up, desk reset, hands & wrists, neck & shoulders, lower back, hips & legs, bedtime wind-down and a quick reset. Each stretch has an illustration (moving ones are animated), a ring timer counts each hold, and spoken cues name every stretch and tell you when to switch sides, so you can keep your eyes off the screen. Works offline.

INFIL routes add a quick stretch as a waypoint, and the 15-minute stand-down break offers the desk routine.

## This week: mini deadlines

Assignments due this week (from Canvas, or ops in the School area) get their own mini deadlines, spread over Monday to Friday and well before the real deadline. Bigger ones are split into steps (Start → Keep going → Finish) on different days. Tick a step on HQ when it's done; ticking the last step closes the op. Unfinished steps move to today, and REPLAN rebuilds the rest of the week.

Canvas tags each class with a section number. Tap **NAME THEM** on HQ (or a course chip) to give each one a short name; the screen lists a few assignments under each number so you can tell which class it is. Old copies of a Canvas assignment (from an earlier import, or typed by hand with the same title and due date) are merged into the one coming from Canvas, keeping anything already done on them.

## Your data

- Saved on the device. Each device keeps its own copy until you turn on sync.
- **Settings → Sync between devices** keeps your phone and computer in step through a private GitHub repo you own. Everything is encrypted on the device with your passphrase before it leaves, so the repo only holds unreadable data. Canvas assignments can come in through the same repo (see [the data repo setup](#canvas-and-sync-setup)).
- **Settings → EXPORT BACKUP** saves everything to one `.json` file. Keep it in iCloud Drive or Google Drive.
- **Settings → RESTORE BACKUP** loads a backup onto a device (for example a new phone).

## Canvas and sync setup

1. Create a **private** repo (for example `zero-gap-data`) and copy everything from [`sync-template/`](sync-template/) into it. Its README explains the Canvas part.
2. Make a fine-grained GitHub token with access to that repo only, permission **Contents: Read and write**.
3. In the app: **Settings → Sync between devices**, enter the repo, the token and a passphrase. Use the same passphrase on every device.

The token and passphrase stay on your device. Lose the passphrase and the synced copy can't be read, so keep a backup file too.

## Updates

The app is a single `index.html` plus a service worker (`sw.js`) that keeps it available offline.
When a new version is pushed here, the app shows **NEW VERSION READY → UPDATE NOW** the next time it's opened online. Your data is kept.

For every change, bump both version numbers together:

- `APP_VERSION` in `index.html`
- `VERSION` in `sw.js`

## Files

| File | What it is |
| --- | --- |
| `index.html` | The whole app: markup, styles and code |
| `sw.js` | Offline cache and update handling |
| `manifest.webmanifest` | Name, colors and icons for installing |
| `icons/` | Home-screen icons |
| `sync-template/` | Files for your private sync repo, including the Canvas workflow |

## License

MIT. Use it, fork it, change it. See [LICENSE](LICENSE).
