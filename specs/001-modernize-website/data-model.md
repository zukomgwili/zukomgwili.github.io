# data-model.md — Entities for the modernize-website feature

This feature is content-focused and uses structured front matter and repository assets. No new database or external storage is required; data remains in Markdown files and YAML front matter.

Entities

- AboutPage
  - Fields: title (string), slug (string), bio (markdown text), highlights (array of key/value blocks optional), contact_email (string), resume_asset (string path), social_links (array of SocialLink)
  - Validation: contact_email must be a valid email pattern; resume_asset points to a file path under `assets/`.

- SocialLink
  - Fields: label (string, e.g., LinkedIn), url (string), icon (optional string), visible (boolean)
  - Constraints: URL must be https and not include tracking parameters by default.

- Post (existing)
  - Fields of interest: title (string), date (ISO date), tags (array), excerpt (string, optional), featured_image (optional path), canonical_url (optional)
  - Validation: date must parse; tags normalized to lowercase; fallback excerpt defaulted from content.

- ResumeEntry (existing in _work_history or similar)
  - Fields: company_name (string), job_title (string), start_date (string), end_date (nullable string), description (markdown), location (optional)
  - Validation: start_date must exist; end_date optional for current positions.

Notes: No schema migration required because this feature is a minor refresh. If we later move to Option B/C (structured resume highlights or full site redesign), we may create a small data model migration plan and standardize front-matter across posts and resume entries.
