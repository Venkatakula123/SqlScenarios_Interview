use database MYDB;
use schema public;
CREATE TABLE EMP_T(ID NUMBER, NAME VARCHAR, CITY VARCHAR);
INSERT INTO EMP_T VALUES (1, 'PRAVEEN', 'HYD') ;
INSERT INTO EMP_T VALUES (2, 'KUAMR', 'CHN'); --01c2d2c4-0000-dea6-0011-b95f00564082
INSERT INTO EMP_T VALUES (3, 'RAM', 'BNG' ) ; 

Select * from EMP_T;

select * from emp_t before(statement => '01c2d2c4-0000-dea6-0011-b95f00564082');
select * from emp_t at(statement => '01c2d2c4-0000-dea6-0011-b95f00564082');

create or replace database MYDB;

use database MYDB;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE,
    product VARCHAR(100),
    amount DECIMAL(10, 2)
);

INSERT INTO Orders (order_id, customer_name, order_date, product, amount)
VALUES
(101, 'Alice', '2025-10-01', 'Laptop', 1200.00),
(102, 'Bob', '2025-10-02', 'Smartphone', 800.00),
(103, 'Charlie', '2025-10-03', 'Tablet', 450.00); --01c2e8dd-0000-e9d4-0000-001851efe035

Select * from orders at(statement => '01c2e8dd-0000-e9d4-0000-001851efe035'); --3
Select * from orders at(statement => '01c2e8dd-0000-eaff-0000-001851ef4049'); --5
Select * from orders before(statement => '01c2e8dd-0000-eaff-0000-001851ef4049'); --3

INSERT INTO Orders (order_id, customer_name, order_date, product, amount)
VALUES
(104, 'Alice', '2025-10-04', 'Monitor', 300.00),
(105, 'Bob', '2025-10-05', 'Keyboard', 75.00); --01c2e8dd-0000-eaff-0000-001851ef4049

create table Orders_c clone orders;

show tables in schema public; 

delete from orders; --01c2e8e5-0000-ea3e-0000-001851efd061

select * from orders_c; -- Data is still available in the cloneing table

Select * from orders at(statement => '01c2e8dd-0000-e9d4-0000-001851efe035'); -- 3 Records
Select * from orders before(statement => '01c2e8dd-0000-e9d4-0000-001851efe035'); --0 Records

Create table orders_CTAS as  -- Storage + Comput Cost
Select * from orders at(statement => '01c2e8dd-0000-e9d4-0000-001851efe035');

Select * from orders_CTAS;

--drop table ORDERS_TT;

Create table ORDERS_TT clone Orders at(statement => '01c2e8dd-0000-e9d4-0000-001851efe035');

Select * from ORDERS_TT;

Show tables;

--How to find a table is Normal Table or Cloning Table.To find the clonned table Storage cost use the query and check the Active Bytes column and also time travel bytes of a Table. And more over to create clonned Objects doesn't require warehouse as well.
--While cloning the Entire Database it doesn't clone the Internal Stages and External Tables;
-- Base tables and Clonned tables both are independent. If we do the changes on the base table or clonned tables it doesn't effect the Base or clonned table.
-- WHat is  cloning in Snowflake? In Snowflake cloning we referred as Zero Copy clonning. It is an advanced feature users to allow the to clone the Entire Database or a Schema or a Table  quickly with out storage Cost . Simply it will refer the Micro Partitions of a Base Table. 
Select * from INFORMATION_SCHEMA.TABLE_STORAGE_METRICS where TABLE_CATALOG = 'MYDB';

--We can able to Point the data with "SWAP WITH" like If we consider the EMP Table has data but EMP_C tables doesn't have the Data simply we can swap the data like below using Order Tables. 

create table Orders_1 as Select * from Orders; --0 Rows
Select * from Orders_1;
Select * from Orders;

INSERT INTO Orders (order_id, customer_name, order_date, product, amount)
VALUES
(104, 'Alice', '2025-10-04', 'Monitor', 300.00),
(105, 'Bob', '2025-10-05', 'Keyboard', 75.00),
(106, 'Charlie', '2025-10-06', 'Mouse', 25.00),
(107, 'Diana', '2025-10-07', 'Laptop', 1200.00),
(108, 'Ethan', '2025-10-08', 'Headphones', 150.00),
(109, 'Fiona', '2025-10-09', 'Printer', 200.00),
(110, 'George', '2025-10-10', 'Webcam', 90.00);

