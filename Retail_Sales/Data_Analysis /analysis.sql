/*
====================================================================
				              Data Analysis 
====================================================================
*/
SELECT * FROM retail_sales; 
	
-- Customer behavior by category
SELECT
    gender,
    category,
    COUNT(*) AS total_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY category), 2) AS pct_within_category,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_overall,
    ROUND(SUM(total_sale), 2) AS revenue_by_gender,
    ROUND(SUM(SUM(total_sale)) OVER (PARTITION BY category), 2) AS revenue_by_category
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;

-- Which age group buys the most and spends the most?
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18–25 Young'
        WHEN age BETWEEN 26 AND 35 THEN '26–35 Young Adults'
        WHEN age BETWEEN 36 AND 45 THEN '36–45 Adults'
        WHEN age BETWEEN 46 AND 55 THEN '46–55 Mature Adults'
        ELSE '56+ Senior'
    END AS age_group,
    COUNT(*) AS total_buys,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total_sale), 2) AS total_revenue,
    ROUND(AVG(total_sale), 2) AS avg_ticket
FROM retail_sales
GROUP BY age_group
ORDER BY total_revenue DESC;


-- Monthly purchase trend by gender
SELECT 
	EXTRACT('month' FROM sale_date) AS month,
	gender,
	COUNT(*) AS total_transaction,

	-- Comparison with previous month
	LAG(COUNT(*)) OVER (PARTITION BY gender ORDER BY EXTRACT('month' FROM sale_date)) AS prev_month_transactions,
	ROUND(COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY gender ORDER BY EXTRACT('month' FROM sale_date)), 2) AS transactions_diff
FROM retail_sales
WHERE EXTRACT('year' FROM sale_date) = 2023
GROUP BY EXTRACT('month' FROM sale_date), gender
ORDER BY month, gender;
