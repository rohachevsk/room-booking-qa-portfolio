# Test Design — Booking Time Validation Rules

## Target Endpoint
`POST /api/bookings`

## Business Rules Under Test
1. **Duration:** Must be between 15 minutes and 4 hours.
2. **Time Step:** Minutes must be divisible by 15 (`minutes % 15 == 0`), seconds must be `00`.
3. **Past Date:** `startTime` cannot be set in the past.

---

## Test Data Matrix (BVA & EP)

| ID | Test Scenario | Input Data (`startTime` -> `endTime`) | Boundary / Partition Class | Expected HTTP Status | Expected Response Payload |
|---|---|---|---|---|---|
| TC-TIME-01 | Minimum valid duration | 10:00 -> 10:15 | Valid Boundary (Min Duration) | 201 Created | Booking object |
| TC-TIME-02 | Duration below minimum | 10:00 -> 10:14 | Invalid Boundary (< 15 min) | 400 Bad Request | `{"message": "..."}` |
| TC-TIME-03 | Maximum valid duration | 10:00 -> 14:00 | Valid Boundary (Max Duration) | 201 Created | Booking object |
| TC-TIME-04 | Duration above maximum | 10:00 -> 14:01 | Invalid Boundary (> 4 hours) | 400 Bad Request | `{"message": "..."}` |
| TC-TIME-05 | Nominal valid duration | 10:00 -> 11:30 | Valid Equivalence Class | 201 Created | Booking object |
| TC-TIME-06 | Invalid minute step (startTime) | 10:05 -> 10:35 | Invalid Step (`10:05 % 15 != 0`) | 400 Bad Request | `{"message": "..."}` |
| TC-TIME-07 | Invalid minute step (endTime) | 10:00 -> 10:22 | Invalid Step (`10:22 % 15 != 0`) | 400 Bad Request | `{"message": "..."}` |
| TC-TIME-08 | Non-zero seconds input | 10:00:15 -> 10:30:00 | Invalid Step (Seconds != 00) | 400 Bad Request | `{"message": "..."}` |
| TC-TIME-09 | Start time in the past | Yesterday 10:00 -> 10:30 | Invalid Class (Past Date) | 400 Bad Request | `{"message": "..."}` |
| TC-TIME-10 | End time earlier than start time | 11:00 -> 10:30 | Invalid Logical Range | 400 Bad Request | `{"message": "..."}` |
