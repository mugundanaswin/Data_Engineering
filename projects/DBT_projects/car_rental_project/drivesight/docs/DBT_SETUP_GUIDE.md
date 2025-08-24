# DriveSight dbt Setup & DuckDB Connection Guide

## 🎯 Project Overview

**DriveSight** is a comprehensive analytics solution for FINN's car subscription business, built using dbt (data build tool) with DuckDB as the analytical database.

## 🚀 Initial Setup

### Prerequisites
- Python 3.8+
- Libraries: dbt-core, dbt-duckdb, duckdb, pandas, jupyter
- DuckDB CLI (optional, for manual exploration)

### 1. Repository Clone
```bash
# Clone the repository
git clone <repository-url>
cd <project-directory/drivesight>
```

### 2. Python Virtual Environment Setup
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
source venv/bin/activate  # On macOS/Linux
# or
venv\Scripts\activate     # On Windows

# Install required packages
pip install -r requirements.txt

```

### 3. DuckDB CLI Installation
```bash
# Install DuckDB CLI for database access and schema inspection
brew install duckdb

# Verify installation
duckdb --version

# Connect to database (optional - for manual inspection)
duckdb
# In DuckDB CLI, connect to the database
.open <path-to-FINN.duckdb>
```

## 🔧 Environment Configuration

### 4. Environment Variables Setup
```bash
# Set essential environment variables for development
export DBT_DUCKDB_DEV_PATH=<path-to-FINN.duckdb>
export DBT_CATALOG_DEV=FINN
export ENV=dev

# Optional: Set for other environments
export DBT_DUCKDB_STG_PATH=./data/stg.duckdb
export DBT_CATALOG_STG=FINN
export DBT_DUCKDB_PROD_PATH=./data/prod.duckdb
export DBT_CATALOG_PROD=FINN

# Verify environment variables
echo $DBT_DUCKDB_DEV_PATH
echo $DBT_CATALOG_DEV
echo $ENV
```

**Why Environment Variables?**
- **Flexibility**: Easy deployment across different environments (dev/staging/prod)
- **Security**: Avoid hardcoding paths and credentials
- **Maintainability**: Single point of configuration change

## 📁 dbt Project Initialization

### 5. Project Structure Creation
```bash
# Create dbt profile directory
mkdir -p .dbt

# Initialize dbt project structure
dbt init drivesight
```

### 6. Configuration Files Setup
#### **NOTE**: The following files are already provided in the repository. The below is for reference only.

#### `.dbt/profiles.yml`
```yaml
# =============================================================================
# DBT PROFILES CONFIGURATION
# =============================================================================
# Project: DriveSight - FINN Car Subscription Analytics
# Purpose: Database connection profiles for different environments
# =============================================================================

drivesight:
  # Default target environment (can be overridden with --target flag)
  target: "{{ env_var('ENV', 'dev') }}"

  outputs:
    # -------------------------------------------------------------------------
    # DEVELOPMENT ENVIRONMENT
    # -------------------------------------------------------------------------
    # Purpose: Local development and testing
    dev:
      type: duckdb
      path: "{{ env_var('DBT_DUCKDB_DEV_PATH', '../../FINN.duckdb') }}"
      catalog: "{{ env_var('DBT_CATALOG_DEV', 'FINN') }}"
      threads: 4

    # -------------------------------------------------------------------------
    # STAGING ENVIRONMENT
    # -------------------------------------------------------------------------
    # Purpose: Pre-production testing and validation
    stg:
      type: duckdb
      path: "{{ env_var('DBT_DUCKDB_STG_PATH', './data/stg.duckdb') }}"
      catalog: "{{ env_var('DBT_CATALOG_STG', 'FINN') }}"
      threads: 4

    # -------------------------------------------------------------------------
    # PRODUCTION ENVIRONMENT
    # -------------------------------------------------------------------------
    # Purpose: Production data processing and analytics
    prod:
      type: duckdb
      path: "{{ env_var('DBT_DUCKDB_PROD_PATH', './data/prod.duckdb') }}"
      catalog: "{{ env_var('DBT_CATALOG_PROD', 'FINN') }}"
      threads: 16
```

#### `dbt_project.yml`
```yaml
# =============================================================================
# DBT PROJECT CONFIGURATION
# =============================================================================
# Project: DriveSight - FINN Car Subscription Analytics
# Purpose: Data pipeline for customer acquisition and fleet operations analysis
# =============================================================================

# Project identity
name: 'drivesight'
version: '1.0.0'
profile: 'drivesight'

# =============================================================================
# FILE PATH CONFIGURATIONS
# =============================================================================
# Specify where dbt should look for different types of files
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]
docs-paths: ["docs"]

# =============================================================================
# CLEANUP CONFIGURATION
# =============================================================================
# Directories to be removed by `dbt clean`
clean-targets:
  - "target"
  - "dbt_packages"

