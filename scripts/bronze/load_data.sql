/*
===============================================================================
Stored Procedure: load_bronze (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `LOAD DATA INFILE` command to load data from CSV files into bronze tables.
Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.
Usage Example:
    CALL load_bronze();
===============================================================================
*/

USE bronze ;
DELIMITER $$

CREATE PROCEDURE load_bronze()
BEGIN
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT '==========================================' AS msg;
        SELECT 'ERROR OCCURRED DURING LOADING BRONZE LAYER' AS msg;
        GET DIAGNOSTICS CONDITION 1
            @p1 = MESSAGE_TEXT;
        SELECT CONCAT('Error Message: ', @p1) AS msg;
        SELECT '==========================================' AS msg;
    END;

    SET batch_start_time = NOW();
    SELECT '================================================' AS msg;
    SELECT 'Loading Bronze Layer' AS msg;
    SELECT '================================================' AS msg;

    -- CRM Tables
    SELECT '------------------------------------------------' AS msg;
    SELECT 'Loading CRM Tables' AS msg;
    SELECT '------------------------------------------------' AS msg;

    -- crm_cust_info
    SET start_time = NOW();
    TRUNCATE TABLE bronze.crm_cust_info;
    LOAD DATA INFILE 'D:/DWH/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    INTO TABLE bronze.crm_cust_info
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;
    SET end_time = NOW();
    SELECT CONCAT('crm_cust_info Load Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- crm_prd_info
    SET start_time = NOW();
    TRUNCATE TABLE bronze.crm_prd_info;
    LOAD DATA INFILE 'D:/DWH/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    INTO TABLE bronze.crm_prd_info
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;
    SET end_time = NOW();
    SELECT CONCAT('crm_prd_info Load Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- crm_sales_details
    SET start_time = NOW();
    TRUNCATE TABLE bronze.crm_sales_details;
    LOAD DATA INFILE 'D:/DWH/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    INTO TABLE bronze.crm_sales_details
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;
    SET end_time = NOW();
    SELECT CONCAT('crm_sales_details Load Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;


    -- ERP Tables
    SELECT '------------------------------------------------' AS msg;
    SELECT 'Loading ERP Tables' AS msg;
    SELECT '------------------------------------------------' AS msg;

    -- erp_loc_a101
    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_loc_a101;
    LOAD DATA INFILE 'D:/DWH/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
    INTO TABLE bronze.erp_loc_a101
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;
    SET end_time = NOW();
    SELECT CONCAT('erp_loc_a101 Load Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- erp_cust_az12
    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_cust_az12;
    LOAD DATA INFILE 'D:/DWH/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
    INTO TABLE bronze.erp_cust_az12
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;
    SET end_time = NOW();
    SELECT CONCAT('erp_cust_az12 Load Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- erp_px_cat_g1v2
    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    LOAD DATA INFILE 'D:/DWH/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
    INTO TABLE bronze.erp_px_cat_g1v2
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;
    SET end_time = NOW();
    SELECT CONCAT('erp_px_cat_g1v2 Load Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- Batch end
    SET batch_end_time = NOW();
    SELECT '==========================================' AS msg;
    SELECT 'Loading Bronze Layer is Completed' AS msg;
    SELECT CONCAT('   - Total Load Duration: ',
                  TIMESTAMPDIFF(SECOND, batch_start_time, batch_end_time), ' seconds') AS msg;
    SELECT '==========================================' AS msg;

END$$

DELIMITER ;

SELECT COUNT(*) FROM bronze.crm_cust_info;
SELECT COUNT(*) FROM bronze.crm_prd_info;
SELECT COUNT(*) FROM bronze.crm_sales_details;
SELECT COUNT(*) FROM bronze.erp_loc_a101;
SELECT COUNT(*) FROM bronze.erp_cust_az12;
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
