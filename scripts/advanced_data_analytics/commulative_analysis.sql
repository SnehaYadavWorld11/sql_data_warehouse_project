-- =============================================================================
-- CUMULATIVE ANALYSIS (CUMULATIVE MEASURE BY DATE DIMENSION)
-- Purpose: Analyze running totals and moving averages over time
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query 1: Monthly Sales with Running Total
-- Purpose: Calculate cumulative sales total across months
-- -----------------------------------------------------------------------------
SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales
FROM(
    SELECT
        MONTH(order_date) AS order_date,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales 
    WHERE order_date IS NOT NULL
    GROUP BY MONTH(order_date)
) t;

-- -----------------------------------------------------------------------------
-- Query 2: Monthly Metrics with Running Totals and Averages
-- Purpose: Analyze cumulative sales and running average price by month
-- -----------------------------------------------------------------------------
SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_average
FROM(
    SELECT
        DATE_FORMAT(order_date,'%Y-%m-01') AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales 
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date,'%Y-%m-01')
) t;
