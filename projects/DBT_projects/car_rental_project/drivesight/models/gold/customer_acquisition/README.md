# 👥 Customer Acquisition Analytics

This subdirectory contains gold-layer models focused on **customer acquisition, segmentation, and growth analytics** for FINN's car subscription business.

## 🎯 Business Focus

The Customer Acquisition domain provides insights into:
- **Customer Segmentation**: B2B vs B2C customer analysis
- **Market Share**: Brand and customer type distribution
- **Growth Patterns**: Customer acquisition trends over time
- **Product Preferences**: Subscription term preferences by customer segment
- **Strategic Planning**: Data for customer acquisition strategies

## 📊 Models Overview

### `gld_active_customer_type_share.sql`
**Purpose**: Analyze B2B vs B2C customer share by brand and time period

#### Key Metrics
- **Customer Type Distribution**: Percentage split between B2B and B2C customers
- **Brand Performance**: Customer share by brand (FINN, SIXT+)
- **Temporal Trends**: Month-over-month customer type evolution
- **Market Share**: Relative performance across customer segments

#### Dimensions
- **Time**: Monthly aggregation for trend analysis
- **Brand**: FINN vs SIXT+ brand comparison
- **Customer Type**: B2B (Business) vs B2C (Consumer) segmentation
- **Geography**: City-level customer distribution

#### Business Applications
- **Strategic Planning**: Understand customer mix and market positioning
- **Marketing Strategy**: Target acquisition efforts by customer type
- **Brand Performance**: Compare brand effectiveness across segments
- **Market Analysis**: Identify growth opportunities by segment

#### Sample Insights
- "B2B customers represent 35% of FINN's customer base in Berlin"
- "SIXT+ shows stronger B2C penetration compared to FINN"
- "B2B customer share increased 5% month-over-month"

---

### `gld_customer_type_distribution_per_term.sql`
**Purpose**: Analyze customer distribution across subscription terms by customer type

#### Key Metrics
- **Term Popularity**: Distribution of customers across subscription terms
- **Customer Preferences**: Term preferences by B2B vs B2C segments
- **Revenue Impact**: Customer volume by high-value term categories
- **Trend Analysis**: Evolution of term preferences over time

#### Dimensions
- **Subscription Terms**: 1-month, 3-month, 6-month, 12-month, 18-month, 24-month
- **Customer Type**: B2B vs B2C segmentation
- **Time Period**: Monthly trend analysis
- **Geography**: City-level term preferences

#### Business Applications
- **Product Strategy**: Optimize subscription term offerings
- **Pricing Strategy**: Understand price sensitivity by customer type
- **Inventory Planning**: Align fleet planning with term preferences
- **Customer Experience**: Tailor offerings to customer preferences

#### Sample Insights
- "B2B customers prefer longer terms (12+ months) representing 60% of B2B subscriptions"
- "B2C customers show preference for flexible short-term options (1-3 months)"
- "12-month terms are the most popular across both customer types"

## 🔄 Data Flow

```
Silver Layer Models
├── slv_customers (customer information)
├── slv_subscriptions (subscription details)
└── slv_cars (vehicle information)
    ↓
Customer Acquisition Analytics
├── gld_active_customer_type_share
└── gld_customer_type_distribution_per_term
    ↓
Business Intelligence & Reporting
```

## 🧪 Data Quality & Testing

### Validation Tests
- **Completeness**: Ensure all customer types are represented
- **Accuracy**: Validate percentage calculations sum to 100%
- **Consistency**: Cross-model metric alignment
- **Trend Logic**: Ensure logical month-over-month changes

### Business Logic Tests
- **Customer Type Validation**: Ensure only valid B2B/B2C values
- **Term Validation**: Verify subscription terms are within expected ranges
- **Date Consistency**: Validate time-based aggregations
- **Brand Consistency**: Ensure brand values match expected categories

## 📈 Key Performance Indicators (KPIs)

### Customer Mix KPIs
- **B2B Customer Share**: Percentage of total customers who are B2B
- **B2C Customer Share**: Percentage of total customers who are B2C
- **Customer Type Growth Rate**: Month-over-month growth by customer type
- **Brand Market Share**: Customer distribution across brands

### Product Preference KPIs
- **Term Distribution**: Customer percentage by subscription term
- **Average Term Length**: Mean subscription term by customer type
- **Term Preference Index**: Relative popularity of each term
- **Customer Lifetime Value by Term**: Revenue potential by term preference

## 🎯 Business Use Cases

### Strategic Planning
- **Market Positioning**: Understand competitive position in B2B vs B2C markets
- **Growth Strategy**: Identify high-potential customer segments
- **Resource Allocation**: Focus acquisition efforts on profitable segments

### Marketing & Sales
- **Campaign Targeting**: Tailor marketing messages by customer type
- **Sales Strategy**: Optimize sales approach for B2B vs B2C customers
- **Channel Strategy**: Align distribution channels with customer preferences

### Product Development
- **Term Optimization**: Adjust subscription term offerings based on demand
- **Feature Development**: Develop features that appeal to target segments
- **Pricing Strategy**: Optimize pricing for different customer types and terms

### Operations
- **Capacity Planning**: Align fleet capacity with customer demand patterns
- **Service Delivery**: Tailor service levels to customer type expectations
- **Inventory Management**: Stock vehicles based on customer preferences

## 🔄 Refresh Schedule

- **Frequency**: Monthly refresh
- **Dependencies**: Silver layer models must be updated first
- **Business Impact**: Critical for monthly business reviews and strategic planning
- **Data Freshness**: Reflects customer activity through the previous month

This customer acquisition analytics domain provides essential insights for understanding and optimizing FINN's customer base, supporting data-driven decisions for growth and market expansion.
