---
description: "Task list for feature implementation: Modernize website look & content"
---

# Tasks: Modernize website look & content

**Input**: Design documents from `specs/001-modernize-website/` (spec.md, plan.md, research.md, data-model.md, quickstart.md)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and baseline that enables safe, incremental UI changes.

- [x] T001 [P] Create a canonical, version-controlled resume at `assets/resume.pdf` (add placeholder PDF and README comment) — file path: `/assets/resume.pdf`
- [x] T002 [P] Create the About page scaffold at `/about.md` (front-matter and placeholder content) — file path: `/about.md` (T011 will add finalized content).
- [x] T003 [P] Add a CI workflow file that enforces the constitution gates: full site build, link-check, and automated accessibility checks. Create `.github/workflows/site-checks.yml` with placeholder jobs for `build`, `link-check`, and `a11y`.
- [ ] T004 [P] Add design tokens and initial SCSS variables for colors and typography in `_sass/_tokens.scss` and import them in `assets/css/styles.scss` (or primary stylesheet) — file paths: `/_sass/_tokens.scss`, `/assets/css/styles.scss`
- [ ] T005 [P] Add a small developer guide to update and replace `assets/resume.pdf` in `specs/001-modernize-website/quickstart.md` (already present) and ensure it references the recommended path.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core repository changes that must be in place before any story implementations (templates & CI must be stable).

**⚠️ CRITICAL**: No user story implementation should merge before these tasks complete.

- [ ] T006 Ensure header/footer include updated navigation placeholders & accessibility improvements (skip-links, semantic nav landmarks) — edit files `_includes/header.html` and `_includes/footer.html` and add `aria` attributes where appropriate.
- [ ] T007 Update `_layouts/default.html` and `_layouts/post.html` to reference the new SCSS tokens and provide default typography and spacing blocks.
- [ ] T008 Update `resume.html` (site root) and/or `_layouts/resume.html` to link to `/assets/resume.pdf` and show a clear Download resume link/button (no external embeds) — file path: `/resume.html` or `_layouts/resume.html`.
 - [x] T009 [P] Implement link-check configuration and a11y configuration used by CI (e.g., `.github/ci/link-check-config.yml`, `.github/ci/a11y-config.yml`) and a small sanity test runner script `scripts/ci-checks.sh` to be called from the workflow.
- [ ] T010 [P] Add tests or scripts to verify that updated front-matter fields don't break the build (example: `scripts/validate-front-matter.sh`) — ensure this runs in CI and emits human-readable errors.

---

## Phase 3: User Story 1 - Discover & connect (Priority: P1) 🎯 MVP

**Goal**: Make contact and background information discoverable (About page + mailto link + social links). This is the highest priority and forms the MVP.

**Independent Test**: A new visitor can find an 'About' link from the homepage, visit `/about.html` and see a short bio, an email mailto link and linked LinkedIn + Facebook links; the Download Resume link points to `/assets/resume.pdf`.

 - [x] T011 [US1] Create `about.md` content (short human-readable biography), add the mailto contact link and LinkedIn + Facebook direct links — file path: `/about.md`.
 - [x] T012 [US1] Update site navigation (`_includes/header.html` and/or `_includes/navigation.html`) to include 'About' and 'Resume' links and ensure they are keyboard-accessible and announced by screen readers.
 - [x] T013 [US1] Add an automated discoverability check script `scripts/check-discoverability.sh` that attempts to fetch `/` and confirm `/about.html` and `/assets/resume.pdf` are reachable in the generated site — file path: `/scripts/check-discoverability.sh` and integrate it into CI as a sanity check.
- [ ] T014 [US1] Add content accessibility checks and manual review steps to PR template (`.github/PULL_REQUEST_TEMPLATE.md`) instructing reviewers to check contact info & links.

**Checkpoint**: The About page must be reachable and contain the mailto & social links; CI must validate presence of resources.

---

## Phase 4: User Story 2 - Modern look & readability (Priority: P2)

**Goal**: Improve typography, spacing, and responsive layout to give the site a modern, readable look while preserving content and accessibility.

**Independent Test**: Visual review + CI-based checks show updated typography and responsive layout with no accessibility regressions in automated checks.

