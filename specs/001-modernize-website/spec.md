# Feature Specification: Modernize website look & content

**Feature Branch**: `001-modernize-website`  
**Created**: 2025-11-25  
**Status**: Draft  
**Input**: User description: "This is my (Zuko Mgwili) personal website and blog. I want to improve the look and feel to give it a modern look. I want to also enhance the content and pages with information that is publicly accessible about me. My linkedin profile can be found https://www.linkedin.com/in/zukomgwili/. My facebook page is https://www.facebook.com/zukomgwili"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - [Brief Title] (Priority: P1)
### User Story 1 - Discover & connect (Priority: P1)

As a site visitor, I want to quickly discover authoritative, up‑to‑date information about Zuko (who he is, where to find his work, and how to connect) so I can evaluate his background or contact him.

**Why this priority**: Making contact and credibility information discoverable is the primary user need for a personal website; this delivers the most value with low friction.

**Independent Test**: A new visitor can find an "About" or "Contact" link from the homepage, reach a page with a short biography, and locate LinkedIn and Facebook links within three clicks.

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)
### User Story 2 - Modern look & readability (Priority: P2)

As a visitor reading posts or the resume, I want a clean modern layout (better typography, spacing, and responsive improvements) so the site feels contemporary and is easier to read on all devices.

**Why this priority**: Visual improvements make content more approachable and increase perceived credibility.

**Independent Test**: Visual review and automated accessibility checks show improved typography, spacing and responsive layout on desktop/tablet/mobile; no regressions vs existing pages.

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)
### User Story 3 - Better content structure for posts & resume (Priority: P3)

As a reader or potential employer, I want clearer organization of blog posts and resume details so I can quickly assess skills, experience, and highlights.

**Why this priority**: Improves long-term value of the site and helps visitors find professional material faster.

**Independent Test**: Posts show consistent excerpt/metadata, tags/categories are visible, and the resume section presents clear company/date/role blocks.

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

 - Mobile screens smaller than 320px should still show content legibly (font scaling and layout fallbacks)
 - If a visitor blocks external resources, social links and images should gracefully fall back to text links
 - Any missing front-matter fields in old posts should display safely with a default label (e.g., "Date: unknown")

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

 - **FR-001**: The site MUST provide a persistent, discoverable "About" page with a short biography, public links (LinkedIn + Facebook) and a contact email (mailto link). No third-party contact forms will be added by default. The About page MUST include a downloadable resume link that points to a repository asset (recommended path: `assets/resume.pdf`).
 - **FR-002**: The site layout MUST be updated with a modern, responsive theme (typography, spacing, color palette) and improve mobile usability without breaking existing content structure.
 - **FR-003**: All updated pages MUST pass automated CI checks: a full site build, link-checker for internal/external links, and automated accessibility checks (WCAG AA where reasonable).
 - **FR-004**: No third-party tracking/analytics may be added without explicit approval and privacy justification; social links should be non-tracking by default (prefer direct links, not widgets).
 - **FR-005**: Blog posts and resume entries MUST show consistent, structured metadata (title, date, tags, company, role), and older content should gracefully degrade if fields are missing.

*Example of marking unclear requirements (clarifications follow):*

- **FR-006**: The scope is a Minor refresh — typography, spacing, color palette, header/footer polish (PATCH/MINOR impact).
- **FR-007**: About page scope: Short bio + social links + downloadable resume link (lightweight, privacy-preserving).
- **FR-008**: Social integration approach: Direct links only (no third-party embeds or widgets) to preserve privacy.

*Example of marking unclear requirements:* (examples removed — spec uses real clarifications above)

### Key Entities *(include if feature involves data)*

 - **AboutPage**: human-readable biography + optional structured highlights (location, current role, contact email, links)
 - **SocialLink**: external link resource (e.g., LinkedIn, Facebook) with attributes: label, url, visibility
 - **Post**: blog post (title, date, excerpt, tags, content) — ensure consistent display
 - **ResumeEntry**: work history item (company_name, job_title, start_date, end_date, description)

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: Homepage and key pages build cleanly in CI and pass link-checker with 0 broken internal links and no unexpected 4xx/5xx responses from required external links.
- **SC-002**: 95%+ of updated pages pass automated accessibility checks aimed at WCAG 2.1 AA (where automated checks apply) and all high-risk issues are remediated in manual review.
- **SC-003**: Contact & About information is discoverable within three clicks from the homepage on mobile and desktop in 100% of tested scenarios.
 - **SC-004**: Visual improvements should not regress performance: Core pages should maintain reasonable perceived performance (no >20% regression vs current baseline using standard web performance measurements) — and keep the site lightweight.

