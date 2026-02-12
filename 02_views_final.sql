-- ============================================================
-- SQL Pareto Analysis — Final Views Pipeline
-- File: 02_views_final.sql

-- Purpose:
-- Generates final Pareto metrics from previously created views, including cumulative customer percentages and revenue share.

-- This file produces the final analytical dataset used to determine how many customers generate 80% of total revenue.

-- Dependencies:
--   - Views created in 01_views.sql

-- Output:
--   Final Pareto analysis table with ranked customers and cumulative revenue percentages

-- SQL Dialect: BigQuery SQL
-- ============================================================

-- declare variable
DECLARE target_sales_pct FLOAT64 DEFAULT 0.80;


-- number of customers, cum_revenue, total_revenue, target_sales_percent,
-- target_sales, cum_sales_share, cum_pct, customers
SELECT
  MIN(cum_customers) AS number_of_customers,
  MIN(total_customers) AS total_customers,
  MIN(cum_revenue) AS cumulative_revenue,
  MIN(total_revenue) AS total_revenue,
  target_sales_pct * 100 AS target_sales_percent,
  MIN(total_revenue * target_sales_pct) AS target_sales,
  MIN(cum_sales_share) AS cum_sales_share,
  MIN(cum_pct_customers) AS cum_pct_customers
FROM `pareto-portfolio.paretoportfolio.sales_v4`
WHERE cum_sales_share >= target_sales_pct;