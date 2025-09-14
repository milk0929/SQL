-- Question 37
-- Several friends at a cinema ticket office would like to reserve consecutive available seats.
-- Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?
-- | seat_id | free |
-- |---------|------|
-- | 1       | 1    |
-- | 2       | 0    |
-- | 3       | 1    |
-- | 4       | 1    |
-- | 5       | 1    |
 

-- Your query should return the following result for the sample case above.
 

-- | seat_id |
-- |---------|
-- | 3       |
-- | 4       |
-- | 5       |
-- Note:
-- The seat_id is an auto increment int, and free is bool ('1' means free, and '0' means occupied.).
-- Consecutive available seats are more than 2(inclusive) seats consecutively available.

--------------------------------------------------
--Solution -Window Function：
Select seat_id
from 
(Select 
seat_id,
free,
LAG(free) over(order by seat_id) as prev_seat, --prev row
LEAD(free) over(order by seat_id) as next_seat --next row
From Cinema)t
where free = 1 AND 
(prev_seat = 1 or next_seat = 1)
Order by seat_id 

--Solution 2  -Self Join 

Select distinct c1.seat_id
From Cinema c1
Join Cinema c2 
ON ABS(c1.seat_id - c2.seat_id) = 1
Where c1.free = 1 and c2.free = 1
Order by c1.seat_id