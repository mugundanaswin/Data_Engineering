# 🌱 Seeds Directory

This directory contains **CSV files** that dbt can load as tables in the database. Seeds are typically used for reference data, lookup tables, and small datasets that need to be version-controlled and easily accessible within the dbt project.

## 🎯 Purpose

- **Reference Data**: Store lookup tables and reference datasets
- **Configuration Data**: Business rules and configuration parameters
- **Test Data**: Sample datasets for testing and development
- **Mapping Tables**: Data mapping and transformation references
- **Static Data**: Small, relatively static datasets that change infrequently

## 📁 Directory Structure

```
seeds/
├── .gitkeep                    # Placeholder file to maintain directory structure
└── [future seed files]        # CSV files for reference data
```

## 🔍 Seed Categories

### Reference Data Seeds
**Purpose**: Lookup tables and reference information

#### Potential Seed Types
- **City Mappings**: City name standardization and geographic data
- **Brand Configurations**: Brand-specific settings and parameters
- **Customer Type Definitions**: B2B/B2C classification rules
- **Subscription Term Mappings**: Term standardization and conversion rules
- **Status Code Mappings**: Status code definitions and descriptions

### Configuration Seeds
**Purpose**: Business rules and system configuration

#### Potential Seed Types
- **Business Rules**: Configurable business logic parameters
- **Calculation Parameters**: Constants used in business calculations
- **Threshold Values**: Business thresholds and limits
- **Feature Flags**: Feature enablement and configuration
- **Reporting Periods**: Standard reporting period definitions

### Test Data Seeds
**Purpose**: Sample data for testing and development

#### Potential Seed Types
- **Sample Customers**: Test customer data for development
- **Sample Vehicles**: Test vehicle data for model testing
- **Sample Subscriptions**: Test subscription data for validation
- **Edge Case Data**: Data representing edge cases and boundary conditions
- **Performance Test Data**: Data for performance testing scenarios

## 🔧 Seed Development

### Creating Seed Files

#### Example: City Mapping Seed (`city_mappings.csv`)
```csv
city_raw,city_standardized,region,country,population
berlin,Berlin,Berlin,Germany,3669491
münchen,Munich,Bavaria,Germany,1484226
hamburg,Hamburg,Hamburg,Germany,1906411
köln,Cologne,North Rhine-Westphalia,Germany,1073096
frankfurt,Frankfurt,Hesse,Germany,753056
```

#### Example: Subscription Term Mapping (`subscription_term_mappings.csv`)
```csv
term_text,term_months,term_category,is_flexible
"1 month",1,short_term,true
"3 months",3,short_term,true
"6 months",6,medium_term,false
"12 months",12,long_term,false
"18 months",18,long_term,false
"24 months",24,long_term,false
```

### Seed Configuration
```yaml
# dbt_project.yml
seeds:
  drivesight:
    +materialized: table
    +schema: reference
    city_mappings:
      +column_types:
        population: integer
    subscription_term_mappings:
      +column_types:
        term_months: integer
        is_flexible: boolean
```

### Loading Seeds
```bash
# Load all seeds
dbt seed

# Load specific seed
dbt seed --select city_mappings

# Refresh seed (drop and recreate)
dbt seed --full-refresh

# Load seeds with specific target
dbt seed --target prod
```

## 📊 Usage Patterns

### Reference Data Usage
```sql
-- Using city mapping seed in models
SELECT 
    c.customer_id,
    c.city as city_raw,
    cm.city_standardized,
    cm.region,
    cm.country
FROM {{ ref('slv_customers') }} c
LEFT JOIN {{ ref('city_mappings') }} cm
    ON LOWER(c.city) = LOWER(cm.city_raw)
```

### Configuration Data Usage
```sql
-- Using subscription term mapping
SELECT 
    s.subscription_id,
    s.term as term_original,
    stm.term_months,
    stm.term_category,
    stm.is_flexible
FROM {{ ref('slv_subscriptions') }} s
LEFT JOIN {{ ref('subscription_term_mappings') }} stm
    ON s.term = stm.term_text
```

### Business Rules Usage
```sql
-- Using business rule parameters
WITH business_rules AS (
    SELECT * FROM {{ ref('business_rule_parameters') }}
),
customer_segments AS (
    SELECT 
        customer_id,
        total_revenue,
        CASE 
            WHEN total_revenue >= (SELECT high_value_threshold FROM business_rules)
                THEN 'High Value'
            WHEN total_revenue >= (SELECT medium_value_threshold FROM business_rules)
                THEN 'Medium Value'
            ELSE 'Low Value'
        END as value_segment
    FROM customer_summary
)
SELECT * FROM customer_segments
```

