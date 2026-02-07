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


