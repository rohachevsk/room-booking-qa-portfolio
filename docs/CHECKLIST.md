
# REST API Test Checklist — Room Booking Service

## Base URL
`http://localhost:4000/api`

---

## 1. Authentication & Authorization (`/auth`)

### 1.1. Registration (`POST /auth/register`)
- [ ] **Valid Registration:** Register with new email, fullName, and valid password (>= 6 chars) → `201 Created` with user object (verify JWT token is NOT returned).
- [ ] **Duplicate Email:** Register with an already existing email → `409 Conflict`.
- [ ] **Short Password:** Register with password < 6 characters → `400 Bad Request`.
- [ ] **Missing Fields:** Register without email / password / fullName → `400 Bad Request`.
- [ ] **Email Lowercasing:** Verify email is automatically converted to lowercase before saving.

### 1.2. Login (`POST /auth/login`)
- [ ] **Valid Login:** Login with correct credentials → `200 OK` with JWT token and user details.
- [ ] **Invalid Password:** Login with correct email and wrong password → `401 Unauthorized`.
- [ ] **Non-existent Email:** Login with unregistered email → `400 Bad Request` or `401 Unauthorized`.
- [ ] **Missing Credentials:** Login with empty body → `400 Bad Request`.

---

## 2. Rooms Management (`/rooms`)

### 2.1. Get Rooms List (`GET /rooms`) — Public
- [ ] **Fetch All Rooms:** Retrieve list of active rooms without filters → `200 OK`.
- [ ] **Filter by Capacity:** Pass `?capacity=5` → verify returned rooms fit capacity requirement → `200 OK`.
- [ ] **Filter by Equipment:** Pass `?equipment=projector,whiteboard` → verify returned rooms have specified equipment → `200 OK`.

### 2.2. Create Room (`POST /rooms`) — Admin Only
- [ ] **Admin Creation:** Create room as ADMIN role with valid `name`, `capacity (> 0)`, and `equipment` array → `201 Created`.
- [ ] **User Role Block:** Attempt creation as USER role → `403 Forbidden`.
- [ ] **Unauthorized Block:** Attempt creation without `Authorization` header → `401 Unauthorized`.
- [ ] **Invalid Payload:** Attempt creation with `capacity <= 0` or missing `name` → `400 Bad Request`.

---

## 3. Bookings Management (`/bookings`)

### 3.1. Get Bookings Calendar (`GET /bookings?date=YYYY-MM-DD`) — Public
- [ ] **Fetch Date Bookings:** Retrieve bookings for a valid date query → `200 OK` (returns only `CONFIRMED` status bookings).
- [ ] **Missing Date Param:** Call `GET /bookings` without `?date=` parameter → `400 Bad Request`.

### 3.2. Get User Bookings (`GET /bookings/my`) — Authenticated
- [ ] **Fetch My Bookings:** Call endpoint with valid USER token → `200 OK` (returns array of current user's bookings).
- [ ] **Unauthorized Access:** Call endpoint without token → `401 Unauthorized`.

### 3.3. Create Booking (`POST /bookings`) — Authenticated
- [ ] **Valid Booking:** Create booking for an available slot with valid payload → `201 Created`.
- [ ] **Time Validation:** Covered in `docs/TEST_DESIGN_TIME.md`.
- [ ] **Non-existent Room:** Attempt booking for invalid `roomId` → `404 Not Found`.
- [ ] **Time Overlap (Single Request):** Attempt booking for a time slot overlapping with an existing `CONFIRMED` booking → `409 Conflict`.
- [ ] **Race Condition (Concurrent Requests):** Send two identical simultaneous `POST /bookings` requests (Prisma Serializable transaction check) → 1 request gets `201`, 1 gets `409`.

### 3.4. Cancel Booking (`DELETE /bookings/:id`) — Auth / Owner or Admin
- [ ] **Owner Cancellation:** Booking creator deletes their own booking → `200 OK` (verify soft delete: status changes to `CANCELLED` in DB).
- [ ] **Admin Cancellation:** Admin deletes another user's booking → `200 OK`.
- [ ] **Foreign User Block:** Regular user attempts to delete another user's booking → `403 Forbidden`.
- [ ] **Non-existent Booking:** Delete booking with non-existent ID → `404 Not Found`.
