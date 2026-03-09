create or replace schema DT;
use schema DT;
CREATE OR REPLACE TABLE CALL_CENTER
AS
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER;
Select * from CALL_CENTER;
CREATE OR REPLACE TABLE CALL_CENTER_VW
AS
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER where cc_division='6';
Select * from CALL_CENTER_VW;
update CALL_CENTER
set cc_employees = '988007687'
where cc_division='6';

create or replace table lineitem
as
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;

CREATE OR REPLACE DYNAMIC TABLE LINEITEM_DYN
TARGET_LAG = '20 minutes'
WAREHOUSE = 'COMPUTE_WH'
as 
select
  l_returnflag,
  l_linestatus,
  sum(l_quantity) as sum_qty,
  sum(l_extendedprice) as sum_base_price,
  sum(l_extendedprice * (
1
 - l_discount)) as sum_disc_price,
  sum(l_extendedprice * (
1
 - l_discount) * (
1
 + l_tax)) as sum_charge,
  avg(l_quantity) as avg_qty,
  avg(l_extendedprice) as avg_price,
  avg(l_discount) as avg_disc,
  count(*) as count_order
from lineitem
where  l_shipdate <= date '1998-12-01'
group by  l_returnflag,  l_linestatus
order by  l_returnflag,  l_linestatus;

show dynamic Tables;
Select *  from LINEITEM_DYN;

CREATE OR REPLACE DYNAMIC TABLE LINEITEM_DYN_1
WAREHOUSE = 'COMPUTE_WH'
as 
select
  l_returnflag,
  l_linestatus,
  sum(l_quantity) as sum_qty,
  sum(l_extendedprice) as sum_base_price,
  sum(l_extendedprice * (
1
 - l_discount)) as sum_disc_price,
  sum(l_extendedprice * (
1
 - l_discount) * (
1
 + l_tax)) as sum_charge,
  avg(l_quantity) as avg_qty,
  avg(l_extendedprice) as avg_price,
  avg(l_discount) as avg_disc,
  count(*) as count_order
from lineitem
where  l_shipdate <= date '1998-12-01'
group by  l_returnflag,  l_linestatus
order by  l_returnflag,  l_linestatus;
//It gives a Error not specified the TARGET_LAG
CREATE OR REPLACE DYNAMIC TABLE LINEITEM_DYN2
TARGET_LAG = '20 minutes'
as 
select
  l_returnflag,
  l_linestatus,
  sum(l_quantity) as sum_qty,
  sum(l_extendedprice) as sum_base_price,
  sum(l_extendedprice * (
1
 - l_discount)) as sum_disc_price,
  sum(l_extendedprice * (
1
 - l_discount) * (
1
 + l_tax)) as sum_charge,
  avg(l_quantity) as avg_qty,
  avg(l_extendedprice) as avg_price,
  avg(l_discount) as avg_disc,
  count(*) as count_order
from lineitem
where  l_shipdate <= date '1998-12-01'
group by  l_returnflag,  l_linestatus
order by  l_returnflag,  l_linestatus;
//It gives Error Because of the WAREHOUSE not specified

Alter dynamic table LINEITEM_DYN refresh;

CREATE OR REPLACE DYNAMIC TABLE CALL_CENTER_DYN
  TARGET_LAG = '1 minute'
  WAREHOUSE = compute_wh
  AS
SELECT * FROM CALL_CENTER;

Select * from CALL_CENTER_DYN;
show dynamic tables;
ALTER DYNAMIC TABLE CALL_CENTER_DYN refresh;

INSERT INTO CALL_CENTER
SELECT * FROM CALL_CENTER where cc_call_center_sk=3;

Select * from CALL_CENTER_DYN;

update CALL_CENTER
set cc_call_center_id ='testing dyn'
where cc_call_center_sk=1;


Show tables like 'Order%';
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
(103, 'Charlie', '2025-10-03', 'Tablet', 450.00),
(104, 'Alice', '2025-10-04', 'Monitor', 300.00),
(105, 'Bob', '2025-10-05', 'Keyboard', 75.00);
Select * from public.Orders;
create schema DTab;

