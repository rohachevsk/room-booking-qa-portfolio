# Regression Test Report — Room Booking Service

## 📋 Overview

This document describes the regression testing performed after fixing the defects identified during the initial test execution.

The purpose of regression testing was to verify that the implemented fixes did not introduce new defects and that previously working functionality remained stable.

**Tester:** Rohachevsk
**Testing Date:** 21.09.2026
**Environment:** Local
**Backend:** Node.js + Express + Prisma + PostgreSQL
**Frontend:** React + Vite
**API:** `http://localhost:4000/api`
**Frontend:** `http://localhost:5173`

---

## 🎯 Regression Scope

A full regression test run was performed using the complete test case suite.

The regression scope included:

* User registration
* Authentication and login
* JWT authorization
* User roles and access control
* API response validation
* Security-related scenarios
* Room retrieval and filtering
* Room management
* Booking creation
* Booking validation
* Booking overlap prevention
* Concurrent booking scenarios
* Booking cancellation
* Database operations
* Database seed behavior
* Log management
* Calendar date selection
* Calendar time-slot availability
* Partial booking visualization
* API error handling

**Total Regression Test Cases:** 41

---

## 🧪 Regression Test Execution

All 41 test cases from `TEST_CASES.md` were executed after the implementation of the reported defect fixes.

| Result           |    Count |
| ---------------- | -------: |
| Total Test Cases |   **41** |
| PASS             |   **41** |
| FAIL             |    **0** |
| Blocked          |    **0** |
| Pass Rate        | **100%** |

### Regression Result

**✅ PASS — 41/41 test cases passed**

No regressions were identified during the full regression test execution.

---

## 🐛 Defect Fixes Covered

The regression run included verification of the areas affected by all previously reported defects:

| Bug ID  | Fixed Issue                           | Regression Result |
| ------- | ------------------------------------- | ----------------- |
| BUG-001 | Insecure JWT fallback secret          | ✅ PASS            |
| BUG-002 | Destructive database seed behavior    | ✅ PASS            |
| BUG-003 | Invalid UUID handling                 | ✅ PASS            |
| BUG-004 | Missing login rate limiting           | ✅ PASS            |
| BUG-005 | Whitespace-only full name accepted    | ✅ PASS            |
| BUG-006 | Missing log retention/cleanup         | ✅ PASS            |
| BUG-007 | Past date selection in calendar       | ✅ PASS            |
| BUG-008 | Partial booking conflicts in calendar | ✅ PASS            |

All previously reported defects remained fixed during the regression run.

---

## 🔄 Regression Strategy

A full regression approach was selected because the project contains multiple interconnected application layers:

* REST API
* Authentication and authorization
* Database operations
* Booking business logic
* Frontend calendar functionality

The complete 41-test suite was executed to verify that the implemented fixes did not negatively affect existing functionality outside the individual defect scenarios.

This provided broader coverage than retesting the 8 failed test cases alone.

---

## 📊 Comparison of Test Cycles

| Test Cycle              | Total | PASS | FAIL | Pass Rate |
| ----------------------- | ----: | ---: | ---: | --------: |
| Initial Execution       |    41 |   33 |    8 |     80.5% |
| Retest of Fixed Defects |     8 |    8 |    0 |      100% |
| Full Regression         |    41 |   41 |    0 |  **100%** |

### Result

The initial execution identified **8 defects**.

All 8 defects were subsequently fixed and successfully retested.

The final full regression run resulted in **41/41 PASS**, confirming that no regressions were identified in the tested functionality.

---

## 🔗 Related Documentation

* [Test Plan](./docs/TEST_PLAN.md)
* [Test Cases](./docs/TEST_CASES.md)
* [Retest Report](./docs/RETEST_REPORT.md)
* [Test Summary](./docs/TEST_SUMMARY.md)
* [Bug Reports](./bug-reports/)

---

## ✅ Final Regression Status

**Regression Status: PASS**

**41 / 41 test cases passed**

**100% regression pass rate**

No unresolved regressions were identified during the final regression test execution.
