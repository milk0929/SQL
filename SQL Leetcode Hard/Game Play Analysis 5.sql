-- Question 111
-- Table: Activity

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key of this table.
-- This table shows the activity of players of some game.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

-- We define the install date of a player to be the first login day of that player.

-- We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X, divided by the number of players whose install date is X, rounded to 2 decimal places.

-- Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.

-- The query result format is in the following example:

-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-01 | 0            |
-- | 3         | 4         | 2016-07-03 | 5            |
-- +-----------+-----------+------------+--------------+

-- Result table:
-- +------------+----------+----------------+
-- | install_dt | installs | Day1_retention |
-- +------------+----------+----------------+
-- | 2016-03-01 | 2        | 0.50           |
-- | 2017-06-25 | 1        | 0.00           |
-- +------------+----------+----------------+
-- Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the
-- day 1 retention of 2016-03-01 is 1 / 2 = 0.50
-- Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00

with install_d as
(
    Select 
    install_date as event_date,count(*) as total_install
    from
    (Select player_id, min(event_date) as install_date
    from Activity
    group by player_id) t
    group by event_date
),


ret as (
Select 
event_date,
count(distinct player_id) as re_number
from(
Select distinct
player_id,
event_date
from 
(
    Select 
*,
min(event_date) over(partition by player_id) as install_date
from 
Activity) t
where DATEDIFF(t.event_date, t.install_date) = 1
)
group by event_date)



Select 
i.event_date,
round(re_number/total_install,2) as Day1_retention
from install_d i
LEFT JOIN ret r
  ON r.event_date = DATE_ADD(i.event_date, INTERVAL 1 DAY)
ORDER BY i.event_date;


--- S2

with t1 as(
Select
    player_id, 
    event_date,
    ROW_NUMBER() over(partition by player_id order by event_date) as rnk,
    MIN(event_date) over(partition by player_id) as install_date,
    LEAD(event_date, 1) over(partition by player_id order by event_date) as nex_log
From Activity)

Select 
install_date,
count(*) as installs, 

round(Sum(CASE WHEN DATEDIFF(nex_log, install_date) = 1 then 1 else 0 end) * 1.0/ 
NULLIF(count(*), 0),2) as Day1_retention

from t1
where rnk =1 
group by install_date
order by install_date

