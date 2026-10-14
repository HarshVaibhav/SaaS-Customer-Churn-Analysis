# SaaS Customer Churn & Usage Analysis

A SQL Server + Power BI portfolio project exploring customer churn, product engagement, support activity, subscription behavior, and churn reasons for a SaaS business.

## Business Objective

Identify customer behaviors associated with churn and translate the findings into practical retention actions.

## Tools

- SQL Server / SQL Server Management Studio
- Power BI and DAX
- GitHub

## Dataset

The project uses five related datasets: Accounts, Subscriptions, Feature Usage, Support Tickets, and Churn Events.

## Repository Contents

- [SQL analysis scripts](SQL/) — data quality, churn, feature usage, support, and business insights
- [Power BI dashboard file](PowerBI/SaaS_Churn_Dashboard.pbix)
- [Power BI model and report notes](PowerBI/README.md)
- [Business insights](Documentation/Business_Insights.md)
- [Dashboard screenshots folder](Screenshots/)

## Power BI Dashboard

The report includes:
- KPI cards for total accounts, churned accounts, and account-level churn rate
- Churn rate by plan tier
- Churn events by reason
- Average product usage by customer status
- Slicers for plan tier and billing frequency

The PBIX file is uploaded. A screenshot of the actual Power BI report will be added after final metric validation. Earlier dashboard mockups are design references only and are not presented as actual report output.

## Metric Definitions and Reconciliation

The headline account-level KPI currently uses `ravenstack_accounts[churn_flag]`: 110 flagged accounts out of 500 (22%). Subscription analyses use `ravenstack_subscriptions[churn_flag]`, which describes subscription lifecycle status and can produce different totals because an account may have multiple subscription records.

These measures must not be compared as if they share the same grain. Before treating the report as final, validate:
1. Which status definition each visual uses.
2. Whether account-level status filters usage through Subscriptions to Feature Usage.
3. How one plan tier is assigned to an account when multiple subscription records exist.
4. Whether joining churn events to subscriptions duplicates event rows.

Churn events are historical churn-related records and are not automatically equivalent to subscription cancellations. Usage/churn relationships are observational and do not prove causation.

## Data Quality Notes

- The Accounts table has 500 accounts and should be the source for account-level denominators.
- Subscriptions contains multiple lifecycle records per account; don't count subscription rows as unique accounts.
- Feature Usage links to Subscriptions through `subscription_id`.
- 825 of 2,000 support tickets have no satisfaction score (41.25%); preserve missing values as NULL.
- Churn-event counts and refund amounts describe event activity, not necessarily unique cancellations or lost revenue.

## Project Status

- SQL analysis scripts: prepared; metric-grain review in progress
- Power BI dashboard: uploaded
- Account-versus-subscription metric reconciliation: in progress
- Actual Power BI screenshot: pending final validation

