-- 1) Find all properties with an average rating > 4.0 using a (non‑correlated) subquery
SELECT
  p.property_id,
  p.name,
  p.location,
  p.price_per_night
FROM properties AS p
WHERE (
  SELECT AVG(r.rating)
  FROM reviews AS r
  WHERE r.property_id = p.property_id
) > 4.0
ORDER BY p.property_id;


-- 2) Find all users who have made more than 3 bookings using a correlated subquery
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email
FROM users AS u
WHERE (
  SELECT COUNT(*)
  FROM bookings AS b
  WHERE b.user_id = u.user_id
) > 3
ORDER BY u.user_id;
