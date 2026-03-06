/*
==============================================================
					PURPOSE OF THIS QUERY
==============================================================
This query calculates the median values of `price_per_unit`
and `cogs` for specific groups of transactions.
The main goal is to fill in realistic values for records
that contain missing data (NULL values).

The data is grouped by:
- Month (truncated to the first day of the month)
- Gender
- Category

This grouping allows the calculation of median values for
similar transactions across all genders and categories
present in the dataset.

The MEDIAN is used instead of the average because the dataset
contains extreme price values (outliers), which could distort
the mean. The median represents the middle value and gives a
more reliable estimate of typical transactions.

Only records where `price_per_unit` or `cogs` are NULL
are updated. The median is calculated exclusively from
records that already have valid (non-NULL) values for
both fields.
==============================================================
*/

UPDATE retail_sales
SET 
    price_per_unit = m.median_price,
    cogs = m.median_cogs
FROM (
    SELECT 
        DATE_TRUNC('month', sale_date) AS month_date,
        gender,
        category,

		 -- Median price per unit for each group
        PERCENTILE_CONT(0.5) 
			WITHIN GROUP (ORDER BY price_per_unit) AS median_price,
        
		-- Median cost of goods sold for each group
		PERCENTILE_CONT(0.5) 
            WITHIN GROUP (ORDER BY cogs) AS median_cogs
			
    FROM retail_sales
    
	WHERE price_per_unit IS NOT NULL
      AND cogs IS NOT NULL
    
	GROUP BY 
        DATE_TRUNC('month', sale_date),
        gender,
        category
) m
WHERE DATE_TRUNC('month', retail_sales.sale_date) = m.month_date
  AND retail_sales.gender = m.gender
  AND retail_sales.category = m.category
  AND (retail_sales.price_per_unit IS NULL 
  	OR retail_sales.cogs IS NULL);
