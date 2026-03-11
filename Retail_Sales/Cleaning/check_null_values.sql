/*
=========================================================================
                    NULL VALUES CHECK
=========================================================================
This query scans the entire dataset to identify any records that
contain NULL values in any of the columns.

It covers all columns in the table:
- transaction_id
- sale_date
- sale_time
- customer_id
- gender
- age
- category
- quantity
- price_per_unit
- cogs
- total_sale

If the query returns no rows, the dataset is complete and
contains no missing values.
=========================================================================
*/


-- =====================================================================
-- CHECK — Return all records that contain at least one NULL value
-- =====================================================================
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
