-- Question 2
-- Table: Sessions

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | session_id          | int     |
-- | duration            | int     |
-- +---------------------+---------+
-- session_id is the primary key for this table.
-- duration is the time in seconds that a user has visited the application.
 

-- You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>" and "15 minutes or more" and count the number of sessions on it.

-- Write an SQL query to report the (bin, total) in any order.

-- The query result format is in the following example.

-- Sessions table:
-- +-------------+---------------+
-- | session_id  | duration      |
-- +-------------+---------------+
-- | 1           | 30            |
-- | 2           | 199           |
-- | 3           | 299           |
-- | 4           | 580           |
-- | 5           | 1000          |
-- +-------------+---------------+

-- Result table:
-- +--------------+--------------+
-- | bin          | total        |
-- +--------------+--------------+
-- | [0-5>        | 3            |
-- | [5-10>       | 1            |
-- | [10-15>      | 0            |
-- | 15 or more   | 1            |
-- +--------------+--------------+

-- For session_id 1, 2 and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
-- For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
-- There are no session with a duration greater or equial than 10 minutes and less than 15 minutes.
-- For session_id 5 has a duration greater or equal than 15 minutes.

-- 假如有一个区间没有的话，怎么显示是0呢； 
 
 --Correct Solution

 with bins as (
    Select 
    '[0-5>' as bin, 1 as ord 
    Union ALL 
    select '[5-10>', 2
    Union all 
    select '[10-15>', 3
    Union all 
    select '15 or more', 4
 ), 
 binned AS (
  SELECT
    CASE
      WHEN duration < 300 THEN '[0-5>'
      WHEN duration < 600 THEN '[5-10>'
      WHEN duration < 900 THEN '[10-15>'
      ELSE '15 or more'
    END AS bin
  FROM Sessions
)

Select 
t1.bin, coalesce(t2.total,0) as total 
from bins t1
Left join 
(Select bin, count(*) as total
from binned
group by bin) t2
on t2.bin = t1.bin 
order by t1.ord
