Paints v1.14.0 REVIEW CANDIDATE

Implemented in UI:
- Budgets -> Paints / Moorings placeholder
- Vessel selection, Jotun manual actuals (10/12 months), confirmation and annualization
- Five-year history, 5% below average calculation
- Separate paint deliveries with date/port/quantity/unit/cost
- Supply-based balance, separate from official Jotun actuals
- Annual Paints budget entry, review confirmation, audit log
- Excel-compatible CSV export

NOT IMPLEMENTED:
- Formatted .xlsx matching the Jotun workbook
- Supabase synchronization and fleet-wide sharing of NEW paint actuals/deliveries
- Manager notification for new paint budget edits
- Full end-to-end tests / production deployment

DO NOT deploy over live v1.12.4 yet. Keep existing Supabase unchanged.
