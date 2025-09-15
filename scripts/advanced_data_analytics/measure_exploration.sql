-- =============================================================================
-- MEASURE EXPLORATION QUERIES
-- Purpose: To analyze key business metrics and performance indicators
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query 1: Total Sales Revenue
-- Purpose: Calculate the overall sales amount generated
-- -----------------------------------------------------------------------------
SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- -----------------------------------------------------------------------------
-- Query 2: Total Quantity Sold
-- Purpose: Calculate the total number of items sold
-- -----------------------------------------------------------------------------
SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- -----------------------------------------------------------------------------
-- Query 3: Average Selling Price
-- Purpose: Calculate the average price per item sold
-- -----------------------------------------------------------------------------
SELECT AVG(price) AS avg_selling_price
FROM gold.fact_sales;

-- -----------------------------------------------------------------------------
-- Query 4: Total Number of Orders
-- Purpose: Count all orders and distinct orders (handling potential duplicates)
-- -----------------------------------------------------------------------------
SELECT COUNT(order_number) AS total_orders
FROM gold.fact_sales;

SELECT COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- -----------------------------------------------------------------------------
-- Query 5: Total Number of Products
-- Purpose: Count all products and distinct products in the catalog
-- -----------------------------------------------------------------------------
SELECT COUNT(product_name) AS total_product
FROM gold.dim_products;

SELECT COUNT(DISTINCT product_name) AS total_product
FROM gold.dim_products;

-- -----------------------------------------------------------------------------
-- Query 6: Total Customer Count
-- Purpose: Count all customers in the database
-- -----------------------------------------------------------------------------
SELECT COUNT(customer_id) AS total_customer FROM gold.dim_customers;

-- -----------------------------------------------------------------------------
-- Query 7: Active Customer Count
-- Purpose: Count customers who have actually placed orders
-- -----------------------------------------------------------------------------
SELECT COUNT(customer_key) AS total_customer FROM gold.fact_sales;

SELECT COUNT(DISTINCT customer_key) AS total_customer FROM gold.fact_sales;

-- -----------------------------------------------------------------------------
-- Query 8: Business Performance Dashboard
-- Purpose: Generate a comprehensive report of all key business metrics
-- -----------------------------------------------------------------------------
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity Sold', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Selling Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products (Catalog)', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers (Database)', COUNT(customer_id) FROM gold.dim_customers
UNION ALL
SELECT 'Active Customers (Placed Orders)', COUNT(DISTINCT customer_key) FROM gold.fact_sales;
