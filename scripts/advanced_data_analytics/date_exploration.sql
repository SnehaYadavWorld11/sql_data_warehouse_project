-- =============================================================================
-- DATE EXPLORATION QUERIES
-- Purpose: To analyze temporal aspects of the data including order timelines and customer demographics
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query 1: Order Date Range Analysis
-- Purpose: Identify the complete timeframe of sales data available
-- Result: Returns the very first and last order dates in the fact_sales table
-- -----------------------------------------------------------------------------
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM gold.fact_sales;

-- -----------------------------------------------------------------------------
-- Query 2: Sales Data Duration Analysis  
-- Purpose: Calculate the total number of years covered by the sales data
-- Result: Returns date range and calculated year difference
-- -----------------------------------------------------------------------------
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    YEAR(MAX(order_date)) - YEAR(MIN(order_date)) AS year_diff
FROM gold.fact_sales;

-- -----------------------------------------------------------------------------
-- Query 3: Customer Birthdate Range Analysis
-- Purpose: Identify the age distribution range of customers
-- Result: Returns the oldest and youngest customer birthdates
-- -----------------------------------------------------------------------------
SELECT 
    MIN(birthdate) AS oldest_customer_birthdate,
    MAX(birthdate) AS youngest_customer_birthdate
FROM gold.dim_customers;

-- -----------------------------------------------------------------------------
-- Query 4: Customer Age Analysis
-- Purpose: Calculate actual ages of the oldest and youngest customers
-- Result: Returns birthdates and calculated ages for demographic analysis
-- -----------------------------------------------------------------------------
SELECT
    MIN(birthdate) AS oldest_customer_birthdate,
    YEAR(CURRENT_DATE()) - YEAR(MIN(birthdate)) AS oldest_customer_age,
    MAX(birthdate) AS youngest_customer_birthdate,
    YEAR(CURRENT_DATE()) - YEAR(MAX(birthdate)) AS youngest_customer_age
FROM gold.dim_customers;
