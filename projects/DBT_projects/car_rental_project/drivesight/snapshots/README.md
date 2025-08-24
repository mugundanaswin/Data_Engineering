# 📸 Snapshots Directory

This directory contains **dbt snapshots** that implement **Slowly Changing Dimension (SCD) Type 2** tracking for historical data analysis. Snapshots capture changes to data over time, enabling historical reporting and trend analysis.

## 🎯 Purpose

- **Historical Tracking**: Preserve historical states of changing data
- **Trend Analysis**: Enable time-based analysis of data changes
- **Audit Trail**: Maintain complete change history for compliance
- **Point-in-Time Analysis**: Query data as it existed at specific dates
- **Change Detection**: Track when and how data values change

## 📁 Directory Structure

```
snapshots/
└── silver/                           # Silver layer snapshots
    ├── slv_cars_snap.sql            # Vehicle fleet historical tracking
    ├── slv_customers_snap.sql       # Customer data historical tracking
    └── slv_subscriptions_snap.sql   # Subscription data historical tracking
```

## 🔄 Snapshot Strategy

### SCD Type 2 Implementation
All snapshots implement **Slowly Changing Dimension Type 2** with:
- **dbt_valid_from**: When the record became active
- **dbt_valid_to**: When the record became inactive (NULL for current)
- **dbt_scd_id**: Unique identifier for each version
- **dbt_updated_at**: Timestamp of the snapshot execution

### Change Detection
Snapshots use **timestamp strategy** to detect changes:
- **updated_at**: Column that indicates when source record was last modified
- **Incremental Processing**: Only processes records that have changed
- **Efficient Execution**: Minimizes processing time and resource usage

## 📊 Snapshot Models

### 🚗 `slv_cars_snap.sql`
**Purpose**: Track historical changes to vehicle fleet data

#### Key Use Cases
- **Fleet Evolution**: Track how fleet composition changes over time
- **Vehicle Lifecycle**: Monitor vehicle status changes (active/inactive)
- **Geographic Movement**: Track vehicle location changes
- **Maintenance History**: Historical view of vehicle maintenance status

#### Tracked Changes
- **Fleet Status**: Active/inactive status changes
- **Location Changes**: Vehicle city/location updates
- **Registration Status**: Registration/deregistration events
- **Maintenance Status**: Service and maintenance state changes

#### Business Applications
- **Fleet Utilization Analysis**: Historical fleet usage patterns
- **Geographic Analysis**: Vehicle distribution changes over time
- **Lifecycle Management**: Vehicle aging and replacement planning
- **Operational Insights**: Fleet efficiency trends

---

### 👥 `slv_customers_snap.sql`
**Purpose**: Track historical changes to customer information

#### Key Use Cases
- **Customer Journey**: Track customer lifecycle and changes
- **Segmentation Evolution**: Monitor customer type changes (B2B/B2C)
- **Geographic Movement**: Track customer location changes
- **Profile Updates**: Historical view of customer profile modifications

#### Tracked Changes
- **Customer Type**: B2B to B2C transitions (or vice versa)
- **Location Changes**: Customer city/address updates
- **Profile Updates**: Contact information and preference changes
- **Status Changes**: Customer account status modifications

#### Business Applications
- **Customer Analytics**: Historical customer behavior analysis
- **Segmentation Analysis**: Customer segment migration patterns
- **Churn Analysis**: Customer lifecycle and retention patterns
- **Market Analysis**: Geographic customer distribution trends

---

### 📋 `slv_subscriptions_snap.sql`
**Purpose**: Track historical changes to subscription data

#### Key Use Cases
- **Subscription Evolution**: Track subscription modifications over time
- **Term Changes**: Monitor subscription term adjustments
- **Status Tracking**: Historical subscription status changes
- **Pricing History**: Track subscription pricing changes

#### Tracked Changes
- **Subscription Terms**: Term length modifications
- **Status Changes**: Active/paused/cancelled status updates
- **Pricing Updates**: Subscription fee changes
- **Service Level**: Subscription tier or service changes

