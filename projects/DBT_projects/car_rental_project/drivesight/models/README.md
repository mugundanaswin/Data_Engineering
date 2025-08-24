# 📊 Models Directory

This directory contains all dbt models organized in a **medallion architecture** (Bronze → Silver → Gold) for the DriveSight Analytics project.

## 🏗️ Architecture Overview

```
models/
├── 🥉 bronze/     # Raw data ingestion layer
├── 🥈 silver/     # Cleaned and standardized data layer  
├── 🥇 gold/       # Business-ready analytics layer
└── sources/       # Source system definitions
```

## 📁 Directory Structure

### 🥉 Bronze Layer (`bronze/`)
**Purpose**: Raw data ingestion from source systems with minimal transformation
- **brz_cars.sql** - Raw vehicle fleet data
- **brz_customers.sql** - Raw customer information
- **brz_subscriptions.sql** - Raw subscription data

### 🥈 Silver Layer (`silver/`)
**Purpose**: Cleaned, standardized, and validated data ready for business logic
- **slv_cars.sql** - Processed vehicle data with calculated fields
- **slv_customers.sql** - Cleaned customer data with standardized types
- **slv_subscriptions.sql** - Standardized subscription data
- **schema.yml** - Data quality tests and documentation

### 🥇 Gold Layer (`gold/`)
**Purpose**: Business-ready analytics and aggregated metrics
- **customer_acquisition/** - Customer segmentation and acquisition analytics
- **operations/** - Fleet and delivery operations analytics
- **schema.yml** - Business metric tests and documentation

### 📋 Sources (`sources/`)
**Purpose**: Source system table definitions and data lineage
- **drivesight/sources.yml** - Source table configurations and tests

## 🔄 Data Flow

1. **Bronze Models** ingest raw data from source systems
2. **Silver Models** apply data cleaning, type casting, and standardization
3. **Gold Models** create business metrics and aggregated analytics
4. **Sources** define the connection to external data systems

## 🏷️ Naming Conventions

- **Bronze**: `brz_<source_table_name>`
- **Silver**: `slv_<business_entity>`
- **Gold**: `gld_<metric_description>`

## 🧪 Testing Strategy

Each layer includes comprehensive data quality tests:
- **Bronze**: Source data validation
- **Silver**: Data type and business rule validation
- **Gold**: Metric accuracy and completeness tests

For detailed information about each model, refer to the schema.yml files in each layer directory.
