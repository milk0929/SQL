# Stored Procedure
---




Stored Procedure: precompiled code

Reason: 

Stored Procedure can be delete, insert,update,join,select...all happen inside on procedure

example:Add more columns in the table and it is not exist in the Select.. code. If we want the new column in our code, we need to go over the sql code make the changes. 

Allow we have the transactions in one place; 



We have a bunch of Stored procedures in system that created by microsoft and help us do different things. 



Process: 
Right click on stored producre and create new, it will provides us a templates for us. 

Attention: The name of procedure, don't start with sp_; Beacuse that's resered for system level; 

My Format: spTable_Action


Create a simple basic one: 
```sql
create procedure dbo.spTesttable_GetAll
as
begin
     select id,FirstName,LastName
     from dbo.Testtable
end
```
Call the procedure:
```sql
exec dbo.spTesttable_GetAll
```
It will return the same records as Select From


Change the stored procedure:
```sql  
Alter procedure dbo.spTesttable_GetAll
as
begin
    Set nocount on;
     select id,FirstName,LastName
     from dbo.Testtable
end
```

---
Want to limit it by LastName, so we add a variable @LastName
```sql
create procedure dbo.spTesttable_GetByLastName
    @LastName nvarchar(50)
as
begin
     select id,FirstName,LastName
     from dbo.Testtable
     Where LastName = @LastName
end
```
```sql
exec dbo.spTesttable_GetByLastName @LastName='pan'
```
```sql
Alter procedure dbo.spTesttable_GetByLastName
    @LastName nvarchar(50),
    @FirstName nvarchar(50)
as
begin
     select id,FirstName,LastName
     from dbo.Testtable
     Where LastName = @LastName and
           FirstName= @FirstName;
end
```
```sql
exec dbo.spTesttable_GetByLastName 'pan','ryan'
--variable in orders
```

### Benefits
1. **Security**: Sometimes we don't want people to see other columns that contain sentitive information. Or Limit the access to the tables. 

```sql
--Database Rule
create role dbStoredProcedureOnlyAccess
grant execute to dbStoredProcedureOnlyAccess
---Allow the users to call the stored procedures
--- Sometimes specific users don't have the access to the tables but can access the stored procedure for security settings. 
```
2. Faster
3. Clearly defined
4. Reuseability
5. Protection against SQL Server injection attacks