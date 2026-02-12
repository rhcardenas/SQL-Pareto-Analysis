-- ============================================================
-- SQL Pareto Analysis — CTE Implementation
-- File: 03_cte_pareto_analysis.sql

-- Purpose:
-- Performs a complete Pareto (80/20) revenue analysis using Common Table Expressions (CTEs) in a single query pipeline.

-- This implementation demonstrates:
--   - Revenue aggregation
--   - Customer ranking
--   - Window functions
--   - Cumulative revenue calculations
--   - Pareto threshold identification

-- Dependencies:
--   - pet_shop_sales table (CSV dataset)

-- Output:
--   Ranked customers with cumulative revenue metrics used to identify the 80% revenue threshold

-- SQL Dialect: BigQuery SQL
-- ============================================================

-- declare variable
DECLARE target_sales_pct FLOAT64 DEFAULT 0.80;

WITH base_sales AS (
  SELECT
    CustomerID,
    (Quantity * UnitPrice) AS sales
  FROM `pareto-portfolio.paretoportfolio.sales`
),
customer_sales AS (
  SELECT
    CustomerID,
    SUM(sales) AS customer_revenue
  FROM base_sales
  GROUP BY CustomerID
),
ranked AS (
  SELECT
    CustomerID,
    customer_revenue,
    ROW_NUMBER() OVER(ORDER BY customer_revenue DESC) AS cum_customers,
    COUNT(*) OVER() AS total_customers,
    SUM(customer_revenue) OVER(ORDER BY customer_revenue DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_revenue,
    SUM(customer_revenue) OVER() AS total_revenue
  FROM customer_sales
),
with_pct AS (
  SELECT
    CustomerID,
    customer_revenue,
    cum_customers,
    total_customers,
    cum_revenue,
    total_revenue,
    cum_revenue / total_revenue AS cum_sales_share,
    cum_customers / total_customers AS cum_pct_customers
  FROM ranked
)
SELECT
  MIN(cum_customers) AS number_of_customers,
  MIN(total_customers) AS total_customers,
  MIN(cum_revenue) AS cumulative_revenue,
  MIN(total_revenue) AS total_revenue,
  target_sales_pct * 100 AS target_sales_percent,
  MIN(total_revenue * target_sales_pct) AS target_sales,
  MIN(cum_sales_share) AS cum_sales_share,
  MIN(cum_pct_customers) AS cum_pct_customers
FROM with_pct
WHERE cum_sales_share >= target_sales_pct;
