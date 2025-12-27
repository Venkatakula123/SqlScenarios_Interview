--https://youtube.com/playlist?list=PLM68C8Cb4yoNTMyZVe-tFQvDkPAdRfqpG&si=5D0Ts5SpGLFcgQiS

use database MYDB;
use schema SQL_P;
Show tables;
create table names(ename varchar);
describe table names;
insert into names values('PRAVEEN'),('RAMESH'),('PRATAP'),('AKHIL'),('ARYA'),('Durga'),('Bhagya'),('SRINU');
Select * from names;
--Employee Name starting and ending with same character
Select ENAME,SUBSTR(ename,1,1),LEFT(ename,1) from names;
Select ename,SUBSTR(ename,-1,1),RIGHT(ename,1) from names;
Select ename from names where SUBSTR(ename,1,1) = SUBSTR(ename,-1,1);
Select ename from names where LEFT(ename,1) = RIGHT(ename,1);
--Patteren Matching using like Operator
Select ename,SUBSTR(ename,1,1)||'%'||SUBSTR(ENAME,1,1) as patt from names where ename like SUBSTR(ename,1,1)||'%'||SUBSTR(ENAME,1,1);
--How to find next value from the Current position 
Select ename, LEAD(ename) over (order by ename ) as n_ename from names;
Select ename, LAG(ename) over(order by ename) as p_name from names;
CREATE TABLE Persons (
    person_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20) NOT NULL
);

INSERT INTO Persons (person_id, full_name, gender) VALUES
(1, 'Ravi Kumar'),
(2, 'Priya Sharma', 'Female'),
(3, 'Arun Mehta', 'Male'),
(4, 'Sneha Reddy', 'Female'),
(5, 'Vikram Singh', 'Male'),
(6, 'Anita Desai', 'Female'),
(7, 'Rahul Verma', 'Male'),
(8, 'Meena Iyer', 'Female'),
(9, 'Karthik Nair', 'Non-Binary'),
(10, 'Sunita Joshi', 'Female'),
(11, 'Alex Fernandes', 'Non-Binary'),
(12, 'Jordan Patel', 'Male');

Select * from persons;

Select  FULL_NAME, 
        CASE WHEN GENDER = 'Male' then '1'  
             WHEN GENDER = 'Female' then '0' 
             WHEN GENDER = 'Non-Binary' or GENDER IS NULL then '$'
             END as Gen from persons;

Select DECODE(GENDER,'Male','1','Female','0','Non-Binary','$',NULL,'$') from persons;

--Arrange Numbers in Ascending Order
Select 532486;
    -- Print 1-6 numbers 
    with cte as (
    Select 1 as ID, SUBSTR('532486',1,1) as val
    UNION ALL
    Select ID+1, SUBSTR('532486',ID+1,1) as val  from CTE where ID < length('532486'))

    Select LISTAGG(val,'|') within group (order by val asc) as val from cte order by val asc;

--number of Records for each Join
--INNSER OR EQUI JOIN == Matching records from both tables, It won't compare the null values 
--OUTER JOIN(LEFT,RIGHT,FULL OUTER)   == Gives the matching records from the appropriate join and not matching records written null for the not matching records. It comapres the Null values in the Table
--SELF JOIN == Table joined it self called as Self Join
--Cartisian or Cross JOIN ==

-- Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,   -- foreign key to Departments
    salary DECIMAL(10,2)
);

INSERT INTO Departments (dept_id, dept_name) VALUES
(10, 'HR'),
(20, 'Finance'),
(30, 'IT'),
(40, 'Sales'),
(50, 'Marketing');

INSERT INTO Employees (emp_id, emp_name, dept_id, salary) VALUES
(101, 'Ravi Kumar', 10, 50000),
(102, 'Priya Sharma', 20, 60000),
(103, 'Arun Mehta', 30, 55000),
(104, 'Sneha Reddy', 40, 45000),
(105, 'Vikram Singh', NULL, 40000),   -- No department assigned
(106, 'Anita Desai', 30, 70000),
(107, 'Rahul Verma', 60, 48000);      -- Dept doesn’t exist

INSERT INTO Departments (dept_id, dept_name) VALUES
(60, 'Operations'),
(70, 'Research'),
(80, 'Support'),
(90, 'Legal');

INSERT INTO Employees (emp_id, emp_name, dept_id, salary) VALUES
(108, 'Meena Iyer', 50, 52000),     -- Marketing employee
(109, 'Karthik Nair', 70, 61000),   -- Research employee
(110, 'Sunita Joshi', NULL, 43000), -- No department
(111, 'Alex Fernandes', 80, 47000), -- Support employee
(112, 'Jordan Patel', 90, 75000),   -- Legal employee
(113, 'Deepak Rao', 20, 58000),     -- Finance employee
(114, 'Neha Gupta', 100, 50000);    -- Dept doesn’t exist

INSERT INTO Departments (dept_id, dept_name) VALUES
(110, 'Engineering'),
(120, 'Human Resources'),
(130, 'Finance'),
(140, 'Information Technology'),
(150, 'Sales'),
(160, 'Marketing'),
(170, 'Customer Support'),
(180, 'Research & Development'),
(190, 'Legal'),
(200, 'Operations'),
(210, 'Procurement'),
(220, 'Quality Assurance');

