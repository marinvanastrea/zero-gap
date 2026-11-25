# zero-gap-data (private)

Private storage for the ZERØ GAP app. Keep this repository **private**.

> Template: copy everything in this folder (including the hidden `.github` folder) into the root of a new **private** repository. It does nothing while it sits inside the public app repo.

| File | What it is |
| --- | --- |
| `zerogap.sync.json` | Your app data, encrypted on your device with your passphrase. GitHub cannot read it. |
| `canvas.json` | Upcoming Canvas assignments (titles, courses, due dates), plus class names, grades, submitted and missing work if you add a Canvas token. Written by the Canvas workflow. Not encrypted, so keep the repo private. |
| `.github/workflows/canvas.yml` | Fetches your Canvas calendar feed (and grades, with a token) every 2 hours. |
| `scripts/canvas_feed.py` | The script that workflow runs. |

## Setup

1. **Canvas feed:** in Canvas open Calendar → Calendar Feed and copy the link. Here, open Settings → Secrets and variables → Actions → New repository secret, name it `CANVAS_FEED_URL` and paste the link.
2. **Run it once:** Actions tab → Canvas assignments → Run workflow.
3. **Sync:** create a fine-grained token limited to this repository with Contents: Read and write, then in ZERØ GAP open Settings → Sync between devices and paste the repo name, the token and your passphrase. Do the same on every device.
4. **Grades (optional):** in Canvas open Account → Settings → Approved Integrations → **+ New Access Token**. Give it a purpose (ZERØ GAP) and an expiry date, generate it and copy it (Canvas shows it once). Add it here as a repository secret named `CANVAS_TOKEN`, then run the workflow. ZERØ GAP then shows each class's current grade and missing work, names your classes, and marks assignments done once you submit them in Canvas. The token can do anything your Canvas account can, so keep it only in this secret. If it expires, the app keeps your last grades and tells you.
