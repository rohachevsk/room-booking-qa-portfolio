# Test Design — Boundary Value Analysis & Interval Matrix

## 1. Booking Time Validation (`POST /api/bookings`)

### Business Rules Under Test
1. **Duration:** 15 minutes minimum, 4 hours maximum.
2. **Time Step:** Minutes must be divisible by 15 (`minutes % 15 == 0`), seconds must be `00`.
3. **Past Date:** `startTime` cannot be set in the past.

| ID | Test Scenario | Input Data (`startTime` -> `endTime`) | Boundary / Partition Class | Expected Result |
|---|---|---|---|---|
| TD-TIME-01 | Minimum valid duration | 10:00 -> 10:15 | Valid Boundary (Min Duration) | `201 Created` |
| TD-TIME-02 | Duration below minimum | 10:00 -> 10:14 | Invalid Boundary (< 15 min) | `400 Bad Request` |
| TD-TIME-03 | Maximum valid duration | 10:00 -> 14:00 | Valid Boundary (Max Duration) | `201 Created` |
| TD-TIME-04 | Duration above maximum | 10:00 -> 14:01 | Invalid Boundary (> 4 hours) | `400 Bad Request` |
| TD-TIME-05 | Nominal valid duration | 10:00 -> 11:30 | Valid Equivalence Class | `201 Created` |
| TD-TIME-06 | Invalid minute step (start) | 10:05 -> 10:35 | Invalid Step (`10:05 % 15 != 0`) | `400 Bad Request` |
| TD-TIME-07 | Invalid minute step (end) | 10:00 -> 10:22 | Invalid Step (`10:22 % 15 != 0`) | `400 Bad Request` |
| TD-TIME-08 | Non-zero seconds input | 10:00:15 -> 10:30:00 | Invalid Step (Seconds != 00) | `400 Bad Request` |
| TD-TIME-09 | Start time in the past | Yesterday 10:00 -> 10:30 | Invalid Class (Past Date) | `400 Bad Request` |
| TD-TIME-10 | End time earlier than start | 11:00 -> 10:30 | Invalid Logical Range | `400 Bad Request` |

---

## 2. Interval Overlap Matrix (Concurrency & Conflict Rules)

### Business Rules Under Test
A single room cannot have overlapping `CONFIRMED` bookings.
**Base Condition:** Room A has an existing `CONFIRMED` booking from **10:00 to 11:00**.

| ID | Interval Scenario | New Booking Input | Interaction Type | Expected Result |
|---|---|---|---|---|
| TD-OV-01 | Adjacent Before | `09:00 -> 10:00` | No Overlap (Exact edge connection) | `201 Created` |
| TD-OV-02 | Adjacent After | `11:00 -> 12:00` | No Overlap (Exact edge connection) | `201 Created` |
| TD-OV-03 | Partial Overlap (Start edge) | `09:30 -> 10:30` | Conflict (Overlaps first 30 mins) | `409 Conflict` |
| TD-OV-04 | Partial Overlap (End edge) | `10:30 -> 11:30` | Conflict (Overlaps last 30 mins) | `409 Conflict` |
| TD-OV-05 | Fully Inside | `10:15 -> 10:45` | Conflict (Completely inside existing) | `409 Conflict` |
| TD-OV-06 | Fully Covering | `09:00 -> 12:00` | Conflict (Completely engulfs existing) | `409 Conflict` |
| TD-OV-07 | Exact Match | `10:00 -> 11:00` | Conflict (Identical time boundaries) | `409 Conflict` |

---

## 3. Room Capacity & Constraints (`POST /api/rooms`)

### Business Rules Under Test
1. **Capacity:** Must be a positive integer (`capacity > 0`).

| ID | Test Scenario | Input Data (`capacity`) | Boundary / Partition Class | Expected Result |
|---|---|---|---|---|
| TD-CAP-01 | Minimum valid capacity | `1` | Valid Boundary (Min Positive Int) | `201 Created` |
| TD-CAP-02 | Zero capacity | `0` | Invalid Boundary (Zero) | `400 Bad Request` |
| TD-CAP-03 | Negative capacity | `-1` | Invalid Boundary (Negative) | `400 Bad Request` |
| TD-CAP-04 | Float capacity | `4.5` | Invalid Class (Non-integer) | `400 Bad Request` |
