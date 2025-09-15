-- Question 15
-- The Employee table holds all employees including their managers. 
-- Every employee has an Id, and there is also a column for the manager Id.

-- +----+-------+--------+-----------+
-- | Id | Name  | Salary | ManagerId |
-- +----+-------+--------+-----------+
-- | 1  | Joe   | 70000  | 3         |
-- | 2  | Henry | 80000  | 4         |
-- | 3  | Sam   | 60000  | NULL      |
-- | 4  | Max   | 90000  | NULL      |
-- +----+-------+--------+-----------+
-- Given the Employee table, write a SQL query that finds out employees who earn more than their managers. 
-- For the above table, Joe is the only employee who earns more than his manager.

-- +----------+
-- | Employee |
-- +----------+
-- | Joe      |
-- +----------+

--S1:
Select 
t1.Name as Employee
from Employee t1
Left join Employee t2
on t1.ManagerId = t2.Id
where t1.Salary > t2.Salary

--s2:SELECT
t1.name as Employee
FROM 
Employee t1
JOIN 
Employee t2
ON t2.id = t1.managerId and t1.salary > t2.salary