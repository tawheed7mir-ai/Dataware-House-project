
/********************************************************************************************
 🥉 BRONZE LAYER | RAW DATA INGESTION
 -------------------------------------------------------------------------------------------
 📌 Description:
   The Bronze Layer represents the *raw data storage zone* in the data warehouse.
   It ingests unprocessed data directly from source systems such as CRM or ERP platforms.
   This layer preserves data in its original form for traceability and audit purposes.

 📂 Purpose:
   - Store data exactly as received from the source system (no transformations).
   - Maintain data lineage for all downstream layers.
   - Act as a single source of truth for historical and raw data.

 ⚙️ Key Characteristics:
   - Minimal cleaning or formatting.
   - Schema mirrors the source data.
   - Used as the input for the Silver Layer (data cleansing and standardization).

 📑 Script Includes:
   - Database creation (bronze schema)
   - Table creation (e.g., crm_cust_info, crm_prd_info, crm_sales_details,bronze.erp_loc_a101,bronze.erp_cust_az12,bronze.erp_px_ct_g1v2)
   - Optional: Initial raw data inserts or data import instructions.

 🧠 Next Step:
   Data from Bronze → Silver Layer for cleaning and standardization.

 Author     : Tawheed Mir
 Database   : MySQL
 Layer Type : Bronze (Raw Zone)
******************************************************************************************* */

CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(100),
    cst_lastname VARCHAR(100),
    cst_marital_status VARCHAR(20),
    cst_gndr CHAR(50),
    cst_create_date DATE
);

CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost int,
    prd_line VARCHAR(100),
    prd_start_dt datetime,
    prd_end_dt datetime
);

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num varchar(100),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int,
    sls_sales int,
    sls_quantity INT,
    sls_price int
);
drop table bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(cid varchar(50),
cntry varchar(50));

create table bronze.erp_cust_az12(cid varchar(50),
bdate date,
gen varchar(40));

create table bronze.erp_px_ct_g1v2(
id varchar(50),
cat varchar(50),
subcat varchar(50),
maintenance varchar(50));




