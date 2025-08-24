# 📓 Notebooks Directory

This directory contains **Jupyter notebooks** for interactive data analysis, exploration, and validation of the DriveSight Analytics platform. These notebooks provide hands-on analysis capabilities and serve as documentation for data exploration workflows.

## 🎯 Purpose

- **Interactive Analysis**: Hands-on data exploration and investigation
- **Model Validation**: Test and validate dbt model outputs
- **Business Analysis**: Perform ad-hoc business analysis and insights
- **Data Quality**: Explore and validate data quality across layers
- **Documentation**: Provide examples of data usage and analysis patterns

## 📁 Directory Structure

```
notebooks/
├── duckdb_analysis.ipynb      # Data exploration and validation
└── model_querying.ipynb       # Interactive model testing and business analysis
```

## 📊 Notebook Overview

### 🔍 `duckdb_analysis.ipynb`
**Purpose**: Comprehensive data exploration and validation notebook

#### Key Sections
1. **Database Connection**: Setup and connection to DuckDB
2. **Source Data Exploration**: Investigate raw data quality and structure
3. **Data Profiling**: Statistical analysis of key datasets
4. **Quality Assessment**: Data quality checks and validation
5. **Relationship Analysis**: Explore data relationships and dependencies

#### Analysis Areas
- **Data Volume Analysis**: Record counts and data distribution
- **Data Quality Assessment**: Missing values, duplicates, outliers
- **Statistical Profiling**: Descriptive statistics for key metrics
- **Temporal Analysis**: Time-based data patterns and trends
- **Relationship Validation**: Foreign key relationships and referential integrity

#### Business Value
- **Data Understanding**: Deep dive into data structure and content
- **Quality Assurance**: Identify and document data quality issues
- **Baseline Metrics**: Establish baseline understanding of data
- **Issue Investigation**: Investigate specific data quality concerns

---

### 📈 `model_querying.ipynb`
**Purpose**: Interactive model testing and business analysis

#### Key Sections
1. **Model Testing**: Validate dbt model outputs and logic
2. **Business Metrics**: Calculate and validate key business KPIs
3. **Analytical Queries**: Perform complex business analysis
4. **Visualization**: Create charts and graphs for insights
5. **Use Case Examples**: Demonstrate common analytical patterns

#### Analysis Areas
- **Model Validation**: Test model outputs against expected results
- **Business KPIs**: Calculate customer, fleet, and operational metrics
- **Trend Analysis**: Time-based analysis of business performance
- **Segmentation Analysis**: Customer and operational segmentation
- **Comparative Analysis**: Cross-dimensional business comparisons

#### Business Value
- **Model Verification**: Ensure model accuracy and business logic
- **Insight Generation**: Discover actionable business insights
- **Use Case Documentation**: Provide examples for business users
- **Analysis Templates**: Reusable analysis patterns and queries

## 🔧 Technical Setup

### Environment Requirements
```python
# Required packages
import duckdb
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from datetime import datetime, timedelta
```

### Database Connection
```python
# Connect to DuckDB database
conn = duckdb.connect('../FINN.duckdb')

# Test connection
result = conn.execute("SELECT COUNT(*) FROM cars").fetchone()
print(f"Connected successfully. Cars table has {result[0]} records.")
```

### Common Query Patterns
```python
# Query dbt models
def query_model(model_name):
    """Query a dbt model and return as DataFrame"""
    query = f"SELECT * FROM {model_name}"
    return conn.execute(query).df()

# Business metric calculation
def calculate_kpi(metric_query):
    """Calculate business KPI from SQL query"""
    return conn.execute(metric_query).fetchone()[0]
```

## 📊 Analysis Workflows

### Data Exploration Workflow
1. **Connect to Database**: Establish DuckDB connection
2. **Explore Schema**: Understand table structure and relationships
3. **Profile Data**: Generate statistical summaries
4. **Quality Assessment**: Identify data quality issues
5. **Document Findings**: Record insights and recommendations

### Model Validation Workflow
1. **Load Model Outputs**: Query dbt model results
2. **Validate Logic**: Test business logic and calculations
3. **Compare Expectations**: Verify against expected outcomes
4. **Performance Analysis**: Assess model performance metrics
5. **Document Results**: Record validation outcomes