INSERT INTO Employees (emp_id, emp_name, dept_id, salary) VALUES (201, 'Ravi Kumar', 10, 50000), (202, 'Priya Sharma', 20, 60000), (203, 'Arun Mehta', 30, 55000), (204, 'Sneha Reddy', NULL, 45000),  (205, 'Vikram Singh', NULL, NULL),   (206, 'Anita Desai', 30, 70000), (207, 'Rahul Verma', 60, 48000), (208, 'Meena Iyer', NULL, 52000),  (209, 'Karthik Nair', 70, NULL),  (210, 'Sunita Joshi', 90, 43000);


Select * from employees;
Select * from departments;

Select * from employees e INNER JOIN DEPARTMENTS d on e.dept_id = d.dept_id; 

Create table t4(id varchar);
create table t5(id varchar);
INSERT INTO t4 values('1'),('2'),(null),('3');
INSERT INTO t5 values('1'),('2'),(null),('4');

Select * from t4;
Select * from t5;

Select a.ID, b.id from t4 a JOIN t5 b ON a.id = b.id;
Select a.ID, b.id from t4 a LEFT JOIN t5 b ON a.id = b.id;
Select a.ID, b.id from t4 a RIGHT JOIN t5 b ON a.id = b.id;
-- Full Join === Each & every row will compares here like (right JOIN + left join but matched records are common. Observe the below query)
Select a.ID, b.id from t4 a FULL JOIN t5 b ON a.id = b.id; 
/*
ID	ID_2
1	1
2	2
null	null            // Full Join       
null	4
null	null
3	null */

--Employee Name 2nd character should be a
Select * from names where ename like '_A%';
Select * from names where SUBSTR(ename,2,1) = 'A';

--How to find number of occurrence of a string in sql
--   ABCABC123ABCD(3's ABC) String
Select REGEXP_COUNT('PRAVEEN','E');
Select REGEXP_COUNT('ABCABC123ABCD','ABC');

Select (Length('ABCABC123ABCD')-LENGTH(REPLACE('ABCABC123ABCD','ABC','')))/length('ABC'),REPLACE('ABCABC123ABCD','ABC','');

Select (length('PRAVEEN')-length(replace('PRAVEEN','E','')))/length('E'),replace('PRAVEEN','E','');

Select (length('ABCDABCABCDABCDABCD123ABCD')-LENGTH(REPLACE('ABCDABCABCDABCDABCD123ABCD','ABCD')))/length('ABCD');

--How to remove double quotes in SQL
Create table t6(name varchar);
insert into t6 values('"Avr"'),('"Bvr"'),('"Cvr"'),('"Dvr"');
Select * from t6;
Select name,    REPLACE(name,'"',''),
                TRIM(name,'"'),
                TRANSLATE(name,'"',''),
                REGEXP_REPLACE(name,'"',''),
                SUBSTR(name,2,length(name)-2) from t6;

--SUBSTR() in SQL:
--It returns varchar only like string. It requires 3 Params 1. base expr 2.start_expr 3.length_expr
-- SUBSTR('VENKAT',1,4) -> VENK
-- It only takes left to right directions only. If we use (-) indexes it takes right directions only

SELECT SUBSTR('Snowflake', 1, 4);   -- 'Snow'
SELECT SUBSTR('Snowflake', 5);      -- 'flake'
Select SUBSTR('SNOWFLAKE',5,2); --fl
Select SUBSTR('SNOWFLAKE',-1); --E
SELECT SUBSTR('SNOWFLAKE',-1,4); --E
Select SUBSTR('SNOWFLAKE',-4,2); --LA 
SELECT SUBSTR(TO_VARCHAR(CURRENT_DATE), 1, 4); -- Year part

CREATE TABLE Countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100),
    continent VARCHAR(50),
    population_millions INT
);

INSERT INTO Countries (country_id, country_name, continent, population_millions) VALUES
(1, 'India', 'Asia', 1420),
(2, 'China', 'Asia', 1410),
(3, 'United States', 'North America', 340),
(4, 'Brazil', 'South America', 215),
(5, 'Germany', 'Europe', 84),
(6, 'Australia', 'Oceania', 26),
(7, 'South Africa', 'Africa', 61),
(8, 'Japan', 'Asia', 124),
(9, 'United Kingdom', 'Europe', 68),
(10, 'Canada', 'North America', 40),
(11, 'Mexico', 'North America', 130),
(12, 'Russia', 'Europe/Asia', 145);

Select * from countries;
--Order Mexico, Russia remaining in alphabetical order 
Select Country_name, CASE   WHEN Country_name = 'Mexico' then 0
                            WHEN COUNTRY_NAME = 'Russia' then 1 
                            ELSE 2 END as code from countries order by code, Country_name asc ;

--2nd High sal from emp table
Select * from emp;
Select empno,ename,sal,deptno from emp where sal = (Select max(sal) from emp where sal < (Select max(sal) from emp));
with cte as (
    Select empno,ename,sal,deptno, dense_rank() over(order by sal desc) as rno from emp order by sal desc
)
Select * from cte where rno = 2;
-- department wise avg salary highest sal > Company Avg
with cte as (
Select * from emp where sal > (Select avg(sal) from emp)
)
Select deptno,max(sal) from cte group by deptno;
with ct1 as (
Select deptno,avg(sal) as avg from emp group by deptno
)
Select * from ct1 where avg > (Select avg(sal) from emp);

Select deptno,avg(sal) as avg from emp group by deptno having avg(sal)> (Select avg(sal) from emp);