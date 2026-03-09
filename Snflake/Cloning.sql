use database MYDB;
use schema public;
CREATE TABLE EMP_T(ID NUMBER, NAME VARCHAR, CITY VARCHAR);
INSERT INTO EMP_T VALUES (1, 'PRAVEEN', 'HYD') ;
INSERT INTO EMP_T VALUES (2, 'KUAMR', 'CHN'); --01c2d2c4-0000-dea6-0011-b95f00564082
INSERT INTO EMP_T VALUES (3, 'RAM', 'BNG' ) ; 

Select * from EMP_T;

select * from emp_t before(statement => '01c2d2c4-0000-dea6-0011-b95f00564082');
select * from emp_t at(statement => '01c2d2c4-0000-dea6-0011-b95f00564082');

