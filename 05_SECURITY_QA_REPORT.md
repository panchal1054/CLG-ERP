# 05 Security and QA Report

## Findings

| ID | Severity | File | Lines | Finding | Confidence |
|---|---|---|---:|---|---:|
| SEC-001 | P0 | `app/Http/Controllers/Teacher/TeacherAttendanceController.php` | 24-76 | Attendance writes trust request `class_id` and student IDs without teacher/class/student authorization | 9/10 |
| SEC-002 | P1 | `app/Http/Controllers/Principal/InternalMarksApprovalController.php` | 132-148 | Principal publication accepts `faculty_submitted`, bypassing mandatory HOD approval | 9/10 |
| SEC-003 | P1 | `app/Jobs/SendSmsNotification.php` | 25-34 | SMS delivery is logging-only; absence/receipt alerts are not sent to a provider | 10/10 |
| SEC-004 | P2 | `app/Models/User.php` | 207-214; `app/Http/Middleware/RoleMiddleware.php` | Admin/super-admin global permission and route bypasses make least privilege dependent on role hygiene | 8/10 |
| SEC-005 | P2 | `resources/views/layouts/app.blade.php` | 8-18 | External Google Fonts, FontAwesome, and Chart.js are loaded from CDNs without visible integrity/pinning controls | 7/10 |
| SEC-006 | P2 | `app/Http/Controllers/MessagingController.php` | 103-129 | Any authenticated user can start a direct conversation with any active user unless higher-level policy is added | 7/10 |
| SEC-007 | P2 | `app/Http/Controllers/SystemSettingsController.php` | 320-365 | Backup download/delete relies on controller-level access inherited from broad settings route; restore authorization and immutable retention are not evidenced | 7/10 |

## Positive controls

- CSRF tokens are included in the main Blade layout and forms use Laravel routes.
- Passwords use Laravel hashed casts; login regenerates the session.
- MFA challenge and recovery attempts use rate limiting and short-lived session state.
- Private vault downloads perform owner, linked-parent, HOD department, or admin/principal checks.
- Feature tests include teacher object-scope regressions and marks department boundary cases.
- Attendance has a database uniqueness constraint for one student/date.

## QA execution

| Check | Command | Result |
|---|---|---|
| PHP syntax | `php -l` over `app`, `routes`, `database`, `tests` | 383 files, 0 syntax failures |
| Unit suite | `php artisan test --testsuite=Unit --do-not-cache-result` | 1 passed, 1 assertion |
| Feature suite | `php artisan test --testsuite=Feature --do-not-cache-result` | 466 passed, 2 failed, 2424 assertions |
| Coverage | Not run | No coverage claim |

Failed tests:

1. `RoleSidebarAccessTest::hod sidebar shows authorized and hides unauthorized modules`
2. `RoleSidebarAccessTest::cashier sidebar shows counter and hides advanced accounts`

The failures are currently navigation/sidebar assertions, not a basis for claiming the corresponding backend routes are exploitable. They are, however, verified permission-UX regressions.

## Environment limitations

- No Git history exists in the checkout.
- The real `.env` and personal/student records were not inspected.
- No production database, MySQL server, queue worker, external notification provider, payment gateway, GPS service, or restore rehearsal was used.
- No destructive penetration tests or external requests were performed.

