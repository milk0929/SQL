-- Question 107
-- The Numbers table keeps the value of number and its frequency.

-- +----------+-------------+
-- |  Number  |  Frequency  |
-- +----------+-------------|
-- |  0       |  7          |
-- |  1       |  1          |
-- |  2       |  3          |
-- |  3       |  1          |
-- +----------+-------------+
-- In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

-- +--------+
-- | median |
-- +--------|
-- | 0.0000 |
-- +--------+
-- Write a query to find the median of all numbers and name the result as median.



With cte as (Select 
number, 
Frequency,
sum(Frequency) over(order by Number) as running_freq,
sum(Frequency) over() as total_freq
from Number)


Select avg(number)
from 
cte
WHERE total_count / 2 BETWEEN running_total - frequency AND running_total
   OR (total_count + 1) / 2 BETWEEN running_total - frequency AND running_total;

