# SaaS Customer Churn & Usage Analysis

A SQL Server + Power BI portfolio project exploring customer churn, product engagement, support activity, subscription behavior, and churn reasons for a SaaS business.

## Business Objective

Identify customer behaviors associated with churn and translate findings into practical retention questions and actions.

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

The PBIX file is uploaded. A screenshot of the actual Power BI report will be added after final metric validation. Dashboard mockups are design references only and are not presented as actual report output.

## Validated Account-Level Metrics

The account table contains 500 accounts, of which 110 are flagged as churned, giving an account-level churn rate of 22%.

Usage was aggregated per account across its subscriptions and grouped by the account-level churn flag. Among accounts with usage records:

| Account status | Accounts with usage | Total usage | Average usage per account |
|---|---:|---:|---:|
| Active | 390 | 193,101 | 495.13 |
| Churned | 110 | 57,424 | 522.04 |
| Overall | 500 | 250,525 | 501.05 |

This analysis does not support the earlier claim that churned accounts have substantially lower usage. These usage results are descriptive and do not establish causation.

## Metric Definitions and Limitations

The headline KPI uses `ravenstack_accounts[churn_flag]`. Some SQL analyses use `ravenstack_subscriptions[churn_flag]`, which describes subscription lifecycle status. Because an account may have multiple subscription records, the definitions can disagree; 312 accounts have mixed subscription statuses in the current dataset.

Before final publication, validate:
1. Which status definition each visual uses.
2. How one plan tier is assigned to an account when multiple subscription records exist.
3. Whether churn-event joins duplicate event rows.
4. Whether slicers affect only visuals for which those dimensions have a defined relationship and meaning.

Churn events are historical churn-related activity and are not automatically equivalent to subscription cancellations. Refund amounts represent recorded refund impact, not necessarily revenue lost.

## Data Quality Notes

- Use Accounts for account-level denominators.
- Subscriptions contains multiple lifecycle records per account; don't count subscription rows as unique accounts.
- Feature Usage links to Subscriptions through `subscription_id`.
- 825 of 2,000 support tickets have no satisfaction score (41.25%); preserve missing values as NULL.

## Project Status

- SQL analysis scripts: prepared
- Power BI dashboard: uploaded
- Account-level usage benchmark: validated against SQL
- Plan-tier and churn-event grain review: remaining
- Actual Power BI screenshot: pending final validation
