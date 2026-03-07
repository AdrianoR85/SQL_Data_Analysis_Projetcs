/*
=========================================================================
                         DATA EXPLORATION
=========================================================================
Quick overview of the dataset structure, size, and data quality.
=========================================================================
*/

-- =====================================================================
-- SECTION 1: DATASET SIZE
-- =====================================================================

-- Total number of transactions
SELECT COUNT(*) AS total_transactions 
FROM retail_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customer 
FROM retail_sales;

-- What type of category we have?
SELECT DISTINCT category FROM retail_sales;

-- Date range of the dataset
SELECT 
	MIN(sale_date) AS first_transaction,
	MAX(sale_date) AS last_transaction
FROM retail_sales

-- =====================================================================
-- SECTION 2: DISTINCT VALUES
-- =====================================================================

-- Available categories
SELECT DISTINCT category
FROM retail_sales;

-- Available gender
SELECT DISTINCT gender
FROM retail_sales;

-- =====================================================================
-- SECTION 3: DATA QUALITY
-- =====================================================================

-- Check for NULL values
SELECT *
FROM retail_sales
WHERE transaction_id  IS NULL
   OR sale_date        IS NULL
   OR sale_time        IS NULL
   OR customer_id      IS NULL
   OR gender           IS NULL
   OR age              IS NULL
   OR category         IS NULL
   OR quantity         IS NULL
   OR price_per_unit   IS NULL
   OR cogs             IS NULL
   OR total_sale       IS NULL;

-- Check for duplicate transactions
SELECT 
    transaction_id, 
    COUNT(*) AS occurrences
FROM retail_sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- =====================================================================
-- SECTION 4: Statistics
-- =====================================================================

-- Min, Max, Mean and Median of Sales
SELECT 
	MIN(total_sale) AS lowest_sales,
	MAX(total_sale) AS biggest_sales,
	ROUND(AVG(total_sale),2) AS mean_sales,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_sale) AS median_sales,
FROM retail_sales;

-- Outliers
WITH stats AS (
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_sale) AS q1,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_sale) AS q3
	FROM retail_sales
), 
bounds AS (
	SELECT
		q1 - 1.5 * (q3 - q1) AS lower_bound,
		q3 + 1.5 * (q3 - q1) AS upper_bound
	FROM stats
) 
SELECT rs.*
FROM retail_sales AS rs, bounds
WHERE rs.total_sale < bounds.lower_bound
   OR rs.total_sale > bounds.upper_bound;
