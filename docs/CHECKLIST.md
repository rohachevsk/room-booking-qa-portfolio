# REST API Test Checklist — Room Booking Service

## Base URL
`http://localhost:4000/api`

---

## 1. Authentication & User Management (`/auth`)

### 1.1. Registration (`POST /auth/register`)
- [ ] **Valid Registration (Happy Path):** Register with new email, fullName, and valid password (>= 6 chars) → `201 Created`.
- [ ] **Duplicate Email:** Register with an already existing email → `409 Conflict`.
- [ ] **Input Validation - Email Format:** Send invalid email (`user@com`, `user.com`, `user@`) → `400 Bad Request`.
- [ ] **Input Validation - Password Boundary:** Register with password length 5 chars → `400 Bad Request`.
- [ ] **Input Validation - Whitespace:** Send `fullName` with only spaces (`"   "`) or empty string (`""`) → `400 Bad Request`.
- [ ] **Input Validation - Data Types:** Send `fullName` as an integer or `password` as a boolean → `400 Bad Request`.
- [ ] **Missing Fields:** Register without email, password, or fullName → `400 Bad Request` with clear error message.
- [ ] **Data Normalization:** Register with mixed-case email (`QaUpper@EXAMPLE.COM`). Login with lowercase (`qaupper@example.com`) → `200 OK`.

### 1.2. Login (`POST /auth/login`)
- [ ] **Valid Login:** Login with correct credentials → `200 OK` with valid JWT token.
- [ ] **Invalid Password:** Login with correct email and wrong password → `401 Unauthorized`.
- [ ] **Non-existent Email:** Login with unregistered email → `401 Unauthorized` (Security: same status as invalid password to prevent enumeration).
- [ ] **Missing Credentials:** Login with empty body `{}` → `400 Bad Request`.

---

## 2. API Response Validation & Security

### 2.1. Sensitive Data Leakage
- [ ] **No Password Leakage on Auth:** Verify `POST /auth/register` and `POST /auth/login` responses do NOT contain `password` or `passwordHash` fields.
- [ ] **No Password Leakage on Fetch:** Verify `GET /bookings/my` (which includes user relations) does NOT expose password hashes.

### 2.2. Authorization & Rate Limiting
- [ ] **JWT Fallback Secret (White-box):** Verify application does not accept tokens signed with the development fallback secret when JWT_SECRET is missing or misconfigured in production.
- [ ] **Rate Limiting (Brute-force):** Send 20 consecutive invalid login requests within 1 minute → `429 Too Many Requests`.

---

## 3. Rooms Management (`/rooms`)

### 3.1. Get Rooms (`GET /rooms`)
- [ ] **Fetch All Rooms:** Retrieve list of active rooms without filters → `200 OK`.
- [ ] **Filter Semantics - Capacity:** Pass `?capacity=5` → Verify ALL returned rooms have `capacity >= 5` (not strictly equal).
- [ ] **Filter Semantics - Equipment:** Pass `?equipment=projector,whiteboard` → Verify returned rooms contain BOTH items.

### 3.2. Create Room (`POST /rooms`)
- [ ] **Valid Admin Creation:** Create room as ADMIN → `201 Created`.
- [ ] **Authorization Block:** Attempt creation as USER role → `403 Forbidden`.
- [ ] **Input Validation - Boundary (Capacity):** Attempt creation with `capacity = 0` and `capacity = -1` → `400 Bad Request`.
- [ ] **Input Validation - Types:** Send `equipment` as a string (`"projector"`) instead of an array `["projector"]` → `400 Bad Request`.

---

## 4. Bookings Management & Business Logic (`/bookings`)

### 4.1. Core Booking Logic (`POST /bookings`)
- [ ] **Valid Booking:** Create booking for an available slot → `201 Created`.
- [ ] **Non-existent Room:** Attempt booking for a valid UUID that does not exist in the database → `404 Not Found`.
- [ ] **Input Validation - ID Format:** Send invalid UUID format for `roomId` → `400 Bad Request`.
- [ ] **Time & Overlap Boundary Validation:** 
      *Detailed interval testing matrix is covered in `docs/TEST_DESIGN_TIME.md`*
      *(Includes: adjacent slots, exact overlaps, partial overlaps, max/min duration, past dates).*
- [ ] **Race Condition (Concurrency):** Send two simultaneous identical `POST` requests for the same slot → Exactly one `201 Created` and one `409 Conflict`.
- [ ] **Same User, Different Room:** Book Room A and Room B for the exact same time slot → `201 Created` for both.

### 4.2. Get & Cancel Bookings
- [ ] **Fetch Date Bookings (`GET /bookings?date=...`):** Returns only `CONFIRMED` bookings for the specific date → `200 OK`.
- [ ] **Missing Date Param:** `GET /bookings` without `?date=` → `400 Bad Request`.
- [ ] **Fetch My Bookings (`GET /bookings/my`):** Call endpoint with valid USER token → `200 OK` (returns array of current user's bookings).
- [ ] **Unauthorized Access (`GET /bookings/my`):** Call endpoint without token → `401 Unauthorized`.
- [ ] **Owner Cancellation:** Booking creator deletes their own booking → `200 OK`.
- [ ] **Admin Cancellation:** Admin deletes another user's booking → `200 OK`.
- [ ] **Foreign User Block (IDOR):** Regular user attempts to delete another user's booking → `403 Forbidden` (booking remains `CONFIRMED`).

---

## 5. Database & Data Integrity

- [ ] **Soft Delete Verification:** After cancellation (`DELETE /bookings/:id`), verify via DB query that record is NOT physically deleted, but `status` is updated to `'CANCELLED'`.
- [ ] **Database Seeding Safety:** Run `npm run db:seed` on a populated DB → Verify it aborts or appends safely (does not execute `deleteMany` on production data).
- [ ] **Log Retention:** Verify mechanism exists to clean up old records in the `logs` table to prevent infinite growth.

---

## 6. Frontend & UI (React SPA)

- [ ] **Past Date Selection:** UI visually disables past dates in the calendar and prevents opening the booking modal.
- [ ] **Partial Slot Interaction:** UI visually indicates partial unavailability if a slot is partially booked (e.g., 10:15-10:45) and disables overlapping selection.
