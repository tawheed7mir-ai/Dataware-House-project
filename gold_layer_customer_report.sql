/* 
==========================================================
                     CUSTOMER REPORT
==========================================================
Author: Towheed Qayoom
Layer: Gold Layer (Star Schema)
Description:
This report consolidates detailed customer-level insights 
based on transactional and dimensional data in the gold 
layer. It generates customer profiles, segmentation, 
lifespan metrics, revenue contribution, and behavioral KPIs.

----------------------------------------------------------
HIGHLIGHTS
----------------------------------------------------------
✔ Extracts customer identity details (name, age, ID)
✔ Computes customer segmentation (VIP, Regular, New)
✔ Calculates key customer KPIs:
   - Total Orders
   - Total Sales
   - Total Quantity Purchased
   - Total Unique Products Bought
   - Lifespan (months active)
   - Recency (months since last order)
   - Average Order Value
   - Average Monthly Spend
✔ Creates a unified customer report for dashboards, BI tools,
  and advanced analytics use cases.
==========================================================
*/

CREATE VIEW gold.report_customers AS 

-- STEP 1: Base transactional + customer info
WITH base_query AS (
    SELECT 
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,

        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE()) AS age

    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c 
           ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

-- STEP 2: Customer-level aggregations
customer_aggregations AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,

        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,

        MAX(order_date) AS last_order_date,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan

    FROM base_query
    GROUP BY 
        customer_key, customer_number,
        customer_name, age
)

-- STEP 3: Final report output
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age group segmentation
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+' 
    END AS age_group,

    -- Customer segment classification
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    last_order_date,
    TIMESTAMPDIFF(MONTH, last_order_date, CURDATE()) AS recency,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    -- Average order value
    CASE WHEN total_orders = 0 THEN 0
         ELSE ROUND(total_sales / total_orders) 
    END AS avg_order_value,

    -- Average monthly spend
    CASE WHEN lifespan = 0 THEN total_sales
         ELSE ROUND(total_sales / lifespan) 
    END AS avg_monthly_spend

FROM customer_aggregations;
