Use database MYDB;
Use schema SPS;
--Executing the Annonymous Block in Snowflake Stored Procedure 
BEGIN 
    EXECUTE IMMEDIATE 'USE schema MYDB.public'; --In this stmt we can able to change the context like ROLE, WAREHOUSE, Change DB and Schema
    EXECUTE IMMEDIATE 'SHOW TABLES';
    LET RE RESULTSET := (EXECUTE IMMEDIATE 'Select * from table(result_scan())');
    return table(RE);
END;   
--Because it is anonymous Block. But Stored Proc Body we can not able to change the context. It give the Error in runtime 


Create or replace procedure mysp()
returns table()
language SQL
as
$$
BEGIN 
    --EXECUTE IMMEDIATE 'USE schema MYDB.public'; --In this stmt we can able to change the context like ROLE, WAREHOUSE, Change DB and Schema
    EXECUTE IMMEDIATE 'SHOW TABLES';
    LET RE RESULTSET := (EXECUTE IMMEDIATE 'Select * from table(result_scan())');
    return table(RE);
END;   
$$;
CALL MYSP();
Select current_schema();
use schema SPS;
show procedures;
--Parameter Binding in the Anonymous Block by using using() function to map the parameters dynamically
DECLARE
change_context text := 'use schema MYDB.public'; 
show_cmd text := 'show tables';
select_sql text := 'select "name", "rows", "bytes" from table(result_scan ()) where "name" = ? and "rows" >= ?';
BEGIN
EXECUTE IMMEDIATE :change_context;
EXECUTE IMMEDIATE : show_cmd;
--where clause variable
LET table_name:='CUSTOMERS';
LET row_cnt := 0;
LET rs RESULTSET := (EXECUTE IMMEDIATE :select_sql using (table_name, row_cnt));
return table(rs);
END;
--Show tables;

--We can use the numbers like the below to map the parameters dynamically instead of '?' in the above
DECLARE
change_context text := 'use schema MYDB.public'; 
show_cmd text := 'show tables';
select_sql text := 'select "name", "rows", "bytes" from table(result_scan ()) where "name" = :1 and "rows" >= :2';
BEGIN
EXECUTE IMMEDIATE :change_context;
EXECUTE IMMEDIATE : show_cmd;
--where clause variable
LET table_name:='CUSTOMERS';
LET row_cnt := 0;
LET rs RESULTSET := (EXECUTE IMMEDIATE :select_sql using (table_name, row_cnt));
return table(rs);
END;

--Using variables with in the Anonymous Block
DECLARE
change_context text := 'use schema MYDB.public'; 
show_cmd text := 'show tables';
fild_01 := 'name'; -- Variable
select_sql text := 'select "'|| fild_01 ||'", "rows", "bytes" from table(result_scan ()) where "name" = :1 and "rows" >= :2';
BEGIN
EXECUTE IMMEDIATE :change_context;
EXECUTE IMMEDIATE : show_cmd;
--where clause variable
LET table_name:='CUSTOMERS';
LET row_cnt := 0;
LET rs RESULTSET := (EXECUTE IMMEDIATE :select_sql using (table_name, row_cnt));
return table(rs);
END;

--Set Session variables and accessing them by using Select statement
set dt = CURRENT_TIMESTAMP();
Select $dt; --2026-02-08 00:33:17.362 -0800

--Using session variables within the Anonymous Block
SET sql_ses = 'Select * from table(result_scan()) where "owner" = ?';
Select $sql_ses;

declare
t1 := 'USE SCHEMA MYDB.PUBLIC';
t2 := 'show tables';
begin
    EXECUTE IMMEDIATE :t1;
    EXECUTE IMMEDIATE :t2;
    LET owner := 'ACCOUNTADMIN';
    LET RE RESULTSET := (EXECUTE IMMEDIATE $sql_ses using(owner));
    return table(RE);
end;

--Here we tested the Dynamic sql statements by passing the parameters dynamically.