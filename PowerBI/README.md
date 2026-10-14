# Power BI Dashboard

## Report File

[Open SaaS_Churn_Dashboard.pbix](SaaS_Churn_Dashboard.pbix)

## Current Visuals

- KPI cards: Total Accounts, Churned Accounts, and Churn Rate
- Churn rate by plan tier
- Churn events by reason
- Average product usage by customer status
- Slicers for plan tier and billing frequency

## Metric Definitions

### Account-level KPIs

Use `ravenstack_accounts[churn_flag]` for account-level totals and churn rate. Current source counts are 110 flagged accounts out of 500 (22%).

### Subscription-level analysis

`ravenstack_subscriptions[churn_flag]` represents subscription lifecycle status. Since an account can have multiple subscription records, subscription-level results may differ from account-level KPIs. Label subscription-level visuals accordingly and do not compare their denominators directly with the account KPI.

### Visuals requiring validation

1. **Churn by plan tier:** confirm whether the visual measures churned accounts or churned subscriptions. If reporting account churn by plan, define a single plan assignment per account (for example, the latest subscription by start date) and use the account-level churn flag.
2. **Usage by customer status:** aggregate usage to the account level and group accounts using `ravenstack_accounts[churn_flag]`. Avoid grouping the same account into both subscription status categories.
3. **Churn events by reason:** count rows from the Churn Events table at event grain. Joining directly to Subscriptions by `account_id` can duplicate events when an account has multiple subscription records.
4. **Slicers:** confirm plan and billing slicers filter only visuals for which those dimensions have a defined relationship and meaning.

## Model Relationships

- Accounts to Subscriptions: `account_id` (one-to-many)
- Subscriptions to Feature Usage: `subscription_id` (one-to-many)
- Accounts to Support Tickets: `account_id` (one-to-many)
- Accounts to Churn Events: `account_id` (one-to-many)

Keep single-direction filtering where practical and avoid joins that duplicate counts across different grains.

## Final Validation Checklist

- [ ] Reconcile account-level and subscription-level churn definitions.
- [ ] Confirm usage is aggregated per account and status comes from Accounts.
- [ ] Verify plan-level status and the plan assignment rule.
- [ ] Ensure churn-event counts are not multiplied by subscription joins.
- [ ] Check slicers and all displayed values against SQL outputs.
- [ ] Capture a screenshot of the actual report and save it as `Screenshots/dashboard.png`.
