-- Question 99
-- X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

-- Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

-- For example, the table stadium:
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 1    | 2017-01-01 | 10        |
-- | 2    | 2017-01-02 | 109       | 1 1
-- | 3    | 2017-01-03 | 150       | 2 1
-- | 4    | 2017-01-04 | 99        |
-- | 5    | 2017-01-05 | 145       | 3 2
-- | 6    | 2017-01-06 | 1455      | 4 2
-- | 7    | 2017-01-07 | 199       | 5 2
-- | 8    | 2017-01-08 | 188       | 6 2
-- +------+------------+-----------+
-- For the sample data above, the output is:

-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- Note:
-- Each day only have one row record, and the dates are increasing with id increasing.


-- Wrong Solution !
-- Just picked the mid day of 3 consecutive day
with t1 as (
    Select 
    *,
    lag(people) over(order by visit_date) as pre_people,
    lead(people) over(order by visit_date) as nex_p
    from stadium)

Select 
distinct 
id, 
visit_date
from t1
where people >=100 and pre_people >= 100 and nex_p >= 100



---
with s as(
    Select id, visit_date, people,
    id - row_number() over(order by visit_date) as day_diff
from stadium
where people >= 100)

Select id, visit_date, people
from s
where day_diff in 
(Select 
day_diff
from s
group by day_diff
having count(*) >= 3)