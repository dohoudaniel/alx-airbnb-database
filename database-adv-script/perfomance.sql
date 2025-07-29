-- File: database-adv-script/perfomance.sql

-- 1) Initial query: retrieve all bookings with user, property, and payment details
--    and measure its performance
EXPLAIN ANALYZE
SELECT
  b.*,
  u.user_id    AS user_id,
  u.first_name,
  u.last_name,
  p.property_id,
  p.name       AS property_name,
  pm.payment_id,
  pm.amount,
  pm.payment_date
FROM bookings AS b
JOIN users      AS u  ON b.user_id     = u.user_id
JOIN properties AS p  ON b.property_id = p.property_id
JOIN payments   AS pm ON b.booking_id  = pm.booking_id
ORDER BY b.created_at DESC;


-- 2) Create indexes to support the optimized query
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at);
CREATE INDEX IF NOT EXISTS idx_payments_booking_id  ON payments(booking_id);


-- 3) Refactored query: select only required columns, use LEFT JOIN for payments,
--    and limit the result set; then measure its performance
EXPLAIN ANALYZE
SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  u.user_id,
  u.first_name,
  u.last_name,
  p.property_id,
  p.name         AS property_name,
  pm.amount,
  pm.payment_date
FROM bookings AS b
JOIN users      AS u  ON b.user_id     = u.user_id
JOIN properties AS p  ON b.property_id = p.property_id
LEFT JOIN payments   AS pm ON b.booking_id  = pm.booking_id
ORDER BY b.created_at DESC
LIMIT 100;

