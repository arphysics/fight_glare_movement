# How to edit fightglare.org

For anyone helping with the website. **You don't need to know how to code.** You
describe the change you want in plain English, Claude makes it, and you see the
page update in front of you before anyone else sees it.

Nothing you do here can break the live site. Your changes go to Aditya for
review first, and fightglare.org keeps running exactly as-is until he approves.

You use **one app**: Claude. Aditya sets your computer up once, and after that
everything below happens in a single window.

---

## Making a change

Open the Claude app, click the **Code** tab, and pick the
**fight_glare_movement** project. Then:

### 1. Start a branch

Type:

> start a new branch for this

A branch is a private workspace. It keeps your work separate from the live site
until Aditya approves it. Claude is set up to do this on its own, but asking
costs nothing and makes it certain.

If you ever want to know where you are, ask: **"what branch am I on?"** The
answer should be anything except `main`.

### 2. Say what you want changed

Plain English. Be specific about *where* on the page and *what* it should say:

- "In the section 'We're already making headway,' change the third milestone to
  say we presented to the City Council on March 12."
- "Add a question to the FAQ about whether warmer streetlights are less safe,
  with a short answer."
- "The email template at the bottom should mention the new ordinance draft."

Vague requests like "make the top section better" give vague results. If you're
unsure how to word it, describe the problem instead: "the third milestone is out
of date, it should reflect the March council meeting."

Claude proposes each change and waits for you to click **Accept** or **Reject**.
Nothing is written until you accept. Once you're comfortable, switch the mode
dropdown to **Accept edits** so it stops asking every time.

### 3. Look at the page

> show me the page

The site opens in a **Browser pane** next to the chat — the real page, with the
fonts and the owl logo, exactly as a visitor sees it. If it doesn't appear,
click the `index.html` link in the chat or press **Cmd+Shift+B**.

Claude also checks its own work: after an edit it looks at the page, catches
things like text overflowing or a broken image, and fixes them before handing
back to you.

Ask for adjustments in plain English — "that heading is too close to the photo,"
"the new FAQ answer is too long" — and watch it update. Stay here until it looks
right. Nobody sees any of this yet.

### 4. Check what actually changed

Click the small **`+12 −4`** indicator (lines added and removed) to see the
change, old against new.

You're checking one thing: **did it change what you asked for, and nothing
else?** A one-sentence edit should touch a handful of lines. If you asked for
one sentence and see fifty lines changed, say so and ask it to redo the change
more narrowly.

### 5. Send it to Aditya

> commit this and open a pull request

Claude writes up what changed and opens it for review. A pull request means
"here's a proposed change, please take a look." Aditya gets your exact changes
highlighted.

**This does not put anything on the live site.**

If something needs fixing after that, just say so — the pull request updates.

---

## Doing several changes at once

Stay on the same branch and keep going. Make the next change, look at it, and
ask Claude to commit again when it's right. Everything collects into one pull
request, which is one thing for Aditya to review instead of six.

Start a new branch only when the work is genuinely unrelated, or after a pull
request has been merged.

---

## Adding an image

Drag the image file into the `assets` folder inside your
`fight_glare_movement` folder, then tell Claude the filename:

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

- **The page looks wrong in the preview**: say so and ask for a fix. That's the
  normal loop, not a failure.
- **You want to throw the whole thing away**: ask Claude to "switch back to main
  and forget this branch." Nothing you did affects anything.
- **You already opened the pull request and want to abandon it**: ask Claude to
  close it, or open it on GitHub and click **Close pull request**.
- **You're stuck**: comment on the pull request describing what you expected
  versus what you got, and Aditya will sort it out.
- **It says something about "author identity" or asks for a password**: that's
  setup, not you. Send it to Aditya.

---

## Why Aditya reviews everything

Claude is good at this but not perfect. The usual failure is quietly changing
something you didn't ask about — which is exactly what step 4 catches.

The review step isn't about trusting you. It's about the tool, and it stays in
place for Aditya's own changes too.

---
---

## Appendix — one-time machine setup

**Aditya does this once, on her Mac.** She doesn't need to read this section.

```sh
# 1. Command Line Tools (provides git)
xcode-select --install

# 2. Clone somewhere she can find it
git clone https://github.com/arphysics/fight_glare_movement.git \
  ~/Documents/fight_glare_movement

# 3. GitHub access — SIGN IN AS HER, not as Aditya.
#    Install gh first: gh_*_macOS_universal.pkg from
#    https://github.com/cli/cli/releases/latest
gh auth login     # her browser, her GitHub account
                  # answer yes to "Authenticate Git with your GitHub credentials?"

# 4. Her identity on commits — without this the first commit fails with
#    "Author identity unknown", which is a confusing wall to hit alone.
git config --global user.name  "Her Name"
git config --global user.email "her@example.com"   # email on her GitHub account
```

Then install the Claude desktop app, have her sign in with her own Max account,
open the **Code** tab, choose **Local**, and select the
`~/Documents/fight_glare_movement` folder.

Why sign in as her rather than reusing Aditya's credentials: every commit and PR
would otherwise be attributed to Aditya, so he'd be reviewing PRs from himself —
and his token would sit on her machine with access to every repo he can reach.
She already has write access as a collaborator, so her own login just works.

Verify before leaving her machine:

```sh
cd ~/Documents/fight_glare_movement
gh auth status              # shows HER username
git config user.email       # shows HER email
git checkout -b setup-test && git push -u origin setup-test
git push origin --delete setup-test && git checkout main
```

If that push succeeds without prompting for a password, she's ready. Doing this
yourself takes two minutes; discovering it broken mid-edit costs her an evening.
