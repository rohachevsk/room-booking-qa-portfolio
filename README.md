# Room Booking Service — Manual QA Testing Portfolio

Welcome to my Manual QA portfolio! This project demonstrates a complete Software Testing Life Cycle (STLC) applied to a full-stack Room Booking Service web application.

The goal of this project is to showcase my QA workflow: from application analysis and test design to API, database, security, and UI testing, defect reporting, bug fixing, retesting, and regression testing.

The project also demonstrates my ability to investigate defects beyond the UI level, validate application behavior using database queries and source-code inspection, and maintain traceability between test cases, bug reports, fixes, and retest results.

---

## 🎯 Testing Approach & Philosophy

This project focuses on practical manual testing techniques and follows a structured QA workflow:

**Application Analysis → Scope → Test Design → Test Cases → Execution → Bug Reports → Fixes → Retest → Regression → Test Summary**

**Types of Testing Performed:**

* Functional Testing
* REST API Testing
* UI Testing
* Database Testing
* Authentication & Authorization Testing
* Security Testing
* Negative Testing
* Boundary Value Testing
* Equivalence Partitioning
* Concurrency Testing
* Input Validation Testing
* Exploratory Testing
* Retesting & Regression Testing

---

## 💻 Test Environment

* **OS:** Windows 11
* **API:** `http://localhost:4000/api`
* **Frontend:** `http://localhost:5173`
* **Database:** PostgreSQL
* **API Tool:** Postman
* **Browser:** Google Chrome
* **Tester:** Rohachevsk
* **Initial Test Execution:** 21.09.2026
* **Retest & Regression:** 21.09.2026

---

## 🏢 Application Under Test (AUT)

Room Booking Service is a full-stack web application for managing meeting rooms and creating reservations.

The testing scope covered:

* User registration and authentication
* Login and JWT authorization
* User roles and access control
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
* Booking calendar
* Date validation
* Time-slot availability
* Partial booking visualization
* API error handling
* Security-related scenarios

---

## 📊 Test Execution Results

During the initial test execution, **41 test cases** were executed.

| Result            |     Count |
| ----------------- | --------: |
| Total Test Cases  |    **41** |
| Initial PASS      |    **33** |
| Initial FAIL      |     **8** |
| Initial Pass Rate | **80.5%** |

The 8 failed test cases resulted in 8 documented defects.

After defect resolution, all 8 defects were retested successfully.

| Retest Result    |    Count |
| ---------------- | -------: |
| Defects Retested |    **8** |
| Retest PASS      |    **8** |
| Retest FAIL      |    **0** |
| Retest Pass Rate | **100%** |

---

## 📂 Project Structure & QA Documentation

All QA documentation is organized to demonstrate the complete testing lifecycle.

```text
room-booking-qa-portfolio/
├── README.md
│
├── docs/
│   ├── CHECKLIST.md
│   ├── RETEST_REPORT.md
│   ├── TEST_CASES.md
|   ├── TEST_DESIGN_TIME.md
|   ├── TEST_PLAN.md
|   ├── TEST_SUMMARY.md
│   └── REGRESSION_TEST.md
│
├── bug-reports/
│   ├── BUG-001.md
│   ├── BUG-002.md
│   ├── BUG-003.md
│   ├── BUG-004.md
│   ├── BUG-005.md
│   ├── BUG-006.md
│   ├── BUG-007.md
│   └── BUG-008.md
│
├── postman/
│   ├── Room Booking API.postman_collection.json
|   ├── Room Booking Dev.postman_environment.json
|   └── README.md
│
└── sql/
    ├── test-queries.sql
    └── README.md
```

---

## 🐛 Defects Found

During the initial test execution, **8 defects** were identified, documented, and reported.

| Bug ID                                  | Description                                                    | Severity | Priority | Related TC |
| --------------------------------------- | -------------------------------------------------------------- | -------- | -------- | ---------- |
| **[BUG-001](./bug-reports/BUG-001.md)** | Insecure JWT fallback secret allowed forged JWT acceptance.    | Critical | Critical | TC-015     |
| **[BUG-002](./bug-reports/BUG-002.md)** | Database seed script could delete existing application data.   | High     | High     | TC-038     |
| **[BUG-003](./bug-reports/BUG-003.md)** | Invalid `roomId` UUID caused an internal server error.         | Medium   | Medium   | TC-026     |
| **[BUG-004](./bug-reports/BUG-004.md)** | Login endpoint had no rate limiting protection.                | Medium   | Medium   | TC-016     |
| **[BUG-005](./bug-reports/BUG-005.md)** | Registration accepted a `fullName` containing only whitespace. | Minor    | Medium   | TC-005     |
| **[BUG-006](./bug-reports/BUG-006.md)** | Log records had no retention or cleanup mechanism.             | Low      | Low      | TC-039     |
| **[BUG-007](./bug-reports/BUG-007.md)** | Calendar allowed users to select past dates.                   | Low      | Low      | TC-040     |
| **[BUG-008](./bug-reports/BUG-008.md)** | Partially occupied booking hours appeared fully available.     | Medium   | Medium   | TC-041     |

---

