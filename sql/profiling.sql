-- =====================================================
-- CUSTOMERS_RAW PROFILING
-- =====================================================

SELECT * FROM customers_raw LIMIT 10;

SELECT COUNT(*) FROM customers_raw

-- ======================
-- STEP - 1: Null Checks
-- ======================

SELECT COUNT(*) FROM customers_raw WHERE customer_id IS NULL;
-- No NULLs
SELECT COUNT(*) FROM customers_raw WHERE age IS NULL;
-- No NULLs
SELECT COUNT(*) FROM customers_raw WHERE gender IS NULL;
-- No Nulls
SELECT COUNT(*) FROM customers_raw WHERE location IS NULL;
-- No Nulls
SELECT COUNT(*) FROM customers_raw WHERE email IS NULL;
-- 496 NULL Valuse

-- ===========================
-- STEP - 2: Duplication Check
-- ===========================

-- The two columns that should be unique are customer_id and emaisl

SELECT customer_id, COUNT(*)
FROM customers_raw
GROUP BY
    customer_id
HAVING
    COUNT(*) > 1;

SELECT emaiL, COUNT(*)
FROM customers_raw
GROUP BY
    email
HAVING
    COUNT(*) > 1;

-- While customer identifiers are unique, the email field contains missing values and therefore cannot be used as a unique identifier. Email data will be retained but treated as an optional attribute.

-- ===========================
-- STEP - 3: Data Sanity Checks
-- ===========================

SELECT customer_id
FROM customers_raw
WHERE
    customer_id !~ '^C[0-9]{6}$';
-- All customer_id match the pattern

SELECT MIN(age) AS min_age, MAX(age) AS max_age FROM customers_raw;
-- Min age = 16 and Max age = 69, all ages are within a reasonable LIMIT

SELECT gender, COUNT(*) FROM customers_raw GROUP BY gender;
-- 298 rows have gender of '???', looking at document specification we can classifiy them as 'Other'

SELECT location, COUNT(*) FROM customers_raw GROUP BY location;

SELECT email
FROM customers_raw
WHERE
    email !~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
    AND email IS NOT NULL;
-- All emails are standerdised and follow the same pattern

-- =====================================================
-- PRODUCTS_RAW PROFILING
-- =====================================================

SELECT * FROM products_raw;

SELECT COUNT(*) FROM products_raw;
--50,000 rows of data

-- ======================
-- STEP - 1: Null Checks
-- ======================

SELECT COUNT(*) FROM products_raw WHERE product_id IS NULL;
-- No NULLs
SELECT COUNT(*) FROM products_raw WHERE category IS NULL;
-- No NULLs
SELECT COUNT(*) FROM products_raw WHERE color IS NULL;
-- 990 rows of NULL
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

-- The only value which I expect to be unique is product_id

SELECT product_id, COUNT(*)
FROM products_raw
GROUP BY
    product_id
HAVING
    COUNT(*) > 1;
-- All product_ids are unique