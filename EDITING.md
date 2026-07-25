# How to edit fightglare.org

For anyone helping with the website. **You don't need to install anything** and
you don't need to know how to code. You need a free GitHub account and access to
claude.ai.

Nothing you do here can break the live site. Your changes go to Aditya for
review first, and the site keeps running exactly as-is until he approves.

---

## The short version

1. Copy the website's code from GitHub
2. Paste it into claude.ai and describe your change
3. Paste Claude's version back into GitHub
4. Click "Propose changes" — this sends it to Aditya, it does **not** go live
5. Aditya reviews and publishes

Budget about 15 minutes the first time, 5 minutes after that.

---

## Step 1 — Open the file

Go to https://github.com/arphysics/fight_glare_movement and click on
**`index.html`** in the file list.

That one file is the entire website — all the text, colors, and layout.

Click the **pencil icon** (top right of the file, "Edit this file"). You're now
in a text editor. Don't worry about the code looking dense; you won't be
reading it.

## Step 2 — Copy everything

Click anywhere in the code, then press **Cmd+A** (Mac) or **Ctrl+A** (Windows)
to select all of it, then **Cmd+C** / **Ctrl+C** to copy.

Leave this browser tab open. You'll come back to it.

## Step 3 — Ask Claude for the change

Go to claude.ai, start a new chat, and paste this template. Replace the
description with what you actually want, then paste the code underneath.

> I'm editing a one-page website. Below is the complete `index.html`.
>
> Please make this change: **[describe your change in plain English]**
>
> Important:
> - Return the **complete file**, from `<!DOCTYPE html>` to `</html>`
> - Change **only** what I asked for — leave everything else byte-for-byte identical
> - Don't reformat, don't "improve" other things, don't remove comments
> - Keep all image paths starting with `assets/` exactly as they are
>
> Here's the file:
>
> [paste the code here]

Examples of changes that work well:

- "Change the third milestone under 'We're already making headway' to say we
  presented to the City Council on March 12"
- "Add a new question and answer to the FAQ section about whether warmer lights
  are less safe"
- "Update the email template so it mentions the new ordinance draft"

**Ask for one change at a time.** Several at once is where mistakes creep in.

## Step 4 — Check what Claude gave you

Before pasting it back, look at two things:

- Does the response **start** with `<!DOCTYPE html>`?
- Does it **end** with `</html>`?

If either is missing, Claude truncated the file. Reply with "Please send the
complete file again, including the very end" and check again. **Do not paste in
a truncated file** — that's the one mistake that produces a broken page.

## Step 5 — Paste it back into GitHub

Return to your GitHub tab. Select all the code again (**Cmd+A**), then paste
(**Cmd+V**). This replaces the old version with Claude's.

## Step 6 — Propose the change

Click the green **"Commit changes..."** button.

In the box that appears:

- **Description**: write what you changed in plain English, e.g. "Update March
  council meeting milestone". This is what Aditya sees.
- Select **"Create a new branch for this commit and start a pull request"** —
  this is important. The other option publishes straight to the live site.
- Click **Propose changes**, then **Create pull request** on the next screen.

Done. Aditya gets a notification with your exact changes highlighted.

---

## Adding an image

1. On the repo's main page, click into the **`assets`** folder
2. **Add file → Upload files**, drag your image in
3. Same as above: choose "Create a new branch", then Propose changes
4. Mention the filename when you ask Claude to place it on the page

Keep images under ~500KB or the page gets slow on phones. Name them plainly:
`council-meeting-march.jpg`, not `IMG_4821.jpg`.

---

## Things to leave alone

Editing these will break the site or take it offline:

| File | What it does |
| --- | --- |
| `CNAME` | Points fightglare.org at this site |
| `.github/workflows/deploy.yml` | Publishes the site when changes are approved |
| Anything starting with `assets/` in the code | Image paths — renaming breaks the owl logo |

If Claude suggests changing one of these, say no and mention it to Aditya.

---

## If something looks wrong

Nothing you do in a pull request affects the live site, so there's no emergency.
Comment on your pull request describing what you expected versus what you got,
and Aditya will sort it out. If you want to abandon it entirely, click **Close
pull request** — that discards it cleanly.

---

## Why the review step exists

Claude is good at this but not perfect — the usual failure is quietly changing
something you didn't ask about, or dropping the end of the file. A human reading
the diff catches both in seconds. The review isn't about trusting you; it's
about the tool.
