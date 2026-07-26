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
assets/             owl-logo.png (favicon + og:image), owl-logo-v1.png, IMG_3840.png
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

### Things that need real values

- `PETITION_URL` at the top of the `<script>` block is `"#"`. Until it's a real
  link, petition buttons show an alert instead of navigating.
- `hello@fightglare.org` in the footer — make sure mail is actually routed there.

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

Aditya works in Claude Code locally. One teammate edits through Claude Code on
the web (claude.ai/code) against this repo and opens a PR — see `EDITING.md`,
which is written for a non-technical reader. She needs Claude Pro for that;
it isn't available on free accounts.

This file is loaded into her sessions too, so the conventions above are the
actual guardrails on her edits — that's the reason they're written out rather
than left implicit. Still review incoming PRs for unrelated drift before
merging.

The earlier workflow was copy `index.html` into claude.ai and paste the whole
file back. It was replaced because whole-file paste-back invites truncation and
silent edits to untouched sections; the web flow produces a targeted diff.

Branch protection on `main` is deliberately OFF so direct pushes keep working;
a stray commit is recoverable with Revert. Cloudflare Pages was considered for
per-PR preview URLs and deferred — see `todo.txt`.

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
