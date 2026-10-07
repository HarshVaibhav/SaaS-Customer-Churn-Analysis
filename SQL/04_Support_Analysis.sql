/*
Project: SaaS Customer Churn & Usage Analysis
Purpose: Evaluate support activity and satisfaction as potential churn signals.
*/
USE SaaS_Project;
GO

SELECT COUNT(*) AS total_tickets,
       COUNT(DISTINCT account_id) AS accounts_with_tickets,
       SUM(CASE WHEN satisfaction_score IS NOT NULL THEN 1 ELSE 0 END) AS scored_tickets,
       SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) AS unscored_tickets,
       SUM(CASE WHEN escalation_flag=1 THEN 1 ELSE 0 END) AS escalated_tickets
FROM dbo.ravenstack_support_tickets;

SELECT priority, COUNT(*) AS tickets,
       SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) AS missing_satisfaction,
       CAST(100.0 * SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END)
            / NULLIF(COUNT(*),0) AS DECIMAL(10,2)) AS missing_satisfaction_pct
FROM dbo.ravenstack_support_tickets
GROUP BY priority
ORDER BY missing_satisfaction_pct DESC;

SELECT escalation_flag, COUNT(*) AS tickets,
       SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) AS missing_satisfaction,
       CAST(100.0 * SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END)
            / NULLIF(COUNT(*),0) AS DECIMAL(10,2)) AS missing_satisfaction_pct,
       CAST(AVG(CAST(satisfaction_score AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_satisfaction
FROM dbo.ravenstack_support_tickets
GROUP BY escalation_flag;

WITH account_status AS (
    SELECT account_id, MAX(CAST(churn_flag AS INT)) AS churn_flag
    FROM dbo.ravenstack_subscriptions
    GROUP BY account_id
),
ticket_summary AS (
    SELECT account_id, COUNT(*) AS ticket_count
    FROM dbo.ravenstack_support_tickets
    GROUP BY account_id
)
SELECT a.churn_flag,
       COUNT(*) AS accounts_with_tickets,
       SUM(t.ticket_count) AS total_tickets,
       CAST(AVG(CAST(t.ticket_count AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_tickets_per_account
FROM account_status a
JOIN ticket_summary t ON a.account_id=t.account_id
GROUP BY a.churn_flag
ORDER BY a.churn_flag;
