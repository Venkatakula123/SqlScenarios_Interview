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

xUse database MYDB;
use schema SPS;

Use schema Sql_p;

Show tables;
show procedures in schema SPS;

DROP TABLE IF EXISTS emp;

CREATE TABLE emp (
  empno decimal(4,0) NOT NULL,
  ename varchar(10) default NULL,
  job varchar(9) default NULL,
  mgr decimal(4,0) default NULL,
  hiredate date default NULL,
  sal decimal(7,2) default NULL,
  comm decimal(7,2) default NULL,
  deptno decimal(2,0) default NULL
);

DROP TABLE IF EXISTS dept;

CREATE TABLE dept (
  deptno decimal(2,0) default NULL,
  dname varchar(14) default NULL,
  loc varchar(13) default NULL
);

INSERT INTO emp VALUES ('7369','SMITH','CLERK','7902','1980-12-17','800.00',NULL,'20');
INSERT INTO emp VALUES ('7499','ALLEN','SALESMAN','7698','1981-02-20','1600.00','300.00','30');
INSERT INTO emp VALUES ('7521','WARD','SALESMAN','7698','1981-02-22','1250.00','500.00','30');
INSERT INTO emp VALUES ('7566','JONES','MANAGER','7839','1981-04-02','2975.00',NULL,'20');
INSERT INTO emp VALUES ('7654','MARTIN','SALESMAN','7698','1981-09-28','1250.00','1400.00','30');
INSERT INTO emp VALUES ('7698','BLAKE','MANAGER','7839','1981-05-01','2850.00',NULL,'30');
INSERT INTO emp VALUES ('7782','CLARK','MANAGER','7839','1981-06-09','2450.00',NULL,'10');
INSERT INTO emp VALUES ('7788','SCOTT','ANALYST','7566','1982-12-09','3000.00',NULL,'20');
INSERT INTO emp VALUES ('7839','KING','PRESIDENT',NULL,'1981-11-17','5000.00',NULL,'10');
INSERT INTO emp VALUES ('7844','TURNER','SALESMAN','7698','1981-09-08','1500.00','0.00','30');
INSERT INTO emp VALUES ('7876','ADAMS','CLERK','7788','1983-01-12','1100.00',NULL,'20');
INSERT INTO emp VALUES ('7900','JAMES','CLERK','7698','1981-12-03','950.00',NULL,'30');
INSERT INTO emp VALUES ('7902','FORD','ANALYST','7566','1981-12-03','3000.00',NULL,'20');
INSERT INTO emp VALUES ('7934','MILLER','CLERK','7782','1982-01-23','1300.00',NULL,'10');

INSERT INTO dept VALUES ('10','ACCOUNTING','NEW YORK');
INSERT INTO dept VALUES ('20','RESEARCH','DALLAS');
INSERT INTO dept VALUES ('30','SALES','CHICAGO');
INSERT INTO dept VALUES ('40','OPERATIONS','BOSTON');

Select * from emp;
Select * from dept;

--2nd highest Salary
Select max(sal) from emp where sal < (Select max(sal) from emp);


DECLARE
    fnum number default 10;
    snum number default (fnum);
BEGIN
    return snum;
END;

DECLARE
    fnum number default 10;
    snum number default square(fnum);
BEGIN
    return snum;
END;


DECLARE
    fnum number default 10;
    snum number default (fnum+fnum);
BEGIN
    return snum;
END;

-- Snowflake support all datatypes
DECLARE
    text_var text default 'Simple Text';
    int_var number default 100;
    decimal_var number (5,2) default 10.10; 
    date_var date default current_date(); 
    time_var time default current_time();
    ts_var timestamp default current_timestamp();
    boolean_var boolean default False;
    json_Ivar variant default parse_json ('{"key-1": "value-1"}');
    array_var array default '[1,2,3]';
    object_var object default { 'Alberta': 'Edmonton'};
BEGIN
    RETURN boolean_var;
END;

DECLARE
    text_var text default 'Simple Text';
    int_var number default 100;
    decimal_var number (5,2) default 10.10; 
    date_var date default current_date(); 
    time_var time default current_time();
    ts_var timestamp default current_timestamp();
    boolean_var boolean default False;
    json_Ivar variant default parse_json ('{"key-1": "value-1"}');
    array_var array default '[1,2,3]';
    object_var object default { 'Alberta': 'Edmonton'};
BEGIN
    --RETURN json_Ivar;
    --RETURN array_var;
    return object_var;
END;

--Declare LOCAL VARIABLES IN SNOWFLAKE

--Using variables in Expression
-- We can use global variables declared in the declare section in the begin block directly like the below.
CREATE OR REPLACE PROCEDURE VAR()
RETURNS NUMBER(10,2)
LANGUAGE SQL
AS
$$
DECLARE
    A1 NUMBER(10,2);
    A2 NUMBER(10,2) DEFAULT 0.33;
    A3 NUMBER(10,2);
