-- =============================================================================
-- RANK MEASURE (DIMENSION BY MEASURE)
-- Purpose: Identify top-performing products based on revenue generation
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query: Top 5 Highest Revenue Generating Products
-- Purpose: Identify which specific products contribute most to overall revenue
-- This helps in inventory planning, marketing focus, and product strategy
-- -----------------------------------------------------------------------------
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;
