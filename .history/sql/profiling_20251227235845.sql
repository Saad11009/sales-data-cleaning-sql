-- =====================================================
-- CUSTOMERS_RAW PROFILING
-- =====================================================

SELECT * FROM customers_raw LIMIT 10;

SELECT COUNT(*) FROM customers_raw;

-- ======================
-- STEP - 1: Null Checks
-- ======================

SELECT COUNT(*) FROM customers_raw WHERE customer_id IS NULL;
-- No NULLs

SELECT COUNT(*) FROM customers_raw WHERE age IS NULL;
-- No NULLs

SELECT COUNT(*) FROM customers_raw WHERE gender IS NULL;
-- No NULLs

SELECT COUNT(*) FROM customers_raw WHERE location IS NULL;
-- No NULLs

SELECT COUNT(*) FROM customers_raw WHERE email IS NULL;
-- 496 NULL values

-- ===========================
-- STEP - 2: Duplication Check
-- ===========================

-- The two columns that should be unique are customer_id and email

SELECT customer_id, COUNT(*)
FROM customers_raw
GROUP BY
    customer_id
HAVING
    COUNT(*) > 1;

SELECT email, COUNT(*)
FROM customers_raw
GROUP BY
    email
HAVING
    COUNT(*) > 1;

-- Customer identifiers are unique.
-- Email contains missing values and cannot be used as a unique identifier.
-- Email will be retained as an optional attribute.

-- ===========================
-- STEP - 3: Data Sanity Checks
-- ===========================

SELECT customer_id
FROM customers_raw
WHERE
    customer_id IS NOT NULL
    AND customer_id !~ '^C[0-9]{6}$';
-- All customer_id values conform to the expected format

SELECT MIN(age) AS min_age, MAX(age) AS max_age FROM customers_raw;
-- Min age = 16, Max age = 69 (within reasonable bounds)

SELECT gender, COUNT(*) FROM customers_raw GROUP BY gender;
-- 298 rows have gender = '???' → classify as 'Other' during cleaning

SELECT location, COUNT(*) FROM customers_raw GROUP BY location;

SELECT email
FROM customers_raw
WHERE
    email IS NOT NULL
    AND email !~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';
-- All non-NULL emails follow a valid format

-- =====================================================
-- PRODUCTS_RAW PROFILING
-- =====================================================

SELECT * FROM products_raw LIMIT 10;

SELECT COUNT(*) FROM products_raw;
-- 50,000 rows

-- ======================
-- STEP - 1: Null Checks
-- ======================

SELECT COUNT(*) FROM products_raw WHERE product_id IS NULL;
-- No NULLs

SELECT COUNT(*) FROM products_raw WHERE category IS NULL;
-- No NULLs

SELECT COUNT(*) FROM products_raw WHERE color IS NULL;
-- 990 NULL values

SELECT COUNT(*) FROM products_raw WHERE size IS NULL;
-- No NULLs

SELECT COUNT(*) FROM products_raw WHERE season IS NULL;
-- No NULLs

SELECT COUNT(*) FROM products_raw WHERE supplier IS NULL;
-- No NULLs

SELECT COUNT(*) FROM products_raw WHERE cost_price IS NULL;
-- No NULLs

SELECT COUNT(*) FROM products_raw WHERE list_price IS NULL;
-- No NULLs

-- ===========================
-- STEP - 2: Duplication Check
-- ===========================

SELECT product_id, COUNT(*)
FROM products_raw
GROUP BY
    product_id
HAVING
    COUNT(*) > 1;
-- All product_id values are unique

-- ===============================
-- STEP - 3: Data Sanity Checks
-- ===============================

SELECT product_id
FROM products_raw
WHERE
    product_id !~ '^P[0-9]{6}$';
-- All product_id values follow the expected format

SELECT category, COUNT(*) FROM products_raw GROUP BY category;
-- 499 entries with category = '???'

SELECT color, COUNT(*) FROM products_raw GROUP BY color;
-- 990 NULL values

SELECT size, COUNT(*) FROM products_raw GROUP BY size;
-- All products have sizes

SELECT season, COUNT(*) FROM products_raw GROUP BY season;
-- All products have seasons

SELECT
    MIN(cost_price) AS min_cost_price,
    MAX(cost_price) AS max_cost_price,
    MIN(list_price) AS min_list_price,
    MAX(list_price) AS max_list_price
FROM products_raw;
-- No negative prices or extreme outliers

SELECT COUNT(*)
FROM products_raw
WHERE
    color IS NULL
    AND category = '???';
-- 11 products poorly described but still valid

-- ===============================
-- STEP - 4: Logic Tests
-- ===============================

SELECT COUNT(*) FROM products_raw WHERE cost_price > list_price;
-- 8,582 products (17%) where cost_price > list_price
-- Too prevalent to correct → will be flagged in cleaning phase

-- =====================================================
-- STORES_RAW PROFILING
-- =====================================================

SELECT * FROM stores_raw LIMIT 10;

-- ======================
-- STEP - 0: Row Count
-- ======================

SELECT COUNT(*) FROM stores_raw;
-- 5 rows

-- ======================
-- STEP - 1: Null Checks
-- ======================

SELECT COUNT(*) FROM stores_raw WHERE store_id IS NULL;
-- No NULLs

SELECT COUNT(*) FROM stores_raw WHERE store_name IS NULL;
-- No NULLs

SELECT COUNT(*) FROM stores_raw WHERE region IS NULL;
-- No NULLs

