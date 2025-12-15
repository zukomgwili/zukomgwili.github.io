<!-- Pull Request Template — please fill in and ensure CI checks pass -->

## Summary / purpose

Describe the change at a high level. Keep it short and actionable.

## Checklist — reviewer guidance
Please ensure each item checks out before merging. These items help enforce our feature constitution (accessibility, privacy, discoverability) and protect the public content we publish.

- [ ] CI: All automated checks pass (build, link-check, discoverability, accessibility, front-matter validation, lighthouse)
- [ ] Discoverability: About page is reachable from the site header and `assets/resume.pdf` is present and downloadable from `resume.html` (if applicable)
- [ ] Contact info: `about.md` or other pages include the correct public email address (mailto link) and public-facing social links. Confirm they're intentional for publishing.
- [ ] Resume content: The attached `assets/resume.pdf` (if updated) is appropriate for public distribution (no sensitive data), text-searchable, and reasonably sized.
- [ ] Accessibility & keyboard navigation: Manual spot-check of changed pages for keyboard focus (skip-link), ARIA roles/labels, and semantic headings. Confirm there are no obvious regressions.
- [ ] Links & anchors: Manual check that any internal anchors/pages added (about, resume) resolve and link text is descriptive.

Optional checks / advice

- If you added visual changes: include screenshots or short GIFs of the affected pages for reviewer context.
- If you changed front-matter or templates in a way that alters content model, mention the expected migration steps and add tests where possible.

If you're unsure about a privacy or accessibility concern, leave a comment and assign a reviewer with context (or raise an issue with the accessibility team). Thanks!