--Creating dynamic table on top of the Orders table
Create or replace dynamic table Daily_Sales_orders
target_lag = '20 minutes' --Hours || Days || Downstream.
warehouse = COMPUTE_WH
REFRESH_MODE = AUTO -- "FULL || INCREMENTAL"
INITIALIZE = ON_CREATE  -- "ON_SCHEDULE"
as 
Select  CUSTOMER_NAME,
        order_date,
        sum(amount) as amount from PUBLIC.ORDERS
        group by customer_name, ORDER_DATE;

Alter dynamic table Daily_Sales_orders set target_lag = '1minute';

Show tables;

Select * from Daily_Sales_orders;

INSERT INTO Orders (order_id, customer_name, order_date, product, amount)
VALUES (107, 'Merc', '2025-11-10', 'Laptop', 2200.00);

Alter dynamic table Daily_Sales_orders suspend;
alter dynamic table Daily_Sales_orders resume;
alter dynamic table Daily_Sales_orders refresh;

update orders set order_date = '2025-11-10' , Product = 'mouse' , amount = 1000 where order_id = 105; 

Create or replace dynamic table Monthly_sales_orders
target_lag = '1 minute'
warehouse = compute_wh
refresh_mode = AUTO
initialize = ON_SCHEDULE
as
Select  Customer_name,
        month(order_date) as m_sales,
        sum(amount) as amount
        from public.Orders group by order_date, CUSTOMER_NAME;

Alter dynamic table Monthly_sales_orders suspend;

Select * from Monthly_sales_orders;

Create or replace dynamic table Monthly_sales_orders_1
target_lag = '1 minute'
warehouse = compute_wh
refresh_mode = AUTO
initialize = ON_SCHEDULE
as
Select  month(order_date) as m_sales,
        sum(amount) as amount
        from public.Orders group by order_date;

Alter dynamic table Monthly_sales_orders_1 suspend;

Select * from Monthly_sales_orders_1;

CREATE TABLE PUBLIC.CITY (
    customer_name VARCHAR(100),
    city VARCHAR(100)
);
INSERT INTO PUBLIC.CITY (customer_name, city)
VALUES
('Alice', 'Hyderabad'),
('Bob', 'Mumbai'),
('Charlie', 'Delhi'),
('Diana', 'Bangalore'),
('Ethan', 'Chennai'),
('Fiona', 'Pune'),
('George', 'Kolkata'),
('Hannah', 'Ahmedabad'),
('Ian', 'Jaipur'),
('Jane', 'Lucknow'),
('Alice', 'Hyderabad'),
('Bob', 'Mumbai'),
('Charlie', 'Delhi'),
('Diana', 'Bangalore'),
('Ethan', 'Chennai'),
('Fiona', 'Pune'),
('George', 'Kolkata'),
('Hannah', 'Ahmedabad'),
('Ian', 'Jaipur'),
('Jane', 'Lucknow'),
('Kyle', 'Nagpur'),
('Laura', 'Indore'),
('Mike', 'Visakhapatnam'),
('Nina', 'Coimbatore'),
('Oscar', 'Thiruvananthapuram'),
('Paula', 'Patna'),
('Quinn', 'Ranchi'),
('Rita', 'Bhubaneswar'),
('Steve', 'Vijayawada'),
('Tina', 'Surat');


