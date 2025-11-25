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

Place `resume.pdf` at `assets/resume.pdf` as the canonical downloadable file. Example:

```bash
cp ~/Downloads/myresume.pdf assets/resume.pdf
git add assets/resume.pdf && git commit -m "chore(spec): add resume asset for About page"
```

4) Editing styles and templates

- Primary styles: `assets/css/styles.scss` and any `_sass` partials (e.g., `_sass/main.scss`) — update variables and tokens for color/typography.
- Templates: `_layouts/default.html`, `_includes/header.html` and `_includes/footer.html` are the first places to adjust for header/footer polish.

5) CI expectations

- New PRs should pass the site build, link checks and automated accessibility checks before merging.
