# SaaS Customer Churn & Usage Analysis

A SQL Server + Power BI portfolio project exploring customer churn, product engagement, support activity, subscription behavior, and churn reasons for a SaaS business.

## Business Objective

Identify behaviors associated with churn and translate the findings into practical retention actions.

## Tools

- SQL Server / SQL Server Management Studio
- Power BI
- DAX
- GitHub

## Dataset

The analysis uses five related datasets: Accounts, Subscriptions, Feature Usage, Support Tickets, and Churn Events.

## SQL Analysis

The SQL scripts cover data-quality checks, churn patterns, feature usage, support activity, and business insights. They are available in [SQL](SQL/).

## Power BI Dashboard

The current report includes:
- KPI cards for total accounts, churned accounts, and account-level churn rate
- Churn rate by plan tier
- Churn events by reason
- Average product usage by customer status
- Slicers for plan tier and billing frequency

The PBIX file and a full-resolution screenshot should be added to the PowerBI and Screenshots folders.

## Key SQL Findings

### Product engagement is a strong churn signal

In the subscription-status usage analysis, average usage was approximately:

| Status | Average Usage |
|---|---:|
| Active | 453.44 |
| Churned | 76.30 |

This is roughly a 5.9x difference. Exploratory usage bands also showed much higher churn among low-usage groups. These are associations in this dataset, not proof that low usage causes churn.

### Plan tier is a weaker differentiator

Observed SQL churn rates were approximately:
- Enterprise: 30.48%
- Pro: 29.75%
- Basic: 27.50%

### Churn reasons vary by plan

- Basic: Budget was the leading reason
- Enterprise: Support was the leading reason
- Pro: Features was the leading reason

Overall, Features was the largest churn reason by event count and refund impact.

### Support activity is a weaker signal

Among accounts represented in the support-ticket analysis, churned customers averaged about 4.07 tickets per account versus 3.89 for active customers.

## Important Metric Definitions

The Power BI overview currently uses the churn_flag in ravenstack_accounts for its headline account-level KPI: 110 flagged accounts out of 500 (22%). Some SQL analyses use churn_flag in ravenstack_subscriptions and therefore measure subscription lifecycle status at a different grain. These figures are not directly comparable until the project defines and applies one consistent customer-status rule across visuals.

Churn events are historical churn-related activity and should not automatically be interpreted as subscription cancellations. Subscription data contains multiple lifecycle records per account. The analysis identifies associations, not causation.

## Data Quality & Limitations

- Subscription data contains multiple lifecycle records per account; preserve the correct grain in joins and aggregations.
- Feature usage connects to subscriptions through subscription_id.
- 825 of 2,000 support tickets have no satisfaction score (41.25%); missing values should remain NULL.
- Churn events do not always match subscription cancellation flags.
- Exploratory usage thresholds should be validated on future customer cohorts.

## Repository Structure

- README.md
- SQL/ (five analysis scripts)
- PowerBI/ (dashboard file and instructions)
- Screenshots/ (dashboard screenshot)
- Documentation/ (business insights)

## Project Status

- SQL analysis and business insights: complete
- Power BI dashboard: created; final metric reconciliation and visual polish remain
- GitHub binary dashboard and screenshot upload: pending

---
