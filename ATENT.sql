use database mydb;
use schema sql_p;
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
select * from dept;
create table bonus(
  ename varchar2(10),
  job   varchar2(9),
  sal   number,
  comm  number
);
 
create table salgrade(
  grade number,
  losal number,
  hisal number
);

insert into salgrade
values (1, 700, 1200);
insert into salgrade
values (2, 1201, 1400);
insert into salgrade
values (3, 1401, 2000);
insert into salgrade
values (4, 2001, 3000);
insert into salgrade
values (5, 3001, 9999);

--Find empno whose sal is greater than their managers
SELECT e.empno, e.ename, e.sal, e.mgr,e.deptno,m.ename,m.sal
FROM emp e
JOIN emp m
  ON e.mgr = m.empno
WHERE e.sal > m.sal;
Select d.empno,d.sal,d.mgr,d.deptno from emp d where exists  (Select e.sal from emp e where e.empno = d.mgr and e.sal < d.sal);
Select deptno,max(sal) from emp group by deptno;
Select * from emp where sal IN (Select max(sal) from emp group by deptno );
select * from emp;
Select CURRENT_SCHEMA();
Create or replace table t3(empid number,date_d date, stauts varchar);
--insert into t3 values(4,'2025-01-01','Absent');
--truncate table t3;
Select * from t3;
--delete from t3 where empid = 3 and stauts = 'Absent';

WITH PresentDays AS (
    SELECT EMPID, DATE_D
    FROM t3 
    WHERE LOWER(STAUTS) = 'present' --Finding the Present days
),
Ranked AS (
    SELECT EMPID, DATE_D,
           ROW_NUMBER() OVER (PARTITION BY EMPID ORDER BY DATE_D) AS rn
    FROM PresentDays  -- Assigning ROWNUMBERS
),
Streaks AS (
    SELECT EMPID, DATE_D,
           DATEADD(DAY, -rn, DATE_D) AS streak_key
    FROM Ranked  --Using row numbers to get the same date
)
SELECT EMPID
FROM Streaks
GROUP BY EMPID, streak_key
HAVING COUNT(*) >= 3;

--Using LEAD() 
WITH Ranked AS (
    SELECT EMPID,
           DATE_D,
           STAUTS,
           LEAD(DATE_D, 1) OVER (PARTITION BY EMPID ORDER BY DATE_D) AS next_day1,
           LEAD(DATE_D, 2) OVER (PARTITION BY EMPID ORDER BY DATE_D) AS next_day2,
           LEAD(STAUTS, 1) OVER (PARTITION BY EMPID ORDER BY DATE_D) AS next_status1,
           LEAD(STAUTS, 2) OVER (PARTITION BY EMPID ORDER BY DATE_D) AS next_status2
    FROM t3
)
SELECT DISTINCT EMPID
FROM Ranked
WHERE LOWER(STAUTS) = 'present'
  AND LOWER(next_status1) = 'present'
  AND LOWER(next_status2) = 'present'
  AND DATEDIFF(DAY, DATE_D, next_day1) = 1
  AND DATEDIFF(DAY, DATE_D, next_day2) = 2;