Alter table Orders_1 SWAP WITH Orders;



--I have a Customer table with 100 Columns and 1M Records. Mistakenly I have create another table Customer with 2columns and 100 Rows. Now I want the previous Customer Data.
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(100),
    country VARCHAR(100),
    created_at DATE DEFAULT CURRENT_DATE
);

INSERT INTO Customer (customer_id, customer_name, email, phone, address, city, country, created_at)
VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com', '9876543210', '123 Green Street', 'Hyderabad', 'India', '2025-10-01'),
(2, 'Bob Smith', 'bob.smith@example.com', '9123456780', '456 Blue Avenue', 'Mumbai', 'India', '2025-10-02'),
(3, 'Charlie Brown', 'charlie.brown@example.com', '9988776655', '789 Red Road', 'Delhi', 'India', '2025-10-03'),
(4, 'Diana Prince', 'diana.prince@example.com', '9001122334', '321 Yellow Lane', 'Chennai', 'India', '2025-10-04'),
(5, 'Ethan Hunt', 'ethan.hunt@example.com', '9112233445', '654 White Boulevard', 'Bangalore', 'India', '2025-10-05');
INSERT INTO Customer (customer_id, customer_name, email, phone, address, city, country, created_at)
VALUES
(6, 'Grace Lee', 'grace.lee@example.com', '9870011223', '12 Maple Street', 'Pune', 'India', '2025-10-06'),
(7, 'Henry Adams', 'henry.adams@example.com', '9883344556', '34 Oak Avenue', 'Kolkata', 'India', '2025-10-07'),
(8, 'Isabella Clark', 'isabella.clark@example.com', '9894455667', '56 Pine Road', 'Jaipur', 'India', '2025-10-08'),
(9, 'Jack Wilson', 'jack.wilson@example.com', '9905566778', '78 Cedar Lane', 'Lucknow', 'India', '2025-10-09'),
(10, 'Karen Davis', 'karen.davis@example.com', '9916677889', '90 Birch Boulevard', 'Ahmedabad', 'India', '2025-10-10'),
(11, 'Leo Martinez', 'leo.martinez@example.com', '9927788990', '101 Elm Street', 'Surat', 'India', '2025-10-11'),
(12, 'Mia Thompson', 'mia.thompson@example.com', '9938899001', '202 Willow Drive', 'Nagpur', 'India', '2025-10-12'),
(13, 'Noah White', 'noah.white@example.com', '9949900112', '303 Spruce Avenue', 'Indore', 'India', '2025-10-13'),
(14, 'Olivia Harris', 'olivia.harris@example.com', '9950011223', '404 Palm Road', 'Bhopal', 'India', '2025-10-14'),
(15, 'Paul Robinson', 'paul.robinson@example.com', '9961122334', '505 Ash Lane', 'Visakhapatnam', 'India', '2025-10-15');

create or replace table Customer (CID number, CNAME VARCHAR(20));

Select * from Customer;

--Renaming the Existing Customer Table
Alter table customer  rename to Customer_1;

Select * from Customer_1;

Undrop table customer;

Select * from CUSTOMER;

--To run  DDL Commands  in Snowflake warehouse is not required.

--Create Table by using "LIKE OPERATOR", "AS Operator" and "CLONE"
Create table a(id number(10) not null, Name varchar(20));
--drop table a;
describe table a;
Select * from a;
INSERT INTO A VALUES(1,'ABC'),(2,'BCD'),(3,'CDE'),(4,'DEF'),(5,'EFG');
INSERT INTO A VALUES(1,'GHI');

Create table A_CTAS as Select * from a;
SELECT * FROM A_CTAS;
describe table a_CTAS; --NO Constraints+ WAREHOUSE + DATA

CREATE TABLE A_LIKE LIKE A;
Select * from A_LIKE;
describe table A_LIKE; --CONSTRAINTS + NO WAREHOUSE + NO DATA

CREATE TABLE A_CLONE CLONE A;
Select * from A_CLONE;
describe table A_CLONE;  -- CONSTRAINTS + NO WAREHOUSE + DATA

-- Is CLONE feature does copy the grants of a Base table if clone the DB Object. No it doesn't copy the grants. By using the below command we can able to clone the grants 
Create table EMP_C CLONE EMP COPY GRANTS;

--Is cluster key clonned over the table When you clone DB object called Table. Yes it will clone the every information of a table.







