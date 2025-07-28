# 🗄️ Index Optimization and Performance Measurement

## 🎯 Objective
Identify high‑usage columns in the **users**, **bookings**, and **properties** tables, create appropriate indexes to speed up common queries, and measure query performance **before** and **after** adding the indexes using `EXPLAIN`/`ANALYZE`.

---

## 1️⃣ Identify High‑Usage Columns

Based on typical query patterns (WHERE, JOIN, ORDER BY), these columns benefit most from indexing:

| Table         | Column               | Usage Pattern                     |
|---------------|----------------------|-----------------------------------|
| **users**     | `email`              | Lookup by email for login         |
|               | `role`               | Filter by role                    |
|               | `created_at`         | Sort or paginate by creation date |
| **bookings**  | `user_id`            | JOIN/filter bookings by user      |
|               | `property_id`        | JOIN/filter bookings by property  |
|               | `created_at`         | Sort recent bookings              |
|               | `start_date`         | Availability queries              |
| **properties**| `host_id`            | JOIN/filter properties by host    |
|               | `location`           | Search by location                |
|               | `price_per_night`    | Filter by price range             |

---

## 2️⃣ Measure Performance **Before** Indexing

### Example Query: Recent Bookings for a User

```sql
EXPLAIN ANALYZE
SELECT b.*
FROM bookings AS b
WHERE b.user_id = 'a1b2c3d4-2222-4422-8222-fedcbafedcba'
ORDER BY b.created_at DESC
LIMIT 10;
````

> **Expected before-index plan:**
>
> * **Seq Scan** on `bookings`
> * High “cost” and “rows” values
> * Noticeable execution time

---

## 3️⃣ Create Indexes

```sql
-- users table
CREATE INDEX IF NOT EXISTS idx_users_email        ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role         ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at   ON users(created_at);

-- bookings table
CREATE INDEX IF NOT EXISTS idx_bookings_user_id      ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id  ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at   ON bookings(created_at);
CREATE INDEX IF NOT EXISTS idx_bookings_start_date   ON bookings(start_date);

-- properties table
CREATE INDEX IF NOT EXISTS idx_properties_host_id        ON properties(host_id);
CREATE INDEX IF NOT EXISTS idx_properties_location       ON properties(location);
CREATE INDEX IF NOT EXISTS idx_properties_price_per_night ON properties(price_per_night);
```

---

## 4️⃣ Measure Performance **After** Indexing

```sql
EXPLAIN ANALYZE
SELECT b.*
FROM bookings AS b
WHERE b.user_id = 'a1b2c3d4-2222-4422-8222-fedcbafedcba'
ORDER BY b.created_at DESC
LIMIT 10;
```

> **Expected after-index plan:**
>
> * **Index Scan** on `idx_bookings_user_id`
> * Lower cost and execution time

---

## 5️⃣ Summary

* **Before indexing**, queries often perform **sequential scans**, leading to high latency.
* **After indexing**, the database uses **index scans** for faster lookups.
* Use `EXPLAIN ANALYZE` to confirm index usage and performance gains.
