# Fight Glare — fightglare.org

Static one-page site for a resident-led campaign asking Irvine, CA to adopt its
first outdoor lighting ordinance (warm, shielded, night-friendly streetlights).

## Stack

Plain HTML/CSS/JS. No build step, no framework, no dependencies. Live at
**https://fightglare.org**, deployed to GitHub Pages from `main` at the repo
root via `.github/workflows/deploy.yml`.

```
index.html          Entire site — markup, <style>, and <script> in one file
fonts-preview.html  Scratch page for comparing font pairings; not linked from the site
assets/             owl-logo.png — favicon + og:image, the only image on the site
CNAME               fightglare.org — required by Pages, do not delete
EDITING.md          Browser-only guide for non-technical teammates
todo.txt            Open items — check this first, it's kept current
```

## Working on the site

Preview by opening `index.html` in a browser, or `python3 -m http.server 8000`
from the repo root if you need real paths (`http://localhost:8000`).

Everything lives in `index.html`. Keep it that way unless the page outgrows a
single file — the whole point is that it can be edited and deployed without
tooling.

### Conventions

- **Colors and fonts are CSS custom properties** on `:root` (`--navy-deep`,
  `--periwinkle`, `--amber`, `--font-head`, `--font-body`). Change the variable,
  never hardcode a hex in a rule.
- **Fonts** are Roboto Mono (headings) + Lexend (body), loaded from Google Fonts.
  Swap via `--font-head` / `--font-body`.
- Sections are `<section id="...">`: `problem`, `goal`, `facts`, `progress`,
  `help`. The nav links to these anchors — renaming an id means updating the nav.
- Vanilla JS at the bottom of the file, no libraries. Guard DOM lookups with
  null checks, matching the existing style.

### Branch before committing — contributors only, not Aditya

Check `git config user.email` before committing:

- **`aditya@kernematics.com`** — commit to `main` directly. That's the intended
  workflow here and the reason branch protection is off. Don't branch unasked.
- **anything else** — **create a branch and open a PR. Never commit to `main`.**
  If asked to commit to `main`, say why not and open a PR instead.

A commit to `main` deploys to fightglare.org within a minute, unreviewed. The
teammate edits from a clone in the Claude desktop app, where nothing on screen
shows which branch she's on, so this file is the only guardrail in her way. It
isn't a guardrail Aditya needs — he's the reviewer.

### Contact points

- `PETITION_URL` at the top of the `<script>` block drives all four "Sign the
  Petition" buttons. It's live (change.org). Setting it back to `"#"` disables
  every button at once and restores a placeholder alert — that's the intended
  kill switch if the petition ever moves.
- `fightglareirvine@gmail.com` appears twice, in the CTA block and the footer.
  Change both or neither.
- `.note-placeholder` is a dashed amber badge for marking unfinished values.
  Nothing uses it now. It renders **visibly on the live page**, so anything
  wearing it is public — use it only for things being fixed the same day.

## Accessibility

This site is about people who are hurt by bad light, so the page should not be
hard to look at either. Preserve what's already there when editing:

- Visible `:focus-visible` outlines (`--focus-ring`) on links and buttons
- `aria-expanded` / `aria-label` sync on the mobile menu toggle
- `aria-label` on the primary nav, `alt=""` on decorative images
- Sufficient contrast against `--navy-deep` — check any new color pairing

## Content ground rules

Claims about lighting and health are cited to real sources (AMA, DarkSky) and
link out. Do not add statistics, dates, or claims about the City of Irvine's
position without a source to link — this is advocacy aimed at a city council,
and an unsourced number is a liability.

## Contributors

Aditya works in Claude Code locally. One teammate (Claude Max) uses the Claude
desktop app in a Local session on a clone of this repo, and asks Claude to do
the git work in plain English — see `EDITING.md`, written for a non-technical
reader, with the one-time machine setup in its appendix.

This file loads into her sessions too, so the conventions above are the actual
guardrails on her edits — that's why they're written out rather than left
implicit. Still review incoming PRs for unrelated drift before merging.

Earlier approaches and why they were dropped:

- Copy `index.html` into claude.ai and paste the whole file back. Whole-file
  paste-back invites truncation and silent edits to untouched sections.
- Claude Code on the web (claude.ai/code). Produces a clean targeted diff, but
  a cloud session gives her no way to *see* the rendered page — only a diff.
  Desktop Local sessions open static HTML in the Browser pane and auto-verify
  with screenshots, which is the whole reason for the extra setup cost.
- GitHub Desktop alongside the Claude app, for branch/commit/PR. Dropped as
  one GUI too many. Claude runs the git commands for her instead, which is why
  "Branch before committing" above is a rule rather than a note — GitHub
  Desktop used to show the current branch on screen, and nothing does now.

Her clone authenticates as her own GitHub account, not Aditya's, so PR
attribution is hers and no credential of his sits on her machine.

Branch protection on `main` is deliberately OFF so direct pushes keep working;
a stray commit is recoverable with Revert.

Cloudflare is being added for per-branch preview URLs — on **Workers** with
static assets, not Pages, since Cloudflare now steers new projects there. See
`todo.txt`. It is **additive**: fightglare.org stays on GitHub Pages and DNS is
untouched. The `_headers` file at the repo root belongs to Cloudflare and is
inert under GitHub Pages, which ignores it.

Two things about `_headers` that are easy to get wrong:

- Its rules are scoped to `workers.dev` hostnames on purpose, so they keep the
  Cloudflare copies out of search results without touching the real domain.
  Simplifying it to a bare `/*` rule works today but would noindex
  fightglare.org itself the moment production moved to Cloudflare.
- Pages and Workers use different placeholder syntax. `:project.pages.dev`
  patterns do not match a `workers.dev` host, and the failure is silent — the
  file parses, the header just never appears.

Adding fightglare.org as a Cloudflare custom domain is the one step that would
move production off GitHub Pages; don't do it by accident.

## Deploying

Push to `main`. The workflow rebuilds automatically; changes are live in a
minute or two. There is no staging environment — check the page locally first.

Infrastructure notes, learned the hard way:

- `configure-pages` uses `enablement: true` because the Pages site didn't exist
  and the step 404'd. Don't remove it.
- With **Actions-based** deploys, the `CNAME` file does **not** register the
  custom domain — it ships in the artifact but configures nothing. The domain is
  set in repo Settings → Pages. (This differs from branch-based Pages, where the
  file does register it.) Both are in place now; don't "fix" one by deleting the
  other.
- DNS is at GoDaddy: four A records on `@` (185.199.108–111.153) and a `www`
  CNAME to `arphysics.github.io`. The `www` CNAME must point there, not at the
  apex, or the TLS cert won't cover `www`.
- The `/repos/{owner}/{repo}/pages` API needs auth and 404s for anonymous
  requests even when Pages works fine. Don't read that 404 as "Pages is off" —
  check the workflow run and the live site instead.

To verify a deploy landed, diff the live page against the commit:

```sh
curl -sL https://fightglare.org/ | md5 -q; md5 -q index.html
```
