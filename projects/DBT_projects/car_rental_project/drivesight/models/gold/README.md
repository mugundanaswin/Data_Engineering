# 🥇 Gold Layer

The Gold layer represents the **business-ready analytics** stage of our medallion architecture. This layer contains aggregated metrics, KPIs, and business intelligence models that directly support decision-making and reporting.

## 🎯 Purpose

- **Business Metrics**: Create KPIs and aggregated analytics for business users
- **Decision Support**: Provide data for strategic and operational decisions
- **Reporting Ready**: Models optimized for BI tools and dashboards
- **Domain-Specific Analytics**: Organized by business functional areas
- **Performance Optimized**: Pre-aggregated for fast query performance

## 📁 Business Domains

### 👥 Customer Acquisition (`customer_acquisition/`)
**Focus**: Customer growth, segmentation, and acquisition analytics

#### `gld_active_customer_type_share.sql`
**Purpose**: B2B vs B2C customer share analysis by brand and time period
- **Metrics**: Customer type distribution, market share percentages
- **Dimensions**: Brand, month, customer type (B2B/B2C)
- **Business Use**: Market segmentation analysis, customer mix tracking
- **Refresh**: Monthly

#### `gld_customer_type_distribution_per_term.sql`
**Purpose**: Customer segmentation analysis by subscription terms
- **Metrics**: Customer distribution across different subscription terms
- **Dimensions**: Customer type, subscription term, time period
- **Business Use**: Product preference analysis, term popularity tracking
- **Refresh**: Monthly

### 🚛 Operations (`operations/`)
**Focus**: Fleet management and delivery operations analytics

#### `gld_cars_infleet_defleet_volume.sql`
**Purpose**: Daily fleet volume tracking and lifecycle management
- **Metrics**: Fleet size, infleet/defleet volumes, net changes
- **Dimensions**: Date, city, brand, fleet status
- **Business Use**: Fleet utilization analysis, capacity planning
- **Refresh**: Daily

#### `gld_city_weekly_delivery_increase.sql`
**Purpose**: Weekly delivery growth analysis by city
- **Metrics**: Delivery volume, growth rates, performance indicators
- **Dimensions**: City, week, delivery type
- **Business Use**: Market performance tracking, expansion planning
- **Refresh**: Weekly

## 🔧 Model Characteristics

### Aggregation Strategy
- **Pre-Aggregated**: Data is summarized for optimal query performance
- **Time-Based**: Most models include time-based aggregations
- **Multi-Dimensional**: Support various analytical perspectives
- **Parameterized**: Configurable date ranges and filters

### Performance Optimization
- **Materialized Tables**: Fast query response times
- **Indexed**: Optimized for common query patterns
- **Partitioned**: Efficient data access by time periods
- **Compressed**: Optimized storage for large datasets

### Business Logic
- **KPI Calculations**: Standard business metrics and ratios
- **Trend Analysis**: Period-over-period comparisons
- **Segmentation**: Customer and operational segmentation
- **Forecasting Ready**: Data structured for predictive analytics

## 🏷️ Naming Convention

All gold models follow the pattern: `gld_<metric_description>`

## 🔗 Dependencies

### Upstream Dependencies
- **Silver Layer**: All gold models depend on cleaned silver data
- **Macros**: Business calculation functions
- **Date Utilities**: Time-based calculation helpers

### Downstream Usage
- **BI Dashboards**: Direct consumption by visualization tools
- **Reports**: Automated reporting systems
- **APIs**: Data service endpoints
- **Analytics**: Advanced analytics and ML pipelines

## 🧪 Testing Strategy

Comprehensive testing defined in `schema.yml`:

### Business Logic Tests
- **Metric Accuracy**: Validate calculation correctness
- **Completeness**: Ensure all expected data is present
- **Consistency**: Cross-model metric alignment
- **Trend Validation**: Logical trend patterns

### Data Quality Tests
- **Non-Negative Values**: Ensure metrics are logically valid
- **Date Consistency**: Validate time-based calculations
- **Aggregation Accuracy**: Verify sum/count calculations
- **Referential Integrity**: Ensure proper joins and relationships

## 📊 Usage Guidelines

### Business Users
- **Direct Querying**: Models are optimized for business user queries
- **Dashboard Integration**: Ready for BI tool consumption
- **Self-Service Analytics**: Documented and user-friendly
- **Export Ready**: Suitable for Excel and other tools

### Technical Users
- **API Integration**: Structured for programmatic access
- **Further Aggregation**: Can be used as base for additional metrics
- **Data Science**: Ready for advanced analytics workflows
- **Monitoring**: Suitable for operational monitoring systems

### Performance Considerations
- **Query Optimization**: Pre-aggregated for fast response times
- **Resource Efficiency**: Optimized compute and storage usage
- **Scalability**: Designed to handle growing data volumes
- **Refresh Strategy**: Balanced between freshness and performance

## 🔄 Refresh Strategy

### Daily Models
- **Fleet Operations**: Updated daily for operational monitoring
- **Real-time Metrics**: Near real-time business indicators

### Weekly Models
- **Delivery Analytics**: Weekly aggregations for trend analysis
- **Performance Reviews**: Weekly business performance metrics

### Monthly Models
- **Customer Analytics**: Monthly customer behavior analysis
- **Strategic Metrics**: Long-term trend and planning metrics

## 📈 Business Impact

The Gold layer directly supports:
- **Executive Dashboards**: C-level reporting and KPIs
- **Operational Monitoring**: Day-to-day business operations
- **Strategic Planning**: Long-term business strategy decisions
- **Performance Management**: Team and regional performance tracking
- **Customer Insights**: Customer behavior and segmentation analysis

This layer represents the culmination of our data transformation pipeline, providing business-ready analytics that drive decision-making across the organization.
