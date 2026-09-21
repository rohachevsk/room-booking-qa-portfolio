# Test Summary Report

## 1. Project Overview

**Project:** Room Booking Service
**Testing Type:** Manual QA
**Tester:** Rohachevsk
**Testing Period:** September 2026
**Environment:** Local
**Backend:** Node.js / Express / Prisma / PostgreSQL
**Frontend:** React / Vite

The project was tested as a full-stack web application for meeting room management and booking.

The testing process covered API functionality, authentication and authorization, security, database behavior, booking logic, concurrency scenarios, and frontend UI validation.

---

## 2. Testing Scope

The following areas were included in the test scope:

* User registration and authentication
* Login validation
* JWT authentication and authorization
* API response validation
* Sensitive data exposure
* Security-related scenarios
* Room retrieval and filtering
* Room management
* Booking creation and validation
* Booking overlap handling
* Concurrent booking scenarios
* Booking cancellation
* User and admin permissions
* Database behavior
* Soft deletion
* Database seed safety
* Log retention
* Frontend booking calendar
* Date validation
* Time-slot availability
* Partial booking visualization and interaction

---

## 3. Test Execution Summary

A total of **41 test cases** were executed during the initial testing cycle.

| Result            | Count |
| ----------------- | ----: |
| Total Test Cases  |    41 |
| Initial PASS      |    33 |
| Initial FAIL      |     8 |
| Initial Pass Rate | 80.5% |

The 8 failed test cases resulted in 8 documented bug reports.

---

## 4. Defect Summary

A total of **8 defects** were identified and documented.

| Severity  | Count |
| --------- | ----: |
| Critical  |     1 |
| High      |     1 |
| Medium    |     4 |
| Low       |     2 |
| **Total** | **8** |

### Identified Defects

* **BUG-001** — Insecure JWT fallback secret allows forged JWT acceptance
* **BUG-002** — Database seed script deletes existing data
* **BUG-003** — Invalid UUID in `roomId` causes internal server error
* **BUG-004** — Missing rate limiting on login endpoint
* **BUG-005** — Registration accepts whitespace-only full name
* **BUG-006** — Log records grow without retention or cleanup
* **BUG-007** — Calendar allows users to select past dates
* **BUG-008** — Partially occupied hour appears available in calendar

---

## 5. Defect Resolution and Retesting

All 8 identified defects were addressed in the source repository.

Each defect was fixed in a separate Git commit to maintain clear traceability between the defect report and the corresponding code change.

The fixes were subsequently retested using the original defect scenarios.

| Metric             | Result |
| ------------------ | -----: |
| Defects identified |      8 |
| Defects fixed      |      8 |
| Defects retested   |      8 |
| Retest PASS        |      8 |
| Retest FAIL        |      0 |
| Retest Pass Rate   |   100% |

The complete retest results and links to the corresponding fix commits are documented in [`RETEST_REPORT.md`](./docs/RETEST_REPORT.md).

---

## 6. Regression Testing

After defect resolution, regression checks were performed on functionality related to the implemented fixes.

The following areas were verified:

* Authentication and authorization
* User registration and login
* Room management
* Booking creation and validation
* Booking overlap prevention
* Booking cancellation
* Database-related functionality
* Calendar date selection
* Calendar time-slot availability

**Regression Result: PASS**

No regressions were identified during the final verification.

---

## 7. Testing Activities

The project included the following QA activities:

* Application analysis
* Test scope definition
* Test case design
* Positive and negative testing
* Boundary value testing
* API testing
* Authentication and authorization testing
* Security testing
* Database testing
* Concurrency testing
* UI testing
* Bug reporting
* Root-cause investigation
* Retesting
* Regression testing
* Test documentation

---

## 8. Key Findings

The testing process identified issues across several layers of the application:

* **Security:** predictable JWT fallback configuration and missing login rate limiting.
* **Validation:** insufficient validation of user input and UUID format.
* **Database:** unsafe seed behavior and missing log retention.
* **Frontend:** insufficient validation of past dates and partially occupied booking intervals.
* **Error handling:** invalid API input could result in internal server errors instead of structured client errors.

The defects demonstrated that functional correctness alone was insufficient to guarantee correct security, validation, data-management, and user-interface behavior.

---

## 9. Final Test Status

**Final Status: PASS**

All 41 test cases were successfully verified across the initial execution, defect resolution, retesting, and regression stages.

The initial execution resulted in:

* 33 passed test cases
* 8 failed test cases
* 8 documented defects

After defect resolution:

* 8 defects were fixed
* 8 defects were successfully retested
* Regression testing passed
* No unresolved defects from the initial test cycle remained

---

## 10. Conclusion

The Room Booking Service was tested through a structured manual QA process covering functional, security, database, API, concurrency, and UI scenarios.

The testing cycle resulted in 8 documented defects. Each defect was addressed separately in the source repository and subsequently verified through retesting.

The completed QA documentation provides traceability from test cases to defects, fixes, retest results, and regression verification.
