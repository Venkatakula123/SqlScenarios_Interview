use database MYDB;
show schemas;
use schema public;
show tables;
Select * from CITY;
-- Create table to store City and Gender information
CREATE TABLE CityGender (
    id INT PRIMARY KEY AUTOINCREMENT start = 1 increment = 1,  -- unique identifier
    city VARCHAR(50) NOT NULL,
    gender VARCHAR(10)
);

-- Insert provided records
INSERT INTO CityGender (city, gender) VALUES ('Bangalore', 'Male');
INSERT INTO CityGender (city, gender) VALUES ('Hyd', 'Female');
INSERT INTO CityGender (city, gender) VALUES ('Chennai', 'Male');
INSERT INTO CityGender (city, gender) VALUES ('Chennai', 'Female');
INSERT INTO CityGender (city, gender) VALUES ('Chennai', 'Male');
INSERT INTO CityGender (city, gender) VALUES ('Bangalore', 'Male');
INSERT INTO CityGender (city, gender) VALUES ('Hyd', 'Female');
INSERT INTO CityGender (city, gender) VALUES ('Kerala', 'Female');
INSERT INTO CityGender (city, gender) VALUES ('Delhi', 'Male');

Select * from CITYGENDER;
Select 1 from citygender;
--Find the city names have only MALE not Both
Select CITY from CITYGENDER group by city  having count(distinct gender) = 1 and max(gender) = 'Male';
SELECT DISTINCT c.city  FROM CityGender c WHERE c.gender = 'Male'
  AND NOT EXISTS (
                    SELECT 1
                    FROM CityGender c2
                    WHERE c2.city = c.city
                    AND c2.gender = 'Female'
                );
Select * from Orders;
Select distinct Order_id, from orders order by Order_id asc;
Select count(distinct Order_id) from orders order by Order_id asc;
Select * from customers;
create or replace schema sql_p;
use schema sql_p;

-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50)
);

-- Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers (customer_id, customer_name, email, phone, city)
VALUES 
(1, 'Ravi Kumar', 'ravi.kumar@example.com', '9876543210', 'Hyderabad'),
(2, 'Priya Sharma', 'priya.sharma@example.com', '9123456780', 'Bangalore'),
(3, 'Arun Mehta', 'arun.mehta@example.com', '9988776655', 'Chennai'),
(4, 'Sneha Reddy', 'sneha.reddy@example.com', '9001122334', 'Delhi'),
(5, 'Vikram Singh', 'vikram.singh@example.com', '9112233445', 'Kerala');

INSERT INTO Orders (order_id, order_date, customer_id, amount, status)
VALUES
(101, '2025-12-01', 1, 2500.00, 'Completed'),
(102, '2025-12-02', 2, 1800.50, 'Pending'),
(103, '2025-12-03', 3, 3200.75, 'Completed'),
(104, '2025-12-04', 1, 1500.00, 'Cancelled'),
(105, '2025-12-05', 4, 2750.00, 'Completed'),
(106, '2025-12-06', 5, 4200.00, 'Pending'),
(107, '2025-12-07', 2, 1999.99, 'Completed');

INSERT INTO Customers (customer_id, customer_name, email, phone, city)
VALUES
(6, 'Anita Desai', 'anita.desai@example.com', '9223344556', 'Mumbai'),
(7, 'Rahul Verma', 'rahul.verma@example.com', '9334455667', 'Pune'),
(8, 'Meena Iyer', 'meena.iyer@example.com', '9445566778', 'Chennai'),
(9, 'Karthik Nair', 'karthik.nair@example.com', '9556677889', 'Kochi'),
(10, 'Sunita Joshi', 'sunita.joshi@example.com', '9667788990', 'Jaipur');

Select * from customers;
Select * from Orders;
--Finding Customer who placed the Orders
Select * from Customers where Customer_id not in (Select customer_id from orders);
--Select * from customers where not exists(Select customer_id from orders); 
--Using Correlated Sub queries
Select * from customers c where  not exists(Select * from orders o where o.customer_id = c.customer_id );

create table city_gne clone MYDB.PUBLIC.CityGender;
Select * from city_gne;
Select distinct c1.city, gender from city_gne c1 where c1.gender = 'Male'
AND NOT EXISTS( Select 1 from city_gne c2 where c2.city = c1.city and gender = 'Female');

Select distinct city from city_gne where gender = 'Male'
minus
Select distinct city from city_gne where gender = 'Female';

SELECT DISTINCT c1.city
FROM City_gne c1
LEFT JOIN City_gne c2
  ON c1.city = c2.city AND c2.gender = 'Female'
WHERE c1.gender = 'Male'
  AND c2.city IS NULL;


create table t1(c1 int,c2 varchar);
insert into t1 values(1,'a'),(2,'b'),(3,'c');
select * from t1;

create table t2(c3 int,c4 varchar);
insert into t2 values(1,'a'),(2,'b'),(3,'c');
select * from t2;



SELECT c1,
       CASE WHEN c2 = 'a' THEN 'apple' ELSE c2 END AS c2
FROM t1

UNION ALL

SELECT c3 AS c1,
       CASE WHEN c4 = 'a' THEN 'apple' ELSE c4 END AS c2
FROM t2;
