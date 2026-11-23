# ZERØ GAP

A personal task app for ADHD brains, styled like a covert-ops console: ops board, notes, a Proton Calendar schedule, a focus timer and a ledger of everything you closed.

It installs to your phone's home screen and works with no internet. Your data stays on your device and never goes to this repo or any server.

**Open it:** https://marinvanastrea.github.io/zero-gap/

## Install on your phone

- **iPhone (Safari):** open the link → Share → **Add to Home Screen**.
- **Android (Chrome):** open the link → ⋮ menu → **Install app** (or **Add to Home screen**).

Open it once while online. After that it runs offline.

## Your data

- Saved on the device only. Each device keeps its own copy.
- **Settings → EXPORT BACKUP** saves everything to one `.json` file. Keep it in iCloud Drive or Google Drive.
- **Settings → RESTORE BACKUP** loads a backup onto a device (for example a new phone).

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
