# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

This implementation plan covers a minor visual refresh of the personal site: improved typography, spacing, color palette, and header/footer polish, plus an explicit About page with a downloadable resume. The approach preserves the static Jekyll architecture and favors CSS/SCSS-first styling with minimal JavaScript.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: N/A — site is static and built using Jekyll/GitHub Pages (repository already configured).
**Primary Dependencies**: SCSS (site already uses .scss), Jekyll static site generator, minimal JavaScript for progressive enhancement only; recommended CI helpers: link-checker, accessibility runner.
**Storage**: Flat files in the repository (Markdown, YAML front matter). Downloadable resume stored as a repository asset (e.g., assets/resume.pdf).
**Testing**: CI validations: full site build, link checks, automated accessibility checks (headless a11y testing), and lightweight visual regression sampling or manual visual review.
**Target Platform**: GitHub Pages / static hosting
**Project Type**: Static website (content-centric)
**Performance Goals**: Maintain current performance baseline; avoid introducing large assets or heavy client-side frameworks; visual changes should not cause >20% regression in perceived performance metrics.
**Constraints**: No third-party trackers; keep dependencies minimal and justified; respect accessibility and privacy constraints in the constitution.
**Scale/Scope**: Single-person personal website + blog; limited scope (minor refresh) unless later broadened.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The following checks are mandatory in accordance with the repository constitution. A plan MUST document how it satisfies each relevant gate below and point to the evidence (CI job, checklist, or review notes):

- Accessibility: show how the feature will maintain or improve accessibility (ARIA, semantic markup, keyboard focus, alt text) and note any automated accessibility tests planned.
- Privacy & Safety: document whether the feature introduces third-party tracking, data collection, or storage of user information; any data handling must be justified, minimized and approved.
- CI / Test Coverage: describe the CI requirements for the feature (full Jekyll build, link checks, accessibility checks, unit/integration tests if relevant).
- Minimal Dependencies: justify any non-trivial or new dependencies; prefer native static-site / Markdown approaches where possible.
- Versioning Impact: indicate whether the change is MAJOR, MINOR, or PATCH according to the constitution's semantic versioning guidance and include a migration/rollback note for MAJOR changes.

If any gate cannot be met, the plan MUST include a rationale and a mitigation path; the gate can be escalated for approval by maintainers.

### Gate Validation (this plan)

- Accessibility: PASS — plan adds automated accessibility checks to CI, plus manual review steps for important pages and guidelines for semantic HTML and color contrast.
- Privacy & Safety: PASS — no third-party trackers or embeds planned; social links are direct and contact is mailto-only. Resume will be stored as a repository asset.
- CI / Test Coverage: PASS — CI will run a full site build and link-check; plan adds accessibility runner and lightweight visual sanity checks.
- Minimal Dependencies: PASS — plan favors SCSS and minimal JS, avoids heavyweight frameworks.
- Versioning Impact: MINOR/PATCH — Minor refresh is scoped to visual styling and content grooming, so treat as MINOR (or PATCH for extremely small cosmetic changes).


## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]
**Structure Decision**: This is a static site (Jekyll) — updates will be scoped to templates and styles in the repository root. Primary paths to change:

- `_layouts/` (page templates)
- `_includes/` (navigation/header/footer partials)
- `_sass/` and `assets/css/` (SCSS styles and tokens)
- `index.md`, `about.md` (new About page), `_posts/` (post templates), `_work_history/` (resume entries)


## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |

## Implementation Plan & Phases

This feature will be delivered incrementally with small, reviewable PRs to reduce risk.

Phase 1 — Setup & baseline (P0)
- Add `assets/resume.pdf` placeholder and an `about.md` page for content authoring.
- Add CI workflow that runs a build + link-check + a11y check on PRs.
- Add design tokens (SCSS variables) and a lightweight color/typography palette in `_sass/`.

Phase 2 — UI polish & templates (P1)
- Update `_includes/header.html` / `_includes/footer.html` for modern look and updated navigation.
- Adjust `_layouts/post.html` and `_layouts/default.html` for typography and spacing improvements. Create small visual regression checks for key pages.

Phase 3 — Content validation & cleanup (P2)
- Migrate or verify resume asset exists in `assets/` and add About page content.
- Ensure blog posts/resume entries use consistent front-matter fields and fallback gracefully where fields are missing.

Phase 4 — Polish & deploy (P3)
- Final accessibility review, manual checks for all changed pages.
- Performance sanity checks, image optimization and final CI signoff.

Deliverables
- `plan.md`, `research.md`, `data-model.md`, `quickstart.md` (this plan)
- CI workflow files (example GitHub Actions config)
- Small, iterative PRs implementing CSS and template changes with tests and review notes.

Risks & Mitigations
- Risk: Visual regressions on specific post/resume layouts — Mitigation: targeted visual checks and review by maintainers.
- Risk: Unexpected content model edge cases in older posts — Mitigation: fallbacks for missing front-matter and staged migrations.

Next steps (recommended)
1. Commit these planning artifacts and open a PR for the implementation branch `001-modernize-website` with the plan and research docs attached.
2. Create a small first PR that adds `assets/resume.pdf` placeholder + About page content and CI workflow to enforce build/link-check/a11y.
