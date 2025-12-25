Use database MYDB;
use schema SPS;
Create or replace procedure calTax()
returns FLOAT
language SQL
AS
$$
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
$$;

CALL calTax();