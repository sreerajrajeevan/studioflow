# Billing & invoices (Task 3)

## The workflow
New Bill (tap services, assign an employee per line if wanted, add an
owner-authorized discount / GST rate) → Checkout (review, optional
customer name, record payments) → Finalize → Invoice (receipt view,
share text/PDF, reprint) → History (search, filter, confirm pending
payments, void).

## Finalization — atomic and idempotent
`DriftBillingRepository.finalizeDraft` runs ONE transaction:
recompute totals through the money engine (UI numbers are never
trusted) → check for an existing bill with the same draft id (return
it — idempotency) → increment the provisional sequence → insert bill,
lines, payments, audit event → delete the draft. A crash or failure
anywhere rolls everything back: no half-written invoice, no burned
sequence number, and the draft survives for retry. The bill is only
reported finalized after the transaction commits.

## Invoice identity — provisional now, server-authoritative later
- Every bill has a globally unique internal id (`inv_…`) that never
  changes.
- The human reference (`INV-2026-0007`) is a LOCAL PROVISIONAL
  reference from a per-device sequence. It is labelled as such on the
  invoice itself. It is NOT an official invoice number.
- Migration path to server numbering (backend task): the backend
  assigns the official number when the bill syncs and stores it
  alongside — the internal id and the provisional reference are never
  rewritten, so issued receipts stay truthful and collisions are
  impossible (each device's provisional space is namespaced by device
  + internal id during sync).

## Payments — method ≠ status
- Methods: cash, UPI, card; split payments are multiple payment rows.
- Statuses: `pending`, `confirmed_manual`, `verified_provider`
  (future). The bill-level status is DERIVED from its payments and
  the total — never set by hand.
- Manual confirmation records who confirmed and when, in the payment
  row and the audit trail. It is labelled "manually confirmed"
  everywhere — never "verified".
- A UPI QR is generated ONLY from the studio's own merchant config
  (UPI id + payee name in Settings) and is amount-prefilled. Showing
  or scanning a QR is not evidence of payment; the QR from Settings
  may not trigger the studio's soundbox (the soundbox's own QR is a
  separate code) — staff confirm manually after the money arrives.
- Finalizing with pending payments is allowed; the invoice shows
  PAYMENT PENDING, and each pending payment can be confirmed later
  from History. Pending payments are never silently discarded.

## Snapshots
The bill freezes: studio name/tagline/address/phone/email/GSTIN/UPI/
footer/brand colour, each line's service name + price + quantity +
employee name, and the full discount/tax breakdown. Later profile or
catalog edits cannot change a finalized invoice (test-covered).

## Voids
A finalized bill is never edited or deleted. Voiding (owner role,
reason required) flips its status, records who/when/why, and writes
an audit event. Voided bills remain in history, struck through.

## Documents
`InvoiceDocument` is the platform-independent representation.
Renderers: plain-text thermal layout (fixed width — the layout a
future Bluetooth driver would consume; Bluetooth printing itself is
NOT implemented or claimed) and PDF (pure Dart, shareable via the
Android share sheet). Financial logic never lives in renderers.

## Schema v3
New tables: bills, bill_lines, payments, invoice_counters,
billing_audit_events. Drafts gained discount/tax columns; draft
lines gained employee columns. Additive migration, test-covered
from a genuine v2 database.
