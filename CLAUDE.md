# Fight Glare — fightglare.org

Static one-page site for a resident-led campaign asking Irvine, CA to adopt its
first outdoor lighting ordinance (warm, shielded, night-friendly streetlights).

## Stack

Plain HTML/CSS/JS. No build step, no framework, no dependencies. Deployed to
GitHub Pages from `main` at the repo root.

```
index.html          Entire site — markup, <style>, and <script> in one file
fonts-preview.html  Scratch page for comparing font pairings; not linked from the site
assets/             owl-logo.png (favicon + og:image), owl-logo-v1.png, IMG_3840.png
CNAME               fightglare.org — required by Pages, do not delete
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

## Deploying

Push to `main`. GitHub Pages rebuilds automatically; changes are live in a
minute or two. There is no staging environment — check the page locally first.
