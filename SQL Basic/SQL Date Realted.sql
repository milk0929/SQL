--1. Select Between two dates - day, week, month 

--2. Today to last n days, last n weeks, last n months, last n years 

--3. Datediff, Date_sub, Date_add 

--4. date_format, weekly, monthly, yearly aggregation


--1. past 30 days
Select * from user_activity 
where activity_date between current_date() - INTERVAL 30 day AND current_date()

2. 