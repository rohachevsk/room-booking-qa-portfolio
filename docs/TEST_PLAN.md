# Test Plan — Room Booking Service

## 1. Introduction & Objectives
The objective of this testing process is to verify the REST API functionality, ensure correct business logic execution (including race conditions and overlap protection), validate role-based access control (RBAC), and verify data integrity in PostgreSQL.

## 2. Scope of Testing

### 2.1. In-Scope
- **REST API (Auth, Rooms, Bookings):** Verification of HTTP response status codes, JSON schema structures, and request payload validations.
- **Role-Based Access Control (USER, ADMIN):** Validation of authorization rules for protected endpoints and JWT token handling.
- **Time Validation Rules:** Verification of booking duration limits (15 min – 4 hours), time step constraints (minutes % 15 == 0), and prevention of past-date bookings.
- **Overlap & Race Condition Protection:** Testing Prisma Serializable transactions during simultaneous booking requests for the same room.
- **PostgreSQL Data Integrity:** Database state verification for soft deletes (`CANCELLED` status), email uniqueness, and foreign key relations.

### 2.2. Out-of-Scope
- Performance and Load Testing.
- Automated Test Suites (Unit, Integration, or E2E automation).
- Infrastructure-level Security Testing (DDoS, penetration testing).
- Third-party Integrations (email notifications are not implemented).

## 3. Test Environment
- **OS:** Windows 11
- **Runtime:** Node.js v18+ / npm
- **Database:** PostgreSQL (Local instance / Docker)
- **Tools:** Postman, DBeaver / psql, Google Chrome DevTools

## 4. Risk Analysis (Risk-based Testing)
1. **Race Condition Flaws:** Concurrent `POST /api/bookings` requests for the exact same slot might create overlapping confirmed bookings if transaction isolation fails.
2. **Privilege Escalation:** Regular users (`USER` role) attempting to execute admin-only operations (e.g., `POST /api/rooms`) or delete other users' bookings.
3. **Timezone & Date Parsing Errors:** Mismatches in ISO timestamp interpretation between frontend/Postman requests and backend server execution.
