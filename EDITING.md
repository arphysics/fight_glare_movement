# How to edit fightglare.org

For anyone helping with the website. **You don't need to install anything and
you don't need to know how to code.** You describe the change you want in plain
English, and Claude makes it.

Nothing you do here can break the live site. Your changes go to Aditya for
review first, and fightglare.org keeps running exactly as-is until he approves.

---

## What you need before you start

- **A GitHub account**, with an accepted invite to the project. Aditya sends
  the invite; check your email (and spam) for "invited you to collaborate" and
  click Accept. Free account is fine.
- **A Claude Pro subscription** (or Max). The tool below is not available on
  free Claude accounts.

Setup takes about ten minutes and you only do it once.

---

## One-time setup

1. Go to **[claude.ai/code](https://claude.ai/code)** and sign in.
2. It will ask you to connect GitHub. Follow the prompt to install the **Claude
   GitHub App** and give it access to your repositories.
3. It then asks you to create an "environment." **Leave every field at its
   default** and click **Create environment**. The defaults are correct for
   this project — you'll never need to touch this again.

That's it. You won't repeat any of this.

> One thing to know before you connect: a Claude session can reach any GitHub
> repository your account can see. If your GitHub account is also tied to work
> repositories, use a personal GitHub account here instead.

---

## Making a change

### 1. Pick the project

At [claude.ai/code](https://claude.ai/code), click the **repository selector**
below the message box and choose **`arphysics/fight_glare_movement`**.

### 2. Describe what you want

Type it in plain English and press Enter. Be specific about *where* on the page
and *what* it should say. Good examples:

- "In the section 'We're already making headway,' change the third milestone to
  say we presented to the City Council on March 12."
- "Add a question to the FAQ about whether warmer streetlights are less safe,
  with a short answer."
- "The email template at the bottom should mention the new ordinance draft."

Vague requests like "make the top section better" produce vague results. If
you're not sure how to word it, describe the problem instead: "the third
milestone is out of date, it should reflect the March council meeting."

Claude will open the project, find the right spot, and make the edit. This
takes a minute or two. You can close the tab — it keeps working, and you can
check back from your phone.

### 3. Look at what changed

When it's done you'll see a small indicator like **`+12 −4`** (lines added and
removed). Click it to see the change side by side: the old version and the new
one, with the differences highlighted.

**Read this before moving on.** You're checking one thing: did it change what
you asked for, and nothing else? A change to one sentence should show a small
number of edited lines. If you asked for one sentence and see fifty lines
changed, something went wrong — say so in the chat and ask it to try again
more narrowly.

If a specific line looks wrong, click that line, type what's wrong with it, and
press Enter. Your note gets attached to that exact spot, so you don't have to
explain where you mean.

### 4. Send it to Aditya

When the change looks right, click **Create PR** at the top of the diff view.

"PR" is short for pull request — it just means "here's a proposed change,
please review it." Aditya gets a notification showing exactly what you changed.
**This does not put anything on the live site.**

You can keep chatting after this. If you think of a fix, ask for it and the
pull request updates automatically.

---

## Doing several changes at once

If you're working through a batch of fixes, **do them all in one session** —
keep talking to the same conversation and ask for the next change after the
last one looks right. Everything collects into a single pull request, which is
one thing for Aditya to review instead of six.

Start a new session only when the work is genuinely unrelated.

---

## Adding an image

Upload it first, then ask for it to be placed:

1. Go to https://github.com/arphysics/fight_glare_movement
2. Click into the **`assets`** folder
3. **Add file → Upload files**, drag your image in
4. Choose **"Create a new branch for this commit"**, then **Propose changes**
5. Back in Claude, mention the filename: "put `council-meeting-march.jpg` at
   the top of the progress section"

Keep images under about 500KB or the page gets slow on phones. Name them
plainly — `council-meeting-march.jpg`, not `IMG_4821.jpg`.

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
- **Don't change colors or fonts to specific values.** They're defined once at
  the top of the file and reused everywhere. Ask for "warmer amber" and let
  Claude change it in the right place.

---

## If something looks wrong

There's no emergency — nothing in a pull request touches the live site.

- **The change looks wrong in the diff**: say so in the chat and ask for a fix.
- **You want to abandon it**: on GitHub, open the pull request and click
  **Close pull request**. That discards it cleanly, nothing is lost.
- **You're stuck or confused**: comment on the pull request describing what you
  expected versus what you got. Aditya will sort it out.

---

## Why Aditya reviews everything

Claude is good at this but not perfect. The usual failure is quietly changing
something you didn't ask about. A human reading the diff catches that in
seconds.

The review step isn't about trusting you — it's about the tool. It stays even
when Aditya makes changes himself.
