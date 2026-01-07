use database MYDB;
Show tables;
Select distinct sal from emp  order by sal desc limit 10; --Sal gives 5000 -1100 
Select distinct sal from emp  order by sal desc limit 10 offset 2; -- sal gives 2975 to 800
--finding the 2nd highest Salary
Select distinct sal from emp order by sal desc limit 1 offset 1;-- It is 2nd highest salary offset starts from 0 index
Select * from emp limit 3 offset 6; 
--3rd lowest salary
Select distinct sal from emp order by sal asc limit 1 offset 2;
Select distinct sal from emp order by sal desc ;
create table abc(id number(3));
insert into abc values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12);
Select * from abc limit 3 offset 5;
--Categorize employee salaries into Low, Medium, and High groups using dynamic SQL logic.
Select e.*, CASE WHEN e.sal <= 5000 and e.sal >= 3000 then 'High grade'
                 WHEN e.sal <= 3000 and e.sal >=1500 then 'Medium grade'
                 Else 'Low grade' end as grade from emp e order by e.sal desc;

create or replace schema sep10;
use schema sep10;
CREATE TABLE emp (
    empid INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    deptid INT,
    hiredate DATE,
    salary NUMBER(10,2)
);

CREATE TABLE dept (
    deptid INT PRIMARY KEY,
    dname VARCHAR(100),
    location VARCHAR(100)
);
CREATE TABLE project (
    project_id INT PRIMARY KEY,
    pname VARCHAR(100),
    deptid INT,
    managed_by INT,
    start_date DATE
);

INSERT INTO dept (deptid, dname, location) VALUES (10, 'IT', 'Hyderabad');
INSERT INTO dept (deptid, dname, location) VALUES (20, 'HR', 'Bangalore');
INSERT INTO dept (deptid, dname, location) VALUES (30, 'Finance', 'Mumbai');
--update dept set location = 'CHICAGO' where deptid = 30;
INSERT INTO dept (deptid, dname, location) VALUES (40, 'Sleep', 'ReddyPalem');

INSERT INTO emp (empid, firstname, lastname, deptid, hiredate, salary) VALUES (101, 'Arun', 'Sharma', 10, '2021-06-05', 80000.00);
INSERT INTO emp (empid, firstname, lastname, deptid, hiredate, salary) VALUES (102, 'Maya', 'Kumar', 20, '2022-01-10', 65000.00);
INSERT INTO emp (empid, firstname, lastname, deptid, hiredate, salary) VALUES (103, 'Vikram', 'Rao', 10, '2021-09-23', 90000.00);
INSERT INTO emp (empid, firstname, lastname, deptid, hiredate, salary) VALUES (104, 'Sara', 'Naidu', 30, '2020-03-19', 75000.00);

INSERT INTO project (project_id, pname, deptid, managed_by, start_date) VALUES (1001, 'Payroll System', 10, 101, '2023-04-01');
INSERT INTO project (project_id, pname, deptid, managed_by, start_date) VALUES (1002, 'Onboarding', 20, 102, '2023-07-10');
INSERT INTO project (project_id, pname, deptid, managed_by, start_date) VALUES (1003, 'Budget Review', 30, 104, '2023-01-15');
INSERT INTO project (project_id, pname, deptid, managed_by, start_date) VALUES (1004, 'App Migration', 10, 103, '2023-03-20');

Select * from emp;
Select * from dept;
Select * from project;
--Q1: Find the department names (dname) that manage more than one project. Also, display the total number of projects managed.
with cte as (
Select d.deptid as dno,d.dname as dn,d.location as loc, p.project_id,p.pname from dept d INNER JOIN project p ON d.deptid = p.deptid  )
Select dno,dn from CTE group by dno,dn having count(dno) > 1; 
--Q2: Display the deptid and dname of departments that are not managing any projects.
Select d.deptid as dno,d.dname as dn from dept d left JOIN project p ON d.deptid = p.deptid where d.deptid not in (select p.deptid from project p);
--Q3: Get the first name, last name, and department name of employees who work in a department located in 'CHICAGO' and whose department manages at least one project.
with cte as (
Select d.deptid as dno,d.dname as dn,d.location as loc, p.project_id,p.pname from dept d INNER JOIN project p ON d.deptid = p.deptid where d.location = 'CHICAGO' ),
cte1 as (
Select dno,dn from CTE group by dno,dn having count(dno) = 1)
Select c1.dno,c1.dn, e.firstname,e.lastname,e.salary from cte1 c1 INNER JOIN emp e on c1.dno = e.deptid;

create table sales(mon varchar(10), amt number(3));
Insert into sales values('JAN',100),('FEB',200),('MAR',300),('Apr',400),('May',500);
Select * from sales;
SELECT 
 mon,
 amt,
 AVG(amt) OVER (
 ORDER BY mon 
 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
 ) AS Moving_Avg_3
FROM Sales;
/* OVER (ORDER BY Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
ORDER BY Month:
Ensures the calculation follows the chronological order of months.
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW:
This defines a sliding window:
For each row, the window consists of the current row and the two directly preceding rows (i.e., the current month and the previous two months).
The window “slides” as you move through the data, always considering three consecutive rows (unless there are fewer than two prior months at the start). */
Select e.firstname,e.lastname,e.salary from emp e INNER JOIN dept d ON e.deptid = d.deptid where d.dname = 'Finance';
update emp e set e.salary = e.salary * 0.10;

