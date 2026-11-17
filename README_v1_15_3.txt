Maran Toolbox Pro v1.15.3 — Fleet Management and one-time attendance import.

Run VESSEL_DIRECTORY_SETUP.sql in Supabase SQL Editor before using shared Manage Fleet. This setup is NOT applied automatically.
The 49 historical attendances are NOT automatically uploaded: sign in as dkarakasilis@marantankers.gr, open Attendance History, review the list and press Import my historical attendances. Existing matching records are skipped.
Sold historical vessels are seeded locally and will appear in Manage Fleet. For company-wide shared status, save each to the database after setup; existing active vessels continue from built-in fleet list.
This build has static syntax checks only; online database permissions and imports require live testing.
