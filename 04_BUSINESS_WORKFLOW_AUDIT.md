# 04 Business Workflow Audit

| Workflow | Evidence reviewed | Result |
|---|---|---|
| Attendance | Teacher marking controller, unique student/date migration, absence notification gateway, correction/report tests | G — transaction and duplicate protection exist, but teacher/class/student scope and subject/lecture identity are missing |
| Marks | Faculty entry, status transitions, HOD department guard, principal publication, workflow tests | B/G — faculty lock, HOD boundary, return, and notifications are present; principal can publish `faculty_submitted` without HOD approval |
| Address change | Student/parent request controllers, HOD/transport/admin decisions, workflow service/tests | B — multi-stage workflow exists; cross-campus and notification completeness need further verification |
| Fee payment | Fee/cashier controllers, payment models/services, receipt and accounting tests | C — internal transaction flow exists; gateway callback verification and reconciliation cannot be claimed |
| Transport | Registration/allocation/routes/vehicles/drivers/attendance controllers and tests | C — operational CRUD exists; consent, capacity race safety, campus scope, GPS and fee integration remain incomplete |
| Examination | Session/schedule/hall ticket/marks/revaluation controllers and migrations | C — substantial subsystem exists; answer-sheet inventory, invigilation security, and full publication chain not independently verified |
| Certificates | Certificate/document request controllers, PDF/QR verification, vault | B — application, approval, generation and public verification surfaces exist; delivery/audit completeness needs more evidence |

## Critical sequence observations

### Attendance

The controller loads all classes, accepts `class_id`, and loops over request-provided student IDs. It does not establish that the authenticated teacher owns the class or that each student belongs to the submitted class before creating/updating records. The database unique key prevents duplicates but does not prevent unauthorized reassignment.

### Marks

Teacher ownership is enforced when loading the exam. HOD review is department-scoped and conflict-of-interest protected. The final approval condition is too permissive: `hod_approved` **or** `faculty_submitted` can be published.

### Notifications

The absence flow dispatches queued jobs after the transaction and creates database notifications. The queued SMS job writes a log line only, so the complete parent-notification workflow is not live-provider verified.

### Financial integrity

The inspected accounting controller uses transactions and `lockForUpdate()` for ledger entries. This is positive evidence, but it does not prove gateway callback idempotency, bank file reconciliation, or production provider signature validation.

