/*
Project: SaaS Customer Churn & Usage Analysis
Purpose: Analyze churn by plan, reason, and customer engagement.
*/
USE SaaS_Project;
GO

SELECT plan_tier,
       COUNT(DISTINCT account_id) AS accounts,
       COUNT(DISTINCT CASE WHEN churn_flag=1 THEN account_id END) AS churned_accounts,
       CAST(100.0 * COUNT(DISTINCT CASE WHEN churn_flag=1 THEN account_id END)
            / NULLIF(COUNT(DISTINCT account_id),0) AS DECIMAL(10,2)) AS churn_rate_pct
FROM dbo.ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY churn_rate_pct DESC;

SELECT reason_code,
       COUNT(*) AS churn_events,
       COUNT(DISTINCT account_id) AS affected_accounts,
       CAST(SUM(refund_amount_usd) AS DECIMAL(12,2)) AS refund_impact_usd,
       CAST(SUM(refund_amount_usd)/NULLIF(COUNT(DISTINCT account_id),0)
            AS DECIMAL(12,2)) AS refund_per_affected_account
FROM dbo.ravenstack_churn_events
GROUP BY reason_code
ORDER BY churn_events DESC;

SELECT s.plan_tier, ce.reason_code, COUNT(*) AS churn_events,
       CAST(100.0 * COUNT(*) /
            NULLIF(SUM(COUNT(*)) OVER(PARTITION BY s.plan_tier),0)
            AS DECIMAL(10,2)) AS reason_share_pct
FROM dbo.ravenstack_churn_events ce
JOIN dbo.ravenstack_subscriptions s ON ce.account_id=s.account_id
GROUP BY s.plan_tier, ce.reason_code
ORDER BY s.plan_tier, churn_events DESC;

WITH account_usage AS (
    SELECT s.account_id, s.churn_flag, SUM(fu.usage_count) AS total_usage
    FROM dbo.ravenstack_subscriptions s
    JOIN dbo.ravenstack_feature_usage fu ON s.subscription_id=fu.subscription_id
    GROUP BY s.account_id, s.churn_flag
)
SELECT churn_flag,
       COUNT(DISTINCT account_id) AS accounts,
       MIN(total_usage) AS min_usage,
       MAX(total_usage) AS max_usage,
       CAST(AVG(CAST(total_usage AS DECIMAL(18,2))) AS DECIMAL(18,2)) AS avg_usage
FROM account_usage
GROUP BY churn_flag
ORDER BY churn_flag;

WITH account_usage AS (
    SELECT s.account_id, s.churn_flag, SUM(fu.usage_count) AS total_usage
    FROM dbo.ravenstack_subscriptions s
    JOIN dbo.ravenstack_feature_usage fu ON s.subscription_id=fu.subscription_id
    GROUP BY s.account_id, s.churn_flag
),
usage_bands AS (
    SELECT account_id, churn_flag, total_usage,
           CASE
             WHEN total_usage < 50 THEN '0-49'
             WHEN total_usage < 100 THEN '50-99'
             WHEN total_usage < 150 THEN '100-149'
             WHEN total_usage < 200 THEN '150-199'
             WHEN total_usage < 300 THEN '200-299'
             WHEN total_usage < 400 THEN '300-399'
             WHEN total_usage < 500 THEN '400-499'
             ELSE '500+'
           END AS usage_band
    FROM account_usage
)
SELECT usage_band,
       COUNT(DISTINCT account_id) AS accounts,
       COUNT(DISTINCT CASE WHEN churn_flag=1 THEN account_id END) AS churned_accounts,
       CAST(100.0 * COUNT(DISTINCT CASE WHEN churn_flag=1 THEN account_id END)
            / NULLIF(COUNT(DISTINCT account_id),0) AS DECIMAL(10,2)) AS churn_rate_pct
FROM usage_bands
GROUP BY usage_band
ORDER BY MIN(total_usage);
