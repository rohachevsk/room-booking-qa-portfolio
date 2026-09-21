# Retest Report

## 1. Overview

This report documents the retesting of defects identified during the initial testing cycle of the Room Booking Service.

All reported defects were fixed in the source repository and verified through retesting.

**Project:** Room Booking Service
**Tester:** Rohachevsk
**Retest Date:** 2026-09-21
**Environment:** Local
**Backend:** Node.js / Express / Prisma / PostgreSQL
**Frontend:** React / Vite

---

## 2. Retest Scope

The retest covered all 8 defects identified during the initial test execution:

* BUG-001 — Insecure JWT fallback secret
* BUG-002 — Destructive database seed script
* BUG-003 — Invalid UUID causes internal server error
* BUG-004 — Missing login rate limiting
* BUG-005 — Whitespace-only full name accepted
* BUG-006 — Log records grow without retention or cleanup
* BUG-007 — Past dates selectable in calendar
* BUG-008 — Partially occupied hour appears available

Each defect was retested against its original reproduction scenario after the corresponding fix was implemented.

---

## 3. Bug Retest Results

| Bug ID  | Test Case | Initial Result | Retest Result | Fix Commit                                                                                                    |
| ------- | --------- | -------------- | ------------- | ------------------------------------------------------------------------------------------------------------- |
| BUG-001 | TC-015    | FAIL           | PASS          | [`644a595`](https://github.com/rohachevsk/RoomBookingService/commit/644a5952347dff8a47174317809d4bbd723b4c02) |
| BUG-002 | TC-038    | FAIL           | PASS          | [`b034ad8`](https://github.com/rohachevsk/RoomBookingService/commit/b034ad8371446c8a60ab6107d0378e7bfc0e6edb) |
| BUG-003 | TC-026    | FAIL           | PASS          | [`8d83260`](https://github.com/rohachevsk/RoomBookingService/commit/8d83260f05e7d8aa73de0c723a1e14f31b907a25) |
| BUG-004 | TC-016    | FAIL           | PASS          | [`8e55c16`](https://github.com/rohachevsk/RoomBookingService/commit/8e55c16815401b0641d90fd6ed54fbda19fd5402) |
| BUG-005 | TC-005    | FAIL           | PASS          | [`e2ef8bf`](https://github.com/rohachevsk/RoomBookingService/commit/e2ef8bf79eb27dc4df5e0dc9fae01708e86c07d7) |
| BUG-006 | TC-039    | FAIL           | PASS          | [`60b3c84`](https://github.com/rohachevsk/RoomBookingService/commit/60b3c8462996c12fbaf2618da0a201d2151417d8) |
| BUG-007 | TC-040    | FAIL           | PASS          | [`74d89d9`](https://github.com/rohachevsk/RoomBookingService/commit/74d89d93518ccf510d4c49f2a7465abe4784b74e) |
| BUG-008 | TC-041    | FAIL           | PASS          | [`76a0c4b`](https://github.com/rohachevsk/RoomBookingService/commit/76a0c4be1f673a92df33aa39c0f6205cfbd83323) |

---

## 4. Detailed Retest Results

### BUG-001 — Insecure JWT Fallback Secret

**Test Case:** TC-015
**Initial Result:** FAIL
**Retest Result:** PASS

The original security scenario was repeated after the fix. The previously observed JWT authentication issue was no longer reproducible.

**Result:** PASS

**Fix Commit:** [`644a595`](https://github.com/rohachevsk/RoomBookingService/commit/644a5952347dff8a47174317809d4bbd723b4c02)

---

### BUG-002 — Destructive Database Seed Script

**Test Case:** TC-038
**Initial Result:** FAIL
**Retest Result:** PASS

The seed implementation was reviewed after the fix. The previously identified unsafe destructive behavior was no longer present in the tested implementation.

**Result:** PASS

**Fix Commit:** [`b034ad8`](https://github.com/rohachevsk/RoomBookingService/commit/b034ad8371446c8a60ab6107d0378e7bfc0e6edb)

---

### BUG-003 — Invalid UUID Causes Internal Server Error

**Test Case:** TC-026
**Initial Result:** FAIL
**Retest Result:** PASS

The original booking request with an invalid `roomId` format was repeated. The application now handles the invalid input correctly instead of returning the previously observed internal server error.

**Result:** PASS

**Fix Commit:** [`8d83260`](https://github.com/rohachevsk/RoomBookingService/commit/8d83260f05e7d8aa73de0c723a1e14f31b907a25)

---

### BUG-004 — Missing Login Rate Limiting

**Test Case:** TC-016
**Initial Result:** FAIL
**Retest Result:** PASS

The repeated invalid login scenario was executed again after the fix. The previously observed absence of request throttling was resolved.

**Result:** PASS

**Fix Commit:** [`8e55c16`](https://github.com/rohachevsk/RoomBookingService/commit/8e55c16815401b0641d90fd6ed54fbda19fd5402)

---

### BUG-005 — Whitespace-Only Full Name Accepted

**Test Case:** TC-005
**Initial Result:** FAIL
**Retest Result:** PASS

Registration was repeated using a `fullName` containing only whitespace. The application now rejects the invalid value as expected.

**Result:** PASS

**Fix Commit:** [`e2ef8bf`](https://github.com/rohachevsk/RoomBookingService/commit/e2ef8bf79eb27dc4df5e0dc9fae01708e86c07d7)

---

### BUG-006 — Log Records Grow Without Retention or Cleanup

**Test Case:** TC-039
**Initial Result:** FAIL
**Retest Result:** PASS

The logging implementation was reviewed after the fix. The previously identified absence of a retention/cleanup mechanism was addressed and the resulting behavior was verified.

**Result:** PASS

**Fix Commit:** [`60b3c84`](https://github.com/rohachevsk/RoomBookingService/commit/60b3c8462996c12fbaf2618da0a201d2151417d8)

---

### BUG-007 — Past Dates Selectable in Calendar

**Test Case:** TC-040
**Initial Result:** FAIL
**Retest Result:** PASS

The calendar was retested using past dates. Past dates are now unavailable for new bookings as expected.

**Result:** PASS

**Fix Commit:** [`74d89d9`](https://github.com/rohachevsk/RoomBookingService/commit/74d89d93518ccf510d4c49f2a7465abe4784b74e)

---

### BUG-008 — Partially Occupied Hour Appears Available

**Test Case:** TC-041
**Initial Result:** FAIL
**Retest Result:** PASS

The original partially occupied time-slot scenario was repeated. The calendar now correctly accounts for the existing booking and no longer presents the conflicting interval as fully available.

**Result:** PASS

**Fix Commit:** [`76a0c4b`](https://github.com/rohachevsk/RoomBookingService/commit/76a0c4be1f673a92df33aa39c0f6205cfbd83323)

---

## 5. Retest Summary

| Metric                   | Result |
| ------------------------ | -----: |
| Total defects identified |      8 |
| Defects retested         |      8 |
| Retest PASS              |      8 |
| Retest FAIL              |      0 |
| Retest Pass Rate         |   100% |

All 8 defects identified during the initial test execution were successfully verified after the corresponding fixes.

---

## 6. Regression Testing

After fixing the reported defects, related application functionality was checked to ensure that the changes did not introduce regressions.

Regression checks covered:

* Authentication and login
* User registration
* JWT-based authorization
* Room retrieval and filtering
* Booking creation
* Booking validation
* Booking overlap handling
* Booking cancellation
* Database-related functionality
* Calendar date selection
* Calendar booking slot availability

No regressions were identified during the regression verification.

**Regression Result: PASS**

---

## 7. Final Retest Status

**Overall Retest Status: PASS**

All 8 previously failed test cases were successfully verified after defect resolution.

The project is ready for the final test summary and portfolio documentation.