INSERT INTO public.Orders (order_id, customer_name, order_date, product, amount)
VALUES
(101, 'Alice',   '2025-01-15', 'Laptop',        1200.00),
(102, 'Bob',     '2025-01-20', 'Smartphone',     800.00),
(103, 'Charlie', '2025-02-05', 'Tablet',         450.00),
(104, 'Alice',   '2025-02-18', 'Monitor',        300.00),
(105, 'Bob',     '2025-03-10', 'Keyboard',        75.00),
(106, 'Diana',   '2025-03-22', 'Mouse',           50.00),
(107, 'Ethan',   '2025-04-03', 'Printer',        200.00),
(108, 'Fiona',   '2025-04-15', 'Webcam',          90.00),
(109, 'George',  '2025-05-01', 'Headphones',     150.00),
(110, 'Hannah',  '2025-05-12', 'Charger',         40.00),
(111, 'Ian',     '2025-06-08', 'Router',         130.00),
(112, 'Jane',    '2025-06-20', 'SSD',            180.00),
(113, 'Kyle',    '2025-07-04', 'External HDD',   220.00),
(114, 'Laura',   '2025-07-19', 'Speakers',       160.00),
(115, 'Mike',    '2025-08-11', 'Graphics Card',  350.00),
(116, 'Nina',    '2025-08-25', 'RAM',            120.00),
(117, 'Oscar',   '2025-09-09', 'Motherboard',    400.00),
(118, 'Paula',   '2025-09-21', 'Power Supply',   250.00),
(119, 'Quinn',   '2025-10-05', 'Cooling Fan',     60.00),
(120, 'Rita',    '2025-10-28', 'Gaming Chair',   500.00),
(201, 'Alice',   '2024-01-10', 'Laptop',         1150.00),
(202, 'Bob',     '2024-01-25', 'Smartphone',      780.00),
(203, 'Charlie', '2024-02-14', 'Tablet',          430.00),
(204, 'Diana',   '2024-02-28', 'Monitor',         310.00),
(205, 'Ethan',   '2024-03-05', 'Keyboard',         70.00),
(206, 'Fiona',   '2024-03-18', 'Mouse',            55.00),
(207, 'George',  '2024-04-02', 'Printer',         210.00),
(208, 'Hannah',  '2024-04-20', 'Webcam',           95.00),
(209, 'Ian',     '2024-05-06', 'Headphones',      145.00),
(210, 'Jane',    '2024-05-22', 'Charger',          45.00),
(211, 'Kyle',    '2024-06-09', 'Router',          125.00),
(212, 'Laura',   '2024-06-27', 'SSD',             175.00),
(213, 'Mike',    '2024-07-12', 'External HDD',    215.00),
(214, 'Nina',    '2024-07-30', 'Speakers',        155.00),
(215, 'Oscar',   '2024-08-08', 'Graphics Card',   340.00),
(216, 'Paula',   '2024-08-23', 'RAM',             110.00),
(217, 'Quinn',   '2024-09-03', 'Motherboard',     390.00),
(218, 'Rita',    '2024-09-19', 'Power Supply',    245.00),
(219, 'Steve',   '2024-10-07', 'Cooling Fan',      65.00),
(220, 'Tina',    '2024-10-25', 'Gaming Chair',    480.00);

Create or replace dynamic table region_sales
target_lag = DOWNSTREAM           --'1 minute'
warehouse = COMPUTE_WH
refresh_mode = AUTO
INITIALIZE = ON_SCHEDULE
as
Select  c.city,
        o.order_date,
        sum(o.amount) as amount
        from public.orders o join public.city c 
        ON o.customer_name = c.customer_name group by order_date, city;

Alter dynamic table region_sales suspend;

Select * from region_sales;

create or replace dynamic table prod_contribution
target_lag  = '1 minute'
warehouse = compute_wh
as
Select cr.city,
o.product,
o.order_date,
sum(o.amount) as Prod_sales,
rs.amount,
round(SUM(o.amount)/rs.amount * 100,2) as contribution_pct
from public.orders o   JOIN public.city cr ON o.customer_name = cr.customer_name  
                JOIN region_sales rs ON cr.city = rs.city and o.order_date = rs.order_date
                Group by cr.city,o.product,o.order_date,rs.amount;

Alter dynamic table prod_contribution suspend;

Select * from prod_contribution;
Show dynamic tables;

--Implementing SCD TYPE 2 Using Dynamic tables;
CREATE OR REPLACE TABLE public.customers (
    customer_id INT PRIMARY KEY,
    customer_name STRING,
    email STRING,
    city STRING,
    created_at TIMESTAMP
);

