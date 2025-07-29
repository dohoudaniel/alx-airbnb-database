-- database-adv-script/partitioning.sql

-- 1) Rename the existing bookings table
RENAME TABLE bookings TO bookings_old;

-- 2) Create a new partitioned bookings table by RANGE on start_date
CREATE TABLE bookings (
  booking_id   CHAR(36)      NOT NULL PRIMARY KEY,
  user_id      CHAR(36)      NOT NULL,
  property_id  CHAR(36)      NOT NULL,
  start_date   DATE          NOT NULL,
  end_date     DATE          NOT NULL,
  total_price  DECIMAL(10,2) NOT NULL,
  status       ENUM('pending','confirmed','canceled') NOT NULL,
  created_at   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_bookings_user_id     (user_id),
  INDEX idx_bookings_property_id (property_id),
  INDEX idx_bookings_start_date  (start_date)
)
PARTITION BY RANGE (YEAR(start_date)) (
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION p2025 VALUES LESS THAN (2026),
  PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 3) Copy data from old table into partitioned table
INSERT INTO bookings
SELECT * FROM bookings_old;

-- 4) Drop the old table if all data copied correctly
-- DROP TABLE bookings_old;

-- 5) Example performance test: fetch bookings in a date range
EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE start_date BETWEEN '2025-06-01' AND '2025-06-30';

-- 6) Compare to non-partitioned version for reference
-- EXPLAIN ANALYZE
-- SELECT *
-- FROM bookings_old
-- WHERE start_date BETWEEN '2025-06-01' AND '2025-06-30';

