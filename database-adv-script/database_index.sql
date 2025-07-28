-- File: database_index.sql

-- 1) Measure performance BEFORE adding indexes
EXPLAIN ANALYZE
SELECT b.*
FROM bookings AS b
WHERE b.user_id = 'a1b2c3d4-2222-4422-8222-fedcbafedcba'
ORDER BY b.created_at DESC
LIMIT 10;

-- 2) Create indexes on high‑usage columns
CREATE INDEX IF NOT EXISTS idx_users_email        ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role         ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at   ON users(created_at);

CREATE INDEX IF NOT EXISTS idx_bookings_user_id      ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id  ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at   ON bookings(created_at);
CREATE INDEX IF NOT EXISTS idx_bookings_start_date   ON bookings(start_date);

CREATE INDEX IF NOT EXISTS idx_properties_host_id        ON properties(host_id);
CREATE INDEX IF NOT EXISTS idx_properties_location       ON properties(location);
CREATE INDEX IF NOT EXISTS idx_properties_price_per_night ON properties(price_per_night);

-- 3) Measure performance AFTER adding indexes
EXPLAIN ANALYZE
SELECT b.*
FROM bookings AS b
WHERE b.user_id = 'a1b2c3d4-2222-4422-8222-fedcbafedcba'
ORDER BY b.created_at DESC
LIMIT 10;

