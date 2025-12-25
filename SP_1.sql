create or replace schema SPS;
use schema SPS;
CREATE OR REPLACE PROCEDURE SP_1()
returns FLOAT
language SQL
AS
$$
DECLARE 
    v_total_orders  NUMBER(10,2);
    v_total_amount  NUMBER(10,2);
    v_avg_amount    NUMBER(10,2);
BEGIN 
    SELECT COUNT(order_id)
    INTO :v_total_orders
    FROM orders;

    SELECT NVL(SUM(AMOUNT),0)
    INTO :v_total_amount
    FROM orders;

    IF (v_total_orders > 0) THEN
        v_avg_amount := v_total_amount / v_total_orders;
    END IF;

    RETURN  'Total Orders = ' || v_total_orders ||
            ', Total Amount = ' || v_total_amount ||
            ', Avg Amount = ' || v_avg_amount;
END;
$$;

CALL SP_1();