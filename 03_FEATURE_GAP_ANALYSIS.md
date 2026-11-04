# 03 Feature Gap Analysis

## Verified findings

| ID | Module | Feature | Role | Status | Severity | Evidence | Impact | Acceptance test |
|---|---|---|---|---|---|---|---|---|
| GAP-001 | Attendance | Teacher can mark only assigned class students | Faculty | G | P0 | `app/Http/Controllers/Teacher/TeacherAttendanceController.php:24-76` | A teacher can submit a selected class and arbitrary student IDs; records can be reassigned to another class | Reject a teacher request when class is not assigned and when each student is not in that class; assert no writes |
| GAP-002 | Attendance | Attendance is lecture/subject scoped | Faculty | F | P1 | `database/migrations/2026_10_10_000010_create_attendances_table.php:12-21` | Schema stores only student/date uniqueness, so multiple lectures/subjects cannot be represented reliably | Add a verified lecture/subject key and test two same-day sessions independently |
| GAP-003 | Notifications | Real SMS delivery | Parent | C | P1 | `app/Jobs/SendSmsNotification.php:25-34` | Job logs the message instead of calling/verifying a provider; absence alerts are not externally delivered | Provider adapter test with signed/configured response, retries, failure log, and no real send in tests |
| GAP-004 | Marks | Principal publication requires HOD approval | Principal | G | P1 | `app/Http/Controllers/Principal/InternalMarksApprovalController.php:132-148` | `faculty_submitted` is accepted for final publication, bypassing HOD review | Principal publication must reject `faculty_submitted` and accept only `hod_approved` |
| GAP-005 | UI/RBAC | Sidebar reflects effective permissions | HOD/Cashier | G | P2 | Feature suite `RoleSidebarAccessTest`; two failures | Users see links to modules they should not access, causing confusion and possible probing | Render role sidebars and assert unauthorized route URLs are absent |
| GAP-006 | Transport | Live GPS/trip tracking | Transport Manager | F | P2 | Transport models/controllers expose GPS device field but no verified provider/service/job | Fleet safety and live operations are not delivered | Demonstrate provider integration, trip lifecycle, health checks, and audit events |
| GAP-007 | Accounting | Bank reconciliation end-to-end | Accountant | C | P1 | Bank reconciliation migration/controller/tests exist | Import, matching, settlement, and exception operations are not proven end-to-end | Isolated test covers duplicate import, match, unmatch, settlement, and audit trail |
| GAP-008 | Backup | Restore verification | Admin | H | P1 | Backup creation/download/delete routes in `SystemSettingsController` | A backup can exist without a tested recoverability guarantee | Isolated restore rehearsal against disposable database with checksum and audit evidence |
| GAP-009 | Role coverage | Hostel Warden, Placement Officer, Auditor dedicated authorization | Those roles | H | P2 | No dedicated route groups confirmed in inspected route inventory | Role dashboards and least privilege may be incomplete | Add explicit role routes, permissions, and direct URL tests |
| GAP-010 | MFA | Full policy enforcement for every privileged role | Privileged users | C | P1 | `EnsureTwoFactorAuthenticated`, MFA controllers and role checks | Setup/recovery behavior needs complete role matrix and abuse tests | Test every privileged role, expiry, recovery-code reuse, session fixation, and disable authorization |

## Missing or not independently verifiable

- Full 36-module completion cannot be claimed from route/table/view presence alone.
- Production MySQL behavior, queue workers, SMS/WhatsApp/email providers, payment gateway callbacks, GPS, and restore operations were not exercised.
- No coverage report was generated; test pass count is not coverage.
- Database content was not queried for personal records or production integrity because the task did not authorize that access.

