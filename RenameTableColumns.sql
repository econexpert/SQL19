--  Code to change column names in SQL table, used ChatGPT to create this code

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TestMe')
BEGIN
CREATE TABLE TestMe (
FirstName VARCHAR(20), LastName VARCHAR(20), City VARCHAR(20));
INSERT INTO TestMe (FirstName,LastName,City) VALUES ('OneName','SecondName','Here');
END

-- Testatable to change column titles
DECLARE @bigtablename VARCHAR(70);
SET @bigtablename = 'Testatable';

-- declare temporary table as a variable
DECLARE @temp_table TABLE (
  old_name VARCHAR(255),
  new_name VARCHAR(255)
);

-- insert data into temporary table
INSERT INTO @temp_table (old_name, new_name)
VALUES ('City', 'Town'),('Town', 'City');  -- change City to Town and in next step change back

-- execute dynamic SQL statement to update table column name
DECLARE @old_name VARCHAR(255);
DECLARE @new_name VARCHAR(255);
DECLARE @sql_statement NVARCHAR(500);

DECLARE temp_cursor CURSOR FOR 
SELECT old_name, new_name FROM @temp_table;

OPEN temp_cursor;

FETCH NEXT FROM temp_cursor INTO @old_name, @new_name;

WHILE @@FETCH_STATUS = 0
BEGIN

   SET @sql_statement = CONCAT('EXEC sp_rename ''',@bigtablename, '.' ,  @old_name, ''', ''', @new_name, ''', ''COLUMN''');
   PRINT(@sql_statement);
   EXEC sp_executesql @sql_statement;
   FETCH NEXT FROM temp_cursor INTO @old_name, @new_name;
END;

CLOSE temp_cursor;
DEALLOCATE temp_cursor;

-- drop temporary table variable
-- DROP TABLE @temp_table;
delete from @temp_table

