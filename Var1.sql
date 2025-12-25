use database MYDB;
USE SCHEMA SPS;

ALTER SESSION SET QUERY_TAG = 'VSCODE';

DECLARE 
    MY_COUNT NUMBER DEFAULT (SELECT COUNT(*) FROM MYDB.SQL_P.ORDERS);
    --MY_COUNT NUMBER DEFAULT SELECT COUNT(*) FROM MYDB.SQL_P.ORDERS; GIVES YOU THE ERROR
BEGIN
    RETURN MY_COUNT;
END;

--=====================================================
CREATE OR REPLACE PROCEDURE VAR5()
RETURNS NUMBER
LANGUAGE SQL
AS
$$
DECLARE 
    MY_COUNT NUMBER DEFAULT (SELECT COUNT(*) FROM MYDB.SQL_P.ORDERS);
    --MY_COUNT NUMBER DEFAULT SELECT COUNT(*) FROM MYDB.SQL_P.ORDERS; GIVES YOU THE ERROR
BEGIN
    RETURN MY_COUNT;
END;
$$;

CALL VAR5();

--==========================================================
DECLARE 
text_var text default 'Simple Text';
int_var number default 100;
decimal_var number (5,2) default 10.10; date_var date default current_date (); time_var time default current_time ();
ts_var timestamp default current_timestamp ();
boolean_var boolean default False;
json_var variant default parse_json( '{"key-1": "value-1"}');
array_var array default '[1,2,3]';
object_var object default { 'Alberta': 'Edmonton'};
BEGIN
RETURN object_var;
END;

--===============================================================
CREATE  OR  REPLACE  PROCEDURE myVAR6()
RETURNS text
LANGUAGE SQL
AS
DECLARE
    global_var TEXT DEFAULT 'global-value';
BEGIN
    LET local_var_01 text;
--•without • default value!
    LET local_var_02a DEFAULT 'local_default_var'; -- with default value
    LET local_var_02b := 'local_default_var';
-- with default value
    LET local_var_03a text DEFAULT 'local_default_var'; -- default + datatype
    LET local_var_03b text := 'local_default_var';
--default + datatype!
--•built-in-function as default value!
    LET  local_var_04a text DEFAULT current_role() ; -- default + datatype
    LET  local_var_04b text := current_role();
--default + datatype:
-- select • statement as default value!
   LET local_var_05a number DEFAULT (select count (*)  from MYDB.SQL_P.Orders) ;
-- default + select stmt.
   LET local_var_05b number := (select count (*) from  MYDB.SQL_P.Orders ); -- default + select stmt.
    return local_var_01;
END;
CALL myVAR6();

desc procedure myVAR6();