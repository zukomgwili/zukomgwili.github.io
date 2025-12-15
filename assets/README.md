README — assets/

This directory contains site assets used by the site (images, PDFs, etc).

resume.pdf is a canonical, version-controlled copy of the author's resume and should be replaced by the repository owner with a production-ready PDF.

How to replace:

1. Place your final resume PDF at `assets/resume.pdf`.
2. Keep the filename `resume.pdf` (templates & CI checks expect that path).
3. Ensure the PDF is text-searchable (not an image-only scan) and reasonably small.
4. Commit the change: `git add assets/resume.pdf && git commit -m "chore: update resume asset"`.
5. If you want to update the version history, add a short note to the commit message describing the changes.

Privacy note: The resume is public with the repository. Do not include sensitive personal information you don't want published.

Quick verification:

```bash
# Build the site and confirm the resume is discoverable
bundle exec jekyll build --destination _site
./scripts/check-discoverability.sh _site
```
