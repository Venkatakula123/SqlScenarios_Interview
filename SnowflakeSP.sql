declare
    tax_amt number(10,2) DEFAULT 0.00;
    base_salary_slab number(10,2) DEFAULT 300000.00;
    
begin
    -- gross salary and tax percentage value
    LET gross_salary number(10,2) := 1000000.00;
    LET tax_slab number(3,2) := 0.20;
    
    -- taxable salaryto be calcualted
    LET taxable_salary number(10,2) := 0.00;
    
    -- salary calculation
    IF (gross_salary > base_salary_slab) THEN
        taxable_salary := (gross_salary-base_salary_slab);
        tax_amt := taxable_salary * tax_slab;
    END IF;

    RETURN tax_amt;
end;

--=====================================================================
declare 
    v_profit number(10,2) default  0.0;
    --v_cost number(10,2);
    v_revenue number(10,2) default 110.00;

begin 
    LET v_cost := 100.00;
        v_profit := v_revenue - v_cost;
        return v_profit;
END;

--=======================================================================
Select * from orders;

declare
    v_no number(10,2) := 10;
    v_factor number(10,2) default 2;
    v_result number default 0;
begin 
    v_factor :=10;
    v_result := v_no * v_factor;
    return v_result;
end;

--========================================================================
declare
    v_no number(10,2) := 10;
    v_factor number(10,2) default 2;
    v_result number default 0;
begin 
    --v_factor :=10;
    v_result := v_no * v_factor;
    return v_result;
end;
--==========================================================================

Select * from orders;

DECLARE 
    v_total_orders number(10,2);
    v_total_amount number(10,2);
    v_avg_amount number(10,2);
BEGIN 
    Select count(order_id) into :v_total_orders from orders;

    select NVL(SUM(AMOUNT),0) into :v_total_amount from orders;

    if (v_total_orders > 0) then
        v_avg_amount := v_total_amount / v_total_orders;
    end if;

    return  'Total Orders = ' || v_total_orders ||
            ', Total Amount = ' || v_total_amount ||
            ', Avg Amount = ' || v_avg_amount;
END;


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

--=======================================================================
begin
    -- gross salary and tax percentage value
    LET gross_salary number(10,2) := 1000000.00;
    LET tax_slab number(3,2) := 0.20;
    LET base_salary_slab number(12,2) := 20000.00;
    -- taxable salaryto be calcualted
    LET taxable_salary number(10,2) := 0.00;
    LET tax_amt number(12,2);
    
    -- salary calculation
    IF (gross_salary > base_salary_slab) THEN
        taxable_salary := (gross_salary-base_salary_slab);
        tax_amt := taxable_salary * tax_slab;
    END IF;

    RETURN tax_amt;
end;

--========================================================================
DECLARE
    base_salary_slab number(12,2) := 20000.00;
    tax_amt number(12,2);

begin
    -- gross salary and tax percentage value
    LET gross_salary number(10,2) := 1000000.00;
    LET tax_slab number(3,2) := 0.20;
    --LET base_salary_slab number(12,2) := 20000.00;
    -- taxable salaryto be calcualted
    LET taxable_salary number(10,2) := 0.00;
    --LET tax_amt number(12,2);
    
    -- salary calculation
    IF (gross_salary > base_salary_slab) THEN
        taxable_salary := (gross_salary-base_salary_slab);
        tax_amt := taxable_salary * tax_slab;
    END IF;

    RETURN tax_amt;
end;

--=========================================================================
