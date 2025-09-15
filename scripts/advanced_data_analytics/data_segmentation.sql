-- =============================================================================
-- DATA SEGMENTATION (MEASURE BY MEASURE)
-- Purpose: Segment products into cost ranges and analyze distribution
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query: Product Segmentation by Cost Ranges
-- Purpose: Categorize products into different price segments and count
-- how many products fall into each cost range for inventory analysis
-- -----------------------------------------------------------------------------
WITH product_segments AS
(
    SELECT 
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products 
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;