#### Business Applications
- **Revenue Analysis**: Historical revenue and pricing trends
- **Customer Behavior**: Subscription modification patterns
- **Product Analysis**: Term preference evolution
- **Retention Analysis**: Subscription lifecycle patterns

## 🔧 Snapshot Configuration

### Standard Configuration
Each snapshot includes:
```sql
{{
    config(
        target_schema='snapshots',
        unique_key='id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
```

### Execution Schedule
- **Frequency**: Daily execution recommended
- **Timing**: Run after silver layer models complete
- **Dependencies**: Requires silver layer models to be current
- **Resource Usage**: Optimized for incremental processing

## 📈 Historical Analysis Capabilities

### Time-Based Queries
```sql
-- Query data as of specific date
SELECT * FROM {{ ref('slv_cars_snap') }}
WHERE '2024-01-01' BETWEEN dbt_valid_from AND COALESCE(dbt_valid_to, '9999-12-31')

-- Track changes over time
SELECT 
    car_id,
    dbt_valid_from,
    dbt_valid_to,
    status,
    city
FROM {{ ref('slv_cars_snap') }}
WHERE car_id = 'CAR123'
ORDER BY dbt_valid_from
```

### Change Analysis
```sql
-- Identify records that changed
SELECT * FROM {{ ref('slv_customers_snap') }}
WHERE dbt_valid_to IS NOT NULL

-- Count changes by time period
SELECT 
    DATE_TRUNC('month', dbt_valid_from) as month,
    COUNT(*) as changes
FROM {{ ref('slv_subscriptions_snap') }}
GROUP BY 1
ORDER BY 1
```

## 🧪 Testing Strategy

### Snapshot Quality Tests
- **Uniqueness**: Ensure unique_key + dbt_valid_from combinations are unique
- **Completeness**: Verify all expected records are captured
- **Consistency**: Validate dbt_valid_from/dbt_valid_to logic
- **Change Detection**: Ensure changes are properly captured

### Business Logic Tests
- **Historical Integrity**: Verify historical data accuracy
- **Change Logic**: Validate change detection logic
- **Date Consistency**: Ensure valid_from <= valid_to
- **Current Record Logic**: Verify current records have NULL valid_to

## 🔄 Maintenance and Operations

### Regular Maintenance
- **Performance Monitoring**: Track snapshot execution time
- **Storage Management**: Monitor snapshot table growth
- **Data Retention**: Implement retention policies if needed
- **Quality Monitoring**: Regular validation of snapshot accuracy

### Troubleshooting
- **Missing Changes**: Investigate if changes aren't being captured
- **Performance Issues**: Optimize for large datasets
- **Data Inconsistencies**: Validate source data quality
- **Execution Failures**: Monitor and resolve snapshot failures

## 📊 Usage Guidelines

### Best Practices
- **Consistent Execution**: Run snapshots on regular schedule
- **Source Stability**: Ensure source models are stable before snapshotting
- **Testing**: Thoroughly test snapshot logic before deployment
- **Documentation**: Document business rules for change detection

### Performance Considerations
- **Incremental Strategy**: Use timestamp strategy for efficiency
- **Resource Planning**: Account for storage growth over time
- **Query Optimization**: Optimize historical queries for performance
- **Archival Strategy**: Plan for long-term data retention

### Business Usage
- **Historical Reporting**: Use for trend analysis and historical reports
- **Audit Requirements**: Leverage for compliance and audit trails
- **Change Analysis**: Analyze patterns in data changes
- **Point-in-Time Analysis**: Query data states at specific dates

## 🚨 Monitoring and Alerts

### Snapshot Health
- **Execution Success**: Monitor snapshot run success rates
- **Change Volume**: Track volume of changes captured
- **Data Quality**: Monitor snapshot data quality metrics
- **Performance**: Track execution time and resource usage

### Business Alerts
- **Unusual Changes**: Alert on unexpected change volumes
- **Missing Updates**: Alert when expected changes aren't captured
- **Data Anomalies**: Alert on data quality issues in snapshots
- **Performance Degradation**: Alert on slow snapshot execution

This snapshots directory provides comprehensive historical tracking capabilities, enabling rich temporal analysis and ensuring complete audit trails for the DriveSight Analytics platform.
