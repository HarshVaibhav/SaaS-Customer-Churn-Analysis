# Power BI Dashboard

## Current Report

Expected file: SaaS_Churn_Dashboard.pbix

The report currently contains:
- KPI cards: Total Accounts, Churned Accounts, and Churn Rate
- Churn rate by plan tier
- Churn events by reason
- Average product usage by customer status
- Slicers for plan tier and billing frequency

## Important Metric Note

The headline KPI currently uses ravenstack_accounts[churn_flag]: 110 flagged accounts out of 500 (22%). Some SQL analyses use ravenstack_subscriptions[churn_flag], which represents subscription lifecycle status and can produce different totals. Do not compare these figures as if they share the same denominator or status definition. Before adding more visuals, standardize the customer-status definition and make sure every KPI and chart uses the intended grain.

The average-usage chart should also be validated against that same status definition. Similar bars are not automatically a DAX error; they can reflect a mismatch between account-level status and subscription-level status.

## Model Relationships

- Accounts to Subscriptions: account_id (one-to-many)
- Subscriptions to Feature Usage: subscription_id (one-to-many)
- Accounts to Support Tickets: account_id (one-to-many)
- Accounts to Churn Events: account_id (one-to-many)

Keep single-direction filtering where practical and avoid joining tables at different grains in ways that duplicate account counts.

## Before Publishing

1. Confirm all KPI definitions and denominators.
2. Validate average usage by status using one consistent status definition.
3. Check slicers affect only the intended visuals.
4. Save the report as SaaS_Churn_Dashboard.pbix.
5. Add a clean screenshot at Screenshots/dashboard.png.
