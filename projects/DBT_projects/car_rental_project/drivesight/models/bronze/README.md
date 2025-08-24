# 🥉 Bronze Layer

The Bronze layer represents the **raw data ingestion** stage of our medallion architecture. This layer contains models that perform minimal transformation on source data, focusing on data ingestion and basic structure preservation.

## 🎯 Purpose

- **Raw Data Ingestion**: Direct ingestion from source systems with minimal transformation
- **Data Preservation**: Maintain original data structure and values
- **Foundation Layer**: Provides the base for all downstream transformations
- **Audit Trail**: Preserves original data for debugging and auditing purposes

## 📁 Models in this Layer

### 🚗 `brz_cars.sql`
**Purpose**: Raw vehicle fleet data ingestion
- **Source**: FINN vehicle management system
- **Contains**: Vehicle information, registration details, fleet status
- **Key Fields**: car_id, brand, model, registration_date, deregistration_date, city

### 👥 `brz_customers.sql`
**Purpose**: Raw customer information ingestion
- **Source**: FINN customer management system
- **Contains**: Customer profiles, contact information, customer type
- **Key Fields**: customer_id, customer_type (B2B/B2C), registration_date, city

### 📋 `brz_subscriptions.sql`
**Purpose**: Raw subscription data ingestion
- **Source**: FINN subscription management system
- **Contains**: Subscription details, terms, dates, pricing
- **Key Fields**: subscription_id, customer_id, car_id, start_date, end_date, term

## 🔄 Data Processing Approach

### Minimal Transformation
- **Type Casting**: Basic data type conversions where necessary
- **Column Renaming**: Standardize column names for consistency
- **No Business Logic**: Avoid complex transformations at this layer
- **Preserve Raw Values**: Keep original data values intact

### Data Quality
- **Source Validation**: Ensure data is successfully ingested from sources
- **Completeness Checks**: Verify expected data volumes
- **Basic Constraints**: Primary key and not-null validations

## 🏷️ Naming Convention

All bronze models follow the pattern: `brz_<source_table_name>`

## ⬆️ Downstream Dependencies

Bronze models serve as the foundation for:
- **Silver Layer**: `slv_cars`, `slv_customers`, `slv_subscriptions`
- **Data Quality Tests**: Source data validation
- **Snapshots**: Historical data tracking

## 🧪 Testing Strategy

- **Source Tests**: Validate data ingestion from source systems
- **Volume Tests**: Ensure expected data volumes
- **Freshness Tests**: Verify data recency
- **Uniqueness Tests**: Check primary key constraints

## 📊 Usage Notes

- Bronze models should be run first in any dbt execution
- These models form the foundation of all analytics
- Changes to bronze models may impact all downstream models
- Use for debugging data issues and understanding source data structure