## Constitution Compliance *(mandatory)*

Accessibility: The redesign will prioritize WCAG 2.1 AA checks. Automated accessibility tools will be added to CI and manual review is required for all pages containing new content.

Privacy & Safety: No third‑party trackers will be added. The default approach for social profiles is to include direct links to LinkedIn and Facebook (provided by the user). Contact will be provided by email (mailto link) — no third‑party contact forms or widgets will be used by default. Any embeds/widgets must be explicitly requested and approved.

CI / Testing: CI must run a full site build, link-check, and an automated accessibility check. The PR must show CI green before merge.

Dependencies: Prefer CSS/SCSS and minimal JavaScript — avoid large frontend frameworks. Any new dependency must be justified in the PR description.

Versioning Impact: By default this will be a MINOR (non-breaking) change unless scope is clarified as a full site rebrand (in which case this becomes MAJOR).

## Assumptions

- Project remains a static Jekyll GitHub Pages site (no server-side changes expected).
- User-provided public links: LinkedIn (https://www.linkedin.com/in/zukomgwili/) and Facebook (https://www.facebook.com/zukomgwili) will be added as primary social links.
- No analytics or third-party tracking will be added without consent.

 - The downloadable resume will be stored in the repository under `assets/resume.pdf` (or an equivalent versioned path). If an existing resume is hosted externally, it should be copied into the repo during implementation so the canonical copy is version-controlled.

## Clarifications

### Session 2025-11-25

 - Q: Preferred contact method for visitors → A: Option A — mailto (email) link. No third-party contact forms will be used unless explicitly requested and justified.
 - Q: Downloadable resume hosting → A: Option A — include a PDF inside the repository (recommended path: `assets/resume.pdf`) so the document is versioned, auditable, and always available.
 - Q: Social integration approach → A: Option A — direct links only (no third-party widgets); this preserves visitor privacy and aligns with the constitution.

## Open Questions / Clarifications (max 3)

1. Redesign scope (selected): Minor refresh — typography, spacing, color palette, header/footer polish (PATCH/MINOR).
  - Option A: Minor refresh — typography, spacing, color palette, header/footer polish (low effort, PATCH/MINOR).
  - Option B: Targeted page redesign — update homepage, About and Posts templates (moderate effort, MINOR).
  - Option C: Full site redesign / rebrand — new layout system across site and possible content model changes (higher effort, MAJOR).

2. About page content scope (selected): Short bio + social links + downloadable resume link.
  - Option A: Short bio + social links + downloadable resume link.
  - Option B: Short bio + structured resume highlights embedded in the page (structured front-matter content).
  - Option C: Full resume content replicated in the About area and a separate downloadable resume.

3. Social integration approach (selected): Direct links only (recommended — preserves privacy).
  - Option A: Direct links only (recommended — preserves privacy).
  - Option B: Lightweight, privacy-respecting profile cards (serverless markup and image snapshots).
  - Option C: Third-party social widgets / embeds (not recommended — requires explicit approval).



## Constitution Compliance *(mandatory)*

All specifications MUST include a short compliance checklist that explicitly addresses the items in the project constitution. At minimum this should answer:

- Accessibility: Will the feature affect user-facing content? How will accessibility be preserved or improved? What automated/manual checks will be used?
- Privacy & Safety: Does this feature collect, store, or transmit personal data or introduce third‑party trackers? Include data handling/minimization notes.
- CI / Testing: What CI checks validate the feature before merge (site build, link checks, tests, accessibility)?
- Dependencies: Are new runtime or build dependencies required and why? Provide justification.
- Versioning Impact: Does this change require a MAJOR, MINOR or PATCH release? Provide the intended version bump and a migration/rollback note for MAJOR.
