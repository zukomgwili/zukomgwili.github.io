# zukomgwili.github.io — personal website (modernize-website feature)

This repository hosts a Jekyll-based personal website. The `001-modernize-website` feature introduces discoverability, improved readability and CI gates for the site.

Key areas updated by the modernize-website feature:

- About & resume:
  - The `about.md` page is the canonical place for a short author bio and contact links.
  - A canonical, version-controlled resume PDF lives at `assets/resume.pdf` and the site exposes a `Resume` page (`/resume.html`) which links to the PDF and renders the structured `site.work_history` entries.

- Design tokens & styles:
  - Tokens and variables live in `_sass/_tokens.scss` and are imported into `_sass/main.scss` / `assets/css/styles.scss`.
  - To change colors, fonts or spacing start by editing `_sass/_tokens.scss` and then test locally (see below).

- Tests & CI:
  - The repository has CI gates in `.github/workflows/site-checks.yml` which run site build, link checks, accessibility checks and a number of smoke tests.
  - Helpful scripts live in `scripts/` (discoverability, front-matter validators, responsive tests, visual sampling, resume format validation, and front-matter normalizers).
   - Helpful scripts live in `scripts/` (discoverability, front-matter validators, responsive tests, visual sampling, resume format validation, and front-matter normalizers). New accessibility helpers:
    - `scripts/check-image-alts.sh` / `scripts/check-image-alts.py` — scans built HTML for <img> with missing alt attributes
    - `scripts/contrast-check.js` — Playwright + axe-core based color-contrast checks for key pages

    Pre-commit hooks

    The repository includes a pre-commit hook (Husky) that runs a small staged-file image-alt linter. To enable the hooks locally run:

    ```bash
    npm install
    npm run prepare
    ```

    This will ensure `git commit` runs `./scripts/check-image-alts-staged.sh` and blocks commits when markdown/HTML staged files contain images with missing alt text.

How to make small changes safely

1. Edit content (for resume/work-history, change files in `_work_history/*.md`; for site content edit `about.md` or posts in `_posts`).
2. Update tokens and styles in `_sass/_tokens.scss` and `_sass/main.scss`.
3. Build and run tests locally:

```bash
# Build site
bundle install
bundle exec jekyll build --destination _site

# Quick checks (examples)
./scripts/check-discoverability.sh _site
./scripts/validate-front-matter.sh .
./scripts/test-resume-format.sh _site
```

4. Use the visual sampling or responsive smoke-tests for visual verification (optional):

```bash
./scripts/visual-sample-tests.sh _site 4000 visual-snapshots
./scripts/responsive-smoke-tests.sh _site 4000
```

See `specs/001-modernize-website/README.md` for more feature-specific guidance, file locations and development tips.

## Asset optimization helpers

To keep assets and CI artifacts compact you can run lossless optimization helpers that operate on the built site and write their outputs to `_site/optimized/` (non-destructive by default):

```bash
# Build site
bundle exec jekyll build --destination _site

# Optimize images into _site/optimized/assets (svgo + imagemin if available)
npm run optimize:images

# Strip unused CSS into _site/optimized/css (PurgeCSS)
npm run optimize:css

# Inspect results
ls -la _site/optimized
```

The scripts will use `npx` to fetch the required tools on first run if they are not already installed. This lets you review and adopt optimised assets manually or wire them into a CI job.
