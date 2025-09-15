## ✅ When to Create Indexes
Create indexes on columns that:

1. **Frequently appear in `WHERE` clauses**  
   - e.g. `user_id`, `order_date`  
   - Purpose: avoid full table scans and speed up filtering.

2. **Are used in `JOIN` conditions**  
   - Columns that link tables together, such as foreign keys.

3. **Are used in `ORDER BY` or `GROUP BY`**  
   - Speeds up sorting and grouping operations.

4. **Require uniqueness or serve as primary keys**  
   - e.g. `user_id`, `email`, `user_name`  
   - Use **PRIMARY KEY** or **UNIQUE INDEX** to enforce uniqueness.

### ❌ Avoid Indexing
- Columns with **low selectivity** (e.g. true/false flags).  
- Columns that are **frequently updated or refreshed**, because index maintenance will slow down inserts/updates and increase storage overhead.

---

## ⚙️ How to Create Indexes
Create indexes **once**; they are stored in the table’s metadata and used automatically by the query optimizer.  
You **do not need to recreate them every time you run a query**.

```sql
-- Single-column index
CREATE INDEX idx_name ON table_name(column_name);

-- Composite index
CREATE INDEX idx_user_date ON orders(user_id, order_date);

-- Unique index
CREATE UNIQUE INDEX idx_email ON users(email);
```

Or define indexes when creating the table:
```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    created_date DATE,
    INDEX idx_created_date (created_date)
);
```

