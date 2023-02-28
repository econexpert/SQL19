use testdb;  -- database name I am going to use
go

DECLARE @columnCount int = 15; -- Set the number of columns you want to create
DECLARE @TableName VARCHAR(50) = 'MyTestTable';   -- Table name here
DECLARE @statement NVARCHAR(50)  --  variable for SQL statements

IF EXISTS (SELECT * FROM sys.tables WHERE name = @TableName)
begin
SET @statement = N'DROP TABLE ' + @TableName;
	PRINT('Dropping old table: ' + @statement)
	EXEC sp_executesql @statement
	end

-- Build the column list for the CREATE TABLE statement
DECLARE @columnList NVARCHAR(MAX) = ''
DECLARE @i INT = 1
WHILE @i <= @columnCount
BEGIN
    SET @columnList = @columnList + ', Column' + CAST(@i AS NVARCHAR(10)) + ' VARCHAR(50)'
    SET @i = @i + 1
END
SET @columnList = RIGHT(@columnList, LEN(@columnList) - 1) -- Remove the leading comma

-- Build the CREATE TABLE statement
DECLARE @sql NVARCHAR(MAX) = 'CREATE TABLE ' + @TableName + ' (ID INT PRIMARY KEY,' + @columnList + ')'

-- Execute the CREATE TABLE statement
print(@sql)
EXEC sp_executesql @sql
