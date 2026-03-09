Declare
    tax_amt number(10,2) default 0.0;
    base_sal number(10,2) default 30000.0;
BEGIN
    LET g_sal number(10,2) := 1000000.00;
    LET tax_slab number(4,2) := 0.20;
    LET tax_sal number(10,2) := 0.00;

    IF(g_sal > base_sal) then
        tax_sal := (g_sal - base_sal);
        tax_amt := tax_sal * tax_slab;
    END IF;

    return tax_amt;
END;


CREATE OR REPLACE PROCEDURE CAL_TAX()
RETURNS FLOAT
LANGUAGE SQL
AS
$$
Declare
    tax_amt number(10,2) default 0.0;
    base_sal number(10,2) default 30000.0;
BEGIN
    LET g_sal number(10,2) := 1000000.00;
    LET tax_slab number(4,2) := 0.20;
    LET tax_sal number(10,2) := 0.00;

    IF(g_sal > base_sal) then
        tax_sal := (g_sal - base_sal);
        tax_amt := tax_sal * tax_slab;
    END IF;

    return tax_amt;
END;
$$;

SELECT CURRENT_SCHEMA();
USE SCHEMA SPS;
CALL CAL_TAX();

--WITHOUT DECLARE BLOCK
BEGIN
    LET g_sal number(10,2) := 1000000.00;
    LET tax_slab number(4,2) := 0.20;
    LET tax_sal number(10,2) := 0.00;
    LET tax_amt number(10,2) default 0.0;
    LET base_sal number(10,2) default 30000.0;

    IF(g_sal > base_sal) then
        tax_sal := (g_sal - base_sal);
        tax_amt := tax_sal * tax_slab;
    END IF;

    return tax_amt;
END;

BEGIN
    RETURN 'VENKAT';
END;


EXECUTE IMMEDIATE 
$$
BEGIN
    LET g_sal number(10,2) := 1000000.00;
    LET tax_slab number(4,2) := 0.20;
    LET tax_sal number(10,2) := 0.00;
    LET tax_amt number(10,2) default 0.0;
    LET base_sal number(10,2) default 30000.0;

    IF(g_sal > base_sal) then
        tax_sal := (g_sal - base_sal);
        tax_amt := tax_sal * tax_slab;
    END IF;

    return tax_amt;
END;
$$;