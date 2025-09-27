-- ***PARTITION BY AND ORDER BY***



-- 1.Running total

-- Running total of sales per customer
Select customer_id, order_date, 
sum(amount) over(partition by customer_id order by order_date asc) as running_total
From orders; 

-- Running total of company-wide
Select order_date, 
sum(amount) over(order by order_date) as running_total
from orders


-- 2. Ranking 
-----------------------------------------------

-- Rank salaries within each department
Select 
department, employee,
rank() over(partition by department order by salary desc) as salary_rank
from Employee; 


-- Top 3 products by revenue in each category 
Select category, products from (
Select category, products,
dense_rank() over(partition by category order by revenue desc) as revenue_ranking
from order) t
where revenue_ranking <= 3


-- Rank all employees across company by salary
Select employee, 
rank() over(order by salary desc) as salary_ranking
from employee


-- row number
-- second largest and the second smallest 
WITH x AS (
  SELECT
    product,
    day,
    qty,
    ROW_NUMBER() OVER (PARTITION BY product ORDER BY qty ASC, day ASC)  AS rn_asc,
    ROW_NUMBER() OVER (PARTITION BY product ORDER BY qty DESC, day DESC) AS rn_desc
  FROM demand
)
SELECT product, day, qty
FROM x
WHERE rn_asc = 2 OR rn_desc = 2;








-- 3. Simple per-aggregate
Select product,day, qty, 
min(qty) over(partition by product) as min_qty,
max(qty) over(partition by product) as max_qty
from demand; 


-- 4. whole table rank

-- 5. Frame Based moving Window
    -- 7 days moving average across all sales 
    Select order_date,
    avg(amount) over(order by order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as ma7
    from orders

    -- Moving average of the last 7 purchases per customer
    Select customer_id, order_date,
    avg(amount) over(partition by customer_id order by order_date
                    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) avg_last_7
    FROM Orders









___________________________________________________________________________________________
-- ***LAG, LEAD***

-- Find each customer’s days since last purchase
    --look back at an earlier row within a partition
Select 
customer_id,
order_date, 
order_date - LAG(order_date) over(partition by customer_id order by order_date) as days_since_last
from orders 

-- Find the percentage increase in qty compared to the previous day.
with t1 as (
    select product, 
    day, qty, 
    lag(qty) over(partition by product order by day) as qty_lag
from demand
)
Select 
*,
round((qty-qty_lag)/nullif(qty_lag,0) * 100,2) as per_change
from t1
where qty_lag is not null; 