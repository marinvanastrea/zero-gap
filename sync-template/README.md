# zero-gap-data (private)

Private storage for the ZERØ GAP app. Keep this repository **private**.

> Template: copy everything in this folder (including the hidden `.github` folder) into the root of a new **private** repository. It does nothing while it sits inside the public app repo.

| File | What it is |
| --- | --- |
| `zerogap.sync.json` | Your app data, encrypted on your device with your passphrase. GitHub cannot read it. |
| `canvas.json` | Upcoming Canvas assignments (titles, courses, due dates), written by the Canvas workflow. |
| `.github/workflows/canvas.yml` | Fetches your Canvas calendar feed every 4 hours. |
| `scripts/canvas_feed.py` | The script that workflow runs. |

## Setup

1. **Canvas feed:** in Canvas open Calendar → Calendar Feed and copy the link. Here, open Settings → Secrets and variables → Actions → New repository secret, name it `CANVAS_FEED_URL` and paste the link.
2. **Run it once:** Actions tab → Canvas assignments → Run workflow.
3. **Sync:** create a fine-grained token limited to this repository with Contents: Read and write, then in ZERØ GAP open Settings → Sync between devices and paste the repo name, the token and your passphrase. Do the same on every device.
