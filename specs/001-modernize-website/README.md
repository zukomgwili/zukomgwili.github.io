# Modernize website — feature README

This feature modernizes the Jekyll site in small, incremental steps and introduces a number of developer-facing conventions and helper scripts.

What changed
- Added an About page (`/about.md`) and discoverability checks to ensure it remains reachable.
- Added a canonical resume (`assets/resume.pdf`), a `Resume` page (`/resume.html`) and structured work history under `_work_history/*.md`.
- Introduced design tokens at `_sass/_tokens.scss` and refactored `main.scss` to use those tokens.
- Added CI checks for front-matter validation, privacy checks, discoverability, link-check, accessibility and visual/responsive smoke tests.

Where to look (important files)
- Content
  - `about.md` — short bio, contact links and resume link
  - `_posts/` — blog posts (now normalized to show title/date/excerpt/tags)
  - `_work_history/` — work history items used on `resume.html` (fields: `company_name`, `job_title`, `start_date`, `end_date`)

- Styles & tokens
  - `_sass/_tokens.scss` — central tokens (colors, spacing, fonts)
  - `_sass/main.scss` / `_sass/resume.scss` — feature styles

- Tests & helpers
  - `scripts/validate-front-matter.sh` — validates front-matter in posts
  - `scripts/check-discoverability.sh` — ensures about and resume are reachable in `_site`
  - `scripts/normalize-front-matter.sh` — finds posts missing excerpt/date; supports `--apply`
  - `scripts/test-resume-format.sh` — validates built resume page content (checks for company/title/start date)

How to modify tokens safely
1. Edit `_sass/_tokens.scss` — adjust variables for spacing, color, fonts.
2. Update `_sass/main.scss` or other partials to adopt any new tokens if necessary.
3. Build locally, run tests and view changes in the browser.

CI notes
- The CI workflow `.github/workflows/site-checks.yml` runs the checks; some jobs are configured as soft-warnings to prevent failing PRs prematurely while still notifying reviewers.

If you need more examples or expansion, see `specs/001-modernize-website/quickstart.md` which includes commands and tips for running the new scripts and tests locally.
