use testdb;
go

DECLARE @columnCount int = 15; -- Set the number of columns you want to create
DECLARE @TableName VARCHAR(50) = 'MyTestTable';   -- Table name here
Declare @maxid int = 0;
declare @findmax Nvarchar(max);

set @findmax = 'select @maxid= max(ID) from ' + @TableName   -- this part will find max number of rows, table name dynamic 
exec sp_executesql @findmax, N'@maxid int OUTPUT' , @maxid OUTPUT;

print('max rows now: ' + cast (@maxid as varchar(10)))
set @maxid = ISNULL(@maxid,0);
print(@maxid)  -- max number of rows

-- Build the column list for the CREATE TABLE statement
DECLARE @columnList NVARCHAR(MAX) = ''
DECLARE @i INT = 1 
WHILE @i <= @columnCount
BEGIN
    SET @columnList = @columnList + ', Column' + CAST(@i AS NVARCHAR(10))
    SET @i = @i + 1
END
SET @columnList = RIGHT(@columnList, LEN(@columnList) - 1) -- Remove the leading comma

-- Build the CREATE TABLE statement
DECLARE @collist NVARCHAR(MAX) = '(ID,' + @columnList + ')'

-- Execute the CREATE TABLE statement
print(@collist)

-- Declare variables to hold the starting values for the loop
set @i = 1 + @maxid
DECLARE @max INT = 10 + @maxid  -- insterting 10 rows in one run

-- Start the loop
WHILE @i <= @max
BEGIN
    -- Build the INSERT statement
    DECLARE @sql NVARCHAR(MAX) = 'INSERT INTO ' + @TableName + @collist + ' VALUES (' + CAST(@i AS NVARCHAR(10))
    DECLARE @k INT = 1
    WHILE @k <= @columnCount
    BEGIN
        SET @sql = @sql + ', ''Value' + CAST(@k AS NVARCHAR(10)) + ''''
        SET @k = @k + 1
    END
    SET @sql = @sql + ')'

    -- Execute the INSERT statement
	print(@sql)
    EXEC sp_executesql @sql
	
    -- Increment the counter
    SET @i = @i + 1
END