## 🔍 Highlight: Deep Defect Investigation

The testing process included not only black-box testing but also white-box investigation of application behavior.

For example, during the investigation of **BUG-001**, the authentication implementation was inspected to identify the reason why a forged JWT could be processed.

For **BUG-003**, an invalid UUID was used to verify how the API handled malformed input and whether the resulting database exception was converted into an appropriate client error.

Database-related defects were additionally investigated through source-code inspection and direct database verification.

This approach helped identify not only the visible symptoms but also the underlying implementation issues.

---

## 🔄 Retest & Regression Testing

Following the implementation of the fixes, a dedicated retesting cycle was performed.

Each of the 8 reported defects was fixed in a **separate Git commit** in the source repository and then verified against its original test scenario.

### Retest Results

| Bug ID  | Issue Verified                              | Retest Status |
| ------- | ------------------------------------------- | ------------- |
| BUG-001 | JWT fallback secret issue resolved          | ✅ **PASS**    |
| BUG-002 | Unsafe destructive seed behavior resolved   | ✅ **PASS**    |
| BUG-003 | Invalid UUID handled correctly              | ✅ **PASS**    |
| BUG-004 | Login rate limiting implemented             | ✅ **PASS**    |
| BUG-005 | Whitespace-only names rejected              | ✅ **PASS**    |
| BUG-006 | Log retention/cleanup addressed             | ✅ **PASS**    |
| BUG-007 | Past date selection prevented               | ✅ **PASS**    |
| BUG-008 | Partial booking conflicts handled correctly | ✅ **PASS**    |

### Fix Traceability

Each fix is linked directly to its corresponding source commit:

| Bug     | Fix Commit                                                                                                    |
| ------- | ------------------------------------------------------------------------------------------------------------- |
| BUG-001 | [`644a595`](https://github.com/rohachevsk/RoomBookingService/commit/644a5952347dff8a47174317809d4bbd723b4c02) |
| BUG-002 | [`b034ad8`](https://github.com/rohachevsk/RoomBookingService/commit/b034ad8371446c8a60ab6107d0378e7bfc0e6edb) |
| BUG-003 | [`8d83260`](https://github.com/rohachevsk/RoomBookingService/commit/8d83260f05e7d8aa73de0c723a1e14f31b907a25) |
| BUG-004 | [`8e55c16`](https://github.com/rohachevsk/RoomBookingService/commit/8e55c16815401b0641d90fd6ed54fbda19fd5402) |
| BUG-005 | [`e2ef8bf`](https://github.com/rohachevsk/RoomBookingService/commit/e2ef8bf79eb27dc4df5e0dc9fae01708e86c07d7) |
| BUG-006 | [`60b3c84`](https://github.com/rohachevsk/RoomBookingService/commit/60b3c8462996c12fbaf2618da0a201d2151417d8) |
| BUG-007 | [`74d89d9`](https://github.com/rohachevsk/RoomBookingService/commit/74d89d93518ccf510d4c49f2a7465abe4784b74e) |
| BUG-008 | [`76a0c4b`](https://github.com/rohachevsk/RoomBookingService/commit/76a0c4be1f673a92df33aa39c0f6205cfbd83323) |

### Regression Testing

After fixing the identified defects, regression checks were performed across functionality related to the affected areas.

The regression scope included:

* Authentication and authorization
* User registration and login
* Room management
* Booking creation and validation
* Booking overlap handling
* Booking cancellation
* Database-related functionality
* Calendar date selection
* Calendar time-slot availability

**Regression Result:** ✅ **PASS**

No regressions were identified during the final verification.

---

## 🧪 Test Documentation

The complete QA documentation is available in the repository:

* **[Test Plan](./docs/TEST_PLAN.md)** — testing scope, approach, risks, and strategy
* **[Test Cases](./docs/TEST_CASES.md)** — 41 documented test cases
* **[Bug Reports](./bug-reports/)** — 8 detailed defect reports
* **[Retest Report](./docs/RETEST_REPORT.md)** — verification of all fixed defects
* **[Test Summary](./docs/TEST_SUMMARY.md)** — final testing results and conclusions
* **[Postman Collection](./postman/)** — API testing resources
* **[SQL Scripts](./sql/)** — database testing queries and scripts

---

## 🛠️ Tools Used

* **Postman** — REST API testing and request validation
* **PostgreSQL** — database state verification and SQL queries
* **Prisma** — database interaction and white-box investigation
* **Google Chrome** — frontend UI testing
* **Chrome DevTools** — network and browser-side investigation
* **Git & GitHub** — version control and defect-fix traceability
* **Markdown** — QA documentation

---

## 📌 Final Result

The project demonstrates a complete manual QA workflow covering:

**Test Design → Execution → Defect Reporting → Root Cause Investigation → Fix Verification → Retesting → Regression**

A total of **41 test cases** were executed, **8 defects** were identified and documented, all **8 defects were fixed and successfully retested**, and the final regression verification passed.

---

*Thank you for reviewing my portfolio project! This repository demonstrates my ability to perform structured manual testing, investigate defects across multiple application layers, document findings clearly, and verify fixes through retesting and regression testing.*
