# ✅ How to Improve SQL Query Performance

This guide outlines a **step-by-step workflow** and key **optimization techniques** for improving SQL query performance.

---

## 1️⃣ First Step: Understand Before You Optimize

Before handling very large datasets or attempting complex optimizations, **start with understanding**:

1. **Understand the data model and structure**
   - Table relationships, indexes already in place, data types, data distribution, and cardinality.
2. **Preview the data**
   - Use `LIMIT` to sample a small subset and quickly verify columns, null values, and data quality.
3. **Filter early to reduce data volume**
   - Restrict by date ranges or other key conditions (e.g. `WHERE updated_date >= CURRENT_DATE - INTERVAL 30 DAY`).
   - For exmaple, member_snapshot, rember to include the most *recent* members only.
4. **Review business logic and requirements**
   - Clarify which columns and aggregations are really needed to avoid unnecessary computation.
5. **Confirm business logic**  
   Which columns/aggregations are truly needed?
> 🏁 *Key principle*: It’s impossible to optimize a query if you don’t fully understand its purpose, logic, and expected data volume.

---

## 2️⃣ Core Improvement Techniques

### a. Indexing
- Add indexes on columns used in **`WHERE` / `JOIN` / `ORDER BY` / `GROUP BY`**.
- Use **composite indexes** for multi-column filters (respect **left-most prefix rule**).
- Verify usage with `EXPLAIN`.

```sql
-- Composite index example
CREATE INDEX idx_user_date ON orders(user_id, order_date);
```

---

### b. Query Rewriting
- **Avoid `SELECT *`**; select only needed columns.  
- **Push filters down early** (before joins/aggregations).  
- **Remove unnecessary joins/derived tables**.  
- Use **`UNION ALL`** instead of `UNION` when duplicates don’t matter.  
- Replace **correlated subqueries** with `JOIN`/`EXISTS` when appropriate.

```sql
-- Better than SELECT *
SELECT order_id, user_id, amount
FROM orders
WHERE status = 'PAID';

-- Replace correlated subquery with EXISTS
SELECT o.order_id
FROM orders o
WHERE EXISTS (
  SELECT 1
  FROM customers c
  WHERE c.customer_id = o.customer_id
);
```

---

### c. Join Order and Types
- Join **smaller/filtered** sets first; push predicates to the earliest step.  
- Choose the right join type (`INNER` vs `LEFT`/`SEMI`).  
- Ensure dimension tables are indexed on join keys.

```sql
WITH recent_orders AS (
  SELECT *
  FROM orders
  WHERE created_date >= CURRENT_DATE - INTERVAL 30 DAY
)
SELECT ...
FROM recent_orders ro
JOIN customers c ON ro.customer_id = c.customer_id;
```

---

### d. Aggregation and Temporary Storage
- Pre-aggregate heavy data (do further analysis on aggregated data table)or use **materialized views**.  
- Stage intermediate results in **temp tables** to avoid re-computation.  
- Window functions are powerful—sometimes **pre-agg** is faster.

```sql
CREATE TEMP TABLE daily_sales AS
SELECT order_date, SUM(amount) AS total_amount
FROM orders
GROUP BY order_date;
```

---

### e. Partitioning and Clustering
- **Partition** large tables by date or another natural key to prune scans.  
- Use **clustering/sorting** to co-locate related rows (e.g., BigQuery clustering, Snowflake micro-partitions).

```sql
-- BigQuery example
CREATE TABLE sales_partitioned
PARTITION BY DATE(order_date)
AS SELECT * FROM sales;
```

---


### h. Data Modeling and Schema Design
- Normalize/denormalize **based on query patterns**.  
- Use **appropriate data types** (ints for IDs, avoid oversized strings).  
- **Archive/purge** cold data to keep active tables lean.

```sql
-- Archive old data
INSERT INTO orders_archive
SELECT *
FROM orders
WHERE created_date < '2023-01-01';

DELETE FROM orders
WHERE created_date < '2023-01-01';
```

---

## Key Takeaway
Start with **understanding**; then apply **indexing, rewriting, join/agg strategies, partitioning, and caching**.  
Always **measure** changes with execution plans and track performance over time.
