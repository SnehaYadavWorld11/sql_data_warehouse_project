-- =============================================================================
-- CHANGES OVER TIME ANALYSIS (MEASURE BY DATE DIMENSION)
-- Purpose: Analyze sales performance and trends across different time periods
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query 1: Daily Sales Data
-- Purpose: View raw daily sales transactions for detailed analysis
-- -----------------------------------------------------------------------------
SELECT 
    order_date,
    sales_amount
FROM gold.fact_sales;

-- -----------------------------------------------------------------------------
-- Query 2: Annual Sales Performance
-- Purpose: Analyze yearly trends in sales, customer count, and quantity sold
-- -----------------------------------------------------------------------------
SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date);

-- -----------------------------------------------------------------------------
-- Query 3: Monthly Sales Performance
-- Purpose: Analyze monthly trends across different years
-- -----------------------------------------------------------------------------
SELECT
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY MONTH(order_date);