## 🧪 Quality Assurance

### Data Validation
- **Format Validation**: Ensure CSV format is correct and parseable
- **Data Type Validation**: Verify data types match expected formats
- **Completeness**: Ensure all required reference data is present
- **Uniqueness**: Validate unique constraints where applicable

### Business Logic Validation
- **Mapping Completeness**: Ensure all source values have mappings
- **Rule Consistency**: Validate business rules are logically consistent
- **Parameter Ranges**: Ensure parameters are within valid business ranges
- **Cross-Reference Validation**: Validate relationships between seed tables

### Testing Strategy
```yaml
# schema.yml for seeds
seeds:
  - name: city_mappings
    description: "City name standardization and geographic reference data"
    columns:
      - name: city_raw
        description: "Original city name from source systems"
        tests:
          - not_null
          - unique
      - name: city_standardized
        description: "Standardized city name"
        tests:
          - not_null
      - name: population
        description: "City population"
        tests:
          - not_null
          - positive_values
```

## 🔄 Maintenance and Updates

### Update Process
1. **Identify Changes**: Determine what reference data needs updating
2. **Update CSV**: Modify CSV files with new or changed data
3. **Validate Changes**: Test changes in development environment
4. **Deploy Updates**: Run `dbt seed --full-refresh` to update tables
5. **Validate Impact**: Ensure downstream models work correctly

### Version Control
- **Track Changes**: All seed changes tracked in git
- **Change Documentation**: Document reasons for seed updates
- **Review Process**: Peer review of seed changes
- **Rollback Capability**: Ability to revert to previous seed versions

### Performance Considerations
- **Size Limits**: Keep seed files small (typically < 1MB)
- **Load Frequency**: Seeds loaded less frequently than models
- **Indexing**: Consider indexing frequently joined columns
- **Partitioning**: Not typically needed for small seed tables

## 📈 Best Practices

### File Management
- **Clear Naming**: Use descriptive file names
- **Consistent Format**: Maintain consistent CSV format
- **Documentation**: Include header rows with clear column names
- **Encoding**: Use UTF-8 encoding for international characters

### Data Quality
- **Validation**: Validate data before adding to seeds
- **Completeness**: Ensure comprehensive coverage of reference values
- **Accuracy**: Verify accuracy of reference data
- **Currency**: Keep reference data current and up-to-date

### Usage Guidelines
- **Appropriate Size**: Use seeds for small, relatively static datasets
- **Version Control**: Leverage git for change tracking
- **Documentation**: Document business context and usage
- **Testing**: Include appropriate tests for seed data

## 🚨 Monitoring and Alerts

### Seed Health
- **Load Success**: Monitor seed loading success rates
- **Data Quality**: Track seed data quality metrics
- **Usage Patterns**: Monitor which seeds are most frequently used
- **Performance**: Track seed loading time and resource usage

### Business Impact
- **Mapping Coverage**: Monitor coverage of mapping tables
- **Rule Effectiveness**: Assess effectiveness of business rules
- **Data Currency**: Ensure reference data remains current
- **Downstream Impact**: Monitor impact of seed changes on models

## 🔄 Migration Strategies

### From External Systems
- **Extract Process**: Automated extraction from source systems
- **Transformation**: Convert to CSV format for dbt seeds
- **Validation**: Validate extracted data before loading
- **Automation**: Consider automation for frequently updated seeds

### To External Systems
- **Export Process**: Export seed data for use in other systems
- **Format Conversion**: Convert to required formats for external systems
- **Synchronization**: Keep external systems synchronized with seed data
- **Change Notification**: Notify external systems of seed changes

## 📊 Usage Examples

### Geographic Reference Data
```csv
# geographic_regions.csv
region_code,region_name,country,timezone,currency
DE-BE,Berlin,Germany,Europe/Berlin,EUR
DE-BY,Bavaria,Germany,Europe/Berlin,EUR
DE-HH,Hamburg,Germany,Europe/Berlin,EUR
```

### Business Configuration
```csv
# business_parameters.csv
parameter_name,parameter_value,parameter_type,description
high_value_threshold,10000,numeric,Customer high value threshold in EUR
medium_value_threshold,5000,numeric,Customer medium value threshold in EUR
max_subscription_term,24,numeric,Maximum subscription term in months
```

This seeds directory provides a foundation for managing reference data and configuration parameters that support the entire DriveSight Analytics platform.
