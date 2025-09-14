-- Question 11
-- Write a SQL query to find all duplicate emails in a table named Person.

-- +----+---------+
-- | Id | Email   |
-- +----+---------+
-- | 1  | a@b.com |
-- | 2  | c@d.com |
-- | 3  | a@b.com |
-- +----+---------+
-- For example, your query should return the following for the above table:

-- +---------+
-- | Email   |
-- +---------+
-- | a@b.com |
-- +---------+

--S1
Select 
Email 
from Person 
group by Email
having count(Email) > 1

--s2 self join 
Select distinct 
p1.email
from Person p1
Join Person p2
on p1.id != p2.id and p1.email = p2.email

--Window Function 
Select distinct Email 
from 
(Select Email,
count(*) over(partition by Email) as count_a
from Person) t
where count_a > 1

