# DriveSight Schema Documentation

## Overview
This document provides schema-level documentation for different layers in the **DriveSight** dbt project.

## 📊 Schema Structure

### Database Schema Organization
```
FINN (Catalog)
├── main (Source Schema)
│   ├── customers
│   ├── cars
│   ├── subscriptions
│   ├── invoices
│   └── invoice_line_items
├── main_bronze (Bronze Layer)
│   ├── brz_customers
│   ├── brz_cars
│   └── brz_subscriptions
├── main_silver (Silver Layer)
│   ├── slv_customers
│   ├── slv_cars
│   └── slv_subscriptions
└── main_gold (Gold Layer)
    ├── gld_active_customer_type_share
    ├── gld_customer_type_distribution_per_term
    ├── gld_cars_infleet_defleet_volume
    └── gld_city_weekly_delivery_increase
```
**NOTE**: Bronze layer does not have a defined schema, it directly reflects the source data.

---

# Silver Layer Schema

## Overview
The Silver layer represents cleansed and standardized data derived from the Bronze (raw) layer. It is optimized for analytical modeling and acts as a foundation for the Gold (business metric) layer.

---

## 🧍 slv_customers

**Catalog**: `FINN`<br>
**Schema**: `main_silver`<br>
**Description**:<br>
Cleansed customer dimension data used for segmentation, demographic analysis, and business classification (B2B/B2C).<br >
**Source**: `brz_customers`<br>
**Unique Key**: `customer_id`<br>

| Column Name     | Data Type   | Description                                                  |
|-----------------|-------------|--------------------------------------------------------------|
| `customer_id`   | STRING      | Unique identifier for each customer (Primary Key)           |
| `customer_type` | STRING      | Type of customer (`b2b`, `b2c`, or `other`)                 |
| `company_name`  | STRING      | Name of the company for B2B customers                       |
| `city`          | STRING      | City where the customer is located                          |
| `zip_code`      | STRING      | Zip code of the customer's address                          |
| `load_date`     | DATE        | Date when the record was loaded into the silver layer       |
| `rep_date`      | DATE        | Reporting date the record corresponds to                    |

---

## 🚗 slv_cars

**Catalog**: `FINN`<br>
**Schema**: `main_silver`<br>
**Description**:<br>
Standardized and enriched car dimension data for fleet analysis and reporting.<br>
**Source**: `brz_cars`<br>
**Unique Key**: `car_id`<br>

| Column Name           | Data Type   | Description                                                    |
|-----------------------|-------------|----------------------------------------------------------------|
| `car_id`              | STRING      | Unique identifier for each car (Primary Key)                  |
| `brand`               | STRING      | Car brand                                                     |
| `model`               | STRING      | Car model                                                     |
| `engine_type`         | STRING      | Standardized engine type (`electric`, `petrol`, etc.)         |
| `registration_date`   | DATE        | Date car was registered in the fleet                          |
| `deregistration_date` | DATE        | Date car was removed from the fleet (nullable)                |
| `fleet_duration_days` | INTEGER     | Number of days the car has been active in fleet (calculated) |
| `is_active`           | BOOLEAN     | Flag indicating if the car is currently active                |
| `load_date`           | DATE        | Date when the record was loaded into the silver layer         |
| `rep_date`            | DATE        | Reporting date the record corresponds to                      |

---

## 📄 slv_subscriptions

**Catalog**: `FINN`
**Schema**: `main_silver`
**Description**:
Fact table representing subscription events that link customers and cars with time and pricing details.
**Source**: `brz_subscriptions`
**Unique Key**: `subscription_id`

| Column Name        | Data Type   | Description                                                                |
|--------------------|-------------|----------------------------------------------------------------------------|
| `subscription_id`  | STRING      | Unique identifier for each subscription (Primary Key)                     |
| `customer_id`      | STRING      | Customer ID associated with the subscription (FK to `slv_customers`)      |
| `car_id`           | STRING      | Car ID associated with the subscription (FK to `slv_cars`)                |
| `created_at`       | TIMESTAMP   | Date when subscription was created                                         |
| `start_date`       | DATE        | Date when the subscription began                                           |
| `end_date`         | DATE        | Date when subscription ends (start_date + term_months)                    |
| `start_month`      | DATE        | Subscription start month (YYYY-MM-DD)                                     |
| `start_week`       | STRING      | Subscription start week (YYYY-WW)                                         |
| `term_months`      | INTEGER     | Duration in months (converted from string to integer)                     |
| `monthly_rate`     | FLOAT       | Monthly subscription fee charged                                           |
| `is_active`        | BOOLEAN     | Boolean indicating if subscription is currently active                    |
| `load_date`        | DATE        | Date when the record was loaded into the silver layer                     |
| `rep_date`         | DATE        | Reporting date the record corresponds to                                  |

---

# Gold Layer Schema

## Overview
The Gold layer contains business-ready tables that aggregate metrics for dashboards and reporting. It is built from the Silver layer.

---

## 🚛 gld_cars_infleet_defleet_volume