BEGIN
    A1 := 100000;
    A3 := A1*A2;
    RETURN A3;
END;
$$;

CALL VAR();
Select * from public.customers;
--Using variables in Expression(Dynamic String)
CREATE OR REPLACE PROCEDURE DVAR()
RETURNS TEXT
LANGUAGE SQL
AS
$$
DECLARE
    A1 number(2) default 1;
BEGIN
    LET A2 := 'delete from MYDB.PUBLIC.CUSTOMERS where CUSTOMER_ID='|| A1;
    EXECUTE IMMEDIATE A2;
    RETURN 'Deleted Successfullt';
END;
$$;
CALL DVAR();

--Binding Variables in the Expressions
CREATE OR REPLACE PROCEDURE BVAR()
RETURNS NUMBER(10,2)
LANGUAGE SQL
AS
$$
DECLARE 
    A1 NUMBER(4) DEFAULT 7369;
    A3 NUMBER(10,2);
BEGIN
    LET A2 NUMBER(10,2) DEFAULT (SELECT SAL FROM MYDB.PUBLIC.EMP WHERE EMPNO=:A1);

    A3 := A2*10;
    RETURN A3;
END;
$$;
CALL BVAR();
SELECT sal FROM PUBLIC.EMP WHERE EMPNO = 7369;

--bINDING VARIABLES AND USING IDENTIFIER FUNCTION IN THE SCRIPTING IN BELOW.
--WE CAN USE IDENTIFIER FUNCTION FOR THE TABLE OBJECTS ONLY i.e. database objects only.
CREATE OR REPLACE PROCEDURE BIVAR()
RETURNS NUMBER(10,2)
LANGUAGE SQL
AS
$$
DECLARE 
    A1 NUMBER(4) DEFAULT 7369;
    A4 VARCHAR(30) DEFAULT 'MYDB.PUBLIC.EMP';
    A3 NUMBER(10,2);
BEGIN
    LET A2 NUMBER(10,2) DEFAULT (SELECT SAL FROM IDENTIFIER(:A4) WHERE EMPNO=:A1);

    A3 := A2*10;
    RETURN A3;
END;
$$;
CALL BIVAR();

--Nested Blocks
CREATE OR REPLACE PROCEDURE BBLVAR()
RETURNS NUMBER(10,2)
LANGUAGE SQL
AS
$$
DECLARE 
    A1 NUMBER(4) DEFAULT 7369;
    A4 VARCHAR(30) DEFAULT 'MYDB.PUBLIC.EMP';
    
BEGIN
    LET A2 NUMBER(10,2) DEFAULT (SELECT SAL FROM IDENTIFIER(:A4) WHERE EMPNO=:A1);
    BEGIN
        LET A3 := A2*10;
        RETURN A3;
    END;
END;
$$;

CALL BBLVAR();

-- Assign Multiple Values Using INTO keyword
CREATE OR REPLACE PROCEDURE BMVAL()
RETURNS number(10,2)
LANGUAGE SQL
AS
$$
DECLARE 
    MIN_SAL NUMBER(10,2) DEFAULT 0.00;
    MAX_SAL NUMBER(10,2) DEFAULT 0.00;
BEGIN
    SELECT MIN(SAL),MAX(SAL) INTO :MIN_SAL, :MAX_SAL FROM MYDB.PUBLIC.EMP;
    --RETURN MAX_SAL;
    RETURN MIN_SAL;
end;
$$;

CALL BMVAL();

Select * from public.emp;

Create or replace procedure multivar()
RETURNS NUMBER(10,2)
LANGUAGE SQL
AS
$$
DECLARE
    min_bal number(10,2) default 0.00;
    max_bal number(10,2) default 0.00;
BEGIN
    Select max(sal),min(sal) INTO :max_bal,:min_bal from MYDB.PUBLIC.EMP;
    return min_bal;
END;
$$;

CALL multivar();

EXECUTE IMMEDIATE
$$
DECLARE
    min_bal number(10,2) default 0.00;
    max_bal number(10,2) default 0.00;
BEGIN
    Select max(sal),min(sal) INTO :max_bal,:min_bal from MYDB.PUBLIC.EMP;
    return min_bal;
END;
$$;

--: notation not mandatory in INTO variables
Create or replace procedure multivar_without()
RETURNS NUMBER(10,2)
LANGUAGE SQL
AS
$$
DECLARE
    min_bal number(10,2) default 0.00;
    max_bal number(10,2) default 0.00;
BEGIN
    Select max(sal),min(sal) INTO max_bal,min_bal from MYDB.PUBLIC.EMP;
    return min_bal;
END;
$$;

CALL multivar_without();