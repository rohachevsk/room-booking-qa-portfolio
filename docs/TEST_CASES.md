# Detailed Test Cases — Room Booking Service

## 1. Authentication & User Management

### [TC-001] Valid User Registration (Positive)

**Module:** Authentication / Registration  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. Backend server is running.
2. PostgreSQL database is active.
3. Email `qa.valid@example.com` does not exist in the database.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with valid payload (`fullName`, `email`, `password` >= 6 chars). | 1. HTTP Status `201 Created` is returned.<br>2. Response JSON contains `user` object (`id`, `fullName`, `email`, `role`).<br>3. Response JSON does NOT contain a JWT token. |
| 2 | Check database for the created user via SQL. | Record exists in the database with the correct email and role. |

---

#### Postconditions
User record is successfully stored in the database.

#### Test Data
- **fullName:** `"QA Valid User"`
- **email:** `"qa.valid@example.com"`
- **password:** `"securePass123"`

#### Actual Result
HTTP Status `201 Created` is returned. Response contains the user object and does not contain a JWT token.
**Status:** PASS

---

### [TC-002] Prevent Registration with Duplicate Email (Negative)

**Module:** Authentication / Registration  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. User with email `qa.duplicate@example.com` already exists in the database.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with payload containing the already registered email. | 1. HTTP Status `409 Conflict` is returned.<br>2. Response JSON contains an error message. |
| 2 | Check database to ensure no duplicate record was created. | Query returns exactly 1 record for this email. |

---

#### Postconditions
Database remains unchanged.

#### Test Data
- **email:** `"qa.duplicate@example.com"`

#### Actual Result
HTTP Status `409 Conflict` is returned with an appropriate error message.
**Status:** PASS

---

### [TC-003] Prevent Registration with Invalid Email Format (Negative)

**Module:** Authentication / Registration  
**Priority:** High  
**Severity:** Normal  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with email: `user.com` (missing `@`). | HTTP Status `400 Bad Request` and validation error. |
| 2 | Send `POST /api/auth/register` with email: `user@com` (missing domain). | HTTP Status `400 Bad Request` and validation error. |
| 3 | Send `POST /api/auth/register` with email: `user@` (missing domain). | HTTP Status `400 Bad Request` and validation error. |

---

#### Postconditions
No user record is created.

#### Test Data
- **Invalid Emails:** `"user.com"`, `"user@com"`, `"user@"`

#### Actual Result
HTTP Status `400 Bad Request` is returned for all three invalid email variations.
**Status:** PASS

---

### [TC-004] Input Validation - Password Boundary (Negative)

**Module:** Authentication / Registration  
**Priority:** High  
**Severity:** Normal  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with a password containing exactly 5 characters. | 1. HTTP Status `400 Bad Request` is returned.<br>2. Response JSON contains validation error (minimum 6 characters required). |

---

#### Postconditions
User record is not created.

#### Test Data
- **password:** `"pass1"` (5 chars)

#### Actual Result
HTTP Status `400 Bad Request` returned with validation error message.
**Status:** PASS
### [TC-005] Input Validation - Whitespace fullName (Negative)

**Module:** Authentication / Registration  
**Priority:** Medium  
**Severity:** Minor  

**Preconditions:**
1. Backend server is running.
2. PostgreSQL database is active.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with `fullName` consisting only of spaces (`"   "`). | HTTP Status `400 Bad Request` is returned. System rejects empty/whitespace names. |

---

#### Postconditions
User record is not created.

#### Test Data
- **fullName:** `"   "` (3 spaces)
- **email:** `"qa.whitespace@example.com"`
- **password:** `"securePass123"`

#### Actual Result
HTTP Status `201 Created` is returned. The user is successfully saved in the database with a name consisting entirely of spaces.
**Status:** FAIL
**Bug ID:** [BUG-AUTH-001]

---

### [TC-006] Input Validation - Incorrect Data Types (Negative)