### Business Analysis Workflow
1. **Define Questions**: Identify business questions to answer
2. **Design Analysis**: Plan analytical approach and queries
3. **Execute Analysis**: Run queries and generate insights
4. **Visualize Results**: Create charts and visualizations
5. **Summarize Insights**: Document findings and recommendations

## 🧪 Validation and Testing

### Model Validation
- **Output Verification**: Ensure model outputs match expectations
- **Logic Testing**: Validate business logic implementation
- **Edge Case Testing**: Test model behavior with edge cases
- **Performance Testing**: Assess query performance and efficiency

### Data Quality Validation
- **Completeness**: Check for missing or incomplete data
- **Accuracy**: Validate data accuracy against known sources
- **Consistency**: Ensure data consistency across models
- **Timeliness**: Verify data freshness and update patterns

### Business Logic Validation
- **KPI Calculations**: Verify business metric calculations
- **Segmentation Logic**: Validate customer and operational segments
- **Trend Analysis**: Ensure trend calculations are accurate
- **Comparative Analysis**: Validate cross-dimensional comparisons

## 📈 Business Use Cases

### Customer Analytics
```python
# Customer segmentation analysis
customer_segments = query_model('gld_active_customer_type_share')
segment_analysis = customer_segments.groupby(['brand', 'customer_type']).agg({
    'customer_count': 'sum',
    'percentage_share': 'mean'
})
```

### Fleet Analytics
```python
# Fleet utilization analysis
fleet_data = query_model('gld_cars_infleet_defleet_volume')
utilization_trends = fleet_data.groupby('date').agg({
    'active_fleet_size': 'sum',
    'infleet_volume': 'sum',
    'defleet_volume': 'sum'
})
```

### Operational Analytics
```python
# Delivery performance analysis
delivery_data = query_model('gld_city_weekly_delivery_increase')
performance_metrics = delivery_data.groupby('city').agg({
    'delivery_volume': 'sum',
    'growth_rate': 'mean'
})
```

## 🔄 Maintenance and Updates

### Regular Maintenance
- **Update Dependencies**: Keep notebook packages current
- **Refresh Analysis**: Update analysis with latest data
- **Validate Outputs**: Ensure notebook outputs remain accurate
- **Performance Optimization**: Optimize slow-running analyses

### Version Control
- **Clear Outputs**: Clear notebook outputs before committing
- **Documentation**: Keep notebook documentation current
- **Change Tracking**: Track significant changes to analysis logic
- **Collaboration**: Enable team collaboration on notebooks

## 📊 Best Practices

### Development
- **Clear Documentation**: Include comprehensive markdown documentation
- **Modular Code**: Break analysis into logical, reusable sections
- **Error Handling**: Include appropriate error handling and validation
- **Performance**: Optimize queries for large datasets

### Usage
- **Regular Execution**: Run notebooks regularly to catch issues
- **Validation**: Validate results against known benchmarks
- **Sharing**: Share insights with business stakeholders
- **Iteration**: Continuously improve analysis based on feedback

### Collaboration
- **Team Standards**: Establish team conventions for notebook development
- **Knowledge Sharing**: Share analytical techniques and insights
- **Code Review**: Review notebook changes for quality and accuracy
- **Documentation**: Maintain clear documentation for business users

## 🚨 Monitoring and Alerts

### Notebook Health
- **Execution Success**: Monitor notebook execution success rates
- **Data Quality**: Track data quality metrics from notebook analysis
- **Performance**: Monitor notebook execution time and resource usage
- **Output Validation**: Validate notebook outputs against expectations

### Business Insights
- **Anomaly Detection**: Use notebooks to identify business anomalies
- **Trend Monitoring**: Track business trends through notebook analysis
- **KPI Tracking**: Monitor key business metrics through interactive analysis
- **Alert Generation**: Generate alerts based on notebook findings

This notebooks directory provides powerful interactive analysis capabilities, enabling deep data exploration and validation that supports the entire DriveSight Analytics platform.
