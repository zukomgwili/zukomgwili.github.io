# quickstart.md — How to run and iterate on this feature

This quickstart describes how to run the site locally, add the resume PDF into the repository, and preview UI changes.

1) Install dependencies (macOS / zsh):

```bash
# From repository root
bundle install
```

2) Run the site locally (development server):

```bash
# Start Jekyll dev server
bundle exec jekyll serve --livereload
```

3) Add/replace the repository resume asset

Place `resume.pdf` at `assets/resume.pdf` as the canonical downloadable file. Keep the filename exactly `resume.pdf` so templates and discovery scripts can locate it automatically. Recommended checks when replacing the file:

- Keep the PDF text-searchable (not just a scanned image) and remove unnecessary personal data — the repo is public.
- Keep file size small where possible (try to keep under ~2MB) to keep page load and CI artifacts fast.
- Make sure the document is accessible (tagged PDF, readable by screen readers) if you plan to include it as the canonical resume.
- If you must change the path, update `_layouts/resume.html` or the templates that reference the asset and update `scripts/check-discoverability.sh` tests accordingly.

Example commands to update the asset and commit it:

```bash
# Copy your final PDF into the canonical asset path
cp ~/Downloads/myresume.pdf assets/resume.pdf

# Check the built site contains the file and is discoverable
bundle exec jekyll build --destination _site
./scripts/check-discoverability.sh _site

# Commit and push
git add assets/resume.pdf && git commit -m "chore(spec): update canonical resume asset" && git push origin HEAD
```

CI notes: The site CI (see `.github/workflows/site-checks.yml`) includes a discoverability check which ensures that `about.html` and `assets/resume.pdf` exist in the built `_site` and will fail the PR if they are missing. Follow the PR checklist (T014) to include accessibility verification when publishing an updated resume.

4) Editing styles and templates

- Primary styles: `assets/css/styles.scss` and any `_sass` partials (e.g., `_sass/main.scss`) — update variables and tokens for color/typography.
- Templates: `_layouts/default.html`, `_includes/header.html` and `_includes/footer.html` are the first places to adjust for header/footer polish.

6) Visual sampling (optional)

To capture quick visual snapshots for reviewers (mobile/tablet/desktop) run the optional visual sample collector after you build the site:

```bash
# Build site
bundle exec jekyll build --destination _site

# Run the visual sampling wrapper (will install Playwright & browsers temporarily)
./scripts/visual-sample-tests.sh _site 4000 visual-snapshots

# Inspect screenshots in visual-snapshots/ — CI uploads these as artifacts for PRs
ls -l visual-snapshots
```

This step is optional (keeps CI faster when disabled), but can be valuable when reviewing visual changes. The CI job `visual-sampling` implements this during PR checks and saves artifacts for reviewer download.

5) CI expectations

- New PRs should pass the site build, link checks and automated accessibility checks before merging.
