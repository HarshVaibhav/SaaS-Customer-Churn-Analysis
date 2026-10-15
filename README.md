# SaaS Customer Churn & Usage Analysis

> SQL Server + Power BI portfolio project analyzing customer churn, product usage, support activity, subscription behavior, and churn-related events.

## Business Objective

Identify patterns associated with customer churn and translate the analysis into practical retention questions and business actions.

## Tech Stack

- **SQL Server / SSMS** — data preparation and analysis
- **Power BI** — dashboarding and interactive analysis
- **DAX** — analytical measures
- **GitHub** — version control and portfolio presentation

## Data Model

The project uses five related datasets: Accounts, Subscriptions, Feature Usage, Support Tickets, and Churn Events.

## Repository Contents

| Path | Purpose |
|---|---|
| SQL/ | SQL analysis and business queries |
| Dataset/ | Source CSV datasets used in the analysis |
| PowerBI/SaaS_Churn_Dashboard.pbix | Power BI report |
| PowerBI/README.md | Report/model notes |
| Documentation/Business_Insights.md | Business findings |
| Screenshots/ | Dashboard visuals |

## Power BI Dashboard

The report covers:

- Total accounts
- Churned accounts
- Account-level churn rate
- Churn rate by plan tier
- Churn events by reason
- Product usage by customer status
- Plan-tier and billing-frequency analysis

## Validated Account-Level Metrics

The account table contains **500 accounts**, including **110 churned accounts**, resulting in an **account-level churn rate of 22%**.

Usage was aggregated per account and grouped using the account-level churn flag:

| Account status | Accounts with usage | Total usage | Average usage per account |
|---|---:|---:|---:|
| Active | 390 | 193,101 | 495.13 |
| Churned | 110 | 57,424 | 522.04 |
| Overall | 500 | 250,525 | 501.05 |

These figures are descriptive. They do not establish that usage causes or prevents churn.

## Metric Definitions & Limitations

The headline account-level KPI uses ravenstack_accounts[churn_flag]. Some SQL analyses use ravenstack_subscriptions[churn_flag], which represents subscription lifecycle status.

Because one account can have multiple subscription records, the two definitions can differ. The current dataset contains **312 accounts with mixed subscription statuses**.

Before extending the analysis, validate:

1. Which status definition each visual uses.
2. How plan tier is assigned when an account has multiple subscription records.
3. Whether churn-event joins can duplicate event rows.
4. Whether slicers affect only visuals for which the relationship and business meaning are defined.

Churn events are historical churn-related activity and are not automatically equivalent to subscription cancellation. Refund amounts represent recorded refund impact and should not automatically be interpreted as revenue lost.

## Data Quality Notes

- Use **Accounts** for account-level denominators.
- Do not count subscription rows as unique accounts.
- Feature Usage links to Subscriptions through subscription_id.
- **825 of 2,000 support tickets (41.25%)** have no satisfaction score; missing values should remain NULL.

## Project Status

- SQL analysis: prepared
- Power BI dashboard: uploaded
- Account-level usage benchmark: validated
- Core KPI definitions: documented
- Plan-tier and churn-event grain: requires continued validation before making stronger business claims

## Key Takeaway

The project demonstrates an end-to-end analytics workflow:

**Data quality → SQL analysis → metric validation → Power BI modeling → dashboard storytelling**
