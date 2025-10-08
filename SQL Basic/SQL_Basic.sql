

-- Practice number calcualtion , * 1.0, round, case when,count(*) (多练习，不熟练)

-- Practice .. when date condition involved, datediff, where order_date between ...  (日期相关的操作，多练习）


-- Date condition 
-- N days ago 




SELECT 
  product_category, 
  region,
  SUM(amount) AS total_amount,
  SUM(CASE WHEN is_premium THEN 1 ELSE 0 END) AS count_of_premium
FROM sales_date
WHERE sales_date >= DATE '2023-04-01'
  AND sales_date  < DATE '2023-07-01'
GROUP BY product_category, region
HAVING SUM(amount) > 2000
   AND SUM(CASE WHEN is_premium THEN 1 ELSE 0 END) >= 2;




case when()