# 🔧 Macros Directory

This directory contains **reusable SQL macros and functions** that provide common functionality across the DriveSight Analytics project. Macros promote code reusability, consistency, and maintainability.

## 🎯 Purpose

- **Code Reusability**: Create reusable SQL functions and logic
- **Consistency**: Ensure consistent calculations across models
- **Maintainability**: Centralize common logic for easier updates
- **Testing**: Provide specialized testing functions
- **Business Logic**: Encapsulate domain-specific calculations

## 📁 Directory Structure

```
macros/
├── silver/                    # Data transformation macros
│   └── get_term_month_numeric.sql
└── tests/                     # Custom testing macros
    ├── table_generic/
    │   └── at_least_one_row.sql
    └── utils/
        └── validate_rep_date.sql
```

## 🔄 Macro Categories

### 🥈 Silver Layer Macros (`silver/`)
**Purpose**: Data transformation and standardization functions for silver layer models

#### `get_term_month_numeric.sql`
**Purpose**: Convert subscription term text to numeric months
- **Input**: Text-based subscription terms (e.g., "1 month", "3 months", "1 year")
- **Output**: Numeric month values (1, 3, 12, etc.)
- **Usage**: Standardize subscription term data for calculations
- **Business Logic**: 
  - Handles various text formats and variations
  - Converts years to months (1 year = 12 months)
  - Provides consistent numeric values for analytics

**Example Usage**:
```sql
SELECT 
    subscription_id,
    term_original,
    {{ get_term_month_numeric('term_original') }} as term_months
FROM {{ ref('brz_subscriptions') }}
```

### 🧪 Testing Macros (`tests/`)
**Purpose**: Custom data quality and validation functions

#### Table Generic Tests (`table_generic/`)

##### `at_least_one_row.sql`
**Purpose**: Ensure tables contain at least one row of data
- **Use Case**: Validate that models produce expected output
- **Application**: Critical for ensuring data pipeline completeness
- **Business Impact**: Prevents empty tables from breaking downstream processes

**Example Usage**:
```yaml
models:
  - name: slv_customers
    tests:
      - at_least_one_row
```

#### Utility Tests (`utils/`)

##### `validate_rep_date.sql`
**Purpose**: Validate reporting date parameters and ranges
- **Use Case**: Ensure date parameters are within valid business ranges
- **Application**: Validate user inputs and model parameters
- **Business Logic**: 
  - Check date format validity
  - Ensure dates are within reasonable business ranges
  - Validate date logic (start_date <= end_date)

**Example Usage**:
```sql
{{ validate_rep_date('2024-01-01', '2024-12-31') }}
```

## 🛠️ Macro Development Guidelines

### Creating New Macros

#### 1. Identify Reusable Logic
- Look for repeated SQL patterns across models
- Identify business calculations used multiple times
- Consider complex logic that benefits from centralization

#### 2. Design Macro Interface
- Define clear input parameters
- Specify expected output format
- Document parameter types and constraints
- Consider default values for optional parameters

#### 3. Implement Business Logic
- Write clear, efficient SQL code
- Handle edge cases and null values
- Include appropriate error handling
- Add inline comments for complex logic

#### 4. Test Thoroughly
- Test with various input scenarios
- Validate edge cases and error conditions
- Ensure consistent behavior across different databases
- Document expected behavior and limitations

#### 5. Document Usage
- Provide clear usage examples
- Document all parameters and return values
- Explain business context and use cases
- Include performance considerations

### Macro Organization

#### Naming Conventions
- **Transformation Macros**: `get_<description>`, `calculate_<metric>`
- **Test Macros**: `test_<validation_type>`, `validate_<check>`
- **Utility Macros**: `<utility_function>`, `<helper_name>`

#### Directory Structure
- **Layer-Specific**: Organize by data layer (bronze, silver, gold)
- **Functional**: Group by functionality (tests, utils, calculations)
- **Domain-Specific**: Organize by business domain when appropriate

## 🧪 Testing Strategy

### Macro Testing
- **Unit Tests**: Test individual macro functionality
- **Integration Tests**: Test macro usage within models
- **Edge Case Testing**: Validate behavior with unusual inputs
- **Performance Testing**: Ensure macros don't impact query performance

### Quality Assurance
- **Code Review**: Peer review of all macro changes
- **Documentation**: Maintain up-to-date macro documentation
- **Version Control**: Track macro changes and dependencies
- **Backward Compatibility**: Ensure changes don't break existing usage

## 📊 Usage Patterns

### Common Use Cases

#### Data Transformation
```sql
-- Standardize subscription terms
{{ get_term_month_numeric('subscription_term') }}

-- Apply consistent date formatting
{{ standardize_date('date_column') }}
```

#### Data Validation
```sql
-- Ensure table has data
{{ test_at_least_one_row() }}

-- Validate date ranges
{{ validate_rep_date(var('start_date'), var('end_date')) }}
```

#### Business Calculations
```sql
-- Calculate customer lifetime value
{{ calculate_clv('revenue', 'months_active') }}

-- Determine customer segment
{{ get_customer_segment('customer_type', 'subscription_value') }}
```

## 🔄 Maintenance & Updates

### Regular Maintenance
- **Performance Review**: Monitor macro performance impact
- **Usage Analysis**: Track which macros are most/least used
- **Optimization**: Improve macro efficiency and readability
- **Cleanup**: Remove unused or deprecated macros

### Version Management
- **Change Documentation**: Document all macro changes
- **Dependency Tracking**: Understand macro usage across models
- **Migration Planning**: Plan updates to minimize disruption
- **Rollback Strategy**: Maintain ability to revert problematic changes

## 📈 Best Practices

### Development
- **Single Responsibility**: Each macro should have one clear purpose
- **Parameter Validation**: Validate inputs and provide clear error messages
- **Documentation**: Include comprehensive documentation and examples
- **Testing**: Thoroughly test all macro functionality

### Usage
- **Consistent Application**: Use macros consistently across similar use cases
- **Parameter Naming**: Use clear, descriptive parameter names
- **Error Handling**: Handle macro errors gracefully in models
- **Performance Awareness**: Consider performance impact of macro usage

### Collaboration
- **Team Standards**: Establish team conventions for macro development
- **Knowledge Sharing**: Share macro knowledge across team members
- **Code Review**: Review macro changes for quality and consistency
- **Documentation**: Maintain centralized macro documentation

This macros directory provides the foundation for consistent, reusable, and maintainable SQL logic across the entire DriveSight Analytics platform.
