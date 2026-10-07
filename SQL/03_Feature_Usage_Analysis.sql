/*
Project: SaaS Customer Churn & Usage Analysis
Purpose: Identify product-engagement patterns associated with churn.
*/
USE SaaS_Project;
GO

SELECT feature_name,
       COUNT(DISTINCT subscription_id) AS subscriptions_using_feature,
       SUM(usage_count) AS total_usage,
       SUM(error_count) AS total_errors,
       CAST(100.0 * SUM(error_count)/NULLIF(SUM(usage_count),0)
            AS DECIMAL(10,2)) AS error_rate_pct
FROM dbo.ravenstack_feature_usage
GROUP BY feature_name
ORDER BY total_usage DESC;

SELECT fu.feature_name,
       COUNT(DISTINCT s.account_id) AS accounts_using_feature,
       SUM(fu.usage_count) AS total_usage,
       CAST(1.0 * SUM(fu.usage_count)/NULLIF(COUNT(DISTINCT s.account_id),0)
            AS DECIMAL(10,2)) AS usage_per_account,
       CAST(100.0 * SUM(fu.error_count)/NULLIF(SUM(fu.usage_count),0)
            AS DECIMAL(10,2)) AS error_rate_pct
FROM dbo.ravenstack_feature_usage fu
JOIN dbo.ravenstack_subscriptions s ON fu.subscription_id=s.subscription_id
GROUP BY fu.feature_name
ORDER BY usage_per_account DESC;

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
SELECT feature_name,
       CAST(active_usage_per_account AS DECIMAL(10,2)) AS active_usage_per_account,
       CAST(churned_usage_per_account AS DECIMAL(10,2)) AS churned_usage_per_account,
       CAST(active_usage_per_account-churned_usage_per_account AS DECIMAL(10,2)) AS usage_gap
FROM feature_gap
WHERE active_usage_per_account IS NOT NULL
  AND churned_usage_per_account IS NOT NULL
ORDER BY usage_gap DESC;
