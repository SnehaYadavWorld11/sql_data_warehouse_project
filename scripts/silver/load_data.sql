DELIMITER $$

CREATE PROCEDURE silver.load_silver()
BEGIN
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT '==========================================' AS msg;
        SELECT 'ERROR OCCURRED DURING LOADING SILVER LAYER' AS msg;
        GET DIAGNOSTICS CONDITION 1
            @p1 = MESSAGE_TEXT;
        SELECT CONCAT('Error Message: ', @p1) AS msg;
        SELECT '==========================================' AS msg;
    END;

    SET batch_start_time = NOW();
    SELECT '================================================' AS msg;
    SELECT 'Loading Silver Layer' AS msg;
    SELECT '================================================' AS msg;

    -- CRM Tables
    SELECT '------------------------------------------------' AS msg;
    SELECT 'Processing CRM Tables' AS msg;
    SELECT '------------------------------------------------' AS msg;

    -- crm_cust_info
    SET start_time = NOW();
    TRUNCATE TABLE silver.crm_cust_info;
    INSERT INTO silver.crm_cust_info(
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT cst_id,
           cst_key,
           TRIM(cst_firstname) cst_firstname,
           TRIM(cst_lastname) cst_lastname,
           CASE 
                WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
                ELSE 'n/a'
            END cst_marital_status,
           CASE 
                WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
                WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
                ELSE 'n/a'
            END cst_gndr,
           cst_create_date
    FROM (
        SELECT *,
               RANK() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) ranking
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL 
    ) t WHERE ranking = 1;
    SET end_time = NOW();
    SELECT CONCAT('crm_cust_info Processing Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- crm_prd_info
    SET start_time = NOW();
    TRUNCATE TABLE silver.crm_prd_info;
    INSERT INTO silver.crm_prd_info(
           prd_id,
           cat_id,
           prd_key,
           prd_nm,
           prd_cost,
           prd_line,
           prd_start_dt,
           prd_end_dt
    )
    SELECT  prd_id,
            REPLACE(SUBSTRING(prd_key,1,5),'-','_') cat_id,
            SUBSTRING(prd_key,7,LENGTH(prd_key)) prd_key,
            prd_nm,
            IFNULL(prd_cost,0) prd_cost,
            CASE UPPER(TRIM(prd_line))
                WHEN 'M' THEN 'Mountain'
                WHEN 'S' THEN 'other Sales'
                WHEN 'R' THEN 'Road'
                WHEN 'T' THEN 'Touring'
                ELSE 'n/a' 
            END prd_line,
            CAST(prd_start_dt AS DATE) AS prd_start_dt,
            CAST(DATE_SUB(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY) AS DATE) AS prd_end_dt
    FROM bronze.crm_prd_info;
    SET end_time = NOW();
    SELECT CONCAT('crm_prd_info Processing Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- crm_sales_details
    SET start_time = NOW();
    TRUNCATE TABLE silver.crm_sales_details;
    INSERT INTO silver.crm_sales_details(
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE
            WHEN sls_order_dt=0 OR LENGTH(sls_order_dt)!=8 THEN NULL
            ELSE CAST(CAST(sls_order_dt AS CHAR(8)) AS DATE)
         END sls_order_dt,
        CASE
            WHEN sls_ship_dt=0 OR LENGTH(sls_ship_dt)!=8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS CHAR(8)) AS DATE)
         END sls_ship_dt,
        CASE
            WHEN sls_due_dt=0 OR LENGTH(sls_due_dt)!=8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS CHAR(8)) AS DATE)
         END sls_due_dt,
        CASE
            WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END sls_sales,
        sls_quantity,
        CASE 
            WHEN sls_price IS NULL OR sls_price<=0 THEN ROUND(sls_sales/NULLIF(sls_quantity,0),0)
            ELSE sls_price
        END sls_price
    FROM bronze.crm_sales_details;
    SET end_time = NOW();
    SELECT CONCAT('crm_sales_details Processing Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- ERP Tables
    SELECT '------------------------------------------------' AS msg;
    SELECT 'Processing ERP Tables' AS msg;
    SELECT '------------------------------------------------' AS msg;

    -- erp_cust_az12
    SET start_time = NOW();
    TRUNCATE TABLE silver.erp_cust_az12;
    INSERT INTO silver.erp_cust_az12(
        cid,
        bdate,
        gen
    )
    SELECT 
        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
            ELSE cid
        END cid,
        CASE 
            WHEN bdate > CURRENT_DATE() THEN NULL 
            ELSE bdate
        END bdate,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
            WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
            ELSE 'n/a'
        END gen
    FROM bronze.erp_cust_az12;
    SET end_time = NOW();
    SELECT CONCAT('erp_cust_az12 Processing Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- erp_loc_a101
    SET start_time = NOW();
    TRUNCATE TABLE silver.erp_loc_a101;
    INSERT INTO silver.erp_loc_a101(
        cid,
        cntry
    )
    SELECT
        CASE 
            WHEN cid LIKE 'AW%' THEN REPLACE(cid,'-','')
        END cid,
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN TRIM(cntry)='' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END cntry
    FROM bronze.erp_loc_a101;
    SET end_time = NOW();
    SELECT CONCAT('erp_loc_a101 Processing Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- erp_px_cat_g1v2
    SET start_time = NOW();
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    INSERT INTO silver.erp_px_cat_g1v2(
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT 
        id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_g1v2;
    SET end_time = NOW();
    SELECT CONCAT('erp_px_cat_g1v2 Processing Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS msg;

    -- Batch end
    SET batch_end_time = NOW();
    SELECT '==========================================' AS msg;
    SELECT 'Loading Silver Layer is Completed' AS msg;
    SELECT CONCAT('   - Total Processing Duration: ',
                  TIMESTAMPDIFF(SECOND, batch_start_time, batch_end_time), ' seconds') AS msg;
    SELECT '==========================================' AS msg;

END$$

DELIMITER ;

CALL silver.load_silver() ;
