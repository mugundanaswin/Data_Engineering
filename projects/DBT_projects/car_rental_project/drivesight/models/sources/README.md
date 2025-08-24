# 📋 Sources Directory

This directory contains **source system definitions** that establish the connection between dbt models and external data systems. Sources define the raw data tables that serve as the foundation for all downstream transformations.

## 🎯 Purpose

- **Source System Integration**: Define connections to external data systems
- **Data Lineage**: Establish clear lineage from source systems to models
- **Data Freshness**: Monitor and validate source data freshness
- **Source Testing**: Implement data quality tests at the source level
- **Documentation**: Provide comprehensive source system documentation

## 📁 Directory Structure

```
sources/
└── drivesight/
    └── sources.yml    # Source system definitions and configurations
```

## 🔗 Source Systems

### DriveSight Database
**Location**: `drivesight/sources.yml`
**Purpose**: Defines the core operational data sources for FINN's car subscription business

#### Source Tables

##### 🚗 `cars` Table
**Purpose**: Vehicle fleet master data
- **Description**: Complete vehicle inventory and fleet information
- **Key Fields**: car_id, brand, model, registration_date, deregistration_date, city
- **Update Frequency**: Real-time operational updates
- **Business Owner**: Fleet Management Team
- **Data Volume**: ~10K+ vehicles

##### 👥 `customers` Table  
**Purpose**: Customer master data and profiles
- **Description**: Customer information and segmentation data
- **Key Fields**: customer_id, customer_type, registration_date, city
- **Update Frequency**: Real-time customer updates
- **Business Owner**: Customer Management Team
- **Data Volume**: ~50K+ customers

##### 📋 `subscriptions` Table
**Purpose**: Subscription transaction data
- **Description**: All subscription details, terms, and lifecycle information
- **Key Fields**: subscription_id, customer_id, car_id, start_date, end_date, term
- **Update Frequency**: Real-time subscription updates
- **Business Owner**: Subscription Management Team
- **Data Volume**: ~100K+ subscriptions

## 🧪 Source Testing Strategy

### Data Quality Tests
- **Uniqueness**: Primary key constraints on source tables
- **Not Null**: Critical field validation
- **Freshness**: Data recency validation
- **Volume**: Expected data volume checks

### Business Logic Tests
- **Referential Integrity**: Cross-table relationship validation
- **Data Ranges**: Ensure values within expected business ranges
- **Format Validation**: Date formats, text patterns, numeric ranges
- **Completeness**: Ensure all expected data is present

## 📊 Source Monitoring

### Freshness Monitoring
- **cars**: Expected to be updated within 24 hours
- **customers**: Expected to be updated within 24 hours  
- **subscriptions**: Expected to be updated within 24 hours

### Volume Monitoring
- **Daily Volume Checks**: Ensure expected daily data volumes
- **Anomaly Detection**: Identify unusual data volume patterns
- **Growth Tracking**: Monitor data growth trends over time

## 🔄 Data Lineage

### Source to Bronze
```
Source Tables → Bronze Models
├── cars → brz_cars
├── customers → brz_customers
└── subscriptions → brz_subscriptions
```

### Downstream Impact
- **Bronze Layer**: Direct dependency on source tables
- **Silver Layer**: Indirect dependency through bronze models
- **Gold Layer**: Indirect dependency through silver models
- **Analytics**: All analytics depend on source data quality

## 📝 Configuration Details

### Connection Configuration
- **Database**: DuckDB (FINN.duckdb)
- **Schema**: Main schema containing operational tables
- **Access Method**: Direct file access for development/testing
- **Security**: File-based access control

### Source Definitions
Each source table includes:
- **Table Name**: Physical table name in source system
- **Description**: Business purpose and content description
- **Columns**: Key column definitions and descriptions
- **Tests**: Data quality and business logic tests
- **Freshness**: Expected data update frequency
- **Metadata**: Business owner, update patterns, data volume

## 🛠️ Development Guidelines

### Adding New Sources
1. **Identify Source System**: Determine source database and schema
2. **Define Table Structure**: Document table schema and key fields
3. **Configure Tests**: Add appropriate data quality tests
4. **Set Freshness**: Define expected data update frequency
5. **Document Purpose**: Provide clear business context and usage
6. **Validate Access**: Ensure proper connection and permissions

### Modifying Existing Sources
1. **Impact Analysis**: Assess downstream model dependencies
2. **Test Changes**: Validate changes don't break existing models
3. **Update Documentation**: Keep source documentation current
4. **Communicate Changes**: Notify downstream model owners
5. **Version Control**: Track changes through git commits

## 🚨 Monitoring & Alerts

### Data Quality Alerts
- **Freshness Violations**: Source data older than expected
- **Test Failures**: Source data quality test failures
- **Volume Anomalies**: Unexpected data volume changes
- **Schema Changes**: Structural changes to source tables

### Operational Alerts
- **Connection Issues**: Problems accessing source systems
- **Performance Degradation**: Slow source data access
- **Data Availability**: Source system downtime or maintenance

## 📈 Best Practices

### Source Management
- **Minimal Transformation**: Keep source definitions close to raw data
- **Comprehensive Testing**: Test all critical data quality aspects
- **Clear Documentation**: Provide business context for all sources
- **Regular Review**: Periodically review and update source definitions

### Performance Optimization
- **Efficient Queries**: Optimize source queries for performance
- **Incremental Loading**: Use incremental strategies where appropriate
- **Resource Management**: Monitor and optimize resource usage
- **Caching Strategy**: Implement appropriate caching for frequently accessed sources

This sources directory serves as the foundation for all data transformations in the DriveSight Analytics platform, ensuring reliable, well-documented, and high-quality data ingestion from FINN's operational systems.
