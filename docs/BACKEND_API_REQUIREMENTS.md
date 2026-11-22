# Future Backend — API Requirements (design only, Task 1.6)

Planned stack: **Spring Boot + PostgreSQL**, REST + real-time sync, secure
per-studio (tenant) isolation. Flutter clients sync through this backend;
local SQLite (Drift) is a cache + controlled offline queue — never
device-to-device sync.

## Non-negotiable rules

1. **Invoice numbers are assigned by the server** from a per-studio,
   per-prefix sequence inside the bill-commit transaction. Clients submit
   bills with a client-generated UUID (idempotency key) and receive the
   official number back. Offline-created bills stay "pending sync" with no
   official number until committed.
2. **Tenant isolation:** every row carries `studio_id`; the server derives
   it from the authenticated principal, never from a client-supplied field.
3. **Payments:** the backend records payment *status reported by the
   studio's own merchant provider* (e.g. their soundbox/UPI PSP webhook).
   Customer money never touches our accounts. QR payloads are generated for
   the studio's verified merchant VPA only.
4. **Roles:** OWNER and STAFF principals; the server enforces what the
   client's role-preview only hints at (staff cannot read payroll/settings).
5. **Snapshots:** bill commit stores the studio snapshot + line name/price
   copies server-side, identical rule to the local design.

## Core resources (REST sketch)

- `POST /auth/login` → JWT (owner/staff), refresh flow
- `GET/PUT /studios/me` — studio profile & branding
- `GET/POST/PUT /services`, `/services/{id}/deactivate`
- `GET/POST/PUT /employees`
- `POST /attendance/bulk` (one day, whole team), `GET /attendance?date=`
- `POST /bills` (idempotency-key header) → `{ billId, invoiceNumber }`
- `GET /bills?from&to&q`, `GET /bills/{id}`
- `GET /payroll?month=`, `POST /payroll/payments`
- `GET /reports/summary?range=`, `/reports/services`, `/reports/payments`
- `POST /payments/upi/intent` → QR payload for the studio's merchant VPA
- WebSocket/SSE channel per studio for live bill/attendance sync across
  devices, with per-entity version vectors or server timestamps for
  conflict resolution (server wins on totals; last-writer-wins only where
  documented).

## Offline contract

- Clients queue mutations locally (Drift outbox table) with UUIDs.
- Sync is pull-since-cursor + push-outbox; conflicts on bills are
  impossible by construction (append-only + server numbering).
- Attendance edits within the same day from two devices: server keeps an
  audit trail, latest marked status wins, both entries retained.
