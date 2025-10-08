--1. 
Select customer_id,
sum(amount) as total_amount,
sum(case when is_online then 1 end) as online_count 
from transactions 
where year(trans_date) = '2024'
group by customer_id 
having sum(amount) > 15000 and online_count >= 8
order by sum(amount) desc 

--2 
Select store_id,
sum(revenue) as q2_revenue,
sum(case when is_high_rating then 1 end) as high_rating_count
from sales
where sales_date between '2025-04-01' and '2025-06-30'
group by store_id 
having sum(revenue) > 80000 and sum(case when is_high_rating then 1 end) >= 20 
order by sum(case when is_high_rating then 1 end) desc