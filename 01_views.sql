-- ============================================================
-- SQL Pareto Analysis — Pet Shop Sales
-- File: 01_views.sql

-- Purpose:
-- Creates layered analytical views used to perform a Pareto (80/20) revenue analysis on customer sales data.

-- This file builds reusable views that:
--   1. Calculate revenue per transaction
--   2. Aggregate revenue by customer
--   3. Rank customers by revenue
--   4. Compute cumulative revenue metrics

-- Dependencies:
--   - pet_shop_sales table (CSV dataset)

-- Output:
--   Analytical views for Pareto analysis

-- SQL Dialect: BigQuery SQL
-- ============================================================

-- Sales = Quantity * UnitPrice
-- CustomerID, sales

CREATE OR REPLACE VIEW `pareto-portfolio.paretoportfolio.sales_v1`
AS
SELECT
  CustomerID,
  (Quantity * UnitPrice) AS sales
FROM `pareto-portfolio.paretoportfolio.sales`;


-- GROUP BY customers, sales for each customer in one row of data

CREATE OR REPLACE VIEW `pareto-portfolio.paretoportfolio.sales_v2`
AS
SELECT
  CustomerID,
  SUM(sales) AS customer_revenue
FROM `pareto-portfolio.paretoportfolio.sales_v1`
GROUP BY CustomerID;


-- CustomerID, customer_revenue, cum_customers, total_customers, cum_revenue, total_revenue
-- View3

CREATE OR REPLACE VIEW `pareto-portfolio.paretoportfolio.sales_v3`
AS
SELECT
  CustomerID,
  customer_revenue,
  ROW_NUMBER() OVER(ORDER BY customer_revenue DESC) AS cum_customers,
  COUNT(*) OVER() AS total_customers,
  SUM(customer_revenue) OVER(ORDER BY customer_revenue DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_revenue,
  SUM(customer_revenue) OVER() AS total_revenue
FROM `pareto-portfolio.paretoportfolio.sales_v2`;


-- CustomerID, customer_revenue, cum_customers, total_customers, cum_revenue, total_revenue
-- + cum_sales_share, cum_pct_customers
-- View4

CREATE OR REPLACE VIEW `pareto-portfolio.paretoportfolio.sales_v4`
AS
SELECT
  CustomerID,
  customer_revenue,
  cum_customers,
  total_customers,
  cum_revenue,
  total_revenue,
  cum_revenue / total_revenue AS cum_sales_share,
  cum_customers / total_customers AS cum_pct_customers
FROM `pareto-portfolio.paretoportfolio.sales_v3`;











