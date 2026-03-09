--EACH DECLARE STMT MUST BE END WITH ';' ONLY
DECLARE 
    SAL NUMBER(10,2) DEFAULT 3000000;
    NAME DEFAULT 'VENKAT'; -- DATA TYPE IS NOT MUST  APPROACH-2
BEGIN 
    RETURN  NAME;
END;

DECLARE 
    SAL NUMBER(10,2) DEFAULT 3000000;
    NAME DEFAULT 'VENKAT'; -- DATA TYPE IS NOT MUST  APPROACH-2 , IF DATATYPE NOT DECLARED WE NEED TO USE DEFAULT VALUE
    AGE NUMBER; --APPROACH 3
BEGIN 
    RETURN  AGE; -- RETURNS NULL VALUE IF WE DO NOT ASSIGN ANY VALUE
END;

use database MYDB;
use schema SPS;

--To Combine the 2 date operators we need to use pipe(||) Operator only.
alter session set query_tag = 'vars'; -- to track the query history for diff sessions

--We can not directly assign Select stmt to a variable like default.
DECLARE 
    sval number default Select count(*) from MYDB.PUBLIC.EMP; -- It is Error
BEGIN
    return sval;
END;

DECLARE 
    sval number default (Select count(*) from MYDB.PUBLIC.EMP); -- It works here
BEGIN
    return sval;
END;