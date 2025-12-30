-- =====================================================
-- CUSTOMERS CLEANING
-- =====================================================

-- CUST_01 Null Emails → Guest
UPDATE customers_clean SET email = 'Guest' WHERE email IS NULL;

-- CUST_02 '???' Gender → Other
UPDATE customers_clean SET gender = 'Other' WHERE gender = '???';

-- =====================================================
-- PRODUCTS CLEANING
-- =====================================================

-- PROD_01 Null color → Unknown
UPDATE products_clean SET color = 'Unknown' WHERE color IS NULL;

-- PROD_02 '???' Category → Unknown
UPDATE products_clean
SET
    category = 'Unknown'
WHERE
    category = '???';

-- PROD_03 Flag loss-making products (cost > list)
ALTER TABLE products_clean
ADD COLUMN IF NOT EXISTS is_loss_making BOOLEAN;

UPDATE products_clean
SET
    is_loss_making = TRUE
WHERE
    cost_price::NUMERIC > list_price::NUMERIC;

UPDATE products_clean
SET
    is_loss_making = FALSE
WHERE
    is_loss_making IS NULL;

-- =====================================================
-- SALES CLEANING
-- =====================================================

-- SALE_01 Remove guest sales
DELETE FROM sales_clean WHERE customer_id IS NULL;

-- SALE_02 Infer missing discounts using median per product/store/date
WITH
    discount_medians AS (
        SELECT
            product_id,
            store_id,
            date,
            PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY discount::NUMERIC
            ) AS median_discount
        FROM sales_clean
        WHERE
            discount IS NOT NULL
        GROUP BY
            product_id,
            store_id,
            date
    )
UPDATE sales_clean s
SET
    discount = dm.median_discount::TEXT
FROM discount_medians dm
WHERE
    s.discount IS NULL
    AND s.product_id = dm.product_id
    AND s.store_id = dm.store_id
    AND s.date = dm.date;

-- Fallback: no peer discount → 0
UPDATE sales_clean SET discount = '0' WHERE discount IS NULL;

-- =====================================================
-- CROSS TABLE CLEANING
-- =====================================================

-- Remove orphan product sales
DELETE FROM sales_clean WHERE product_id = 'P999999';

-- Remove orphan store sales
DELETE FROM sales_clean WHERE store_id = 'S999';

-- =====================================================
-- FINAL TABLE CONSTRAINTS (POST-CLEANING)
-- =====================================================

-- ======================
-- CUSTOMERS CONSTRAINTS
-- ======================

ALTER TABLE customers_clean
ALTER COLUMN customer_id
SET NOT NULL,
ALTER COLUMN age
SET NOT NULL,
ALTER COLUMN gender
SET NOT NULL,
ALTER COLUMN city
SET NOT NULL;

ALTER TABLE customers_clean
ADD CONSTRAINT customers_clean_pk PRIMARY KEY (customer_id);

-- ======================
-- PRODUCTS CONSTRAINTS
-- ======================

ALTER TABLE products_clean
ALTER COLUMN product_id
SET NOT NULL,
ALTER COLUMN category
SET NOT NULL,
ALTER COLUMN color
SET NOT NULL,
ALTER COLUMN size
SET NOT NULL,
ALTER COLUMN season
SET NOT NULL,
ALTER COLUMN supplier
SET NOT NULL,
ALTER COLUMN cost_price
SET NOT NULL,
ALTER COLUMN list_price
SET NOT NULL,
ALTER COLUMN is_loss_making
SET NOT NULL;

ALTER TABLE products_clean
ADD CONSTRAINT products_clean_pk PRIMARY KEY (product_id);

-- ======================
-- STORES CONSTRAINTS
-- ======================

ALTER TABLE stores_clean
ALTER COLUMN store_id
SET NOT NULL,
ALTER COLUMN store_name
SET NOT NULL,
ALTER COLUMN region
SET NOT NULL,
ALTER COLUMN store_size_m2
SET NOT NULL;

ALTER TABLE stores_clean
ADD CONSTRAINT stores_clean_pk PRIMARY KEY (store_id);

-- ======================
-- SALES CONSTRAINTS
-- ======================

-- Cast discount now that NULLs are resolved
ALTER TABLE sales_clean
ALTER COLUMN discount TYPE NUMERIC USING discount::NUMERIC;

ALTER TABLE sales_clean
ALTER COLUMN transaction_id
SET NOT NULL,
ALTER COLUMN date
SET NOT NULL,
ALTER COLUMN product_id
SET NOT NULL,
ALTER COLUMN store_id
SET NOT NULL,
ALTER COLUMN customer_id
SET NOT NULL,
ALTER COLUMN quantity
SET NOT NULL,
ALTER COLUMN discount
SET NOT NULL,
ALTER COLUMN returned
SET NOT NULL;

ALTER TABLE sales_clean
ADD CONSTRAINT sales_clean_pk PRIMARY KEY (transaction_id);

-- ======================
-- FOREIGN KEY CONSTRAINTS
-- ======================

ALTER TABLE sales_clean
ADD CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES customers_clean (customer_id);

ALTER TABLE sales_clean
ADD CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES products_clean (product_id);

ALTER TABLE sales_clean
ADD CONSTRAINT fk_sales_store FOREIGN KEY (store_id) REFERENCES stores_clean (store_id);