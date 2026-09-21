# SQL Database Testing

This directory contains SQL queries used during manual database testing of the Room Booking Service.

## Coverage

The queries were used to verify:

- Users and roles
- Rooms and room status
- Bookings and booking status
- Soft delete behavior
- Database state after operations
- Log records
- Data integrity

## Purpose

SQL queries were used as an additional verification layer during API and database testing.

They helped validate that API operations correctly affected the underlying PostgreSQL database.

## Database

- PostgreSQL
- Prisma ORM

The queries are intended for local development and testing only.
