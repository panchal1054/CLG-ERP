# 06 Implementation Roadmap

## P0 — authorization and integrity

1. **Lock attendance to authorized teaching scope.** Resolve the teacher's assigned classes/subjects, validate every submitted student against the selected class, reject mismatched class IDs, and add object-scope tests. Add a lecture/subject/session identifier before treating attendance as production-grade.
2. **Require HOD approval before publication.** Change final marks publication to accept only `hod_approved`; add a regression test for `faculty_submitted`.
3. **Audit all write controllers for the same scope invariant.** Prioritize transport allocations, student edits, fees, admissions, exams, and document administration.

## P1 — operational reliability

4. Replace the logging-only SMS job with a provider adapter behind configuration, signed callback handling, retries, dead-letter visibility, delivery logs, and test doubles.
5. Complete payment callback idempotency, signature verification, receipt generation, ledger posting, and bank reconciliation exception handling.
6. Rehearse backup restoration against a disposable database and enforce immutable/retention-aware backup permissions.
7. Test MFA enforcement for every privileged role, including recovery-code reuse, setup, disable, expiry, and session fixation.

## P2 — role consistency and operations

8. Fix HOD and cashier sidebar filtering, then add direct URL authorization tests so navigation and backend policies cannot drift.
9. Define dedicated role routes and permissions for Hostel Warden, Placement Officer, and Auditor.
10. Add transport capacity locking, consent history, campus scope, trip lifecycle, GPS provider integration, and maintenance compliance.
11. Verify examination hall-ticket, seating, invigilation, answer-sheet inventory, revaluation, and publication workflows end-to-end.

## P3 — quality and maintainability

12. Add a coverage baseline for critical controllers and policies.
13. Pin or self-host external frontend assets where policy requires it; add CSP/SRI review.
14. Add accessibility and responsive UI checks for dashboards, forms, tables, errors, focus states, and dark mode.

## Acceptance criteria

- No unauthorized attendance mutation is possible through direct HTTP requests.
- No marks can be published without a recorded HOD approval.
- Parent absence alerts have provider delivery evidence or a visible, actionable failure state.
- All 15 listed institutional roles have explicit route, action, and data-scope tests.
- Feature suite is green and critical workflows have measurable coverage.

