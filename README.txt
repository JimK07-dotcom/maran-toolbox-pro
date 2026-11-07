Maran Toolbox Pro v1.6 — browser/PWA, with OPTIONAL Supabase cloud sync.

Publish files (not ZIP) in GitHub repo maran-toolbox-pro, branch main root.
Existing Marine ETA calculator repository is not affected.

Includes Attendance Planner, full device backup/restore, copy/share report, local change history, fleet-specific records and optional email-code sign-in and fleet-scoped sync.

IMPORTANT: Cloud sync is NOT active just by uploading to GitHub. See SETUP_SYNC.md and supabase_schema.sql. You must create and configure a Supabase project and approve user accounts. End-to-end cloud sync has not been tested with a live backend.

Keep confidential records out of your public GitHub repo. The browser app code is public; only approved fleet users can access cloud records if RLS is configured correctly.
