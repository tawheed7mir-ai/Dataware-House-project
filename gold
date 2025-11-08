/* ---------------------------------------------------------------------------
   Project: Retail Data Warehouse (CRM + ERP Integration)
   Layer: Gold Layer (Star Schema)
   Description:
       The Gold Layer represents the **consumption layer** of the Data Warehouse.
       Data here is clean, standardized, and modeled in a **Star Schema** for
       analytical and reporting purposes.

       - Dimension Tables: Store descriptive attributes
       - Fact Tables: Store business transactions with foreign keys
---------------------------------------------------------------------------- */

/* ===========================================================================
   DIMENSION TABLE: dim_customers
   ---------------------------------------------------------------------------
   Purpose:
       Creates a unified customer dimension combining CRM and ERP sources.
       Standardizes personal, demographic, and geographic data.
   =========================================================================== */

CREATE VIEW gold.dim_customers AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    ci.cst_gndr AS gender,
    ci.cst_create_date AS create_date,
    ca.bdate AS birthdate
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;


/* ===========================================================================
   DIMENSION TABLE: dim_products
   ---------------------------------------------------------------------------
   Purpose:
       Product dimension integrating CRM product info with ERP product categories.
       Includes category, subcategory, cost, and product lifecycle details.
   =========================================================================== */

CREATE VIEW gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_ct_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;  -- Exclude historical product versions


/* ===========================================================================
   FACT TABLE: fact_sales
   ---------------------------------------------------------------------------
   Purpose:
       Central fact table capturing all sales transactions.
       Links to dimension tables for detailed analytics and reporting.
   =========================================================================== */

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;

