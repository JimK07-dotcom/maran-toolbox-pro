Maran Toolbox Pro v1.12.1 — updated from uploaded v1.12 ZIP (2026-11-08).

Changes:
- Separate top-level Attendance Plans and Attendance History tabs.
- Removed the nonfunctional Planned modules section from Home.
- Superintendent-only interface; fleet membership is administrator-assigned in Supabase.
- Save My Vessels stores each user’s selected vessels and active vessel in a private Supabase table.
- Signed-in users retrieve their saved selection on subsequent logins and devices.
- Existing vessel, maintenance, drydock, attendance, budget and sync data structures retained.

REQUIRED BEFORE DEPLOYMENT:
1. In Supabase SQL Editor run SETUP_VESSEL_PREFERENCES_v1_12_1.sql.
2. In Integrations > Data API expose public.user_vessel_preferences (auto-expose is OFF).
3. Upload all files in this ZIP to GitHub repository root, replacing existing versions.
4. Reload the app (service-worker cache version was incremented).
5. Sign in under Auto Sync, open My vessels, select ships and click Save My Vessels.

Cloud sync needs an active signed-in account, internet, configured Supabase URL/key, correct table exposure and RLS.
Test with Fleet A/B/C accounts before distributing to colleagues.
Do not upload company confidential data or secret Supabase service_role keys to the public GitHub repository.
