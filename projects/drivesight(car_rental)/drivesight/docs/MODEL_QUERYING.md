# DriveSight Analytics - Model Querying Guide

# 📘 Overview

This guide provides detailed instructions on how to query the **DriveSight** analytics models for specific business use cases across operational planning, customer segmentation, and subscription analysis.

---

## 📊 Key Metrics & KPIs

### Customer Metrics
- **Customer Type Distribution**: B2B vs B2C segmentation
- **Active Customer Share**: Monthly active customer percentages by brand

### Fleet Metrics
- **Infleet/Defleet Volume**: Daily vehicle additions and removals
- **Fleet Size**: Total fleet size over time

### Delivery Metrics
- **Weekly Delivery Growth**: City-wise delivery performance
- **Delivery Rank**: Comparative city performance rankings
- **Growth Rate**: Week-over-week delivery improvements

---

## Ways to Query the Models

### 1. Direct DuckDB CLI

```bash
# Connect to DuckDB from CLI
duckdb

# Open the database file
.open <path-to-FINN.duckdb>

# Query example
> SELECT * FROM main_gold.gld_active_customer_type_share LIMIT 10;
```

### 2. Python with DuckDB
```python
import duckdb

# Connect to the database
conn = duckdb.connect('<path-to-FINN.duckdb>')

# Query example
query = "SELECT * FROM main_gold.gld_active_customer_type_share LIMIT 10;"
result = conn.sql(query).fetchdf()

# Close the connection
conn.close()
```

---

## 📓 Query Examples & Notebook

To make exploration easier, we’ve included practical SQL queries for each key use case in a Jupyter Notebook.

👉 Check out and run the interactive examples here:  
**[`QUERY NOTEBOOK`](../notebooks/model_querying.ipynb)**

---

## 📊 Customer Acquisition Use Cases

### Use Case 1: Active Customer Type Share per Car Brand (Monthly)

#### Schema: `main_gold`.`gld_active_customer_type_share`

**Purpose**: Analyze the distribution of B2B vs B2C customers by car brand on a monthly basis.

#### Running the Model:
```bash
# Run the specific model
dbt run --select gld_active_customer_type_share

# Run the model with dependencies
dbt run --select +gld_active_customer_type_share

# Run with specific date
dbt run --select gld_active_customer_type_share --vars '{"rep_date": "2024-01-31"}'
```

#### Querying the Results:
```sql
-- Connect to DuckDB and query the results
-- Basic query: Customer type share by brand and month
SELECT 
    month,
    brand,
    customer_type,
    active_customers_per_type_car_brand_month,
    active_customers_per_car_brand_month,
    customer_type_share,
    num_cars_used,
    avg_term_months
FROM main_gold.gld_active_customer_type_share
ORDER BY month DESC, brand, customer_type;

-- Advanced analysis: B2B vs B2C comparison
SELECT 
    month,
    brand,
    SUM(CASE WHEN customer_type = 'b2b' THEN customer_type_share ELSE 0 END) AS b2b_share,
    SUM(CASE WHEN customer_type = 'b2c' THEN customer_type_share ELSE 0 END) AS b2c_share,
    SUM(CASE WHEN customer_type = 'other' THEN customer_type_share ELSE 0 END) AS other_share
FROM main_gold.gld_active_customer_type_share
GROUP BY month, brand
ORDER BY month DESC, brand;
```

### Use Case 2: Customer Type Distribution per Terms

#### Schema: `main_gold`.`gld_customer_type_distribution_per_term`

**Purpose**: Understand how different customer types (B2B, B2C) prefer different subscription term lengths.

#### Running the Model:
```bash
# Run the specific model with dependencies
dbt run --select +gld_customer_type_distribution_per_term
```

#### Querying the Results:
```sql
-- Basic query: Customer distribution by term length
SELECT 
    term_months,
    customer_type,
    customers_per_type_term,
    subscriptions_per_type_term,
    customers_per_term,
    customer_type_share,
    avg_monthly_rate_per_type_term,
    total_revenue_per_type_term
FROM main_gold.gld_customer_type_distribution_per_term
ORDER BY term_months, customer_type;

-- Analysis: Most popular terms by customer type
SELECT 
    customer_type,
    term_months,
    customers_per_type_term,
    customer_type_share,
    RANK() OVER (PARTITION BY customer_type ORDER BY customers_per_type_term DESC) as popularity_rank
FROM main_gold.gld_customer_type_distribution_per_term
ORDER BY customer_type, popularity_rank;

-- Revenue analysis: Revenue contribution by customer type and term
SELECT 
    term_months,
    SUM(CASE WHEN customer_type = 'b2b' THEN total_revenue_per_type_term ELSE 0 END) AS b2b_revenue,
    SUM(CASE WHEN customer_type = 'b2c' THEN total_revenue_per_type_term ELSE 0 END) AS b2c_revenue,
    SUM(total_revenue_per_type_term) AS total_revenue
FROM main_gold.gld_customer_type_distribution_per_term
GROUP BY term_months
ORDER BY term_months;
```

## 🚛 Operations Use Cases

### Use Case 3: Daily Fleet Volume (Infleeted/Defleeted Cars)

#### Schema: `main_gold`.`gld_cars_infleet_defleet_volume`

**Purpose**: Track daily changes in fleet size by monitoring cars added and removed from the fleet.

#### Running the Model:
```bash
# Run the specific model with dependencies
dbt run --select +gld_cars_infleet_defleet_volume
```

#### Querying the Results:
```sql
-- Basic query: Daily fleet changes
SELECT 
    date,
    infleeted_count,
    defleeted_count,
    cumulative_fleet_size,
    net_fleet_change
FROM main_gold.gld_cars_infleet_defleet_volume
ORDER BY date DESC
LIMIT 30;

-- Weekly aggregation: Fleet changes by week
SELECT 
    DATE_TRUNC('week', date) AS week,
    SUM(infleeted_count) AS weekly_infleeted,
    SUM(defleeted_count) AS weekly_defleeted,
    SUM(net_fleet_change) AS weekly_net_change
FROM main_gold.gld_cars_infleet_defleet_volume
GROUP BY DATE_TRUNC('week', date)
ORDER BY week DESC;
```

### Use Case 4: City with Greatest Weekly Delivery Increase

#### Schema: `main_gold`.`gld_city_weekly_delivery_increase`

**Purpose**: Identify cities with the highest absolute increase in car deliveries week-over-week.

#### Running the Model:
```bash
# Run the specific model with dependencies
dbt run --select +gld_city_weekly_delivery_increase
```

#### Querying the Results:
```sql
-- Basic query: Cities with highest weekly delivery growth
SELECT
    delivery_week,
    city,
    current_week_deliveries,
    previous_week_deliveries,
    deliveries_diff,
    growth_rate
FROM main_gold.gld_city_weekly_delivery_increase
ORDER BY delivery_week DESC, deliveries_diff DESC;

-- Top performing cities: Highest growth cities by week
SELECT
    delivery_week,
    city,
    deliveries_diff,
    current_week_deliveries
FROM main_gold.gld_city_weekly_delivery_increase
WHERE deliveries_diff > 0  -- Only positive growth
    AND delivery_rank <= 5  -- Top 5 cities
ORDER BY delivery_week DESC, delivery_rank;
```

This guide provides a starting point for querying the DriveSight analytics models. For more advanced analysis and custom reporting, refer to the interactive Jupyter Notebook provided.