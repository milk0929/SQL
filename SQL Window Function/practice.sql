
select 
day, qty,
sum(qty) over(order by day) as cumQty
from demand2

select 
product, day, qty,
sum(qty) over(partition by product order by day) as cumsum
from demand


Select * from 
(select 
product, day, qty, 
row_number() over(partition by product order by qty) as rnk
from demand) t
where rnk in (1,2)




Select 
product, day, qty
from 
(Select *,
row_number() over(partition by product order by qty) as row_num, 
count(*) over(partition by product) as total_row
from demand)a
where row_num = 2 or row_num = total_row - 1


Select day, product, 
qty
from 
(select day, 
          product,
          qty,
          max(qty) over (partition by day) as maxqty
  from demand) a
where qty = maxqty