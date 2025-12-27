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