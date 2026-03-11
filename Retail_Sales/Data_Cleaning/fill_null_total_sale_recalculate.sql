/*
=========================================================================
                 FILLING NULL VALUES IN total_sale COLUMN
=========================================================================
This update was performed because the dataset contains NULL values
in the `total_sale` column.

The `total_sale` value is derived directly from the multiplication
of two existing columns:

    total_sale = quantity × price_per_unit

No statistical analysis was needed since the value can be calculated
exactly from the data already present in the table.

Only records where ALL of the following conditions are met
will be updated:
- total_sale    IS NULL
- quantity      IS NOT NULL
- price_per_unit IS NOT NULL
=========================================================================
*/


-- =====================================================================
-- UPDATE — Recalculate total_sale from quantity and price_per_unit
-- =====================================================================
UPDATE retail_sales
SET    total_sale = quantity * price_per_unit
WHERE  total_sale        IS NULL
  AND  quantity           IS NOT NULL
  AND  price_per_unit     IS NOT NULL;