# =============================================================================
# MODEL CONFIGURATIONS
# =============================================================================
# Configure materialization, schema, and behavior for all model layers
models:
  drivesight:
    # Global model defaults
    +schema: main
    +docs:
      +show: true

    # -------------------------------------------------------------------------
    # BRONZE LAYER - Raw Data Ingestion
    # -------------------------------------------------------------------------
    # Purpose: Ingest raw data from source systems with minimal transformation
    bronze:
      +schema: bronze
      +materialized: incremental
      +incremental_strategy: delete+insert
      +unique_key: 'id'
      +partition_by: 'load_date'
      +tags: ['bronze', 'raw_data', 'daily_refresh']
      +on_schema_change: 'append_new_columns'

    # -------------------------------------------------------------------------
    # SILVER LAYER - Cleaned and Standardized Data
    # -------------------------------------------------------------------------
    # Purpose: Apply data quality rules, standardization, and basic transformations
    silver:
      +schema: silver
      +materialized: table
      +tags: ['silver', 'cleaned_data', 'daily_refresh', 'ops', 'customer_acquisition']
      +on_schema_change: fail

    # -------------------------------------------------------------------------
    # GOLD LAYER - Business-Ready Analytics
    # -------------------------------------------------------------------------
    # Purpose: Create aggregated, business-ready models for analytics and reporting
    gold:
      +schema: gold
      +tags: ['gold', 'analytical_data']
      +on_schema_change: fail
      
      # Operations Domain Models
      operations:
        +tags: ["ops", "operations"]
        +meta:
          owner: "operations_team"
          business_definition: "Track daily fleet changes and identify cities with the highest growth in car deliveries to optimize fleet management and logistics"
      
      # Customer Acquisition Domain Models
      customer_acquisition:
        +tags: ["customer_acquisition", "analytics"]
        +meta:
          owner: "analytics_team"
          business_definition: "Analyze customer types and their distribution across different subscription terms to inform marketing and sales strategies"

# =============================================================================
# TEST CONFIGURATIONS
# =============================================================================
# Configure test behavior and failure handling
tests:
  drivesight:
    +store_failures: true
    +warn_if: ">100"

# =============================================================================
# SNAPSHOT CONFIGURATIONS
# =============================================================================
# Configure slowly changing dimensions (SCD) for historical data tracking
snapshots:
  drivesight:
    silver:
      +schema: silver_snapshots
      +tags: ['silver', 'cleaned_historical_data', 'scd']

```

#### `models/sources/drivesight/sources.yml`
```yaml
# =============================================================================
# SOURCE DATA CONFIGURATION
# =============================================================================
# Project: DriveSight - FINN Car Subscription Analytics
# Purpose: Define source tables from FINN operational database
# =============================================================================

version: 2

sources:
  # ---------------------------------------------------------------------------
  # FINN CAR OPERATIONS DATA SOURCE
  # ---------------------------------------------------------------------------
  # Description: Core operational data from FINN's car subscription platform
  # Schema: main (default schema in DuckDB)
  # Data Refresh: Daily operational updates
  - name: car_ops
    description: "Car operations data from FINN subscription platform"
    schema: main
    tags: ['source', 'operational_data']

    tables:
      # -----------------------------------------------------------------------
      # CUSTOMER MASTER DATA
      # -----------------------------------------------------------------------
      - name: customers
        description: "Customer master data including personal and company information"

      # -----------------------------------------------------------------------
      # VEHICLE FLEET DATA
      # -----------------------------------------------------------------------
      - name: cars
        description: "Detailed records of individual cars in the FINN fleet"

      # -----------------------------------------------------------------------
      # SUBSCRIPTION DATA
      # -----------------------------------------------------------------------
      - name: subscriptions
        description: "Customer subscription plans and terms information"

      # -----------------------------------------------------------------------
      # BILLING DATA
      # -----------------------------------------------------------------------
      - name: invoices
        description: "Header-level data about customer invoices and billing"

      - name: invoice_line_items
        description: "Line-level details of each invoice including charges and fees"

```

### 7. Package Dependencies Installation

#### Package Configuration
The `packages.yml` file defines project dependencies:
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: [">=1.0.0", "<2.0.0"]
```

#### Install dbt-utils Package
The project uses `dbt-utils` package for advanced testing and utility functions.

```bash
# Install dbt package dependencies
dbt deps

# This will install packages defined in packages.yml:
# - dbt-labs/dbt_utils for advanced testing and utility macros
```

#### About dbt-utils
**dbt-utils** is a package that provides:
- **Advanced Tests**: `accepted_range`, `expression_is_true`, `unique_combination_of_columns`
- **Utility Macros**: Date functions, SQL helpers, and data quality checks
- **Cross-Database Compatibility**: Works across different database platforms

### 8. Connection Verification
```bash
# Test dbt connection
dbt debug

# Expected output:
# ✅ Connection test: [OK connection ok]
# ✅ All checks passed!
```
## ⚠️ DuckDB Limitations

### Known Constraints

#### 1. **Limited Incremental Strategy Support**
```yaml
# Limited options compared to other databases
models:
  drivesight:
    bronze:
      +incremental_strategy: append  # Primary option
      +incremental_strategy: delete+insert # available but limited 
```

#### 2. **In-Memory Processing**
- **Memory Constraints**: Large datasets may cause memory issues
- **Performance Impact**: Complex joins on large tables can be slow

#### 3. **Feature Limitations**
- **Concurrency**: Single-writer limitation

```
This comprehensive guide provides all the necessary steps and context for setting up and working with the DriveSight dbt project using DuckDB as the analytical database.
```