- [ ] T015 [US2] Implement typography tokens in `_sass/_tokens.scss` and update `assets/css/styles.scss` to use the new tokens (fonts, sizes, line-heights, responsive breakpoints). Ensure changes are incremental and isolated to CSS modules.
- [ ] T016 [US2] Update `_layouts/default.html` and `_layouts/post.html` to adopt new spacing and structure (headings size, article width, readable line length). Add a `.a11y-skip` skiplink and visible focus styles.
- [ ] T017 [US2] Add mobile-first responsive tweaks and test on common viewport widths (mobile / tablet / desktop); add a CI job for responsiveness smoke-tests (e.g., screenshot checkpoints or CSS property assertions in a script).
- [ ] T018 [US2] Add a small visual sampling step to CI (manual/automated screenshot comparison for home, post, about, resume pages) — make this optional but documented in `specs/001-modernize-website/quickstart.md`.

---

## Phase 5: User Story 3 - Better content structure for posts & resume (Priority: P3)

**Goal**: Ensure consistent metadata across posts and clear resume presentation (structured display of work history) with graceful fallbacks for missing fields.

**Independent Test**: Updated posts have consistent metadata visible in post listing/excerpt pages and the resume view formats all `work_history` entries consistently.

- [ ] T019 [US3] Normalize blog post templates to show `title`, `date`, `excerpt`, `tags` — update `_layouts/post.html` and any index/listing templates to use these fields consistently.
- [ ] T020 [US3] Add a validation script `scripts/normalize-front-matter.sh` that finds posts with missing `excerpt` or `date` and optionally adds fallback values; add this script to CI as a soft-warning job.
- [ ] T021 [US3] Update resume page templates to read `site.work_history` entries (e.g., `_work_history/*.md`) and display `company_name`, `job_title`, `start_date`, `end_date` uniformly; add tests verifying basic formatting for sample entries.

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Final polish, documentation, and cross-cutting improvements required for a production-ready site.

- [ ] T022 [P] Add documentation updates (README, `specs/001-modernize-website/`) describing the new About page, resume location, design tokens and how to modify them.
- [ ] T023 [P] Run a focused accessibility audit and manual remediation pass for all changed pages; create `specs/001-modernize-website/accessibility-report.md` with findings.
- [ ] T024 [P] Optimize images and assets (lossless compression) and remove any large unused CSS rules; ensure performance is not regressing.
- [ ] T025 [P] Finalize CI: ensure the `.github/workflows/site-checks.yml` workflow runs on PRs and branch merges; add human-friendly output and remediation instructions for failures (file path: `.github/workflows/site-checks.yml`).
 - [ ] T025 [P] Finalize CI: ensure the `.github/workflows/site-checks.yml` workflow runs on PRs and branch merges; add human-friendly output and remediation instructions for failures (file path: `.github/workflows/site-checks.yml`).
 - [x] T026 [P] Add a privacy enforcement script and CI step to detect third-party tracking scripts; create `scripts/check-third-party-scripts.sh` and add job step to `.github/workflows/site-checks.yml`.
 - [x] T027 [P] Add PR compliance enforcement: `scripts/check-pr-compliance.sh` and workflow job to fail PRs missing a constitution compliance note.
 - [x] T028 [P] Add Lighthouse CI job to collect Lighthouse reports for baseline and upload as artifacts (workflow updated to include lighthouse job).

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS user stories
- **User Stories (Phase 3+)**: Depend on Foundational phase completion
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### Within Each User Story

- Tests (if included) should be added or fail before implementation (fail-fast, then implement)
- Templates before CSS rework when both required
- Content before discovery checks

## Parallel Opportunities

- Any task marked with [P] can be run in parallel (different files, small independent changes).
- CI and validation scripts can be added in parallel with some UI changes but must be merged before user story completion.

## Parallel Example: User Story 1

```bash
# Run discovery/verifications in parallel (CI + static checks)
./scripts/check-discoverability.sh &
./scripts/validate-front-matter.sh &
wait
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (resume placeholder, about.md, CI skeleton)
2. Complete Phase 2: Foundational templates + CI enforcement
3. Complete Phase 3: User Story 1 — About page & discoverability (MVP!)
4. STOP and VALIDATE: Ensure About is fully discoverable and CI passes

### Incremental Delivery

1. Foundation ready → User Story 1 → Validate/deploy (MVP)
2. User Story 2 in small PRs for typography/spacing → validate accessibility/performance
3. User Story 3 content structure fixes → validate and document

### Notes

- Keep changes small and reviewable — prefer multiple small PRs over a single large PR
- If adding any external tools (e.g., a11y runner), include clear justification and small tests to show value
