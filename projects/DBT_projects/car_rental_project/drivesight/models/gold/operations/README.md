# 🚛 Operations Analytics

This subdirectory contains gold-layer models focused on **fleet operations and delivery analytics** for FINN's car subscription business.

## 🎯 Business Focus

The Operations domain provides insights into:
- **Fleet Management**: Vehicle lifecycle and utilization tracking
- **Delivery Operations**: Delivery performance and growth analysis
- **Capacity Planning**: Fleet size optimization and demand forecasting
- **Operational Efficiency**: Performance metrics across cities and regions
- **Resource Optimization**: Data-driven operational decision making

## 📊 Models Overview

### `gld_cars_infleet_defleet_volume.sql`
**Purpose**: Track daily fleet volume changes and vehicle lifecycle management

#### Key Metrics
- **Fleet Size**: Total active vehicles by date and location
- **Infleet Volume**: Number of vehicles added to the fleet daily
- **Defleet Volume**: Number of vehicles removed from the fleet daily
- **Net Fleet Change**: Daily net change in fleet size
- **Fleet Utilization**: Active vs total fleet ratios

#### Dimensions
- **Date**: Daily granularity for operational monitoring
- **City**: Geographic fleet distribution
- **Brand**: Fleet composition by brand (FINN, SIXT+)
- **Vehicle Type**: Fleet breakdown by vehicle categories
- **Fleet Status**: Active, inactive, maintenance status

#### Business Applications
- **Capacity Planning**: Optimize fleet size based on demand patterns
- **Operational Monitoring**: Track daily fleet changes and anomalies
- **Resource Allocation**: Distribute vehicles efficiently across cities
- **Performance Management**: Monitor fleet utilization and efficiency

#### Sample Insights
- "Berlin fleet increased by 15 vehicles today (20 infleet, 5 defleet)"
- "Munich maintains 85% fleet utilization rate"
- "Weekend defleet volume typically 40% lower than weekdays"

---

### `gld_city_weekly_delivery_increase.sql`
**Purpose**: Analyze weekly delivery growth and performance by city

#### Key Metrics
- **Delivery Volume**: Total deliveries per city per week
- **Growth Rate**: Week-over-week delivery growth percentage
- **Performance Index**: Relative delivery performance across cities
- **Trend Analysis**: Multi-week delivery trend patterns
- **Market Penetration**: Delivery density and market coverage

#### Dimensions
- **Week**: Weekly aggregation for trend analysis
- **City**: Geographic performance comparison
- **Delivery Type**: Different delivery service categories
- **Customer Segment**: B2B vs B2C delivery patterns
- **Service Level**: Standard vs premium delivery options

#### Business Applications
- **Market Expansion**: Identify high-growth cities for investment
- **Performance Monitoring**: Track delivery efficiency across markets
- **Resource Planning**: Allocate delivery resources based on growth patterns
- **Competitive Analysis**: Understand market position by geography

#### Sample Insights
- "Hamburg shows 25% week-over-week delivery growth"
- "Berlin maintains consistent delivery volume with 5% steady growth"
- "Frankfurt delivery volume doubled in the last 4 weeks"

## 🔄 Data Flow

```
Silver Layer Models
├── slv_cars (vehicle fleet data)
├── slv_subscriptions (delivery/subscription data)
└── slv_customers (customer location data)
    ↓
Operations Analytics
├── gld_cars_infleet_defleet_volume
└── gld_city_weekly_delivery_increase
    ↓
Operational Dashboards & Monitoring
```

## 🧪 Data Quality & Testing

### Validation Tests
- **Volume Consistency**: Ensure infleet/defleet volumes are logical
- **Date Continuity**: Validate continuous date series without gaps
- **Geographic Completeness**: Ensure all operational cities are included
- **Growth Rate Logic**: Validate growth calculations and percentages

### Business Logic Tests
- **Fleet Balance**: Ensure fleet size calculations are accurate
- **Delivery Volumes**: Validate delivery counts and aggregations
- **Trend Consistency**: Ensure logical week-over-week patterns
- **City Coverage**: Verify all operational cities are represented

## 📈 Key Performance Indicators (KPIs)

### Fleet Management KPIs
- **Fleet Utilization Rate**: Percentage of active vehicles in total fleet
- **Average Fleet Size**: Mean number of vehicles across time periods
- **Fleet Turnover Rate**: Frequency of infleet/defleet activities
- **Fleet Growth Rate**: Net fleet expansion over time

### Delivery Operations KPIs
- **Delivery Growth Rate**: Week-over-week delivery volume growth
- **City Performance Index**: Relative delivery performance ranking
- **Market Penetration Rate**: Delivery density per city population
- **Service Level Achievement**: Delivery performance against targets

### Operational Efficiency KPIs
- **Vehicle Utilization**: Average usage per vehicle
- **Geographic Coverage**: Number of cities with active operations
- **Capacity Utilization**: Fleet capacity vs demand ratio
- **Operational Scalability**: Growth rate sustainability metrics

## 🎯 Business Use Cases

### Fleet Management
- **Capacity Planning**: Optimize fleet size based on demand forecasts
- **Vehicle Allocation**: Distribute vehicles efficiently across cities
- **Lifecycle Management**: Plan vehicle acquisition and disposal
- **Utilization Optimization**: Maximize vehicle usage and revenue

### Delivery Operations
- **Performance Monitoring**: Track delivery efficiency and growth
- **Market Expansion**: Identify opportunities for geographic expansion
- **Resource Planning**: Allocate delivery resources based on demand
- **Service Optimization**: Improve delivery speed and reliability

### Strategic Planning
- **Market Analysis**: Understand operational performance by geography
- **Investment Decisions**: Data-driven expansion and resource allocation
- **Competitive Positioning**: Benchmark performance against market standards
- **Growth Strategy**: Plan sustainable operational scaling

### Operational Excellence
- **Daily Monitoring**: Real-time operational performance tracking
- **Anomaly Detection**: Identify and respond to operational issues
- **Efficiency Improvement**: Optimize processes based on data insights
- **Cost Management**: Monitor and control operational costs

## 🔄 Refresh Schedule

### Daily Models (`gld_cars_infleet_defleet_volume`)
- **Frequency**: Daily refresh
- **Business Impact**: Critical for daily operational monitoring
- **Data Freshness**: Reflects fleet changes through previous day
- **Usage**: Operations teams, fleet managers, daily dashboards

### Weekly Models (`gld_city_weekly_delivery_increase`)
- **Frequency**: Weekly refresh (typically Monday for previous week)
- **Business Impact**: Important for weekly performance reviews
- **Data Freshness**: Complete week-over-week analysis
- **Usage**: Regional managers, strategic planning, growth analysis

## 🚨 Operational Alerts

### Fleet Alerts
- **Unusual Fleet Changes**: Significant infleet/defleet volume anomalies
- **Utilization Drops**: Fleet utilization below threshold levels
- **Geographic Imbalances**: Uneven fleet distribution across cities

### Delivery Alerts
- **Growth Anomalies**: Unexpected delivery volume changes
- **Performance Degradation**: Declining delivery performance metrics
- **Market Opportunities**: Cities showing exceptional growth potential

This operations analytics domain provides essential insights for managing FINN's fleet and delivery operations, enabling data-driven decisions for operational efficiency and growth.
