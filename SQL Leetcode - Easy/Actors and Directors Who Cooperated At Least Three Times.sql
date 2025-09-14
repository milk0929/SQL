-- Question 21
-- Table: ActorDirector

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | actor_id    | int     |
-- | director_id | int     |
-- | timestamp   | int     |
-- +-------------+---------+
-- timestamp is the primary key column for this table.
 

-- Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor have cooperated with the director at least 3 times.

-- Example:

-- ActorDirector table:
-- +-------------+-------------+-------------+
-- | actor_id    | director_id | timestamp   |
-- +-------------+-------------+-------------+
-- | 1           | 1           | 0           |
-- | 1           | 1           | 1           |
-- | 1           | 1           | 2           |
-- | 1           | 2           | 3           |
-- | 1           | 2           | 4           |
-- | 2           | 1           | 5           |
-- | 2           | 1           | 6           |
-- +-------------+-------------+-------------+

-- Result table:
-- +-------------+-------------+
-- | actor_id    | director_id |
-- +-------------+-------------+
-- | 1           | 1           |
-- +-------------+-------------+
-- The only pair is (1, 1) where they cooperated exactly 3 times.

-- Row_number is not recommended 
-- Row_Number 一般情况下要带order by

Select
actor_id,director_id
from ActorDirector
Group by actor_id,director_id
Having count(*) >= 3


-- Window Function -optional
Select distinct 
actor_id,
director_id
from 
(Select 
actor_id,
director_id,
count(*) over(partition by actor_id,director_id) as count_a
from ActorDirector) t
where count_a >= 3 
