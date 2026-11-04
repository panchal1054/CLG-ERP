# 02 Role and Permission Matrix

Evidence sources: `routes/web.php`, `app/Http/Middleware/RoleMiddleware.php`, `app/Models/User.php`, controller checks, sidebar tests, and RBAC migrations.

| Role | Route coverage | Default permissions/evidence | Audit result |
|---|---|---|---|
| Super Admin | Broad principal/admin route access | `isAdmin()` bypasses permission checks | G — highest privilege is intentionally broad; must be protected by MFA and separation-of-duties controls |
| Principal | Principal portal and approval routes | Academic, student, attendance, fees, exams, reports, faculty | B — broad access; some workflows permit final publication as designed |
| College Administrator/Admin | Admin bypass in middleware and model | Global bypass | G — verify governance, MFA enforcement, and last-admin controls |
| HOD | Principal group plus department approval | Department-scoped approval helper | B — department checks exist for marks; other modules need consistent scope guards |
| Faculty/Teacher | Teacher group and teacher defaults | Attendance, coursework, marks, practicals | G — attendance controller accepts arbitrary class/student identifiers |
| Admission Officer | Principal group and admission defaults | Admissions/student/document operations | C — route access present; object-level scope not uniformly evidenced |
| Student | Student group and self-service controllers | Coursework, timetable, marks, practical | B — several self-owned paths are scoped; direct URL review remains incomplete |
| Parent/Guardian | Parent group and linked-child controllers | Child attendance/marks/timetable | B — linked-parent checks are present in document vault; verify all child-facing controllers |
| Fees Cashier | Principal group plus fee/counter routes | Collection and receipt defaults | G — feature suite reports cashier sidebar exposes fee structures unexpectedly |
| Accountant | Principal group plus accounting/fee routes | Accounts and fee management | C — broad access; bank/ledger authorization needs role-specific tests |
| Transportation Manager | Principal group plus transport group | Transport view/manage | C — routes exist; transport data is not consistently campus-scoped in inspected controller |
| Hostel Warden | No dedicated role group was found in the inspected route groups | Hostel surface exists | H — role route/permission coverage cannot be confirmed from current evidence |
| Librarian | Library group | Library catalog/issue/return/fines | B — dedicated library middleware exists |
| HR/Payroll Manager | Principal group | HR/payroll defaults | C — route surface present; payroll data segregation requires more tests |
| Placement Officer | Placement controller/views | No dedicated role group confirmed | H — role-specific authorization evidence incomplete |
| Examination Superintendent | Principal group plus exam defaults | Exams, seating, supervision, reports | C — route surface present; object-level exam security not fully verified |
| Auditor | Dashboard URL falls back to principal dashboard | `isAuditor()` only | H — no dedicated auditor route/permission matrix evidenced |

## Authorization observations

1. `RoleMiddleware` grants all routes to primary `admin` and `super_admin` roles.
2. `User::hasPermission()` also grants all permissions to `isAdmin()`, creating two independent global bypasses.
3. Many route groups use role strings, while controllers separately use dynamic permissions; this creates drift risk.
4. The feature suite has two current failures in `RoleSidebarAccessTest`: HOD and cashier navigation exposes links expected to be hidden. This is a verified UI/authorization consistency defect, not proof that the underlying POST routes are exploitable.
5. A role is considered adequately protected only when route middleware, object scope, action authorization, and data scope agree. The inspected attendance write path does not meet that standard.

