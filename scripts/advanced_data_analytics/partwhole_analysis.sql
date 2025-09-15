-- =============================================================================
-- PART TO WHOLE ANALYSIS ((MEASURE/TOTAL MEASURE)*100) BY DIMENSION
-- Purpose: Analyze contribution of each category to overall sales
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query: Category Contribution to Overall Sales
-- Purpose: Identify which product categories contribute most to total revenue
-- and calculate their percentage share of total sales
-- -----------------------------------------------------------------------------
WITH category_sales AS(
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((total_sales/SUM(total_sales) OVER())*100,2),'%') AS percentage_of_total
FROM category_sales;
