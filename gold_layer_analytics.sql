/* 
----------------------------------------------------------
 GOLD LAYER ANALYTICS - DATA WAREHOUSE PROJECT
 Author: Towheed Qayoom
 Description:
 This file contains all business KPIs, exploratory analysis,
 advanced analytics, customer segmentation, product
 segmentation, and time-series insights generated from 
 the star schema views in the gold layer of the data 
 warehouse.
----------------------------------------------------------
*/

----------------------------------------------------------
-- KEY BUSINESS METRICS
----------------------------------------------------------

-- Total items sold
SELECT SUM(quantity) AS total_sold  
FROM gold.fact_sales;

-- Average selling price
SELECT AVG(price) AS avg_price 
FROM gold.fact_sales;

-- Total number of orders
SELECT COUNT(DISTINCT order_number) AS total_orders 
FROM gold.fact_sales;

-- Total number of products
SELECT COUNT(DISTINCT product_name) AS total_products 
FROM gold.dim_products;

-- Total number of customers
SELECT COUNT(customer_key) AS total_customers 
FROM gold.dim_customers;

----------------------------------------------------------
-- SUMMARY METRICS REPORT
----------------------------------------------------------
SELECT 'total sales' AS measure_name, SUM(sales_amount) AS measure_value 
FROM gold.fact_sales
UNION ALL
SELECT 'average price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'total_orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'total_products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'total_customers', COUNT(customer_key) FROM gold.dim_customers;

----------------------------------------------------------
-- EXPLORATORY DATA ANALYSIS (EDA)
----------------------------------------------------------

-- Total customers by country
SELECT country, COUNT(customer_key) AS total_customers
FROM gold.dim_customers 
GROUP BY country
ORDER BY total_customers DESC;

-- Total products by category
SELECT category, COUNT(product_key) AS total_products
FROM gold.dim_products 
GROUP BY category
ORDER BY total_products DESC;

-- Total customers by gender
SELECT gender, COUNT(customer_key) AS total_customers
FROM gold.dim_customers 
GROUP BY gender
ORDER BY total_customers DESC;

-- Average product cost by category
SELECT category, AVG(cost) AS avg_cost
FROM gold.dim_products 
GROUP BY category
ORDER BY avg_cost DESC;

-- Total revenue by category
SELECT p.category, SUM(s.sales_amount) AS total_revenue
FROM gold.dim_products p 
JOIN gold.fact_sales s ON p.product_key = s.product_key
GROUP BY p.category;

-- Total revenue by each customer
SELECT 
 c.first_name,
 c.last_name,
 SUM(f.sales_amount) AS total_revenue
FROM gold.dim_customers c 
JOIN gold.fact_sales f ON c.customer_key = f.customer_key
GROUP BY c.first_name, c.last_name
ORDER BY total_revenue DESC;

-- Distribution of sold items across countries
SELECT 
 c.country,
 SUM(f.quantity) AS total_quantity
FROM gold.dim_customers c 
JOIN gold.fact_sales f ON c.customer_key = f.customer_key
GROUP BY c.country;

----------------------------------------------------------
-- ADVANCED ANALYSIS
----------------------------------------------------------

-- Monthly trend analysis
SELECT 
 YEAR(order_date) AS order_year,
 MONTH(order_date) AS order_month,
 SUM(sales_amount) AS total_sales,
 COUNT(customer_key) AS total_customers,
 SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- Cumulative monthly sales
SELECT 
 DATE_FORMAT(order_date,'%y-%m') AS months,
 SUM(sales_amount) AS total_sales_per_month,
 SUM(SUM(sales_amount)) OVER(ORDER BY DATE_FORMAT(order_date,'%y-%m')) AS cumulative_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date,'%y-%m')
ORDER BY DATE_FORMAT(order_date,'%y-%m');

----------------------------------------------------------
-- YEAR-OVER-YEAR PRODUCT PERFORMANCE
----------------------------------------------------------
WITH yearly_product_sales AS (
    SELECT 
     YEAR(f.order_date) AS order_year,
     p.product_name,
     SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE
