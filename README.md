🏪 Retail Data Warehouse Project (CRM + ERP Integration)
📘 Overview

This project demonstrates a complete Data Warehouse (DW) pipeline built in MySQL, integrating data from multiple source systems — CRM and ERP — into a structured Bronze–Silver–Gold architecture.

It follows best practices of data engineering and analytics to create a star schema model for easy business reporting and insights.

🧱 Architecture Layers
🥉 Bronze Layer – Raw Data Storage

Purpose:
Stores raw data ingested from multiple sources (CRM and ERP systems) without transformation.
Used only as the landing zone for source data.

Highlights:

Directly stores raw tables from CRM & ERP

No data cleaning or validation

Example tables:

bronze.crm_cust_info

bronze.crm_prd_info

bronze.crm_sales_details

bronze.erp_loc_a101

bronze.erp_cust_az12

bronze.erp_px_ct_g1v2

🥈 Silver Layer – Data Cleansing & Standardization

Purpose:
Cleans, validates, and standardizes data from the Bronze Layer.
This layer ensures all data is accurate, formatted, and business-ready.

Highlights:

Removed duplicates and invalid records

Standardized gender, country, and date formats

Derived accurate sales and pricing fields

Fixed nulls and invalid values

All data stored in new, clean tables within the Silver schema

Example transformations:

Trim and clean customer names

Convert integer dates into valid DATE format

Calculate missing or incorrect sales totals

Standardize product lines and categories

🥇 Gold Layer – Analytics & Reporting Layer

Purpose:
Implements a Star Schema model for analytics and BI dashboards.
Stores all data as SQL views based on the cleaned Silver Layer tables.

Highlights:

dim_customers → combines CRM + ERP customer data

dim_products → integrates CRM products with ERP categories

fact_sales → central fact table connecting sales with customers & products

Optimized for business intelligence, trend analysis, and reporting tools



              ┌────────────────────┐
              │   dim_customers     │
              └─────────┬───────────┘
                        │
                        │
   ┌──────────────┐     ▼     ┌──────────────┐
   │ dim_products  │──────────▶  fact_sales  │
   └──────────────┘           └──────────────┘

| Component       | Technology                 |
| --------------- | -------------------------- |
| Database        | MySQL                      |
| Data Model      | Star Schema                |
| Layers          | Bronze → Silver → Gold     |
| ETL Process     | SQL Transformation Scripts |
| Version Control | Git + GitHub               |
| Analytics       | SQL-based Data Exploration |


👤 Author

Tawheed Mir
💼 Aspiring Data Analyst & SQL Enthusiast
📊 Passionate about Data Modeling, Warehousing, and Analytics
🔗LinkedIn : https://linkedin.com/in/tawheed-mir-881009250
gitHub: https://github.com/tawheed7mir-ai


