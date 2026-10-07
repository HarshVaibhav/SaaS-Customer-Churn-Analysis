/*
Project: SaaS Customer Churn & Usage Analysis
Purpose: Validate source-data quality and relationships before analysis.
Database: SaaS_Project
*/
USE SaaS_Project;
GO

SELECT 'accounts' AS table_name, COUNT(*) AS row_count FROM dbo.ravenstack_accounts
UNION ALL SELECT 'subscriptions', COUNT(*) FROM dbo.ravenstack_subscriptions
UNION ALL SELECT 'feature_usage', COUNT(*) FROM dbo.ravenstack_feature_usage
UNION ALL SELECT 'support_tickets', COUNT(*) FROM dbo.ravenstack_support_tickets
UNION ALL SELECT 'churn_events', COUNT(*) FROM dbo.ravenstack_churn_events;

SELECT account_id, COUNT(*) AS record_count
FROM dbo.ravenstack_accounts GROUP BY account_id HAVING COUNT(*) > 1;

SELECT COUNT(*) AS inconsistent_records
FROM dbo.ravenstack_subscriptions
WHERE (churn_flag = 1 AND end_date IS NULL)
   OR (churn_flag = 0 AND end_date IS NOT NULL);

SELECT COUNT(*) AS negative_mrr_records
FROM dbo.ravenstack_subscriptions WHERE mrr_amount < 0;

SELECT is_trial, COUNT(*) AS subscription_count,
       SUM(CASE WHEN mrr_amount = 0 THEN 1 ELSE 0 END) AS zero_mrr_count
FROM dbo.ravenstack_subscriptions GROUP BY is_trial;

SELECT COUNT(*) AS invalid_seat_records
FROM dbo.ravenstack_subscriptions WHERE seats <= 0;

SELECT COUNT(*) AS invalid_date_records
FROM dbo.ravenstack_subscriptions WHERE end_date < start_date;

SELECT usage_id, subscription_id, usage_date, feature_name,
       usage_count, usage_duration_secs, error_count, is_beta_feature,
       COUNT(*) AS duplicate_count
FROM dbo.ravenstack_feature_usage
GROUP BY usage_id, subscription_id, usage_date, feature_name,
         usage_count, usage_duration_secs, error_count, is_beta_feature
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS orphan_subscriptions
FROM dbo.ravenstack_subscriptions s
LEFT JOIN dbo.ravenstack_accounts a ON s.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS orphan_usage_records
FROM dbo.ravenstack_feature_usage fu
LEFT JOIN dbo.ravenstack_subscriptions s ON fu.subscription_id = s.subscription_id
WHERE s.subscription_id IS NULL;

SELECT COUNT(*) AS orphan_tickets
FROM dbo.ravenstack_support_tickets st
LEFT JOIN dbo.ravenstack_accounts a ON st.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS orphan_churn_events
FROM dbo.ravenstack_churn_events ce
LEFT JOIN dbo.ravenstack_accounts a ON ce.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS total_tickets,
       SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) AS missing_satisfaction,
       CAST(100.0 * SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END)
            / NULLIF(COUNT(*),0) AS DECIMAL(10,2)) AS missing_satisfaction_pct
FROM dbo.ravenstack_support_tickets;