**Catalog**: `FINN`
**Schema**: `main_gold`
**Domain**: Operations
**Description**:
Tracks daily volume of cars entering and exiting the fleet to support operational decision-making.
**Source**: `slv_cars`
**Unique Key**: `date`

| Column Name            | Data Type | Description                                                   |
|------------------------|-----------|---------------------------------------------------------------|
| `date`                 | DATE      | Date of the fleet activity                                    |
| `infleeted_count`      | INTEGER   | Number of cars added to the fleet on this date               |
| `defleeted_count`      | INTEGER   | Number of cars removed from the fleet on this date           |
| `cumulative_fleet_size`| INTEGER   | Total fleet size as of this date                             |
| `net_fleet_change`     | INTEGER   | Net change in fleet size on this date                        |
| `load_date`            | DATE      | Date the record was loaded into the gold layer               |

---

## 🏙️ gld_city_weekly_delivery_increase

**Catalog**: `FINN`
**Schema**: `main_gold`
**Domain**: Operations
**Description**:
Analyzes week-over-week changes in delivery volume per city to identify growth trends and inform resource planning.
**Source**: `slv_subscriptions`, `slv_cars`, `slv_customers`
**Unique Key**: Combination of `city`, `delivery_week`

| Column Name                | Data Type | Description                                                         |
|----------------------------|-----------|---------------------------------------------------------------------|
| `city`                     | STRING    | City where deliveries occurred                                      |
| `delivery_week`            | STRING    | Week of car deliveries                             |
| `current_week_deliveries`  | INTEGER   | Number of cars delivered in this city during this week              |
| `previous_week_deliveries` | INTEGER   | Number of cars delivered in the previous week                       |
| `deliveries_diff`          | INTEGER   | Difference in deliveries between current and previous week          |
| `growth_rate`              | FLOAT     | Growth in deliveries compared to previous week           |
| `delivery_rank`            | INTEGER   | Rank of this city within the week based on delivery volume          |
| `load_date`                | DATE      | Date the record was loaded into the gold layer                      |

---

## 🎯 gld_active_customer_type_share

**Catalog**: `FINN`
**Schema**: `main_gold`
**Domain**: Customer Acquisition
**Description**:
Shows active customer type shares (B2B vs B2C) per brand and month for segmentation and acquisition analysis.
**Source**: `slv_subscriptions`, `slv_cars`, `slv_customers`
**Unique Key**: Combination of `month`, `brand`, `customer_type`

| Column Name                                | Data Type | Description                                                                 |
|--------------------------------------------|-----------|-----------------------------------------------------------------------------|
| `month`                                    | DATE      | Month when subscriptions started (YYYY-MM-DD format)                        |
| `brand`                                    | STRING    | Car brand                                                                   |
| `customer_type`                            | STRING    | Type of customer (`b2b`, `b2c`, `other`)                                    |
| `active_customers_per_type_car_brand_month`| INTEGER   | Count of active customers of this type for this brand/month                 |
| `active_customers_per_car_brand_month`     | INTEGER   | Total active customers for this brand/month                                 |
| `customer_type_share`                      | FLOAT     | Percentage share of customer type (0.0 to 1.0)                              |
| `num_cars_used`                            | INTEGER   | Number of cars used by customers of this type                              |
| `avg_term_months`                          | FLOAT     | Average subscription term length for this customer type                    |
| `load_date`                                | DATE      | Date the record was loaded into the gold layer                             |

---

## 📊 gld_customer_type_distribution_per_term

**Catalog**: `FINN`
**Schema**: `main_gold`
**Domain**: Customer Acquisition
**Description**:
Examines distribution of customer types across subscription terms to support pricing and product strategy.
**Source**: `slv_subscriptions`, `slv_customers`
**Unique Key**: Combination of `term_months`, `customer_type`

| Column Name                      | Data Type | Description                                                             |
|----------------------------------|-----------|-------------------------------------------------------------------------|
| `term_months`                    | INTEGER   | Subscription term length in months                                      |
| `customer_type`                  | STRING    | Type of customer (`b2b`, `b2c`, `other`)                                |
| `customers_per_type_term`        | INTEGER   | Number of customers of this type for this term                         |
| `customers_per_term`             | INTEGER   | Total number of customers with this term length                        |
| `customer_type_share`            | FLOAT     | Percentage share of customer type (0.0 to 1.0)                          |
| `subscriptions_per_type_term`    | INTEGER   | Number of subscriptions of this type and term                          |
| `avg_monthly_rate_per_type_term` | FLOAT     | Average monthly subscription rate for this group                       |
| `total_revenue_per_type_term`    | FLOAT     | Total revenue generated by this customer/term combination              |
| `load_date`                      | DATE      | Date the record was loaded into the gold layer                         |

---

## 📌 Notes

- Gold models serve as the final layer for business metrics and visualization tools.
- `load_date` helps identify when a record was added for data lineage.
- These models often support daily dashboards and weekly KPI reporting.

---

Generated for the **DriveSight Analytics** powered by **dbt** and **DuckDB**.