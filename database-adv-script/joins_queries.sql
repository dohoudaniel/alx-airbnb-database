-- 1) INNER JOIN: Retrieve all bookings with the users who made them
SELECT
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.total_price,
  b.status,
  b.created_at    AS booking_created_at,
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  u.role,
  u.created_at    AS user_created_at
FROM bookings AS b
INNER JOIN users AS u
  ON b.user_id = u.user_id
ORDER BY b.created_at;


-- 2) LEFT JOIN: Retrieve all properties and their reviews, including properties without reviews
SELECT
  p.property_id,
  p.host_id,
  p.name,
  p.location,
  p.price_per_night,
  r.review_id,
  r.user_id     AS reviewer_id,
  r.rating,
  r.comment,
  r.created_at  AS review_created_at
FROM properties AS p
LEFT JOIN reviews AS r
  ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at;


-- 3) FULL OUTER JOIN: Retrieve all users and all bookings,
--    even if a user has no bookings or a booking has no matching user.
--    (PostgreSQL syntax)

SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.status
FROM users AS u
FULL OUTER JOIN bookings AS b
  ON u.user_id = b.user_id
ORDER BY COALESCE(u.user_id, b.user_id);


-- If using MySQL (which lacks FULL OUTER JOIN), emulate it via UNION:

SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.status
FROM users AS u
LEFT JOIN bookings AS b
  ON u.user_id = b.user_id

UNION ALL

SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.status
FROM bookings AS b
LEFT JOIN users AS u
  ON u.user_id = b.user_id
WHERE u.user_id IS NULL

ORDER BY COALESCE(user_id, booking_id);

