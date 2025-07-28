-- aggregations_and_window_functions.sql

-- 1) Total number of bookings made by each user
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  COUNT(b.booking_id) AS total_bookings
FROM users AS u
LEFT JOIN bookings AS b
  ON u.user_id = b.user_id
GROUP BY
  u.user_id,
  u.first_name,
  u.last_name
ORDER BY
  total_bookings DESC
;

-- 2) Rank properties based on the total number of bookings using RANK()
WITH property_counts AS (
  SELECT
    p.property_id,
    p.name,
    COUNT(b.booking_id) AS booking_count
  FROM properties AS p
  LEFT JOIN bookings AS b
    ON p.property_id = b.property_id
  GROUP BY
    p.property_id,
    p.name
)
SELECT
  property_id,
  name,
  booking_count,
  RANK() OVER (ORDER BY booking_count DESC) AS booking_rank
FROM property_counts
ORDER BY
  booking_rank
;

