# 🧠 Database Normalization: Airbnb Clone Schema

## 🎯 Objective
Ensure that all tables in the database schema are normalized to **Third Normal Form (3NF)** to minimize redundancy, enforce data integrity, and improve scalability.

---

## ✅ First Normal Form (1NF)

- All tables have atomic (indivisible) values.
- No repeating groups or arrays.
- Each table has a clearly defined **primary key**.
- ✔️ Achieved for all tables.

---

## ✅ Second Normal Form (2NF)

- No partial dependencies exist since all tables use **single-column primary keys**.
- Every non-key attribute is **fully functionally dependent** on the entire primary key.
- ✔️ Achieved for all tables.

---

## ✅ Third Normal Form (3NF)

- There are **no transitive dependencies** — i.e., no non-key attribute depends on another non-key attribute.
- All non-key fields depend **only on the primary key**.
- ENUMs (`booking_roles`, `booking_status`, `payments_method`) are acceptable for domain constraints.
  - Optionally, they could be turned into separate lookup tables if strict normalization is required.
- `total_price` in `booking` may be considered derived, but is kept for performance; validated by business rules.
- ✔️ Achieved for all tables.

---

## 🧪 Conclusion

All tables in the Airbnb Clone database schema conform to **3NF**, ensuring:
- Data redundancy is minimized
- Integrity is preserved
- Relationships are clear and efficient

This schema is now robust enough to support production-grade backend development.

