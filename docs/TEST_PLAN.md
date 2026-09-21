# Test Plan — Room Booking Service

## 1. Introduction & Objectives
The objective of this testing process is to verify the REST API functionality, ensure correct business logic execution (including race conditions and overlap protection), validate role-based access control (RBAC), and verify data integrity in PostgreSQL. Additionally, the process includes white-box security checks and frontend UI validation to ensure a robust, secure end-to-end user experience.

## 2. Scope of Testing

### 2.1. In-Scope
- **REST API (Auth, Rooms, Bookings):** Verification of HTTP response status codes, JSON schema structures, and boundary payload validations.
- **Security & Configuration (White-box):** JWT signature validation, fallback secret vulnerabilities, and rate-limiting (brute-force protection).
- **Role-Based Access Control (USER, ADMIN):** Validation of authorization rules for protected endpoints and prevention of IDOR (Insecure Direct Object Reference) during booking cancellation.
- **Time Validation & Business Logic:** Verification of booking duration limits (15 min – 4 hours), time step constraints, and interval overlap prevention matrix.
- **Database Integrity & Infrastructure:** Soft deletes (`CANCELLED` status), database seeding safety, log retention policies, and transaction isolation (Concurrency).
- **Frontend UI Validation (React SPA):** Visual constraints in the booking calendar (past date blocking, partial slot indication).

### 2.2. Out-of-Scope
- Performance and Stress Testing.
- Automated Test Suites (Unit, Integration, or E2E UI automation).
- Infrastructure-level Security Testing (DDoS, server misconfigurations). *Note: Application-level security is in-scope.*
- Third-party Integrations (email/SMS notifications).

## 3. Test Environment
- **OS:** Windows 11
- **Runtime:** Node.js v18+ / npm
- **Database:** PostgreSQL (Local instance / Docker)
- **Tools:** Postman, DBeaver / psql, Google Chrome DevTools

## 4. Risk Analysis (Risk-based Testing)
1. **Security Vulnerabilities:** Hardcoded fallback secrets (e.g., JWT signing) left in the configuration could allow unauthorized access in production.
2. **Data Loss / Destructive Operations:** Developer utility scripts (e.g., database seeding) might unintentionally wipe production data (`deleteMany`) if executed without environment constraints.
3. **Race Condition Flaws:** Concurrent `POST /api/bookings` requests for the exact same slot might create overlapping confirmed bookings if database transaction isolation fails.
4. **Unhandled Database Exceptions:** Malformed inputs (e.g., invalid UUIDs) bypassing application-level validation might crash the ORM, exposing internal stack traces via `500 Internal Server Error`.
5. **Timezone & Interval Logic Errors:** Mismatches in ISO timestamp interpretation or edge-case overlaps (adjacent bookings, fully covered slots) between frontend and backend.
