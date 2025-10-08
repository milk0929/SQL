-- Question 52
-- Write a SQL query to find all numbers that appear at least three times consecutively.

-- +----+-----+
-- | Id | Num |
-- +----+-----+
-- | 1  |  1  |
-- | 2  |  1  |
-- | 3  |  1  |
-- | 4  |  2  |
-- | 5  |  1  |
-- | 6  |  2  |
-- | 7  |  2  |
-- +----+-----+
-- For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

-- +-----------------+
-- | ConsecutiveNums |
-- +-----------------+
-- | 1               |
-- +-----------------+


Select 
distinct Num as ConsecutiveNums
from 
(Select 
id, num, 
id - row_number() over(partition by num order by id) as diff
from 
logs)
group by Num, diff
having count(*) >= 3

-- s2 
SELECT DISTINCT a.num AS ConsecutiveNums
FROM (
  SELECT
    id,
    num,
    LAG(num, 1)  OVER (ORDER BY id) AS prev,
    LEAD(num, 1) OVER (ORDER BY id) AS next
  FROM Logs
) a
WHERE a.num = a.prev
  AND a.num = a.next;