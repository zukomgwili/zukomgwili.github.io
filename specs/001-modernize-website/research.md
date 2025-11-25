# research.md — Modernize website look & content

Decision: Minor refresh (Option A)

Rationale:
- Low effort, low-risk improvements that increase readability and perceived quality without changing content model.
- Preserves repository's static-first design (GitHub Pages + Jekyll) and aligns with the constitution's minimal-dependency and privacy-first requirements.

Design & Technology choices

- Styling: SCSS with CSS variables and a small design token set for colors/typography. Use system font stack with a tasteful fallback for improved performance and wide coverage.
- Layout: Responsive layout using modern CSS (flexbox + CSS grid) with mobile-first breakpoints. Avoid heavy frontend frameworks.
- Accessibility: Improve semantic structure (proper headings, landmarks, skip links), ensure alt text on images, color contrast checks for palette choices, and focus-visible states for keyboard users.
- Contact & Social: Use direct links for LinkedIn & Facebook (no embeds/widgets); include mailto: contact link on About page.
- Resume: Add a downloadable PDF to the repo at `assets/resume.pdf` so the canonical copy is versioned and auditable.

CI & QA

- CI checks: Add a GitHub Actions workflow that runs a full site build, link-check (internal and external link verification), and an automated accessibility check (headless a11y runner) on PRs.
- Visual regression: For this minor refresh a full visual regression suite is optional; instead use a small set of visual sanity checks and manual review for key pages (home, about, post template, resume pages).
- Performance: Keep CSS/JS small, prefer inlined critical CSS or pre-rendered CSS optimizations for above-the-fold content; optimize images and avoid large third-party assets.

Alternatives considered

- Full site redesign (Option C): Not chosen because it increases risk, requires content model changes, and needs a migration plan; reserved for a later milestone.
- Heavy JS frameworks (React/Vue): Rejected because of performance and maintenance cost for this static site — prefer SCSS-driven approach.
- External hosted resume: Considered but rejected to keep canonical content versioned and under control in the repository.

Next steps

1. Create a short implementation plan (data-model.md if needed and quickstart.md) and break down prioritized tasks.
2. Add CI workflow examples and scaffolding for accessibility checks.
3. Implement small, incremental CSS + template updates with PRs for review.