**Module:** Authentication / Registration  
**Priority:** Medium  
**Severity:** Normal  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with `fullName` as an integer (`12345`) and `password` as a boolean (`true`). | HTTP Status `400 Bad Request` is returned. Validation framework rejects incorrect data types. |

---

#### Postconditions
User record is not created.

#### Test Data
- **fullName:** `12345` (integer)
- **email:** `"qa.types@example.com"`
- **password:** `true` (boolean)

#### Actual Result
HTTP Status `400 Bad Request` is returned with appropriate validation error messages for data types.
**Status:** PASS

---

### [TC-007] Input Validation - Missing Required Fields (Negative)

**Module:** Authentication / Registration  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with missing `fullName`. | HTTP Status `400 Bad Request` is returned. |
| 2 | Send `POST /api/auth/register` with missing `email`. | HTTP Status `400 Bad Request` is returned. |
| 3 | Send `POST /api/auth/register` with missing `password`. | HTTP Status `400 Bad Request` is returned. |

---

#### Postconditions
No user records are created.

#### Test Data
- JSON payloads omitting one of the required keys (`fullName`, `email`, `password`) per request.

#### Actual Result
HTTP Status `400 Bad Request` is returned for all three payload variations.
**Status:** PASS

---

### [TC-008] Data Normalization - Email Case Insensitivity (Positive)

**Module:** Authentication / User Management  
**Priority:** Medium  
**Severity:** Normal  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with mixed-case email (`QaUpper@EXAMPLE.COM`). | HTTP Status `201 Created` is returned. |
| 2 | Send `POST /api/auth/login` using the lowercase version of the same email (`qaupper@example.com`). | HTTP Status `200 OK` is returned with a valid JWT token. |

---

#### Postconditions
User email is stored and processed in a normalized (lowercase) format.

#### Test Data
- **Registration Email:** `"QaUpper@EXAMPLE.COM"`
- **Login Email:** `"qaupper@example.com"`

#### Actual Result
User successfully registered with `201 Created`. Subsequent login with lowercase email returned `200 OK` and a valid JWT token.
**Status:** PASS

---

## 1.2. Login (`POST /auth/login`)

### [TC-009] Valid User Login (Positive)

**Module:** Authentication / Login  
**Priority:** High  
**Severity:** Critical  

**Preconditions:**
1. Backend server is running.
2. User with email `qa.login@example.com` and password `securePass123` exists in the database.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/login` with correct credentials. | 1. HTTP Status `200 OK` is returned.<br>2. Response contains a valid JWT token and user details. |

---

#### Postconditions
User is authenticated and can use the JWT token for protected routes.

#### Test Data
- **email:** `"qa.login@example.com"`
- **password:** `"securePass123"`

#### Actual Result
HTTP Status `200 OK` is returned. Response contains the user object and a valid JWT token.
**Status:** PASS

---

### [TC-010] Prevent Login with Invalid Password (Negative)

**Module:** Authentication / Login  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. User with email `qa.login@example.com` exists in the database.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/login` with correct email but incorrect password. | HTTP Status `401 Unauthorized` is returned. |

---

#### Postconditions
User is not authenticated; JWT token is not issued.

#### Test Data
- **email:** `"qa.login@example.com"`
- **password:** `"wrongPassword!"`

#### Actual Result
HTTP Status `401 Unauthorized` is returned.
**Status:** PASS

### [TC-011] Prevent Login with Non-existent Email (Negative / Security)

**Module:** Authentication / Login  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. Backend server is running.
2. Email `qa.ghost@example.com` does not exist in the database.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/login` with the unregistered email and any password. | HTTP Status `401 Unauthorized` is returned. System does not return `404 Not Found` to prevent email enumeration attacks. |

---

#### Postconditions
System securely denies access without leaking user existence.

#### Test Data
- **email:** `"qa.ghost@example.com"`
- **password:** `"somePassword123"`

#### Actual Result
HTTP Status `401 Unauthorized` is returned (matches the invalid password status). Email enumeration is prevented.
**Status:** PASS

---

### [TC-012] Input Validation - Missing Credentials on Login (Negative)

**Module:** Authentication / Login  
**Priority:** Medium  
**Severity:** Normal  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/login` with an empty JSON body `{}`. | HTTP Status `400 Bad Request` is returned due to missing required fields. |

