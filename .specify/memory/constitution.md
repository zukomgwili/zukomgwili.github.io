<!--
Sync Impact Report
Version change: template → 1.0.0
Modified principles:
	- [PRINCIPLE_1_NAME] → Content-first & Accessibility (MUST)
	- [PRINCIPLE_2_NAME] → Simplicity, Maintainability & Minimal Dependencies (SHOULD)
	- [PRINCIPLE_3_NAME] → Privacy & Safety (NON-NEGOTIABLE)
	- [PRINCIPLE_4_NAME] → Test-first / CI Validation (MUST)
	- [PRINCIPLE_5_NAME] → Versioning, Releases & Deployments (SHOULD)
Added sections: Site Constraints & Technology; Development Workflow & Quality Gates
Removed sections: none
Templates updated:
	- .specify/templates/plan-template.md ✅ updated (added explicit checks)
	- .specify/templates/spec-template.md ✅ updated (added compliance checklist)
	- .specify/templates/tasks-template.md ✅ updated (added compliance tasks)
	- .specify/templates/checklist-template.md ✅ updated (compliance guidance)
	- .specify/templates/agent-file-template.md ✅ updated (constitution notes)
Templates to review / manual follow-up:
	- .specify/templates/commands/* ⚠ no commands/ folder found — confirm if any external commands reference templates
Follow-up TODOs: None (RATIFICATION_DATE recorded as adoption date 2025-11-25)
-->

# Zuko Mgwili — Personal Website Constitution

## Core Principles

### Content-first & Accessibility (MUST)
All content published in this repository is the primary purpose of the project. Pages, posts, and site content MUST be designed for clarity, accessibility, and forward-compatibility. Provide semantic HTML, descriptive headings, and accessible images/alt text. Accessibility review (automated + manual checks) is required for new or substantially changed pages.
<!-- Example: Every feature starts as a standalone library; Libraries must be self-contained, independently testable, documented; Clear purpose required - no organizational-only libraries -->

### Simplicity, Maintainability & Minimal Dependencies (SHOULD)
Keep the site implementation simple and maintainable. Avoid unnecessary frameworks or heavy client-side tooling. Prefer content-first implementations using Markdown/Jekyll front matter, small scoped styles in SCSS, and minimal JavaScript. Document any non-trivial dependency and justify it in PRs.
<!-- Example: Every library exposes functionality via CLI; Text in/out protocol: stdin/args → stdout, errors → stderr; Support JSON + human-readable formats -->

### Privacy & Safety (NON-NEGOTIABLE)
Protect visitor privacy and user data: do not include third‑party tracking scripts, leak personally identifying data, or store secrets in the repository. Any analytics or tracking integration MUST be approved by repository owners and documented with the privacy rationale.
<!-- Example: TDD mandatory: Tests written → User approved → Tests fail → Then implement; Red-Green-Refactor cycle strictly enforced -->

### Test-first / CI Validation (MUST)
All changes that affect the built site MUST pass CI validation before merge. CI checks should include a full Jekyll build, link validation, and basic accessibility / lint checks for HTML/CSS when available. Tests ensure regressions are caught early and the GitHub Pages deployment remains reliable.
<!-- Example: Focus areas requiring integration tests: New library contract tests, Contract changes, Inter-service communication, Shared schemas -->

### Versioning, Releases & Deployments (SHOULD)
Treat the site and its infrastructure with simple semantic versioning for significant changes. Use MAJOR.MINOR.PATCH where:
	- MAJOR: Breaking content model or public contract changes (template/front-matter rework)
	- MINOR: New features, new content types, or non-breaking structural additions
	- PATCH: Editorial changes, small fixes, and styling tweaks
Deployments to production via GitHub Pages MUST be backed by a reviewed PR; major changes should include a short migration/rollback plan.
<!-- Example: Text I/O ensures debuggability; Structured logging required; Or: MAJOR.MINOR.BUILD format; Or: Start simple, YAGNI principles -->

## Site Constraints & Technology

This repository is a Jekyll-based static site built for GitHub Pages. Choose technologies that align with the static-first model and optimize for accessibility, performance, and long-term maintainability. Key constraints:

- Static content is preferred — server-side functionality is disallowed unless explicitly documented and reviewed.
- Keep build dependencies minimal and pinned when possible; CI must be able to reproduce builds from repository artifacts.
- Content authorship is recorded in posts/front matter; maintain attribution and source metadata for contributions.
<!-- Example: Technology stack requirements, compliance standards, deployment policies, etc. -->

## Development Workflow & Quality Gates

Changes to this site follow a pull-request based workflow:

- Open a PR with a clear description of what changed and why.
- All PRs MUST be reviewed by at least one repository maintainer before merge.
- CI validation MUST pass prior to merge: build, link checks, and automated accessibility tests when configured.
- For major content-model or structural changes, include a short rollout and rollback plan in the PR description.

Editorial content (posts/stories) may be authored by contributors and approved through normal PR review.
<!-- Example: Code review requirements, testing gates, deployment approval process, etc. -->

## Governance

This constitution is the authoritative source for how this site is managed. The key governance points are:

- Amendments: Any material change to principles or governance MUST be proposed as a PR against this file and approved by the repository owners/maintainers. Minor clarifications may be applied as patch-level changes.
- Compliance: All contributors MUST include a short statement in PR descriptions explaining how the change complies with the constitution (or why an exception is requested).
- Enforcement: Repository maintainers are responsible for enforcing the constitution during code review and CI validation. Rewrites or reversions may be required if a merged change violates non-negotiable items.

**Versioning** and amendment rules are defined in the Version line below.

**Version**: 1.0.0 | **Ratified**: 2025-11-25 | **Last Amended**: 2025-11-25
<!-- Example: Version: 2.1.1 | Ratified: 2025-06-13 | Last Amended: 2025-07-16 -->
