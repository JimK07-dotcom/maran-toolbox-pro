Maran Toolbox Pro v1.13.1 — Marine Overview REVIEW CANDIDATE

DO NOT DEPLOY TO PRODUCTION WITHOUT TESTING.

Updated:
- Supabase migration preserves existing superintendent fleet memberships.
- Separate manager role for ageorgiou@marantankers.gr.
- Cross-fleet read access for synchronized events and attendance.
- Manager append-only budget revision and management notices.
- Restrictive insert policy to prevent superintendent impersonation of manager notices.

Still to complete/test:
- Manager-created incidents currently use manager_incident events, NOT the full
  vessel_incidents workflow. This is not a substitute for the incident register.
- Existing annual budget records are created in the superintendent app and
  synchronized; there are currently none in Supabase.
- Budget notifications are in-app sync events, not push notifications.
- Confirm correct fleet-specific budget display and notifications in two browsers.
- Mandatory first-login password change is not enforced.
- Audit all RLS policies and run end-to-end tests using separate test accounts.
- Manager budget edits should be tested with a sample budget first.
- Back up Supabase before executing the SQL.
- Do not distribute temporary credentials until first-login password
  enforcement and password recovery arrangements are complete.