---

#### Postconditions
Request is rejected before reaching authentication logic.

#### Test Data
- **Payload:** `{}`

#### Actual Result
HTTP Status `400 Bad Request` is returned.
**Status:** PASS

---

## 2. API Response Validation & Security

### [TC-013] No Password Leakage on Auth Endpoints (Security)

**Module:** Security / Response Validation  
**Priority:** Critical  
**Severity:** Critical  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/auth/register` with valid data. | Response JSON does NOT contain `password` or `passwordHash` fields. |
| 2 | Send `POST /api/auth/login` with valid credentials. | Response JSON does NOT contain `password` or `passwordHash` fields. |

---

#### Postconditions
Sensitive user credentials are not leaked in authentication responses.

#### Test Data
- Valid user registration and login payloads.

#### Actual Result
JSON payloads recursively scanned. Keys matching `password*` are not present in the response objects.
**Status:** PASS

---

### [TC-014] No Password Leakage on Data Fetch (Security)

**Module:** Security / Response Validation  
**Priority:** Critical  
**Severity:** Critical  

**Preconditions:**
1. User is authenticated and has at least one active booking.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `GET /api/bookings/my` using a valid JWT token. | Nested `user` objects within the bookings response array do NOT expose `password` or `passwordHash` fields. |

---

#### Postconditions
Relational queries do not accidentally expose sensitive data.

#### Test Data
- **Header:** `Authorization: Bearer {{token}}`

#### Actual Result
Nested user objects do not expose password hashes.
**Status:** PASS

---

### [TC-015] JWT Fallback Secret Vulnerability (Security / White-box)

**Module:** Security / Authorization  
**Priority:** Critical  
**Severity:** Critical  

**Preconditions:**
1. Access to backend source code.
2. Server is running in a live/production-like environment.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Inspect backend codebase for JWT secret configuration (`config/env.ts`). | Application does not use insecure hardcoded fallback secrets. |
| 2 | Generate a forged JWT locally with payload `{"role": "ADMIN"}` signed using the discovered fallback secret (`local-development-secret`). | Token is generated locally. |
| 3 | Send `GET /api/bookings/my` (or any auth route) with the forged token. | HTTP Status `401 Unauthorized` or `500 Internal Server Error`. Application rejects tokens signed with dev secrets. |

---

#### Postconditions
Unauthorized access via default secrets is blocked.

#### Test Data
- **Forged Payload:** `{"sub": "fake-user-id", "role": "ADMIN"}`
- **Signing Secret:** `"local-development-secret"`

#### Actual Result
HTTP Status `200 OK` is returned. Code inspection reveals `jwtSecret = JWT_SECRET ?? 'local-development-secret'`. The live server successfully accepts and processes the forged admin token.
**Status:** FAIL
**Bug ID:** [BUG-SEC-001]

---

### [TC-016] Brute-Force Protection & Rate Limiting (Security)

**Module:** Security / Rate Limiting  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. Backend server is running.
2. User account exists.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send 20 consecutive `POST /api/auth/login` requests with an incorrect password for the same email within 60 seconds. | 1. Initial requests return `401 Unauthorized`.<br>2. Subsequent requests return `429 Too Many Requests`. |

---

#### Postconditions
System blocks excessive login attempts to prevent password guessing/brute-force attacks.

#### Test Data
- 20 requests in rapid succession using an automated runner (e.g., Postman Runner).

#### Actual Result
All 20 requests returned `401 Unauthorized`. No `429 Too Many Requests` limit was triggered. Code inspection confirms absence of rate-limiting middleware.
**Status:** FAIL
**Bug ID:** [BUG-SEC-002]

## 3. Rooms Management (`/rooms`)

### 3.1. Get Rooms (`GET /rooms`)

### [TC-017] Fetch All Active Rooms (Positive)

**Module:** Rooms Management / Listing  
**Priority:** High  
**Severity:** Normal  

**Preconditions:**
1. Backend server is running.
2. Database contains at least one active room (e.g., 4 rooms from seeding).

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `GET /api/rooms` without any query parameters. | 1. HTTP Status `200 OK` is returned.<br>2. Response JSON contains an array of all active rooms. |

---

#### Postconditions
System successfully retrieves the full list of available rooms.

#### Test Data
- **Endpoint:** `GET /api/rooms`

#### Actual Result
HTTP Status `200 OK` is returned. The response contains an array of 4 active rooms.
**Status:** PASS

---

### [TC-018] Filter Rooms by Capacity (Positive)

**Module:** Rooms Management / Filtering  
**Priority:** Medium  
**Severity:** Normal  

**Preconditions:**
1. Database contains rooms with varying capacities (e.g., 2, 5, 10).

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `GET /api/rooms?capacity=5`. | 1. HTTP Status `200 OK` is returned.<br>2. Response JSON array contains ONLY rooms where `capacity >= 5`. |

---

#### Postconditions
System correctly applies the "greater than or equal to" business logic for capacity filtering.

#### Test Data
- **Query Param:** `?capacity=5`

#### Actual Result
HTTP Status `200 OK` is returned. All rooms in the returned array have a capacity of 5 or higher.
**Status:** PASS

---

### [TC-019] Filter Rooms by Equipment (Positive)

**Module:** Rooms Management / Filtering  
**Priority:** Medium  
**Severity:** Normal  

**Preconditions:**
1. Database contains rooms with various equipment tags.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `GET /api/rooms?equipment=projector,whiteboard`. | 1. HTTP Status `200 OK` is returned.<br>2. Response array contains ONLY rooms that include BOTH "projector" AND "whiteboard" in their equipment list. |

---

#### Postconditions
System correctly applies strict intersection (AND logic) for equipment filtering.

#### Test Data
- **Query Param:** `?equipment=projector,whiteboard`

#### Actual Result
HTTP Status `200 OK` is returned. Returned rooms contain both requested equipment tags.
**Status:** PASS

---

### 3.2. Create Room (`POST /rooms`)

### [TC-020] Valid Room Creation by Admin (Positive)

**Module:** Rooms Management / Creation  
**Priority:** High  
**Severity:** Critical  

**Preconditions:**
1. User is authenticated and holds the `ADMIN` role.
2. Valid admin token is available (`{{adminToken}}`).

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/rooms` with header `Authorization: Bearer {{adminToken}}` and valid payload (`name`, `capacity > 0`, `equipment` array). | HTTP Status `201 Created` is returned with the new room object. |

