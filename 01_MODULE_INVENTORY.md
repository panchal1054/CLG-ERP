# 01 Module Inventory

Audit date: 2026-11-03. Scope: read-only repository review at `D:\attendance`; no migrations, seeders, external calls, notifications, payments, or production writes were run.

## Baseline

- Laravel 12, PHP `^8.2`, SQLite test configuration; Composer and npm manifests are present.
- The Git repository has no commits. All project files are untracked, so historical commit/branch comparisons are unavailable.
- `.env.example` was inspected; the real `.env` was not read or reproduced.
- 383 PHP files under `app`, `routes`, `database`, and `tests` pass `php -l`.
- 67 test files contain 469 test declarations.
- The application has 28 migrations, extensive Blade views, Vite/Tailwind assets, queued notification classes, and a database-backed queue/cache/session design.

## Module status inventory

| Area | Evidence | Status |
|---|---|---|
| Authentication/password reset | `AuthController`, login/reset routes, session regeneration | C — implemented, security hardening incomplete |
| MFA/TOTP | `MfaChallengeController`, `MfaSetupController`, MFA middleware, rate limiter | B — implemented; recovery and policy paths need further verification |
| Users/RBAC | `User`, `Role`, `Permission`, role pivots, role middleware | G — broad role coverage, but route/UI mismatch and default bypass risk |
| Campus/buildings/rooms | campus, room, infrastructure models/controllers/migrations | C — present; full data-scope enforcement not uniformly evidenced |
| Departments/classes/courses | principal routes/controllers and migrations | B — CRUD and relationships present |
| Admission/registration | public registration, OTP routes, admission controllers and tests | B — substantial flow present; delivery/provider production behavior unverified |
| Student/parent identity | student, parent, vault, profile workflows | B — implemented with ownership checks in vault paths |
| Faculty/HR/payroll | faculty, leave, payroll controllers/migrations/views | C — broad surface; end-to-end payroll verification unavailable |
| Academic year/calendar | calendar controller, migration, tests | B — verified by passing feature tests |
| Subjects/allocation/timetable | controllers, routes, clash tests | B — present and tested; authorization breadth requires review |
| Attendance | teacher controller, attendance migration, correction/reporting controllers | G — write path lacks teacher/class/student scope validation |
| Parent absence notifications | gateway, queued SMS job, database notification | C — in-app and queue plumbing present; SMS job is logging-only |
| Internal marks/HOD approval | teacher/principal controllers, statuses, tests | B — workflow substantially verified; principal can publish `faculty_submitted` directly |
| Examinations/hall tickets/seating | university examination controllers and migrations | C — surface exists; full workflow and security not independently verified |
| Revaluation/retotaling | revaluation routes/controller/migrations/tests | B — present; broader result publication integration not verified |
| LMS/materials/assignments | teacher/student controllers, analytics, tracking tests | B — present and tested in selected flows |
| Fees/payments/refunds | fee controllers, payment models/services, cashier routes/tests | C — internal payment workflow present; gateway verification/reconciliation risk remains |
| Accounting/ledger | accounting and bank reconciliation controllers/migrations/tests | B — present with transactional ledger operations |
| Transport | vehicles, drivers, routes, stops, allocations, attendance | C — broad CRUD; capacity, campus scope, and GPS/provider operation not fully verified |
| GPS/fleet maintenance | vehicle GPS fields/compliance command | F — no verified live trip/GPS integration |
| Hostel | hostel controllers, allocations, gate passes, fees | C — surface exists; full operational verification unavailable |
| Library | catalog/circulation controller/views/tests | B — present and tested |
| Notifications/in-app messaging | notifications, messaging, queued jobs | C — database notifications work; external SMS provider is not implemented in the job |
| Certificates/document requests | certificate and vault controllers/services | B — private storage and scoped student vault download verified by code |
| Grievances/helpdesk | helpdesk controllers/views/tests | C — present; delivery/escalation evidence incomplete |
| Placement/alumni | placement controller/views/tests | C — present; integrations not verified |
| Inventory/procurement | inventory controller/views/tests | C — present; procurement lifecycle evidence incomplete |
| Audit trail/analytics | `AuditLog`, audit explorer, analytics controllers/tests | B — present; tamper resistance and completeness not independently proven |
| CMS/public website | CMS controllers, public routes, views/tests | B — present and tested |
| Backup/monitoring | settings backup controller, backup logs, scheduled commands | C — backup UI exists; operational restore and access isolation need verification |

Status legend: B = integration incomplete, C = partially implemented, F = missing entirely, G = broken or insecure. A feature is not classified A unless the relevant business behavior and authorization were verified.

