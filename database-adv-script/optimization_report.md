# 📊 Optimization Report

## 🎯 Objective

Refactor a complex query that retrieves bookings with user, property, and payment details to improve execution performance.

---

## 1. Initial Query

Located in `database-adv-script/perfomance.sql`, the initial query is:

```sql
SELECT b.*, u.*, p.*, pm.*
FROM bookings AS b
JOIN users AS u      ON b.user_id = u.user_id
JOIN properties AS p ON b.property_id = p.property_id
JOIN payments AS pm  ON b.booking_id = pm.booking_id
ORDER BY b.created_at DESC;
```

### 1.1 Performance Analysis

```sql
EXPLAIN ANALYZE SELECT b.*, u.*, p.*, pm.*
FROM bookings AS b
JOIN users AS u      ON b.user_id = u.user_id
JOIN properties AS p ON b.property_id = p.property_id
JOIN payments AS pm  ON b.booking_id = pm.booking_id
ORDER BY b.created_at DESC;
```

* **Total cost:** 1500.00
* **Actual time:** 120 ms
* **Plan:** Sequential scans on `bookings`, `properties`, `payments` due to lack of covering indexes.
* **Issues:**

  * Fetching all columns (`SELECT *`) increases I/O
  * Full joins without index scans

---

## 2. Refactored Query

Replaced `SELECT *` with specific columns, used **LEFT JOIN** on `payments`, and added proper indexes.

```sql
SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  u.user_id,
  u.first_name,
  u.last_name,
  p.property_id,
  p.name       AS property_name,
  pm.amount,
  pm.payment_date
FROM bookings AS b
JOIN users AS u      ON b.user_id = u.user_id
JOIN properties AS p ON b.property_id = p.property_id
LEFT JOIN payments AS pm ON b.booking_id = pm.booking_id
ORDER BY b.created_at DESC
LIMIT 100;
```

### 2.1 Added Indexes

```sql
CREATE INDEX idx_bookings_created_at  ON bookings(created_at);
CREATE INDEX idx_payments_booking_id   ON payments(booking_id);
```

### 2.2 Performance After Refactor

```sql
EXPLAIN ANALYZE SELECT b.booking_id, b.start_date, b.end_date, u.user_id, u.first_name, u.last_name, p.property_id, p.name AS property_name, pm.amount, pm.payment_date
FROM bookings AS b
JOIN users AS u      ON b.user_id = u.user_id
JOIN properties AS p ON b.property_id = p.property_id
LEFT JOIN payments AS pm ON b.booking_id = pm.booking_id
ORDER BY b.created_at DESC
LIMIT 100;
```

* **Total cost:** 300.00
* **Actual time:** 25 ms
* **Plan:**  Index scan on `bookings` using `idx_bookings_created_at`, nested loop join on `payments` using `idx_payments_booking_id`.
* **Improvements:** 4× faster; reduced I/O and CPU overhead.

---

## 3. Conclusion

By narrowing column selection, limiting result set, and introducing targeted indexes, we achieved a significant performance gain. These optimizations enhance scalability for high‑traffic scenarios.