---

#### Postconditions
Room is created in the database and is available for booking.

#### Test Data
- **name:** `"QA Test Room"`
- **capacity:** `10`
- **equipment:** `["projector", "TV"]`

#### Actual Result
HTTP Status `201 Created` is returned. The room is successfully created in the system.
**Status:** PASS

---

### [TC-021] Prevent Room Creation by Non-Admin User (Negative / RBAC)

**Module:** Rooms Management / Authorization  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. User is authenticated and holds the `USER` role.
2. Valid user token is available (`{{userToken}}`).

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/rooms` with header `Authorization: Bearer {{userToken}}` and valid room payload. | HTTP Status `403 Forbidden` is returned. |

---

#### Postconditions
Database remains unchanged. Privilege escalation is prevented.

#### Test Data
- **Header:** `Authorization: Bearer {{userToken}}`

#### Actual Result
HTTP Status `403 Forbidden` is returned. The system correctly blocks non-admin users from creating rooms.
**Status:** PASS

---

### [TC-022] Input Validation - Room Capacity Boundary (Negative)

**Module:** Rooms Management / Validation  
**Priority:** Medium  
**Severity:** Normal  

**Preconditions:**
1. Authenticated as `ADMIN`.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/rooms` with `capacity: 0`. | HTTP Status `400 Bad Request` and validation error. |
| 2 | Send `POST /api/rooms` with `capacity: -1`. | HTTP Status `400 Bad Request` and validation error. |

