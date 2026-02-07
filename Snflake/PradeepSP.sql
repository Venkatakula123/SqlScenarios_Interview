Select CURRENT_DATABASE();
show schemas;
create or replace schema SP;
use schema SP;
CREATE TRANSIENT TABLE MYDB.PUBLIC.CUSTOMER as select * from  "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER";
Select Current_schema();
--Creating SP to find the No.of rown in the Table
CREATE OR REPLACE PROCEDURE FNR(TNAME VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS 
$$
var msql = "SELECT COUNT(*) FROM "+TNAME+";"  // Stored the Sql statement in the msql variable
var stmt = snowflake.createStatement({sqlText: msql});  // Converting the msql statement into text format
var  rset = stmt.execute(); // Executing the sql sttement by using execute()
rset.next() // next() method pointing to the resultSet or Offset

r_count = rset.getColumnValue(1); //Getting the value of rowcount by using getColumnValue(1)
return "The row count is"+r_count;
$$;

CALL FNR('MYDB.PUBLIC.CUSTOMER');

CREATE OR REPLACE PROCEDURE FNR(TNAME VARCHAR)
RETURNS NUMBER  //Language JAVASCRIPT does not support type 'NUMBER(38,0)' for argument or return type.
LANGUAGE JAVASCRIPT
AS 
$$
var msql = "SELECT COUNT(*) FROM "+TNAME+";"  // Stored the Sql statement in the msql variable
var stmt = snowflake.createStatement({sqlText: msql});  // Converting the msql statement into text format
var  rset = stmt.execute(); // Executing the sql sttement by using execute()
rset.next() // next() method pointing to the resultSet or Offset

r_count = rset.getColumnValue(1); //Getting the value of rowcount by using getColumnValue(1)
return "The row count is"+r_count;
$$;

CALL FNR('MYDB.PUBLIC.CUSTOMER');

--We are trying to return the Statement Object 
CREATE OR REPLACE PROCEDURE FNR_1(TNAME VARCHAR)
RETURNS String  // We can specify as VARCHAR as well //Language JAVASCRIPT does not support type 'NUMBER(38,0)' for argument or return type.
LANGUAGE JAVASCRIPT
AS 
$$
var msql = "SELECT COUNT(*) FROM "+TNAME+";"  // Stored the Sql statement in the msql variable
var stmt = snowflake.createStatement({sqlText: msql});  // Converting the msql statement into text format
var  rset = stmt.execute(); // Executing the sql sttement by using execute()
rset.next() // next() method pointing to the resultSet or Offset

r_count = rset.getColumnValue(1); //Getting the value of rowcount by using getColumnValue(1)
return stmt;
$$;

CALL FNR_1('MYDB.PUBLIC.CUSTOMER'); //It returns [Object only ]

CREATE OR REPLACE PROCEDURE FNR_1(TNAME VARCHAR)
RETURNS variant NOT NULL
LANGUAGE JAVASCRIPT
AS 
$$
var msql = "SELECT COUNT(*) FROM "+TNAME+";"  // Stored the Sql statement in the msql variable
var stmt = snowflake.createStatement({sqlText: msql});  // Converting the msql statement into text format
var  rset = stmt.execute(); // Executing the sql sttement by using execute()
rset.next() // next() method pointing to the resultSet or Offset

r_count = rset.getColumnValue(1); //Getting the value of rowcount by using getColumnValue(1)
return stmt;
$$;

CALL FNR_1('MYDB.PUBLIC.CUSTOMER');  // It returns the all Methods in the Statement Object

CREATE OR REPLACE PROCEDURE FNR_1(TNAME VARCHAR)
RETURNS variant NOT NULL  // We can specify as VARCHAR as well //Language JAVASCRIPT does not support type 'NUMBER(38,0)' for argument or return type.
LANGUAGE JAVASCRIPT
AS 
$$
var msql = "SELECT COUNT(*) FROM "+TNAME+";"  // Stored the Sql statement in the msql variable
var stmt = snowflake.createStatement({sqlText: msql});  // Converting the msql statement into text format
var  rset = stmt.execute(); // Executing the sql sttement by using execute()
rset.next() // next() method pointing to the resultSet or Offset

r_count = rset.getColumnValue(1); //Getting the value of rowcount by using getColumnValue(1)
return rset;
$$;
CALL FNR_1('MYDB.PUBLIC.CUSTOMER'); 

--Checking the Arguments are CASE SENSITIVE OR CASE INSENSITIVE
Create or replace Procedure args(argument varchar)
returns varchar
language javascript
as 
$$
var loc_val = ARGUMENT;

return loc_val;
$$;
CALL args('VENKAT');

Create or replace Procedure args(argument varchar)
returns varchar
language javascript
as 
$$
var loc_val = ARGUMENT;

return loc_val;
$$;
CALL args('venkat');

Create or replace Procedure args(argument varchar) // we can pass arguments in lower or upper case
returns varchar
language javascript
as 
$$
var loc_val = argument; // Arguments i.e. Parameters should be in the UPPERCASE with in the Javascript Portion 

return loc_val;
$$;
CALL args('venkat'); // Also Valid

create or replace transient table public.json_tbl ( fill_rate VARIANT) ;
Insert into public.json_tbl select parse_json('{
  "key1": [
    {
      "ColumnName": "ABC",
      "column_value": 0.98
    },
    {
      "ColumnName": "DEF",
      "column_value": 0.81
    }
    ]
}');
Insert into public.json_tbl select parse_json('{
  "key2": [
    {
      "ColumnName": "GHI",
      "column_value": 1.98
    },
    {
      "ColumnName": "JKL",
      "column_value": 2.81
    }
    ]
}');
Select * from public.json_tbl;
Select f.value:ColumnName,f.value:column_value from public.json_tbl, table(flatten(fill_rate:key1)) F;

Create or replace procedure column_fill_rate_output_sturcture(TNAME VARCHAR)
returns variant not null
language javascript
as 
$$
var array_of_rows = [];
row_as_json = {};
var sql_stmt = "select floor(9/10) ABC,floor(8/10) DEF from "+ TNAME +";"
var stmt = snowflake.createStatement({sqlText: sql_stmt});
var rset = stmt.execute();
rset.next();

a = rset.getColumnName(1);
b = rset.getColumnValue(1);
//pushing the ab in to a Dictionary variable
row_as_json = { CN: a, CV: 9/10}
array_of_rows.push(row_as_json)
a = rset.getColumnName(2);
b = rset.getColumnValue(2);
//pushing the ab in to a Dictionary variable
row_as_json = { CN: a, CV: 8/10}
array_of_rows.push(row_as_json)
table_as_json = {"key1":array_of_rows};
return table_as_json;
$$;
CALL column_fill_rate_output_sturcture('MYDB.PUBLIC.CUSTOMER');
select floor(9/10) ABC,floor(8/10) DEF from MYDB.PUBLIC.CUSTOMER;
//We can not use the any other functions like Sql or Javascript Functions within the Javascript Stored Procedures aprt of Statement, ResultSets functions.
//To Normalize the output as a table 
Select f.value:CN,f.value:CV from table(result_scan(last_query_id())) as res , table(flatten(column_fill_rate_output_sturcture:key1)) f;

Create or replace procedure column_fill_rate_output_sturcture(TNAME VARCHAR)
returns variant not null
language javascript
as 
$$
var array_of_rows = [];
row_as_json = {};
var sql_stmt = "select floor(9/10) ABC,floor(8/10) DEF from "+ TNAME +";"
var stmt = snowflake.createStatement({sqlText: sql_stmt});
var rset = stmt.execute();
while(rset.next()) {

    for(var n = 0; n < rset.getColumnCount();n = n+1){
        a = rset.getColumnName(n+1);
        b = rset.getColumnValue(n+1);
        row_as_json = { CN: a, CV: b}
        array_of_rows.push(row_as_json)
    }
}
table_as_json = {"key1":array_of_rows};
return table_as_json;
$$;
CALL column_fill_rate_output_sturcture('MYDB.PUBLIC.CUSTOMER');

Create or replace procedure contabtojson(TNAME VARCHAR)
returns variant not null
language javascript
as 
$$
var array_of_rows = [];
row_as_json = {};
var sql_stmt = "select *  from "+ TNAME +" limit 10;"
var stmt = snowflake.createStatement({sqlText: sql_stmt});
var rset = stmt.execute();
while(rset.next()) {

    for(var n = 0; n < rset.getColumnCount();n = n+1){
        a = rset.getColumnName(n+1);
        b = rset.getColumnValue(n+1);

        if (a == 'C_NAME') {
          b = 'AVR' } else 
          {
            b
          }
        row_as_json = { CN: a, CV: b}
        array_of_rows.push(row_as_json)
    }
}
table_as_json = {"key1":array_of_rows};
return table_as_json;
$$;
CALL contabtojson('MYDB.PUBLIC.CUSTOMER');

//Using Bind variable to store the result set into a table
create transient table MYDB.public.CUSTOMER_TRANSPOSED (COLUMN_NAME varchar ,COLUMN_VALUE varchar);

Create or replace procedure storeresult(TNAME VARCHAR)
returns variant not null
language javascript
as 
$$
var array_of_rows = [];
row_as_json = {};
var sql_stmt = "select *  from "+ TNAME +" limit 10;"
var stmt = snowflake.createStatement({sqlText: sql_stmt});
var rset = stmt.execute();
var ins_stmt = "INSERT INTO MYDB.public.CUSTOMER_TRANSPOSED values(:1,:2)"
while(rset.next()) {

    for(var n = 0; n < rset.getColumnCount();n = n+1){
        a = rset.getColumnName(n+1);
        b = rset.getColumnValue(n+1);

        if (a == 'C_NAME') {
          b = 'AVR' } else 
          {
            b
          }
        row_as_json = { CN: a, CV: b}
        array_of_rows.push(row_as_json)
        snowflake.execute({sqlText: ins_stmt, binds: [a,b] });
    }
}
table_as_json = {"key1":array_of_rows};

return table_as_json;
$$;
CALL storeresult('MYDB.PUBLIC.CUSTOMER');

Select * from MYDB.public.CUSTOMER_TRANSPOSED;

--Handling Errors using try, Catch and Throw Blocks
Create or replace procedure   MYDB.SP.tableExist(TNAME varchar)
returns varchar
language javascript
as 
$$
var sql_Stmt = "Select rlike('" + TNAME + "','[a-zA-Z0-9_]+')"
var stmt = snowflake.createStatement({sqlText: sql_Stmt});
var rset = stmt.execute();
rset.next();

var status = rset.getColumnValue(1)

if(status == false){
  throw :TNAME+"is not a table"
}
return status;
$$;

CALL MYDB.SP.tableExist('emp');
CREATE OR REPLACE TABLE public.error_log (error_code string, error_state string, error_message string, stack_trace string);
Create or replace procedure checkrowcnt(TNAME varchar)
returns varchar
language javascript
as
$$
  try{
    var sql_stmt = "Select count(*) from "+TNAME+";"
    var stmt = snowflake.createStatement({sqlText: sql_stmt});
    var rset = stmt.execute();
    rset.next();

  }
  catch (err){
    snowflake.execute({sqlText: 'INSERT INTO MYDB.PUBLIC.ERROR_LOG values(?,?,?,?)',
                      binds: [err.code,err.state,err.message,err.stackTraceTxt]});
                      throw err.message;
  }
  var cnt = rset.getColumnValue(1);
  if(cnt == 0){
    throw TNAME+"Is Empty"
  }

$$;

call checkrowcnt('MYDB.PUBLIC.ad');

Select * from MYDB.PUBLIC.ERROR_LOG;

