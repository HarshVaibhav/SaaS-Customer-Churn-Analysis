# Business Insights

## Executive summary

The project currently reports account-level churn separately from subscription lifecycle churn. These measures use different grains and should not be combined into one headline conclusion. The validated account-level churn rate is 22% (110 of 500 accounts).

## Validated account-level product usage

Usage was aggregated across each account's subscriptions, then grouped using `ravenstack_accounts[churn_flag]`. Accounts without matching feature-usage records are excluded from this comparison.

| Account status | Accounts with usage | Total usage | Average usage per account |
|---|---:|---:|---:|
| Active | 390 | 193,101 | 495.13 |
| Churned | 110 | 57,424 | 522.04 |
| Overall | 500 | 250,525 | 501.05 |

In this account-level comparison, flagged churned accounts have approximately 5.4% higher average usage than active accounts. This does **not** support the earlier claim that churned customers use the product substantially less. It is an association in this dataset, not evidence of causation.

## Subscription-level plan analysis

An earlier SQL analysis reported these plan-level subscription-status rates:

- Enterprise: approximately 30.48%
- Pro: approximately 29.75%
- Basic: approximately 27.50%

These are subscription-table results and should not be presented as account-level churn rates unless the plan assignment and account-level status logic are standardized. The spread is modest, but the metric definition must be clearly labeled.

## Churn reasons

Churn-event records describe historical churn-related activity. Earlier analysis found that the leading recorded reason varied by plan (Basic: Budget; Enterprise: Support; Pro: Features) and that Features was a leading overall reason by event count. These results should be validated for duplicate event rows before being presented as unique customer cancellations.

Refund amounts represent recorded refund impact, not necessarily total revenue lost.

## Support activity

An earlier analysis found only a small difference in average ticket counts between groups classified using subscription-derived status. Recalculate this comparison using the account-level churn definition before using it as an account-level conclusion.

## Recommendations

1. Keep account-level KPIs anchored to `ravenstack_accounts[churn_flag]`.
2. Label subscription lifecycle metrics explicitly as subscription-level.
3. Define a single plan assignment rule per account before reporting account churn by plan.
4. Count churn events at event grain and avoid joins that multiply event rows.
5. Investigate customer behavior with cohort and time-based analysis before making causal claims.

## Data limitations

- The subscriptions table contains multiple lifecycle records per account, and 312 accounts have mixed subscription status flags.
- Account-level and subscription-level churn flags disagree for many accounts; they are not interchangeable.
- Churn events are not automatically equivalent to subscription cancellations.
- Support satisfaction is missing for 825 of 2,000 tickets (41.25%); preserve missing values as NULL.
- Results are observational and should not be interpreted as causal evidence.