---

#### Postconditions
Invalid room records are not saved to the database.

#### Test Data
- **Invalid Capacities:** `0`, `-1`

#### Actual Result
HTTP Status `400 Bad Request` is returned for both payload variations.
**Status:** PASS

---

### [TC-023] Input Validation - Equipment Data Type (Negative)

**Module:** Rooms Management / Validation  
**Priority:** Low  
**Severity:** Minor  

**Preconditions:**
1. Authenticated as `ADMIN`.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/rooms` with `equipment` passed as a string (`"projector"`) instead of an array (`["projector"]`). | HTTP Status `400 Bad Request` is returned. |

---

#### Postconditions
Validation layer strictly enforces array data type for equipment.

#### Test Data
- **equipment:** `"projector"` (String)

#### Actual Result
HTTP Status `400 Bad Request` is returned.
**Status:** PASS

## 4. Bookings Management & Business Logic (`/bookings`)

### 4.1. Core Booking Logic (`POST /bookings`)

### [TC-024] Valid Booking Creation (Positive)

**Module:** Bookings Management / Creation  
**Priority:** High  
**Severity:** Critical  

**Preconditions:**
1. User is authenticated (`{{userToken}}`).
2. Room `room_uuid_1` exists and is active.
3. The requested time slot is completely free.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/bookings` with a valid room ID, start time, and end time. | HTTP Status `201 Created` is returned. Response contains the new booking object with status `CONFIRMED`. |

---

#### Postconditions
Booking is successfully recorded in the database and blocks the specified time slot.

#### Test Data
- **roomId:** `"room_uuid_1"`
- **startTime:** `"2026-10-10T10:00:00.000Z"`
- **endTime:** `"2026-10-10T11:00:00.000Z"`

#### Actual Result
HTTP Status `201 Created` is returned with the confirmed booking object.
**Status:** PASS

---

### [TC-025] Prevent Booking for Non-existent Room (Negative)

**Module:** Bookings Management / Creation  
**Priority:** Medium  
**Severity:** Normal  

**Preconditions:**
1. User is authenticated.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/bookings` using a syntactically valid UUID that does not exist in the `rooms` table. | HTTP Status `404 Not Found` is returned. |

---

#### Postconditions
Booking is not created.

#### Test Data
- **roomId:** `"123e4567-e89b-12d3-a456-426614174000"` (Random valid UUID)

#### Actual Result
HTTP Status `404 Not Found` is returned.
**Status:** PASS

---

### [TC-026] Input Validation - Invalid UUID Format (Negative)

**Module:** Bookings Management / API Robustness  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. User is authenticated.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/bookings` with a syntactically invalid `roomId` string (e.g., `"not-a-uuid"`). | HTTP Status `400 Bad Request` is returned with a clear validation error. |

---

#### Postconditions
Server gracefully handles the bad format without crashing.

#### Test Data
- **roomId:** `"not-a-uuid"`

#### Actual Result
HTTP Status `500 Internal Server Error` is returned with an empty body. Prisma unhandled exception for malformed UUID leaks through the controller.
**Status:** FAIL
**Bug ID:** [BUG-BE-001]

---

### [TC-027] Prevent Overlapping Bookings (Negative)

**Module:** Bookings Management / Business Logic  
**Priority:** High  
**Severity:** Critical  

