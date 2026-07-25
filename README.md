# Fight Glare

Source for [fightglare.org](https://fightglare.org) — a resident-led movement
asking Irvine, CA to adopt its first outdoor lighting ordinance: warm,
well-shielded, night-friendly streetlights.

## Running it locally

No build step, no dependencies. Open `index.html` in a browser, or serve the
directory if you want real paths:

```sh
python3 -m http.server 8000   # then visit http://localhost:8000
```

## Layout

| Path                  | What it is                                          |
| --------------------- | --------------------------------------------------- |
| `index.html`          | The entire site — markup, styles, and script in one  |
| `assets/`             | Owl logo (favicon + social preview) and images       |
| `fonts-preview.html`  | Scratch page for comparing font pairings             |
| `CNAME`               | Custom domain for GitHub Pages                       |
| `.github/workflows/`  | Deploys `main` to GitHub Pages on every push         |

## Deploying

Push to `main`. The Pages workflow publishes the repo root as-is; the site is
live a minute or two later.
