-- =============================================================================
-- MAGNITUDE ANALYSIS (MEASURE BY DIMENSION)
-- Purpose: Analyze business metrics across different dimensions and categories
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query 1: Customer Distribution by Country
-- Purpose: Understand geographic distribution of customer base
-- -----------------------------------------------------------------------------
SELECT
    country,
    COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY country 
ORDER BY total_customer DESC;

-- -----------------------------------------------------------------------------
-- Query 2: Customer Distribution by Gender
-- Purpose: Analyze gender distribution of customer base
-- -----------------------------------------------------------------------------
SELECT 
    gender,
    COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY gender;

-- -----------------------------------------------------------------------------
-- Query 3: Product Count by Category
-- Purpose: Understand product variety across different categories
-- -----------------------------------------------------------------------------
SELECT 
    category,
    COUNT(product_key) AS total_product
FROM gold.dim_products
GROUP BY category;

-- -----------------------------------------------------------------------------
-- Query 4: Average Cost by Product Category
-- Purpose: Analyze cost structure across different product categories
-- -----------------------------------------------------------------------------
SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- -----------------------------------------------------------------------------
-- Query 5: Total Revenue by Product Category
-- Purpose: Identify highest revenue-generating categories
-- -----------------------------------------------------------------------------
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;