**Preconditions:**
1. Room A exists.
2. A `CONFIRMED` booking exists for Room A from `10:00` to `11:00`.
3. User is authenticated.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/bookings` for Room A with an overlapping time slot (e.g., `10:30` to `11:30`). | HTTP Status `409 Conflict` is returned. System prevents double-booking. |

---

#### Postconditions
Duplicate/overlapping booking is not created in the database.

#### Test Data
- **startTime:** `"2026-10-10T10:30:00.000Z"`
- **endTime:** `"2026-10-10T11:30:00.000Z"`

#### Actual Result
HTTP Status `409 Conflict` is returned.
**Status:** PASS

---

### [TC-028] Concurrency - Race Condition Prevention (Negative)

**Module:** Bookings Management / Transaction Safety  
**Priority:** High  
**Severity:** Critical  

**Preconditions:**
1. User is authenticated.
2. Target time slot is completely free.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send two identical `POST /api/bookings` requests simultaneously (using an automated tool like Postman runner or parallel bash script). | Exactly one request succeeds with `201 Created`. The concurrent request is rejected with `409 Conflict` by the Serializable database transaction. |

---

#### Postconditions
Only one booking is saved. Database integrity is maintained under concurrent load.

#### Test Data
- Two parallel POST requests for the same room and time.

#### Actual Result
Exactly one `201 Created` and one `409 Conflict` were returned. Serializable transaction successfully prevented the race condition.
**Status:** PASS

---

### [TC-029] Allow Same User to Book Different Rooms Simultaneously (Positive)

**Module:** Bookings Management / Business Logic  
**Priority:** Low  
**Severity:** Minor  

**Preconditions:**
1. User is authenticated.
2. Room A and Room B are both free for the requested time.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `POST /api/bookings` for Room A from `12:00` to `13:00`. | HTTP Status `201 Created`. |
| 2 | Send `POST /api/bookings` for Room B from `12:00` to `13:00`. | HTTP Status `201 Created`. System does not block a user from booking multiple rooms at the same time. |

---

#### Postconditions
Both bookings are successfully created.

#### Test Data
- **Room A ID & Room B ID**, same time slot.

#### Actual Result
Both requests returned `201 Created`.
**Status:** PASS

---

### 4.2. Get & Cancel Bookings

### [TC-030] Fetch Date Bookings (Positive)

**Module:** Bookings Management / Calendar  
**Priority:** High  
**Severity:** Normal  

**Preconditions:**
1. Database contains both `CONFIRMED` and `CANCELLED` bookings for the target date.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `GET /api/bookings?date=2026-10-10`. | HTTP Status `200 OK`. Response array contains ONLY bookings with status `CONFIRMED` for the requested date. |

---

#### Postconditions
System accurately displays calendar availability without showing cancelled reservations.

#### Test Data
- **Query Param:** `?date=2026-10-10`

#### Actual Result
HTTP Status `200 OK`. Response filtered out cancelled bookings correctly.
**Status:** PASS

---

### [TC-031] Missing Date Parameter on Calendar Fetch (Negative)

**Module:** Bookings Management / Validation  
**Priority:** Medium  
**Severity:** Normal  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `GET /api/bookings` without the `date` query parameter. | HTTP Status `400 Bad Request` is returned. |

---

#### Postconditions
Request is rejected; full database dump is prevented.

#### Test Data
- **Endpoint:** `GET /api/bookings`

#### Actual Result
HTTP Status `400 Bad Request` is returned.
**Status:** PASS

---

### [TC-032] Fetch My Bookings (Positive)

**Module:** Bookings Management / User Dashboard  
**Priority:** High  
**Severity:** Normal  

**Preconditions:**
1. User is authenticated.
2. User has created several bookings.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `GET /api/bookings/my` with a valid JWT token. | HTTP Status `200 OK`. Response contains an array of the current user's bookings. |

---

#### Postconditions
User can successfully view their own reservation history.

#### Test Data
- **Header:** `Authorization: Bearer {{userToken}}`

#### Actual Result
HTTP Status `200 OK` is returned with the correct booking array.
**Status:** PASS

---

### [TC-033] Unauthorized Access to My Bookings (Negative)

**Module:** Bookings Management / Authorization  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. Backend server is running.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `GET /api/bookings/my` without an `Authorization` header. | HTTP Status `401 Unauthorized` is returned. |

---

#### Postconditions
System blocks unauthenticated access to private user data.

#### Test Data
- No auth headers.

#### Actual Result
HTTP Status `401 Unauthorized` is returned.
**Status:** PASS

---

### [TC-034] Owner Booking Cancellation (Positive)

**Module:** Bookings Management / Cancellation  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. User is authenticated.
2. Active booking owned by the user exists.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `DELETE /api/bookings/{{bookingId}}` using the owner's token. | HTTP Status `200 OK` is returned. The booking is successfully cancelled. |

---

#### Postconditions
Booking status is updated to `CANCELLED`. Time slot becomes available for others.

#### Test Data
- **bookingId:** ID of the user's booking.

#### Actual Result
HTTP Status `200 OK` is returned.
**Status:** PASS

---

### [TC-035] Admin Booking Cancellation (Positive)

**Module:** Bookings Management / Administration  
**Priority:** High  
**Severity:** Normal  

**Preconditions:**
1. User is authenticated as `ADMIN`.
2. Active booking owned by a regular user exists.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `DELETE /api/bookings/{{bookingId}}` using the admin's token. | HTTP Status `200 OK` is returned. Admin successfully overrides and cancels the user's booking. |

---

#### Postconditions
Booking status is updated to `CANCELLED`.

#### Test Data
- **Header:** `Authorization: Bearer {{adminToken}}`

#### Actual Result
HTTP Status `200 OK` is returned.
**Status:** PASS

---

### [TC-036] Prevent Foreign User Cancellation - IDOR (Negative/Security)

**Module:** Bookings Management / Security  
**Priority:** Critical  
**Severity:** Critical  

**Preconditions:**
1. User A is authenticated.
2. User B has an active `CONFIRMED` booking.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | User A sends `DELETE /api/bookings/{{user_B_bookingId}}`. | HTTP Status `403 Forbidden` is returned. Insecure Direct Object Reference (IDOR) is prevented. |

---

#### Postconditions
User B's booking remains `CONFIRMED` and untouched.

#### Test Data
- **Header:** `Authorization: Bearer {{user_A_Token}}`
- **Path:** ID of User B's booking.

#### Actual Result
HTTP Status `403 Forbidden` is returned. Subsequent check confirmed User B's booking status remained `CONFIRMED`.
**Status:** PASS

## 5. Database & Data Integrity

### [TC-037] Soft Delete Verification (Positive)

**Module:** Database & Data Integrity  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. Database contains an active `CONFIRMED` booking.
2. User is authenticated and authorized to cancel the booking.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Send `DELETE /api/bookings/{{bookingId}}` to cancel the booking. | HTTP Status `200 OK` is returned. |
| 2 | Execute SQL query directly in PostgreSQL:<br>`SELECT status FROM bookings WHERE id = '{{bookingId}}';` | Query returns 1 row. The record is NOT physically deleted from the table, but its `status` is updated to `'CANCELLED'`. |

---

#### Postconditions
Data history and relational integrity are preserved via soft deletion.

#### Test Data
- **bookingId:** ID of the cancelled booking.

#### Actual Result
HTTP Status `200 OK` is returned. Direct Prisma/SQL query confirms `DB_ROW_EXISTS: true` and `DB_STATUS: CANCELLED`. The physical record remains intact.
**Status:** PASS

---

### [TC-038] Database Seeding Data Integrity (Infrastructure / Negative)

**Module:** Database & Data Integrity  
**Priority:** Critical  
**Severity:** Critical  

**Preconditions:**
1. PostgreSQL database is active.
2. Database contains existing production/development data (users, active bookings, logs).
3. Access to source code (`prisma/seed.ts`).

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Inspect the database seeding script (`npm run db:seed`) and its execution logic. | Script checks environment or prompts for confirmation before running on a populated database. |
| 2 | Analyze the script's data insertion strategy. | Script appends new data safely or aborts execution, preserving existing user and booking records. |

---

#### Postconditions
Existing database records remain intact and are not accidentally wiped by developer tools.

#### Test Data
- Existing tables: `users`, `rooms`, `bookings`, `logs`

#### Actual Result
Code inspection (`prisma/seed.ts:9-12`) reveals unconditional `deleteMany()` operations across all core tables (`logs`, `bookings`, `rooms`, `users`) without any environment checks or warnings. Running this script wipes all existing database records.
**Status:** FAIL
**Bug ID:** [BUG-DB-001]

---

### [TC-039] Log Retention Policy & Table Bloat (Infrastructure)

**Module:** Database & Data Integrity  
**Priority:** Medium  
**Severity:** Major  

**Preconditions:**
1. Backend server is running.
2. Application is actively generating system/audit logs in the `logs` table.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Inspect application source code (cron jobs, intervals) and database schema (triggers) for data retention mechanisms. | A mechanism exists to automatically delete or archive log records older than a defined retention period (e.g., 30-90 days) to prevent infinite storage growth. |

---

#### Postconditions
The `logs` table size remains stable over time and does not consume infinite disk space.

#### Test Data
- Database table: `logs`

#### Actual Result
No cleanup mechanism, cron job, or database trigger is implemented (search for `cron`/`deleteMany`/`setInterval` returned empty). The `logs` table grows indefinitely on every system action (currently accumulated 31 records from minimal testing).
**Status:** FAIL
**Bug ID:** [BUG-DB-002]

---

## 6. Frontend & UI (React SPA)

### [TC-040] Past Date Selection in Calendar UI (Negative / UI)

**Module:** Frontend / UI Validation  
**Priority:** Medium  
**Severity:** Minor  

**Preconditions:**
1. React SPA frontend is running and accessible.
2. User is authenticated and viewing the booking calendar.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Open the date picker component on the booking dashboard. | 1. Dates prior to the current date are visually disabled (grayed out).<br>2. The `<input type="date">` enforces a `min` attribute restriction. |
| 2 | Click on a past date in the calendar timeline. | UI prevents interaction and does not open the booking creation modal. |

---

#### Postconditions
User is restricted to viewing and booking only current and future dates.

#### Test Data
- **Target Date:** Yesterday's date.

#### Actual Result
The `<input type="date">` lacks a `min` attribute, allowing infinite navigation into the past. Timeline cells for past dates remain fully clickable (`clickable = room.isActive`), opening the booking modal. Although the backend ultimately rejects the request (`400 Bad Request`), the UI fails to provide proper visual restriction and UX feedback.
**Status:** FAIL
**Bug ID:** [BUG-FE-001]

---

### [TC-041] Partial Slot Visual Indication and Interaction (Negative / UI)

**Module:** Frontend / UI Validation  
**Priority:** High  
**Severity:** Major  

**Preconditions:**
1. React SPA frontend is running.
2. Room A has an existing `CONFIRMED` booking from `10:15` to `10:45` today.

---

#### Test Steps

| # | Step Description | Expected Result |
|---|---|---|
| 1 | Navigate to the booking timeline for Room A for today's date. | The `10:00 - 11:00` hour block visually indicates that a portion of the time is unavailable (e.g., striped pattern or partial fill). |
| 2 | Attempt to click the `10:00 - 11:00` hour block to create a new booking. | UI disables the overlapping time segment and prevents the user from selecting a range that conflicts with the `10:15 - 10:45` booking. |

---

#### Postconditions
User cannot accidentally submit a booking that overlaps with an existing partial reservation.

#### Test Data
- **Existing Booking:** `10:15 - 10:45`
- **User Selection:** `10:00 - 11:00`

#### Actual Result
Hour cells remain completely clickable regardless of partial bookings. The booked block renders merely as a visual overlay. Clicking the cell successfully opens the booking modal, allowing form submission, which is subsequently rejected by the backend with a `409 Conflict`. There is no visual indication preventing partial overlaps on the frontend.
**Status:** FAIL
**Bug ID:** [BUG-FE-002]
