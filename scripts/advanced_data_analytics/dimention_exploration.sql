-- =============================================================================
-- DIMENSION EXPLORATION QUERIES
-- Purpose: To analyze and understand the structure and content of dimension tables
-- Dimension tables contain descriptive attributes and are used for filtering and grouping
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query 1: Explore Customer Geography
-- Purpose: Identify all unique countries where customers are located
-- This helps understand the geographic reach of the business
-- Result: Returns a list of distinct countries from the customers dimension table
-- -----------------------------------------------------------------------------
SELECT DISTINCT country
FROM gold.dim_customers;

-- -----------------------------------------------------------------------------
-- Query 2: Explore Product Categories
-- Purpose: Identify all unique product categories in the product catalog
-- This helps understand the breadth of product offerings
-- Result: Returns a list of distinct product categories
-- -----------------------------------------------------------------------------
SELECT DISTINCT category
FROM gold.dim_products;

-- -----------------------------------------------------------------------------
-- Query 3: Explore Complete Product Hierarchy
-- Purpose: Analyze the full product taxonomy structure (Category → Subcategory → Product)
-- This provides insights into product organization and variety across different levels
-- ORDER BY 1,2,3 ensures hierarchical sorting: first by category, then subcategory, then product
-- Result: Returns a comprehensive list of all product combinations with hierarchical sorting
-- -----------------------------------------------------------------------------
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY 1,2,3;
