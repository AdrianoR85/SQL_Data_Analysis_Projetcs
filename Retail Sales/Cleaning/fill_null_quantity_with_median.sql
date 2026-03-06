/*
=========================================================================
                    METRICS FOR THE QUANTITY COLUMN
=========================================================================
This analysis was performed because the dataset contains NULL values
in the `quantity` column.

To decide which value should replace the missing data, three statistical
measures were calculated:
- Mean (average)
- Mode
- Median

The analysis focuses only on FEMALE customers because the missing
values were found in this group. The data was also filtered by the
categories Beauty and Clothing to keep the comparison consistent
with similar transactions.

Results:
                | Beauty | Clothing |
  Mean          |  2.51  |   2.53   |
  Median        |    3   |     3    |
  Mode          |    4   |     4    |

The mean would need to be rounded to 3, which would make it equal
to the median. Because of this, the median was chosen as the most
appropriate value to replace the missing quantities.

The median is also less affected by extreme values and represents
the middle value of the distribution.

Therefore, the missing `quantity` values were replaced with 3.
=========================================================================
*/


-- =====================================================================
-- STEP 1: MODE (most frequent quantity)
-- =====================================================================
SELECT 
    category,
    quantity, 
    COUNT(quantity) AS frequency
FROM retail_sales
WHERE gender   = 'Female' 
  AND category IN ('Beauty', 'Clothing')
  AND quantity  > 0
GROUP BY category, quantity
ORDER BY category, frequency DESC;

-- Result:
--   Beauty   → mode = 4
--   Clothing → mode = 4


-- =====================================================================
-- STEP 2: MEAN (average quantity)
-- =====================================================================
SELECT 
    category,
    ROUND(AVG(quantity), 2) AS mean_quantity
FROM retail_sales
WHERE gender   = 'Female'
  AND category IN ('Beauty', 'Clothing')
GROUP BY category
ORDER BY category;

-- Result:
--   Beauty   → mean ≈ 2.51
--   Clothing → mean ≈ 2.53


-- =====================================================================
-- STEP 3: MEDIAN (middle value)
-- =====================================================================
SELECT 
    category,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY quantity) AS median_quantity
FROM retail_sales
WHERE gender   = 'Female'
  AND category IN ('Beauty', 'Clothing')
GROUP BY category
ORDER BY category;

-- Result:
--   Beauty   → median = 3
--   Clothing → median = 3


-- =====================================================================
-- STEP 4: UPDATE — Replace NULL quantities with median value (3)
-- =====================================================================
UPDATE retail_sales
SET    quantity = 3
WHERE  quantity IS NULL
  AND  gender   = 'Female';
