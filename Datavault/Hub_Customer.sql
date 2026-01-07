create or replace database DV;
use database DV;
create or replace schema stg;
use schema stg;

CREATE OR REPLACE TABLE STG_CUSTOMER (
    BK_CUSTOMER STRING,          -- Business key from source
    CUSTOMER_NAME STRING,
    EMAIL STRING,
    ADDRESS STRING,
    RECORD_SOURCE STRING,        -- Source system name
    LOAD_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM STG.STG_CUSTOMER;

CREATE OR REPLACE TABLE STG_ORDER (
    BK_ORDER STRING,             -- Business key from source
    CUSTOMER_ID STRING,          -- FK to customer business key
    ORDER_DATE DATE,
    RECORD_SOURCE STRING,
    LOAD_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM STG.STG_ORDER;

CREATE OR REPLACE TABLE STG_PRODUCT (
    BK_PRODUCT STRING,           -- Business key from source
    PRODUCT_NAME STRING,
    CATEGORY STRING,
    RECORD_SOURCE STRING,
    LOAD_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM STG.STG_PRODUCT;

Create or replace schema strms;
use schema strms;
CREATE OR REPLACE STREAM STG_CUSTOMER_STREAM ON TABLE stg.STG_CUSTOMER;
CREATE OR REPLACE STREAM STG_ORDER_STREAM ON TABLE stg.STG_ORDER;
CREATE OR REPLACE STREAM STG_PRODUCT_STREAM ON TABLE stg.STG_PRODUCT;

/*CREATE OR REPLACE TASK LOAD_HUB_CUSTOMER
WAREHOUSE = MY_WH
SCHEDULE = '1 MINUTE'
AS
INSERT INTO HUB_CUSTOMER (HK_CUSTOMER, BK_CUSTOMER, LOAD_DATE, RECORD_SOURCE)
SELECT DISTINCT
    MD5(BK_CUSTOMER || RECORD_SOURCE) AS HK_CUSTOMER,
    BK_CUSTOMER,
    CURRENT_TIMESTAMP,
    RECORD_SOURCE
FROM STG_CUSTOMER_STREAM
WHERE METADATA$ACTION = 'INSERT'
  AND BK_CUSTOMER IS NOT NULL;

CREATE OR REPLACE TASK LOAD_HUB_ORDER
WAREHOUSE = MY_WH
SCHEDULE = '1 MINUTE'
AS
INSERT INTO HUB_ORDER (HK_ORDER, BK_ORDER, LOAD_DATE, RECORD_SOURCE)
SELECT DISTINCT
    MD5(BK_ORDER || RECORD_SOURCE) AS HK_ORDER,
    BK_ORDER,
    CURRENT_TIMESTAMP,
    RECORD_SOURCE
FROM STG_ORDER_STREAM
WHERE METADATA$ACTION = 'INSERT'
  AND BK_ORDER IS NOT NULL;

CREATE OR REPLACE TASK LOAD_HUB_PRODUCT
WAREHOUSE = MY_WH
SCHEDULE = '1 MINUTE'
AS
INSERT INTO HUB_PRODUCT (HK_PRODUCT, BK_PRODUCT, LOAD_DATE, RECORD_SOURCE)
SELECT DISTINCT
    MD5(BK_PRODUCT || RECORD_SOURCE) AS HK_PRODUCT,
    BK_PRODUCT,
    CURRENT_TIMESTAMP,
    RECORD_SOURCE
FROM STG_PRODUCT_STREAM
WHERE METADATA$ACTION = 'INSERT'
  AND BK_PRODUCT IS NOT NULL; */

CREATE OR REPLACE PROCEDURE SP_LOAD_HUB_CUSTOMER()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
try {
    var sql_command = `
        MERGE INTO HUB_CUSTOMER AS hub
        USING (
            SELECT DISTINCT
                MD5(BK_CUSTOMER || RECORD_SOURCE) AS HK_CUSTOMER,
                BK_CUSTOMER,
                CURRENT_TIMESTAMP AS LOAD_DATE,
                RECORD_SOURCE
            FROM STG_CUSTOMER_STREAM
            WHERE METADATA$ACTION = 'INSERT'
              AND BK_CUSTOMER IS NOT NULL
        ) AS src
        ON hub.HK_CUSTOMER = src.HK_CUSTOMER
        WHEN NOT MATCHED THEN
            INSERT (HK_CUSTOMER, BK_CUSTOMER, LOAD_DATE, RECORD_SOURCE)
            VALUES (src.HK_CUSTOMER, src.BK_CUSTOMER, src.LOAD_DATE, src.RECORD_SOURCE);
    `;
    
    snowflake.execute({sqlText: sql_command});
    return "HUB_CUSTOMER merge completed successfully";
} catch (err) {
    return "Error in HUB_CUSTOMER merge: " + err.message;
}
$$;

CREATE OR REPLACE PROCEDURE SP_LOAD_HUB_ORDER()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
try {
    var sql_command = `
        MERGE INTO HUB_ORDER AS hub
        USING (
            SELECT DISTINCT
                MD5(BK_ORDER || RECORD_SOURCE) AS HK_ORDER,
                BK_ORDER,
                CURRENT_TIMESTAMP AS LOAD_DATE,
                RECORD_SOURCE
            FROM STG_ORDER_STREAM
            WHERE METADATA$ACTION = 'INSERT'
              AND BK_ORDER IS NOT NULL
        ) AS src
        ON hub.HK_ORDER = src.HK_ORDER
        WHEN NOT MATCHED THEN
            INSERT (HK_ORDER, BK_ORDER, LOAD_DATE, RECORD_SOURCE)
            VALUES (src.HK_ORDER, src.BK_ORDER, src.LOAD_DATE, src.RECORD_SOURCE);
    `;
    
    snowflake.execute({sqlText: sql_command});
    return "HUB_ORDER merge completed successfully";
} catch (err) {
    return "Error in HUB_ORDER merge: " + err.message;
}
$$;

CREATE OR REPLACE PROCEDURE SP_LOAD_HUB_PRODUCT()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
try {
    var sql_command = `
        MERGE INTO HUB_PRODUCT AS hub
        USING (
            SELECT DISTINCT
                MD5(BK_PRODUCT || RECORD_SOURCE) AS HK_PRODUCT,
                BK_PRODUCT,
                CURRENT_TIMESTAMP AS LOAD_DATE,
                RECORD_SOURCE
            FROM STG_PRODUCT_STREAM
            WHERE METADATA$ACTION = 'INSERT'
              AND BK_PRODUCT IS NOT NULL
        ) AS src
        ON hub.HK_PRODUCT = src.HK_PRODUCT
        WHEN NOT MATCHED THEN
            INSERT (HK_PRODUCT, BK_PRODUCT, LOAD_DATE, RECORD_SOURCE)
            VALUES (src.HK_PRODUCT, src.BK_PRODUCT, src.LOAD_DATE, src.RECORD_SOURCE);
    `;
    
    snowflake.execute({sqlText: sql_command});
    return "HUB_PRODUCT merge completed successfully";
} catch (err) {
    return "Error in HUB_PRODUCT merge: " + err.message;
}
$$;

CREATE OR REPLACE TASK TASK_LOAD_HUBS
WAREHOUSE = compute_wh
SCHEDULE = '1 MINUTE'
AS
CALL SP_LOAD_HUB_CUSTOMER();
CALL SP_LOAD_HUB_ORDER();
CALL SP_LOAD_HUB_PRODUCT(); 
desc task TASK_LOAD_HUBS;

drop task TASK_LOAD_HUBS;



CREATE OR REPLACE TABLE HUB_CUSTOMER (
    HK_CUSTOMER STRING NOT NULL,          -- Surrogate hash key (MD5 of BK + source)
    BK_CUSTOMER STRING NOT NULL,          -- Business key (e.g., CustomerID)
    LOAD_DATE TIMESTAMP_NTZ NOT NULL,     -- When the record was first loaded
    RECORD_SOURCE STRING NOT NULL         -- Source system identifier
);

CREATE OR REPLACE TABLE HUB_ORDER (
    HK_ORDER STRING NOT NULL,             -- Surrogate hash key (MD5 of BK + source)
    BK_ORDER STRING NOT NULL,             -- Business key (e.g., OrderID)
    LOAD_DATE TIMESTAMP_NTZ NOT NULL,     -- When the record was first loaded
    RECORD_SOURCE STRING NOT NULL         -- Source system identifier
);

CREATE OR REPLACE TABLE HUB_PRODUCT (
    HK_PRODUCT STRING NOT NULL,           -- Surrogate hash key (MD5 of BK + source)
    BK_PRODUCT STRING NOT NULL,           -- Business key (e.g., ProductID)
    LOAD_DATE TIMESTAMP_NTZ NOT NULL,     -- When the record was first loaded
    RECORD_SOURCE STRING NOT NULL         -- Source system identifier
);

CALL SP_LOAD_HUB_CUSTOMER();
 CALL SP_LOAD_HUB_ORDER(); 
 CALL SP_LOAD_HUB_PRODUCT();

 INSERT INTO stg.STG_CUSTOMER (BK_CUSTOMER, CUSTOMER_NAME, EMAIL, ADDRESS, RECORD_SOURCE)
VALUES
('CUST001', 'Alice Johnson', 'alice.johnson@example.com', '123 Main St, Hyderabad', 'CRM'),
('CUST002', 'Bob Smith', 'bob.smith@example.com', '456 Park Ave, Bangalore', 'CRM'),
('CUST003', 'Charlie Patel', 'charlie.patel@example.com', '789 Lake Rd, Chennai', 'CRM');

INSERT INTO stg.STG_ORDER (BK_ORDER, CUSTOMER_ID, ORDER_DATE, RECORD_SOURCE)
VALUES
('ORD1001', 'CUST001', '2025-12-01', 'ERP'),
('ORD1002', 'CUST002', '2025-12-05', 'ERP'),
('ORD1003', 'CUST003', '2025-12-10', 'ERP');

INSERT INTO stg.STG_PRODUCT (BK_PRODUCT, PRODUCT_NAME, CATEGORY, RECORD_SOURCE)
VALUES
('PROD01', 'Laptop', 'Electronics', 'ERP'),
('PROD02', 'Mobile Phone', 'Electronics', 'ERP'),
('PROD03', 'Office Chair', 'Furniture', 'ERP');

select current_schema();

Select * from HUB_CUSTOMER;
Select * from HUB_ORDER;
SELECT * FROM HUB_PRODUCT;


CREATE OR REPLACE TABLE SAT_CUSTOMER_DETAILS (
    HK_CUSTOMER STRING NOT NULL,          -- Foreign key to HUB_CUSTOMER
    HASH_DIFF STRING NOT NULL,            -- Hash of descriptive attributes for change detection
    CUSTOMER_NAME STRING,
    EMAIL STRING,
    ADDRESS STRING,
    LOAD_DATE TIMESTAMP_NTZ NOT NULL,     -- When the record was loaded
    RECORD_SOURCE STRING NOT NULL         -- Source system identifier
);


CREATE OR REPLACE TABLE SAT_ORDER_HEADER (
    HK_ORDER STRING NOT NULL,             -- Foreign key to HUB_ORDER
    HASH_DIFF STRING NOT NULL,            -- Hash of descriptive attributes
    ORDER_DATE DATE,
    ORDER_STATUS STRING,
    ORDER_CHANNEL STRING,
    ORDER_TOTAL NUMBER(10,2),
    LOAD_DATE TIMESTAMP_NTZ NOT NULL,
    RECORD_SOURCE STRING NOT NULL
);

CREATE OR REPLACE TABLE SAT_PRODUCT_DETAILS (
    HK_PRODUCT STRING NOT NULL,           -- Foreign key to HUB_PRODUCT
    HASH_DIFF STRING NOT NULL,            -- Hash of descriptive attributes
    PRODUCT_NAME STRING,
    CATEGORY STRING,
    ATTRIBUTES VARIANT,                   -- Flexible JSON column for extra attributes
    LOAD_DATE TIMESTAMP_NTZ NOT NULL,
    RECORD_SOURCE STRING NOT NULL
);

select current_schema();
show streams;