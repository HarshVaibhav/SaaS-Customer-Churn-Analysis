# SaaS Customer Churn & Usage Analysis

A SQL Server + Power BI portfolio project analyzing customer churn, product engagement, support activity, subscription behavior, and churn reasons for a SaaS business.

## Business Objective

Identify the customer behaviors most strongly associated with churn and translate those findings into practical retention actions.

## Tools

- SQL Server / SSMS
- Power BI
- GitHub

## Dataset

The project uses five related SaaS datasets:

- Accounts
- Subscriptions
- Feature Usage
- Support Tickets
- Churn Events

## Analysis Approach

1. Validate data quality and referential integrity.
2. Analyze churn by plan tier and churn reason.
3. Aggregate product usage at the customer level.
4. Compare engagement between active and churned customers.
5. Analyze feature-level engagement gaps and error rates.
6. Evaluate support-ticket volume and satisfaction completeness.
7. Translate findings into retention recommendations.

## Key Findings

### Product engagement is the strongest signal

Average product usage was approximately:

| Status | Average Usage |
|---|---:|
| Active | 453.44 |
| Churned | 76.30 |

That is roughly a **5.9x difference**.

Exploratory usage bands showed a sharp change around 200 usage events:

| Usage Band | Churn Rate |
|---|---:|
| 0-49 | 100.00% |
| 50-99 | 98.46% |
| 100-149 | 84.93% |
| 150-199 | 51.22% |
| 200-299 | 4.76% |
| 300-399 | 0.00% |
| 400-499 | 0.00% |
| 500+ | 0.00% |

These thresholds are **dataset-specific exploratory signals**, not causal or universal benchmarks.

### Plan tier is a weaker differentiator

Observed churn rates:

- Enterprise: 30.48%
- Pro: 29.75%
- Basic: 27.50%

The relatively small spread suggests that engagement may be more actionable for retention than plan tier alone.

### Churn reasons vary by plan

The leading reason differed by plan:

- Basic: Budget
- Enterprise: Support
- Pro: Features

Overall, Features was the largest churn reason by event count and refund impact.

### Support activity is a weaker signal

Among accounts represented in the support-ticket analysis:

- Churned: ~4.07 tickets/account
- Active: ~3.89 tickets/account

The difference is small compared with the product-usage signal.

## Business Recommendations

1. Build a low-engagement early-warning segment.
2. Improve onboarding and product adoption.
3. Track activation milestones and time-to-value.
4. Tailor retention interventions to plan-specific churn reasons.
5. Validate engagement thresholds on future customer cohorts.

## Data Quality & Limitations

- Subscription data contains multiple lifecycle records per account, so analysis must respect data grain.
- Churn events represent historical churn-related activity and should not automatically be treated as subscription cancellations.
- 825 of 2,000 support tickets have no satisfaction score (41.25%); missing values should remain NULL.
- The analysis identifies associations, not causation.

## Repository Structure

```
SaaS-Customer-Churn-Analysis/
├── README.md
├── SQL/
│   ├── 01_Data_Quality_Audit.sql
│   ├── 02_Churn_Analysis.sql
│   ├── 03_Feature_Usage_Analysis.sql
│   ├── 04_Support_Analysis.sql
│   └── 05_Business_Insights.sql
├── PowerBI/
│   └── README.md
├── Screenshots/
│   └── README.md
└── Documentation/
    └── Business_Insights.md
```

## Project Status

**SQL analysis and documentation:** Complete  
**Power BI dashboard:** Next  
**Final dashboard screenshot:** Next

---

This project is designed as a portfolio case study demonstrating SQL analysis, data-quality validation, customer segmentation, business interpretation, and dashboard planning.
