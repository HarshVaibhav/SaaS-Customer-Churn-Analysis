# Power BI Dashboard

## Report File

[Open SaaS_Churn_Dashboard.pbix](SaaS_Churn_Dashboard.pbix)

## Current Visuals

- KPI cards: Total Accounts, Churned Accounts, and Churn Rate
- Churn rate by plan tier
- Churn events by reason
- Average product usage by customer status
- Slicers for plan tier and billing frequency

## Validated Account-Level Metrics

Use `ravenstack_accounts[churn_flag]` for account-level totals and churn rate: 110 flagged accounts out of 500 (22%).

The account-level usage benchmark (accounts without usage excluded) is:

| Account status | Accounts with usage | Total usage | Average usage per account |
|---|---:|---:|---:|
| Active | 390 | 193,101 | 495.13 |
| Churned | 110 | 57,424 | 522.04 |
| Overall | 500 | 250,525 | 501.05 |

The usage measure should aggregate usage across subscriptions per account and group accounts using the account table's churn flag. Do not infer that lower usage causes churn from these results.

## Remaining Metric Checks

1. **Churn by plan tier:** confirm whether the visual measures churned accounts or churned subscriptions. For account-level churn by plan, define a single plan assignment per account (for example, latest subscription by start date) and use the account-level churn flag.
2. **Churn events by reason:** count rows from the Churn Events table at event grain. Joining directly to Subscriptions by `account_id` can duplicate events when an account has multiple subscription records.
3. **Slicers:** confirm plan and billing slicers filter only visuals for which those dimensions have a defined relationship and meaning.
4. **Visual validation:** clear slicers and compare values against the SQL benchmarks above.

## Model Relationships

- Accounts to Subscriptions: `account_id` (one-to-many)
- Subscriptions to Feature Usage: `subscription_id` (one-to-many)
- Accounts to Support Tickets: `account_id` (one-to-many)
- Accounts to Churn Events: `account_id` (one-to-many)

Keep single-direction filtering where practical and avoid joins that duplicate counts across different grains.

## Final Validation Checklist

- [x] Validate account-level churn KPI.
- [x] Validate account-level usage aggregation against SQL.
- [ ] Verify plan-level status and the plan assignment rule.
- [ ] Ensure churn-event counts are not multiplied by subscription joins.
- [ ] Check slicers and displayed values against SQL outputs.
- [ ] Capture a screenshot of the actual report and save it as `Screenshots/dashboard.png`.
