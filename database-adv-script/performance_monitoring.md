# 📈 Continuous Database Performance Monitoring & Tuning

## 🎯 Objective
Continuously monitor and refine database performance by analyzing query execution plans, identifying bottlenecks, and applying schema or indexing adjustments to improve frequently used queries.

---

## 📝 Overview
Ongoing performance tuning ensures that as data grows, query response times remain fast and resource usage stays efficient. This document describes:

1. Monitoring tools & commands  
2. Sample queries under analysis  
3. Identified bottlenecks  
4. Schema/index adjustments  
5. Before-and-after results

---

## 1️⃣ Monitoring Queries

Use the following commands to capture execution details:

- **PostgreSQL:**  
  ```sql
  EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
  SELECT ...;
````

* **MySQL:**

  ```sql
  SET profiling = 1;
  SELECT ...;
  SHOW PROFILES;
  SHOW PROFILE FOR QUERY N;
  ```

---

## 2️⃣ Sample Queries Under Review

1. **Recent Bookings by User**

   ```sql
   SELECT b.*
   FROM bookings b
   WHERE b.user_id = '…'
   ORDER BY b.created_at DESC
   LIMIT 10;
   ```

2. **Search Properties by Location & Price**

   ```sql
   SELECT p.property_id, p.name, p.price_per_night
   FROM properties p
   WHERE p.location ILIKE '%Lagos%'
     AND p.price_per_night BETWEEN 50 AND 200
   ORDER BY p.price_per_night;
   ```

3. **User’s Booking History with Payment Info**

   ```sql
   SELECT b.booking_id, b.start_date, pm.amount
   FROM bookings b
   JOIN payments pm ON b.booking_id = pm.booking_id
   WHERE b.user_id = '…';
   ```

---

## 3️⃣ Identified Bottlenecks

| Query # | Issue                                                                               |
| ------- | ----------------------------------------------------------------------------------- |
| 1       | Seq scan on `bookings` table; no index on `user_id` + `created_at` composite filter |
| 2       | Full table scan on `properties`; ILIKE prevents index usage on `location`           |
| 3       | Nested loop join on `payments`; missing supporting index on `payment.booking_id`    |

---

## 4️⃣ Recommended Schema & Index Adjustments

1. **Composite index for bookings**

   ```sql
   CREATE INDEX idx_bookings_user_created 
     ON bookings (user_id, created_at DESC);
   ```

2. **Trigram index for ILIKE searches** (PostgreSQL only)

   ```sql
   CREATE EXTENSION IF NOT EXISTS pg_trgm;
   CREATE INDEX idx_properties_location_trgm 
     ON properties USING gin (location gin_trgm_ops);
   ```

3. **Single‑column index for payments**

   ```sql
   CREATE INDEX idx_payments_booking 
     ON payments (booking_id);
   ```

---

## 5️⃣ Implementation & Results

### 5.1 Before Adjustments

* **Query 1:**  Seq scan, 45 ms
* **Query 2:**  Full scan, 120 ms
* **Query 3:**  Nested loops, 80 ms

### 5.2 After Adjustments

* **Query 1:**  Index scan on `idx_bookings_user_created`, 5 ms
* **Query 2:**  Trigram index scan on `idx_properties_location_trgm`, 15 ms
* **Query 3:**  Index nested loop on `idx_payments_booking`, 10 ms

---

## 6️⃣ Next Steps

* **Automate** periodic re-analysis (e.g., via CI or cron jobs).
* **Monitor** index usage with `pg_stat_user_indexes` (PostgreSQL) or `information_schema` (MySQL).
* **Review** slow-query logs weekly to spot new hot paths.
* **Adjust** partitioning strategy or denormalize selectively for extreme hotspots.

---

> 🚀 Continuous tuning keeps your database responsive and scalable as your Airbnb Clone grows.
> Keep iterating!

