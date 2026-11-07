# Maran Toolbox Pro — optional cloud synchronization (v1.6)

GitHub Pages alone cannot provide user accounts or shared storage. The app is fully usable offline without this setup.

## 1. Create a Supabase project

Create your own project at https://supabase.com/dashboard. Choose the hosting region and review data handling requirements. Under **Authentication → Providers → Email**, enable email OTP sign-in. Set the email template to send a six-digit `{{ .Token }}` code (rather than only a magic link). Configure the site URL to `https://jimk07-dotcom.github.io/maran-toolbox-pro/`. Configure the rate limits and production SMTP before relying on email sign-in.

## 2. Create tables and security policies

In **SQL Editor**, run `supabase_schema.sql`. RLS restricts access to approved fleet members. A user selecting Fleet A in the browser does NOT grant Fleet A access.

## 3. Approve each user

Have each user sign in with their email once. In Supabase **Authentication → Users**, copy their UUID. As the project administrator, run this SQL in the SQL Editor, replacing the sample UUID with the actual user ID:

```sql
insert into public.fleet_members (user_id, fleet) values ('REPLACE-WITH-AUTH-USER-UUID', 'A') on conflict do nothing;
```

Repeat for the second Fleet A Superintendent and, if desired, members of B/C. A member only sees events for their approved fleet. Cross-fleet sharing and per-recipient access are NOT implemented in this release.

## 4. Connect the web app

From Supabase **Project Settings → API** (or Connect), copy **Project URL** and the **publishable/anon** key. In the web app open **Auto Sync**, paste both, Save, enter email, request a code, then verify. **NEVER** use the `service_role` or secret key in the app or GitHub. The anon/publishable key is intended to be public; authorization is enforced by the database RLS policies.

## 5. First synchronization

Use **Upload existing local records** only after reviewing what will be shared. New changes are queued automatically while signed in and uploaded when the app is online and open. The second Superintendent signs in with their approved account and taps **Sync now**. Incoming changes appear in Activity. The app polls while open approximately every 45 seconds and when returning to the app; it does NOT send OS push notifications when closed.

## Limits and cautions

- This is an initial cloud-sync implementation and has not been end-to-end tested against a live Supabase project. Test with non-sensitive dummy data on two devices first.
- This version is **fleet-scoped**, not individual-recipient sharing. Do not invite people to a fleet unless they should see all synchronized records for that fleet.
- New updates are stored as immutable events. When the same record is edited on different devices, newer timestamps are preferred; ambiguous same-time conflicts create a review copy. This is not a fully transactional multi-user editor.
- Photo data in records may make events large; Supabase storage, request and plan limits apply. Dedicated secure photo storage is a future improvement.
- Offline changes queue in localStorage. Browser storage can be cleared, so continue using Switch Phone backups.
- Account email is used instead of SMS phone login. SMS would require an SMS provider and additional setup.
- Do not upload company operational data to third-party hosting without reviewing the applicable confidentiality, access and data-handling obligations.
