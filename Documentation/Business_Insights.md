# Business Insights

## Executive finding

Product engagement is the strongest signal identified in this dataset. Churned customers show substantially lower product usage than active customers.

## Key findings

### Product usage and churn
Average usage was approximately 453.44 for active customers versus 76.30 for churned customers, a difference of roughly 5.9x.

Exploratory usage bands showed a sharp change around 200 usage:
- 0-49: 100.00% churn
- 50-99: 98.46%
- 100-149: 84.93%
- 150-199: 51.22%
- 200-299: 4.76%
- 300-399: 0.00%
- 400-499: 0.00%
- 500+: 0.00%

These thresholds are exploratory and should be validated on future cohorts.

### Plan tier
Observed churn rates were approximately:
- Enterprise: 30.48%
- Pro: 29.75%
- Basic: 27.50%

The spread is modest compared with the engagement difference.

### Churn reasons
The leading reason differed by plan:
- Basic: Budget
- Enterprise: Support
- Pro: Features

Overall, Features was the largest churn reason by event count and refund impact.

### Support
Among accounts represented in the ticket analysis, churned customers averaged about 4.07 tickets per account versus 3.89 for active customers. The difference is small.

## Recommendations

1. Flag persistently low-engagement customers as an early-warning segment.
2. Improve onboarding and feature adoption.
3. Track activation milestones and time-to-value.
4. Tailor retention messaging by plan and churn reason.
5. Validate usage thresholds on new customer cohorts before operationalizing them.

## Data limitations

- The subscriptions table contains multiple lifecycle records per account.
- Churn events are historical churn-related events and are not automatically equivalent to subscription cancellation.
- Support satisfaction is missing for 825 of 2,000 tickets (41.25%).
- Missing satisfaction values should remain NULL rather than being imputed as zero.
- The analysis identifies associations, not causation.
