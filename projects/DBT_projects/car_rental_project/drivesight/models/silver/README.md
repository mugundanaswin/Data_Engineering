# 🥈 Silver Layer

The Silver layer represents the **cleaned and standardized data** stage of our medallion architecture. This layer applies business rules, data cleaning, and standardization to create high-quality, analysis-ready datasets.

## 🎯 Purpose

- **Data Cleaning**: Remove duplicates, handle nulls, and fix data quality issues
- **Standardization**: Apply consistent data types, formats, and naming conventions
- **Business Rules**: Implement domain-specific logic and calculations
- **Validation**: Ensure data quality through comprehensive testing
- **Foundation for Analytics**: Provide clean, reliable data for gold layer models

## 📁 Models in this Layer

### 🚗 `slv_cars.sql`
**Purpose**: Cleaned and enhanced vehicle fleet data
- **Source**: `brz_cars`
- **Enhancements**:
  - Standardized date formats and data types
  - Calculated fields (fleet status, active periods)
  - Data quality validations
  - Consistent naming conventions
- **Key Features**:
  - Active/inactive fleet status calculation
  - Registration period calculations
  - City standardization

### 👥 `slv_customers.sql`
**Purpose**: Cleaned and standardized customer information
- **Source**: `brz_customers`
- **Enhancements**:
  - Customer type standardization (B2B/B2C)
  - Date format standardization
  - Data quality improvements
  - Consistent field naming
- **Key Features**:
  - Customer segmentation preparation
  - Registration date validation
  - City name standardization

### 📋 `slv_subscriptions.sql`
**Purpose**: Cleaned and enhanced subscription data
- **Source**: `brz_subscriptions`
- **Enhancements**:
  - Term standardization using custom macros
  - Date validation and formatting
  - Subscription status calculations
  - Duration calculations
- **Key Features**:
  - Term conversion to numeric months
  - Subscription period calculations
  - Status derivation (active/completed/cancelled)

## 🔧 Data Transformations

### Data Cleaning
- **Null Handling**: Appropriate treatment of missing values
- **Duplicate Removal**: Ensure data uniqueness where required
- **Data Type Casting**: Consistent data types across models
- **Format Standardization**: Consistent date, text, and numeric formats

### Business Logic
- **Calculated Fields**: Derived metrics and status indicators
- **Standardization**: Consistent categorization and naming
- **Validation Rules**: Business rule enforcement
- **Enrichment**: Additional context and calculated attributes

### Quality Assurance
- **Data Validation**: Comprehensive testing framework
- **Business Rule Testing**: Ensure logic correctness
- **Referential Integrity**: Cross-model consistency checks
- **Completeness Testing**: Ensure expected data coverage

## 🏷️ Naming Convention

All silver models follow the pattern: `slv_<business_entity>`

## 🔗 Dependencies

### Upstream Dependencies
- **Bronze Layer**: `brz_cars`, `brz_customers`, `brz_subscriptions`
- **Macros**: Custom transformation functions
- **Sources**: Source system definitions

### Downstream Dependencies
- **Gold Layer**: All gold models depend on silver models
- **Snapshots**: Historical tracking of silver data
- **Tests**: Custom data quality tests

## 🧪 Testing Strategy

Comprehensive testing defined in `schema.yml`:

### Data Quality Tests
- **Uniqueness**: Primary key constraints
- **Not Null**: Required field validation
- **Referential Integrity**: Foreign key relationships
- **Accepted Values**: Valid category values

### Business Logic Tests
- **Date Logic**: Ensure logical date relationships
- **Calculation Accuracy**: Validate derived fields
- **Status Consistency**: Ensure status derivations are correct
- **Cross-Model Consistency**: Validate relationships between models

### Custom Tests
- **Custom Macros**: Specialized validation logic
- **Business Rule Tests**: Domain-specific validations
- **Data Range Tests**: Ensure values within expected ranges

## 📊 Usage Guidelines

### Development Best Practices
- Always run bronze models before silver models
- Test thoroughly before promoting changes
- Document any new business logic in schema.yml
- Follow established naming conventions

### Performance Considerations
- Silver models are optimized for analytical workloads
- Materialized as tables for better query performance
- Indexed on commonly used join keys
- Partitioned by date where applicable

### Data Lineage
- Clear lineage from bronze to silver models
- Documented transformations and business rules
- Traceable data quality improvements
- Audit trail for data changes

This layer serves as the foundation for all business analytics and ensures data quality and consistency across the entire analytics platform.
