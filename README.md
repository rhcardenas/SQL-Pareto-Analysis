# SQL Pareto Analysis — 80/20 Revenue Distribution (Pet Shop Sales)

## Project Overview

This project performs a **Pareto (80/20) analysis** on transactional pet shop sales data to determine:

> **How many customers generate 80% of total revenue?**

The analysis uses SQL window functions, views, and common table expressions (CTEs) to rank customers by revenue and compute cumulative contribution.

---

## Dataset

**File:** `data/pet_shop_sales.csv`

The dataset contains individual sales transactions with the following key fields:

* `CustomerID` — unique customer identifier
* `Quantity` — number of items sold
* `UnitPrice` — price per item
* `InvoiceDate` — transaction date
* `Country` — customer location

Revenue per transaction is calculated as:

```
revenue = Quantity × UnitPrice
```

---

## Methodology

The analysis follows these steps:

1. Calculate revenue per transaction
2. Aggregate revenue by customer
3. Rank customers by descending revenue
4. Compute cumulative revenue using window functions
5. Calculate cumulative revenue share
6. Identify the minimum number of customers required to reach 80% of total revenue

Two implementations are provided:

* **Views pipeline** — modular, reusable layered queries
* **CTE pipeline** — single-query analytical workflow

---

## SQL Implementation

### Views Approach

`sql/01_views.sql`

Creates layered analytical views:

* Transaction-level revenue calculations
* Customer revenue aggregation
* Ranked customers with cumulative metrics
* Final Pareto percentage metrics

### CTE Approach

`sql/03_cte_pareto_analysis.sql`

A single CTE-driven query that performs the full Pareto analysis and returns the final result.

This version demonstrates:

* Window functions
* Analytical ranking
* Cumulative aggregation
* Revenue segmentation

---

## Results

From the dataset:

**150 out of 261 customers (~57%) generate 80% of total revenue**

See:

```
outputs/pareto_results.csv
```

Key output metrics include:

* cumulative revenue
* total revenue
* percentage of customers needed to reach 80%
* cumulative sales share

---

## Skills Demonstrated

* SQL aggregation and grouping
* Window functions (`ROW_NUMBER`, `SUM OVER`, `COUNT OVER`)
* Common Table Expressions (CTEs)
* Analytical ranking and segmentation
* Pareto analysis
* Modular query design

---

## How to Run

1. Load `pet_shop_sales.csv` into your SQL environment
2. Run either:

### Views workflow

```
sql/01_views.sql
sql/02_views_final.sql
```

### CTE workflow

```
sql/03_cte_pareto_analysis.sql
```

---

## Notes

This project was built using BigQuery SQL syntax. Minor adjustments may be required for other SQL dialects.

The analysis illustrates how Pareto principles can be applied to customer segmentation and revenue concentration analysis.
