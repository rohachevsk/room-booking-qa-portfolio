-- 1. Check all registered users
SELECT id, email, full_name, role, created_at 
FROM users 
ORDER BY created_at DESC;

-- 2. Verify registered user by specific email
SELECT id, email, role 
FROM users 
WHERE email = 'user@example.com';

-- 3. Check soft-deleted bookings (status = 'CANCELLED')
SELECT id, room_id, user_id, start_time, end_time, status 
FROM bookings 
WHERE status = 'CANCELLED';

-- 4. Check active room list
SELECT id, name, capacity, active 
FROM rooms 
WHERE active = true;

-- 5. Detect overlapping confirmed bookings (Data Integrity Check)
SELECT b1.id AS booking_1, b2.id AS booking_2, b1.room_id
FROM bookings b1
JOIN bookings b2 ON b1.room_id = b2.room_id AND b1.id != b2.id
WHERE b1.status = 'CONFIRMED' 
  AND b2.status = 'CONFIRMED'
  AND b1.start_time < b2.end_time 
  AND b1.end_time > b2.start_time;