INSERT INTO public.customers (customer_id, customer_name, email, city, created_at) VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com', 'New York', CURRENT_TIMESTAMP),
(2, 'Bob Smith', 'bob.smith@example.com', 'Los Angeles', CURRENT_TIMESTAMP),
(3, 'Charlie Brown', 'charlie.brown@example.com', 'Chicago', CURRENT_TIMESTAMP),
(4, 'Diana Prince', 'diana.prince@example.com', 'Houston', CURRENT_TIMESTAMP),
(5, 'Ethan Hunt', 'ethan.hunt@example.com', 'Phoenix', CURRENT_TIMESTAMP),
(6, 'Fiona Gallagher', 'fiona.gallagher@example.com', 'Philadelphia', CURRENT_TIMESTAMP),
(7, 'George Martin', 'george.martin@example.com', 'San Antonio', CURRENT_TIMESTAMP),
(8, 'Hannah Lee', 'hannah.lee@example.com', 'San Diego', CURRENT_TIMESTAMP),
(9, 'Ian Wright', 'ian.wright@example.com', 'Dallas', CURRENT_TIMESTAMP),
(10, 'Julia Roberts', 'julia.roberts@example.com', 'San Jose', CURRENT_TIMESTAMP),
(11, 'Kevin Durant', 'kevin.durant@example.com', 'Austin', CURRENT_TIMESTAMP),
(12, 'Laura Palmer', 'laura.palmer@example.com', 'Jacksonville', CURRENT_TIMESTAMP),
(13, 'Michael Scott', 'michael.scott@example.com', 'Fort Worth', CURRENT_TIMESTAMP),
(14, 'Nina Dobrev', 'nina.dobrev@example.com', 'Columbus', CURRENT_TIMESTAMP),
(15, 'Oscar Isaac', 'oscar.isaac@example.com', 'Charlotte', CURRENT_TIMESTAMP),
(16, 'Paula Abdul', 'paula.abdul@example.com', 'San Francisco', CURRENT_TIMESTAMP),
(17, 'Quentin Blake', 'quentin.blake@example.com', 'Indianapolis', CURRENT_TIMESTAMP),
(18, 'Rachel Green', 'rachel.green@example.com', 'Seattle', CURRENT_TIMESTAMP),
(19, 'Sam Wilson', 'sam.wilson@example.com', 'Denver', CURRENT_TIMESTAMP),
(20, 'Tina Fey', 'tina.fey@example.com', 'Washington', CURRENT_TIMESTAMP),
(21, 'Uma Thurman', 'uma.thurman@example.com', 'Boston', CURRENT_TIMESTAMP),
(22, 'Victor Hugo', 'victor.hugo@example.com', 'El Paso', CURRENT_TIMESTAMP),
(23, 'Wendy Darling', 'wendy.darling@example.com', 'Nashville', CURRENT_TIMESTAMP),
(24, 'Xavier Woods', 'xavier.woods@example.com', 'Detroit', CURRENT_TIMESTAMP),
(25, 'Yara Shahidi', 'yara.shahidi@example.com', 'Oklahoma City', CURRENT_TIMESTAMP),
(26, 'Zane Malik', 'zane.malik@example.com', 'Portland', CURRENT_TIMESTAMP),
(27, 'Aaron Paul', 'aaron.paul@example.com', 'Las Vegas', CURRENT_TIMESTAMP),
(28, 'Bella Swan', 'bella.swan@example.com', 'Memphis', CURRENT_TIMESTAMP),
(29, 'Chris Evans', 'chris.evans@example.com', 'Louisville', CURRENT_TIMESTAMP),
(30, 'Donna Troy', 'donna.troy@example.com', 'Baltimore', CURRENT_TIMESTAMP);

Select * from public.customers order by CUSTOMER_ID;

Create or replace dynamic table cust_SCD2
target_lag = '1 minute'
warehouse = compute_wh
refresh_mode = FULL
initialize = on_create
as
Select  CUSTOMER_ID,
        CUSTOMER_NAME,
        CITY,
        EMAIL,
        created_at as start_date,
        NVL(LEAD(created_at) over(partition by customer_id order by created_at), '2999-12-31') as END_DATE,
        CASE    WHEN  LEAD(created_at) over(partition by customer_id order by created_at) IS NULL 
                THEN TRUE ELSE FALSE END as IS_ACTIVE                
        from public.customers order by CUSTOMER_ID;

Select * from cust_SCD2 order by IS_ACTIVE, CUSTOMER_ID where IS_ACTIVE = FALSE;

INSERT INTO public.customers (customer_id, customer_name, email, city, created_at) VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com', 'Sarapaka',CURRENT_TIMESTAMP()),
(2, 'Bob Smith', 'bob.smith@example.com', 'Dodleru', CURRENT_TIMESTAMP()),
(3, 'Charlie Brown', 'charlie.brown@example.com', 'BCM', CURRENT_TIMESTAMP());

Alter dynamic table cust_SCD2 suspend;
Show tables;