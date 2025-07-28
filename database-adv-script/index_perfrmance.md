````markdown
# 🗄️ Index Optimization and Performance Measurement

## 🎯 Objective
Identify high‑usage columns in the **users**, **bookings**, and **properties** tables, create appropriate indexes to speed up common queries, and measure query performance **before** and **after** adding the indexes using `EXPLAIN`/`ANALYZE`.

---

## 1️⃣ Identify High‑Usage Columns

Based on typical query patterns (WHERE, JOIN, ORDER BY), these columns benefit most from indexing:

| Table       | Column             | Usage Pattern                     |
|-------------|--------------------|-----------------------------------|
| **users**   | `email`            | Lookup by email for login         |
|             | `role`             | Filter by role                    |
|             | `created_at`       | Sort or paginate by creation date |
| **bookings**| `user_id`          | JOIN/filter bookings by user      |
|             | `property_id`      | JOIN/filter bookings by property  |
|             | `created_at`       | Sort recent bookings              |
|             | `start_date`       | Availability queries              |
| **properties** | `host_id`       | JOIN/filter properties by host    |
|             | `location`         | Search by location                |
|             | `price_per_night`  | Filter by price range             |

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
> * Noticeable execution time (e.g., > 50 ms on large table)

---

## 3️⃣ Create Indexes

Add the following indexes to accelerate the identified operations:

```sql
-- users table
CREATE INDEX idx_users_email        ON users(email);
CREATE INDEX idx_users_role         ON users(role);
CREATE INDEX idx_users_created_at   ON users(created_at);

-- bookings table
CREATE INDEX idx_bookings_user_id      ON bookings(user_id);
CREATE INDEX idx_bookings_property_id  ON bookings(property_id);
CREATE INDEX idx_bookings_created_at   ON bookings(created_at);
CREATE INDEX idx_bookings_start_date   ON bookings(start_date);

-- properties table
CREATE INDEX idx_properties_host_id       ON properties(host_id);
CREATE INDEX idx_properties_location      ON properties(location);
CREATE INDEX idx_properties_price_per_night ON properties(price_per_night);
```

> **Tip:** Use `IF NOT EXISTS` in PostgreSQL/MySQL 8+ to avoid duplicate‑index errors:
>
> ```sql
> CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
> ```

---

## 4️⃣ Measure Performance **After** Indexing

Re‑run the same query to verify improved performance:

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
> * **Index Scan** on `idx_bookings_user_id` (and possibly `idx_bookings_created_at`)
> * Dramatically lower “cost” and “rows” estimates
> * Execution time reduced (e.g., < 5 ms)

---

## 5️⃣ Summary

* **Before indexing**, queries on large tables often perform **sequential scans**, leading to high latency.
* **After indexing**, the database can leverage **index scans** to quickly locate relevant rows, reducing I/O and CPU time.
* Always **measure** with `EXPLAIN ANALYZE` (PostgreSQL) or `EXPLAIN` (MySQL 8+) to confirm that the planner is using your new indexes.

---

> 📂 **File Location:**
> Save this content as `database_index.sql` (with the SQL blocks) and document the performance results in your repo’s README or a companion markdown file.

```
```