SELECT COUNT(*) FROM stores_raw WHERE store_size_m2 IS NULL;
-- No NULLs

-- ===========================
-- STEP - 2: Duplication Check
-- ===========================

SELECT store_id, COUNT(*)
FROM stores_raw
GROUP BY
    store_id
HAVING
    COUNT(*) > 1;
-- All store_id values are unique

-- ===========================
-- STEP - 3: Data Sanity Checks
-- ===========================

SELECT * FROM stores_raw WHERE store_size_m2 < 0;
-- No negative store sizes

SELECT
    MIN(store_size_m2) AS min_store_size,
    MAX(store_size_m2) AS max_store_size
FROM stores_raw;
-- Store sizes within reasonable bounds

-- =====================================================
-- SALES_RAW PROFILING
-- =====================================================

SELECT * FROM sales_raw LIMIT 10;

SELECT COUNT(*) FROM sales_raw;
-- 50,000 rows

-- ======================
-- STEP - 1: Null Checks
-- ======================

SELECT COUNT(*) FROM sales_raw WHERE transaction_id IS NULL;
-- No NULLs

SELECT COUNT(*) FROM sales_raw WHERE transaction_date IS NULL;
-- No NULLs

SELECT COUNT(*) FROM sales_raw WHERE product_id IS NULL;
-- No NULLs

SELECT COUNT(*) FROM sales_raw WHERE store_id IS NULL;
-- No NULLs

SELECT COUNT(*) FROM sales_raw WHERE customer_id IS NULL;
-- 1,844 NULL values (guest purchases)

SELECT COUNT(*) FROM sales_raw WHERE quantity IS NULL;
-- No NULLs

SELECT COUNT(*) FROM sales_raw WHERE discount IS NULL;
-- 2,583 NULL values (treated as no discount)

SELECT COUNT(*) FROM sales_raw WHERE returned IS NULL;
-- No NULLs

SELECT COUNT(*)
FROM sales_raw
WHERE
    customer_id IS NULL
    AND discount IS NULL;
-- 105 guest purchases with no discount

-- ======================
-- STEP - 2: Duplication Check
-- ======================

SELECT transaction_id, COUNT(*)
FROM sales_raw
GROUP BY
    transaction_id
HAVING
    COUNT(*) > 1;
-- No duplicate transactions

-- ======================
-- STEP - 3: Data Sanity Checks
-- ======================

SELECT * FROM sales_raw WHERE transaction_id !~ '^T[0-9]{7}$';
-- All transaction_id values follow the expected format

SELECT MIN(transaction_date), MAX(transaction_date) FROM sales_raw;
-- Sales data spans ~4 years

SELECT * FROM sales_raw WHERE product_id !~ '^P[0-9]{6}$';
-- All product_id values valid

SELECT *
FROM sales_raw
WHERE
    customer_id IS NOT NULL
    AND customer_id !~ '^C[0-9]{6}$';
-- All non-NULL customer_id values valid

SELECT MIN(quantity) AS min_quantity, MAX(quantity) AS max_quantity
FROM sales_raw;
-- No negative or unrealistic quantities

SELECT MIN(discount) AS min_discount, MAX(discount) AS max_discount
FROM sales_raw;
-- Discounts within logical bounds

SELECT MIN(returned) AS min_returned, MAX(returned) AS max_returned
FROM sales_raw;
-- Returned quantities within logical bounds

-- =====================================================
-- CROSS-TABLE INTEGRITY VALIDATION
-- =====================================================
-- Purpose:
-- Validate referential integrity between fact (sales)
-- and dimension tables prior to cleaning.
-- No data is modified in this section.

-- =====================================================
-- SALES → CUSTOMERS REFERENCE CHECK
-- =====================================================

SELECT COUNT(*) AS orphaned_customer_sales
FROM sales_raw s
WHERE
    s.customer_id IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM customers_raw c
        WHERE
            c.customer_id = s.customer_id
    );
-- Result: 0
-- All non-NULL customer_id values in sales_raw
-- correctly reference existing customers.
-- Guest purchases (NULL customer_id) are valid and excluded.

-- =====================================================
-- SALES → PRODUCTS REFERENCE CHECK
-- =====================================================

SELECT s.product_id, COUNT(*) AS affected_sales_count
FROM sales_raw s
WHERE
    s.product_id IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM products_raw p
        WHERE
            p.product_id = s.product_id
    )
GROUP BY
    s.product_id;
-- Result:
-- Product ID 'P999999' does not exist in products_raw
-- and appears in 200 sales records.
-- Indicates orphaned product references.

-- =====================================================
-- SALES → STORES REFERENCE CHECK
-- =====================================================

SELECT s.store_id, COUNT(*) AS affected_sales_count
FROM sales_raw s
WHERE
    s.store_id IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM stores_raw st
        WHERE
            st.store_id = s.store_id
    )
GROUP BY
    s.store_id;
-- Result:
-- Store ID 'S999' does not exist in stores_raw
-- and appears in 200 sales records.
-- Indicates orphaned store references.

-- =====================================================
-- ANOMALY VERIFICATION (DRILL-DOWN)
-- =====================================================

SELECT *
FROM sales_raw
WHERE
    store_id = 'S999'
    AND product_id = 'P999999';
-- Example transaction:
-- Transaction ID 'T0019535' references both an invalid
-- store ('S999') and an invalid product ('P999999'),
-- confirming a genuine referential integrity issue.