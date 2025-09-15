-- Question 49
-- In social network like Facebook or Twitter, people send friend requests and accept others’ requests as well. Now given two tables as below:
 

-- Table: friend_request
-- | sender_id | send_to_id |request_date|
-- |-----------|------------|------------|
-- | 1         | 2          | 2016_06-01 |
-- | 1         | 3          | 2016_06-01 |
-- | 1         | 4          | 2016_06-01 |
-- | 2         | 3          | 2016_06-02 |
-- | 3         | 4          | 2016-06-09 |
 

-- Table: request_accepted
-- | requester_id | accepter_id |accept_date |
-- |--------------|-------------|------------|
-- | 1            | 2           | 2016_06-03 |
-- | 1            | 3           | 2016-06-08 |
-- | 2            | 3           | 2016-06-08 |
-- | 3            | 4           | 2016-06-09 |
-- | 3            | 4           | 2016-06-10 |
 

-- Write a query to find the overall acceptance rate of requests rounded to 2 decimals, which is the number of acceptance divide the number of requests.
 

-- For the sample data above, your query should return the following result.
 

-- |accept_rate|
-- |-----------|
-- |       0.80|
 

-- Note:
-- The accepted requests are not necessarily from the table friend_request. In this case, you just need to simply count the total accepted requests (no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate.
-- It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once. In this case, the ‘duplicated’ requests or acceptances are only counted once.
-- If there is no requests at all, you should return 0.00 as the accept_rate.
 

-- Explanation: There are 4 unique accepted requests, and there are 5 requests in total. 
-- So the rate is 0.80.

-- Not the optimal solution 
-- When duplicate sending
Select 
round(count(case when accept_date is not null then accept_date end)/count(*),2) as accept_rate
from 
friend_request t1
Left join 
request_accepted t2 
on t1.sender_id = t2.requester_id
and t1.send_to_id = t2.accepter_id

--S1: 
SELECT 
  CASE 
    WHEN COUNT(DISTINCT t1.sender_id, t1.send_to_id) = 0 THEN 0.00
    ELSE ROUND(
      COUNT(DISTINCT t2.requester_id, t2.accepter_id) 
      / COUNT(DISTINCT t1.sender_id, t1.send_to_id), 2
    )
  END AS accept_rate
FROM FriendRequest t1
LEFT JOIN RequestAccepted t2
  ON t1.sender_id = t2.requester_id
 AND t1.send_to_id = t2.accepter_id;