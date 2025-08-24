# 🧪 Tests Directory

This directory contains **custom data quality tests** that validate business logic and data integrity beyond standard dbt tests. These tests ensure data accuracy and business rule compliance across the DriveSight Analytics platform.

## 🎯 Purpose

- **Business Logic Validation**: Test domain-specific business rules
- **Data Integrity**: Ensure logical consistency across related data
- **Quality Assurance**: Validate complex data relationships
- **Regression Prevention**: Catch data quality issues early
- **Compliance**: Ensure data meets business requirements

## 📁 Directory Structure

```
tests/
└── silver/                                    # Silver layer specific tests
    ├── assert_car_registration_before_deregistration.sql
    └── assert_subscription_dates_logical.sql
```

## 🔍 Test Categories

### 🥈 Silver Layer Tests (`silver/`)
**Purpose**: Validate cleaned and standardized data in the silver layer

#### `assert_car_registration_before_deregistration.sql`
**Purpose**: Ensure vehicle registration dates occur before deregistration dates

**Business Rule**: A vehicle cannot be deregistered before it is registered
- **Logic**: `registration_date <= deregistration_date` for all vehicles with both dates
- **Impact**: Prevents illogical vehicle lifecycle data
- **Failure Scenario**: Returns rows where deregistration_date < registration_date
- **Business Context**: Critical for fleet management and vehicle lifecycle tracking

**Test Logic**:
```sql
-- Returns rows that violate the business rule
SELECT 
    car_id,
    registration_date,
    deregistration_date
FROM {{ ref('slv_cars') }}
WHERE deregistration_date IS NOT NULL
  AND registration_date > deregistration_date
```

**Expected Result**: Zero rows (empty result set indicates test passes)

#### `assert_subscription_dates_logical.sql`
**Purpose**: Validate subscription start and end date relationships

**Business Rule**: Subscription end dates must be after start dates
- **Logic**: `start_date <= end_date` for all completed subscriptions
- **Impact**: Ensures subscription duration calculations are accurate
- **Failure Scenario**: Returns rows where end_date < start_date
- **Business Context**: Essential for subscription analytics and revenue calculations

**Test Logic**:
```sql
-- Returns rows that violate the business rule
SELECT 
    subscription_id,
    customer_id,
    start_date,
    end_date
FROM {{ ref('slv_subscriptions') }}
WHERE end_date IS NOT NULL
  AND start_date > end_date
```

**Expected Result**: Zero rows (empty result set indicates test passes)

## 🔧 Test Implementation

### Test Structure
Each custom test follows this pattern:
1. **Query Logic**: SQL that returns violating rows
2. **Business Rule**: Clear statement of the rule being tested
3. **Failure Condition**: Rows returned indicate test failure
4. **Success Condition**: Empty result set indicates test passes

### Test Execution
```bash
# Run all tests
dbt test

# Run specific test
dbt test --select test_name

# Run tests for specific model
dbt test --select slv_cars

# Run tests for specific layer
dbt test --select tag:silver
```

## 📊 Test Categories by Business Domain

### Fleet Management Tests
- **Vehicle Lifecycle**: Registration/deregistration date logic
- **Fleet Status**: Active/inactive status consistency
- **Geographic Consistency**: Vehicle location data validation
- **Brand Validation**: Ensure valid brand values

### Customer Management Tests
- **Customer Type**: Validate B2B/B2C categorization
- **Registration Logic**: Customer registration date validation
- **Geographic Data**: Customer location consistency
- **Segmentation Rules**: Customer segment assignment logic

### Subscription Management Tests
- **Date Logic**: Start/end date relationship validation
- **Term Consistency**: Subscription term and duration alignment
- **Status Logic**: Subscription status derivation rules
- **Revenue Calculations**: Pricing and term consistency

## 🚨 Test Failure Handling

### Failure Investigation
1. **Identify Scope**: Determine how many records are affected
2. **Root Cause Analysis**: Investigate source of data quality issue
3. **Business Impact**: Assess impact on downstream analytics
4. **Remediation**: Determine if data fix or business rule update is needed

### Failure Response
- **Critical Failures**: Stop pipeline execution, investigate immediately
- **Warning Failures**: Log issue, continue pipeline, schedule investigation
- **Expected Failures**: Document known issues, plan resolution

### Communication
- **Stakeholder Notification**: Alert business users of data quality issues
- **Documentation**: Record test failures and resolutions
- **Process Improvement**: Update processes to prevent similar issues

## 📈 Test Development Guidelines

### Creating New Tests

#### 1. Identify Business Rules
- **Collaborate with Business Users**: Understand critical business logic
- **Document Requirements**: Clearly define what constitutes valid data
- **Prioritize Impact**: Focus on rules that affect key business metrics
- **Consider Edge Cases**: Account for unusual but valid scenarios

#### 2. Design Test Logic
- **Clear SQL**: Write readable, maintainable test queries
- **Efficient Execution**: Optimize for performance on large datasets
- **Comprehensive Coverage**: Test all relevant scenarios
- **False Positive Prevention**: Ensure tests don't flag valid data

#### 3. Test Implementation
- **Descriptive Naming**: Use clear, descriptive test names
- **Documentation**: Include comments explaining business logic
- **Error Messages**: Provide helpful failure messages
- **Maintainability**: Write tests that are easy to update

#### 4. Validation and Deployment
- **Test the Test**: Validate test logic with known good/bad data
- **Performance Testing**: Ensure tests don't slow down pipeline
- **Integration Testing**: Verify tests work within dbt framework
- **Documentation**: Update test documentation and runbooks

### Test Maintenance

#### Regular Review
- **Effectiveness**: Assess if tests are catching real issues
- **Performance**: Monitor test execution time and resource usage
- **Relevance**: Ensure tests remain aligned with business rules
- **Coverage**: Identify gaps in test coverage

#### Updates and Improvements
- **Business Rule Changes**: Update tests when business logic changes
- **Performance Optimization**: Improve slow-running tests
- **New Requirements**: Add tests for new business rules
- **Deprecation**: Remove obsolete or redundant tests

## 🔄 Integration with dbt

### Test Configuration
Tests can be configured in `dbt_project.yml`:
```yaml
tests:
  drivesight:
    +severity: error  # fail | warn | error
    +store_failures: true
    +schema: test_failures
```

### Test Selection
Use dbt selectors for targeted test execution:
```bash
# Run tests by tag
dbt test --select tag:data_quality

# Run tests by model
dbt test --select slv_cars+

# Run tests by directory
dbt test --select tests/silver/
```

## 📊 Test Monitoring and Reporting

### Test Results Tracking
- **Success Rate**: Monitor test pass/fail rates over time
- **Failure Patterns**: Identify recurring test failures
- **Performance Metrics**: Track test execution time
- **Coverage Analysis**: Ensure comprehensive test coverage

### Alerting and Notifications
- **Real-time Alerts**: Immediate notification of critical test failures
- **Daily Summaries**: Regular test result summaries
- **Trend Analysis**: Long-term test performance trends
- **Stakeholder Reports**: Business-friendly test result reporting

This tests directory ensures the reliability and accuracy of data throughout the DriveSight Analytics platform, providing confidence in business decisions based on the data.
