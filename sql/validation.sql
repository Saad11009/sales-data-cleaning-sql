-- =====================================================
-- DATA CLEANING VALIDATION CHECKS
-- =====================================================
-- Purpose:
-- Validate that all cleaning rules have been correctly
-- applied across customers, products, sales, and
-- cross-table relationships.
-- =====================================================

-- =====================================================
-- CUSTOMERS VALIDATION
-- =====================================================

-- CUST_VAL_01: No NULL emails remain
SELECT COUNT(*) AS cust_null_email_count
FROM customers_clean
WHERE
    email IS NULL;

-- CUST_VAL_02: Guest email label applied
SELECT email, COUNT(*) AS email_count
FROM customers_clean
GROUP BY
    email
ORDER BY email_count DESC;

-- CUST_VAL_03: No invalid gender values remain
SELECT gender, COUNT(*) AS gender_count
FROM customers_clean
GROUP BY
    gender;

-- CUST_VAL_04: Customer ID format validation
SELECT COUNT(*) AS invalid_customer_ids
FROM customers_clean
WHERE
    customer_id !~ '^C[0-9]{6}$';

-- =====================================================
-- PRODUCTS VALIDATION
-- =====================================================

-- PROD_VAL_01: No NULL colors remain
SELECT COUNT(*) AS prod_null_color_count
FROM products_clean
WHERE
    color IS NULL;

-- PROD_VAL_02: No '???' categories remain
SELECT COUNT(*) AS prod_invalid_category_count
FROM products_clean
WHERE
    category = '???';

-- PROD_VAL_03: Loss-making flag completeness
SELECT is_loss_making, COUNT(*) AS product_count
FROM products_clean
GROUP BY
    is_loss_making;

-- PROD_VAL_04: Validate loss-making flag logic
SELECT COUNT(*) AS incorrect_loss_flags
FROM products_clean
WHERE (
        cost_price::NUMERIC > list_price::NUMERIC
        AND is_loss_making = FALSE
    )
    OR (
        cost_price::NUMERIC <= list_price::NUMERIC
        AND is_loss_making = TRUE
    );

-- =====================================================
-- SALES VALIDATION
-- =====================================================

-- SALE_VAL_01: No NULL customer IDs remain
SELECT COUNT(*) AS sales_null_customer_id
FROM sales_clean
WHERE
    customer_id IS NULL;

-- SALE_VAL_02: Orphan product sales removed
SELECT COUNT(*) AS orphan_product_sales
FROM sales_clean
WHERE
    product_id = 'P999999';

-- SALE_VAL_03: Orphan store sales removed
SELECT COUNT(*) AS orphan_store_sales
FROM sales_clean
WHERE
    store_id = 'S999';

-- SALE_VAL_04: No NULL discounts remain
SELECT COUNT(*) AS sales_null_discount
FROM sales_clean
WHERE
    discount IS NULL;

-- SALE_VAL_05: Discount numeric sanity check
SELECT MIN(discount::NUMERIC) AS min_discount, MAX(discount::NUMERIC) AS max_discount
FROM sales_clean;

-- =====================================================
-- CROSS-TABLE INTEGRITY VALIDATION
-- =====================================================

-- XREF_VAL_01: Sales → Customers
SELECT COUNT(*) AS orphan_customer_sales
FROM
    sales_clean s
    LEFT JOIN customers_clean c ON s.customer_id = c.customer_id
WHERE
    c.customer_id IS NULL;

-- XREF_VAL_02: Sales → Products
SELECT COUNT(*) AS orphan_product_sales
FROM
    sales_clean s
    LEFT JOIN products_clean p ON s.product_id = p.product_id
WHERE
    p.product_id IS NULL;

-- XREF_VAL_03: Sales → Stores
SELECT COUNT(*) AS orphan_store_sales
FROM
    sales_clean s
    LEFT JOIN stores_clean st ON s.store_id = st.store_id
WHERE
    st.store_id IS NULL;