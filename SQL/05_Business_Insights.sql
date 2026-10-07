/*
Project: SaaS Customer Churn & Usage Analysis
Purpose: Produce decision-oriented outputs for the portfolio dashboard.

Important: these results are observational. Low usage is associated with churn;
this analysis does not establish causation.
*/
USE SaaS_Project;
GO

WITH account_usage AS (
    SELECT s.account_id, s.churn_flag, SUM(fu.usage_count) AS total_usage
    FROM dbo.ravenstack_subscriptions s
    JOIN dbo.ravenstack_feature_usage fu ON s.subscription_id=fu.subscription_id
    GROUP BY s.account_id, s.churn_flag
)
SELECT churn_flag, COUNT(DISTINCT account_id) AS accounts,
       CAST(AVG(CAST(total_usage AS DECIMAL(18,2))) AS DECIMAL(18,2)) AS avg_usage,
       MIN(total_usage) AS min_usage, MAX(total_usage) AS max_usage
FROM account_usage
GROUP BY churn_flag;

SELECT plan_tier,
       COUNT(DISTINCT account_id) AS accounts,
       COUNT(DISTINCT CASE WHEN churn_flag=1 THEN account_id END) AS churned_accounts,
       CAST(100.0 * COUNT(DISTINCT CASE WHEN churn_flag=1 THEN account_id END)
            / NULLIF(COUNT(DISTINCT account_id),0) AS DECIMAL(10,2)) AS churn_rate_pct
FROM dbo.ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY churn_rate_pct DESC;

SELECT reason_code, COUNT(*) AS churn_events,
       COUNT(DISTINCT account_id) AS affected_accounts,
       CAST(SUM(refund_amount_usd) AS DECIMAL(12,2)) AS refund_impact_usd
FROM dbo.ravenstack_churn_events
GROUP BY reason_code
ORDER BY churn_events DESC, refund_impact_usd DESC;

WITH feature_usage_by_status AS (
    SELECT fu.feature_name, s.churn_flag,
           COUNT(DISTINCT s.account_id) AS accounts,
           SUM(fu.usage_count) AS total_usage
    FROM dbo.ravenstack_feature_usage fu
    JOIN dbo.ravenstack_subscriptions s ON fu.subscription_id=s.subscription_id
    GROUP BY fu.feature_name, s.churn_flag
),
feature_gap AS (
    SELECT feature_name,
           MAX(CASE WHEN churn_flag=0 THEN total_usage*1.0/NULLIF(accounts,0) END) AS active_usage_per_account,
           MAX(CASE WHEN churn_flag=1 THEN total_usage*1.0/NULLIF(accounts,0) END) AS churned_usage_per_account
    FROM feature_usage_by_status
    GROUP BY feature_name
)
SELECT TOP 10 feature_name,
       CAST(active_usage_per_account AS DECIMAL(10,2)) AS active_usage_per_account,
       CAST(churned_usage_per_account AS DECIMAL(10,2)) AS churned_usage_per_account,
       CAST(active_usage_per_account-churned_usage_per_account AS DECIMAL(10,2)) AS usage_gap
FROM feature_gap
WHERE active_usage_per_account IS NOT NULL
  AND churned_usage_per_account IS NOT NULL
ORDER BY usage_gap DESC;
