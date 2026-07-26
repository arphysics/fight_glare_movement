# How to edit fightglare.org

For anyone helping with the website. **You don't need to know how to code.** You
describe the change you want in plain English, Claude makes it, and you see the
page update in front of you before anyone else sees it.

Nothing you do here can break the live site. Your changes go to Aditya for
review first, and fightglare.org keeps running exactly as-is until he approves.

---

## What you need

- **A Mac or Windows PC** (this doesn't work on a phone or iPad)
- **A GitHub account**, with the project invite accepted
- **Claude Pro or Max**

You'll install two apps. Each has one job, and keeping them straight is the
only genuinely confusing part of this:

| App | What you use it for |
| --- | --- |
| **Claude** | Making the change and looking at the result |
| **GitHub Desktop** | Sending the finished change to Aditya |

Setup takes about twenty minutes, once.

---

## One-time setup

### 1. GitHub Desktop — get the project onto your computer

1. Download from **[desktop.github.com](https://desktop.github.com/)** and install it.
2. Open it and sign in with your GitHub account.
3. Choose **Clone a repository from the Internet**.
4. Find **`arphysics/fight_glare_movement`** in the list and click **Clone**.
5. Note the folder it saves to — usually `Documents/GitHub/fight_glare_movement`.
   You'll point Claude at this folder in a moment.

"Clone" just means downloading your own copy to work in.

### 2. Claude — install the desktop app

*On Windows only:* install [Git for Windows](https://git-scm.com/downloads/win)
first, then restart. Macs already have what's needed.

1. Download the Claude desktop app for
   [Mac](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect) or
   [Windows](https://claude.ai/api/desktop/win32/x64/setup/latest/redirect).
2. Install it, open it, sign in.
3. Click the **Code** tab at the top.
4. Choose **Local**, click **Select folder**, and pick the
   `fight_glare_movement` folder from step 1.

Done. From now on you start at "Making a change" below.

---

## Making a change

### Step 1 — Start a branch first

**Do this before you edit anything.** In GitHub Desktop:

1. Click **Current Branch** at the top, then **New Branch**
2. Name it after what you're doing: `march-council-update`, `faq-safety`
3. Click **Create Branch**

A branch is a private workspace for your change. It keeps your work separate
until Aditya approves it.

> **This step matters more than it looks.** If you skip it, you're working
> directly on the live version, and your changes can reach fightglare.org
> without anyone reviewing them. Thirty seconds here prevents that entirely.

### Step 2 — Ask Claude for the change

In the Claude app, on the **Code** tab, type what you want in plain English.
Be specific about *where* on the page and *what* it should say:

- "In the section 'We're already making headway,' change the third milestone to
  say we presented to the City Council on March 12."
- "Add a question to the FAQ about whether warmer streetlights are less safe,
  with a short answer."
- "The email template at the bottom should mention the new ordinance draft."

Vague requests like "make the top section better" give vague results. If you're
unsure how to word it, describe the problem instead: "the third milestone is out
of date, it should reflect the March council meeting."

Claude proposes each change and waits for you to click **Accept** or **Reject**.
Nothing is written until you accept. Once you're comfortable, you can switch the
mode dropdown to **Accept edits** so it stops asking each time.

### Step 3 — Look at the page

This is the part the old process couldn't do. Ask:

> show me the page

The site opens in a **Browser pane** right next to the chat — the real page,
with the fonts and the owl logo, exactly as a visitor would see it. If it
doesn't appear, click the `index.html` link in the chat, or press
**Cmd+Shift+B** (Mac) / **Ctrl+Shift+B** (Windows).

Claude also checks its own work as it goes: after an edit it looks at the page,
spots things like text overflowing or a broken image, and fixes them before
handing back to you.

Look at it properly. Ask for adjustments in plain English — "that heading is too
close to the photo," "the new FAQ answer is too long" — and watch it update.
Stay in this loop until it looks right. Nobody sees any of this yet.

### Step 4 — Check the actual changes

Click the small **`+12 −4`** indicator (lines added and removed) to see exactly
what changed, old against new.

You're checking one thing: **did it change what you asked for, and nothing
else?** A one-sentence edit should touch a handful of lines. If you asked for
one sentence and see fifty lines changed, say so in the chat and ask it to
redo the change more narrowly.

### Step 5 — Send it to Aditya

Back in **GitHub Desktop**, your changes are waiting.

> If GitHub Desktop shows nothing to commit, Claude already committed for you.
> That's fine — skip to step 3 below. If you'd rather it didn't, tell it
> "don't commit anything, I'll do that myself."

1. Bottom left, write a short summary: "Update March council milestone"
2. Click **Commit to `your-branch-name`**
3. Click **Publish branch** (top right)
4. Click **Create Pull Request** — this opens your browser
5. Click **Create pull request** on that page

A pull request means "here's a proposed change, please review it." Aditya gets
your exact changes highlighted. **This does not put anything on the live site.**

---

## Doing several changes at once

Stay on the same branch and keep going — make the next change in Claude, then
commit it in GitHub Desktop alongside the first. Everything collects into one
pull request, which is one thing for Aditya to review instead of six.

Start a new branch only when the work is genuinely unrelated. Once a pull
request is merged, make a new branch for your next piece of work.

---

## Adding an image

Put the image file into the `assets` folder inside your
`fight_glare_movement` folder — drag it in like any other file. Then tell
Claude the filename:

> put `council-meeting-march.jpg` at the top of the progress section

Keep images under about 500KB or the page gets slow on phones. Name them plainly
— `council-meeting-march.jpg`, not `IMG_4821.jpg`.

---

## Things to leave alone

If Claude proposes changing any of these, say no and mention it to Aditya:

| What | Why |
| --- | --- |
| `CNAME` | Points fightglare.org at this site. Deleting it takes the domain down. |
| `.github/workflows/deploy.yml` | Publishes the site. Breaking it stops updates. |
| Image paths starting with `assets/` | Renaming these breaks the owl logo. |

Two content rules that matter more than they look:

- **No statistics, dates, or claims about the City of Irvine's position without
  a source we can link to.** This site is aimed at a city council. An unsourced
  number is a liability, not a detail.
- **Don't ask for specific colors or fonts by name.** They're defined once and
  reused across the page. Ask for "a warmer amber" and let Claude change it in
  the right place, so it stays consistent everywhere.

---

## If something looks wrong

There's no emergency. Nothing reaches fightglare.org without Aditya merging it.

- **The page looks wrong in the preview**: say so in the chat and ask for a fix.
  This is the normal loop, not a failure.
- **You want to throw the whole thing away**: in GitHub Desktop, switch
  **Current Branch** back to `main`. Your branch stays where it is and nothing
  you did affects anything.
- **You already opened the pull request and want to abandon it**: open it on
  GitHub and click **Close pull request**. That discards it cleanly.
- **You're stuck**: comment on the pull request describing what you expected
  versus what you got, and Aditya will sort it out.

---

## Why Aditya reviews everything

Claude is good at this but not perfect. The usual failure is quietly changing
something you didn't ask about — which is exactly what Step 4 catches.

The review step isn't about trusting you. It's about the tool, and it stays in
place for Aditya's own changes too.
