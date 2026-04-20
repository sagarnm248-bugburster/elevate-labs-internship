-- ============================================================
--  Task 6: Sales Trend Analysis Using Aggregations
--  Internship: Elevate Labs – Data Analyst Track
--  Dataset   : online_sales
--  Compatible: MySQL | PostgreSQL | SQLite
-- ============================================================


-- ------------------------------------------------------------
-- STEP 1: Create the table (for reference / local testing)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS online_sales (
    order_id   INT,
    order_date DATE,
    amount     NUMERIC(10, 2),
    product_id INT
);


-- ------------------------------------------------------------
-- STEP 2: Sample data for testing
-- (Skip this block if your database already has the data)
-- ------------------------------------------------------------

INSERT INTO online_sales (order_id, order_date, amount, product_id) VALUES
(1001, '2024-01-05', 250.00, 201),
(1002, '2024-01-18', 430.50, 202),
(1003, '2024-02-03', 120.00, 203),
(1004, '2024-02-14', 540.00, 201),
(1005, '2024-02-28', 310.75, 204),
(1006, '2024-03-07', 890.00, 202),
(1007, '2024-03-22', 215.00, 203),
(1008, '2024-04-10', 760.00, 205),
(1009, '2024-04-25', 430.00, 201),
(1010, '2024-05-01', 980.00, 204),
(1011, '2024-05-15', 150.25, 202),
(1012, '2024-05-30', 620.00, 203),
(1013, '2024-06-08', 310.00, 205),
(1014, '2024-06-19', 870.50, 201),
(1015, '2024-07-04', 440.00, 204);


-- ============================================================
-- QUERY 1: Monthly Sales Trend Analysis
-- ============================================================
-- Purpose  : Shows total revenue and order volume for each
--            month, sorted chronologically (oldest → newest).
-- Key steps:
--   • EXTRACT year and month from order_date
--   • SUM(amount)               → total monthly revenue
--   • COUNT(DISTINCT order_id)  → unique orders per month
--   • GROUP BY year, month      → one row per month
--   • ORDER BY year, month      → chronological order
-- ============================================================

SELECT
    EXTRACT(YEAR  FROM order_date)  AS order_year,
    EXTRACT(MONTH FROM order_date)  AS order_month,

    -- Total revenue for the month (ignores NULLs automatically)
    ROUND(SUM(amount), 2)           AS total_revenue,

    -- Count of unique orders placed in the month
    COUNT(DISTINCT order_id)        AS total_orders,

    -- Average order value for the month
    ROUND(AVG(amount), 2)           AS avg_order_value

FROM
    online_sales

-- Exclude rows where order_date or amount is NULL
WHERE
    order_date IS NOT NULL
    AND amount IS NOT NULL

-- Group by year then month to get one row per month
GROUP BY
    EXTRACT(YEAR  FROM order_date),
    EXTRACT(MONTH FROM order_date)

-- Sort chronologically: earliest month first
ORDER BY
    order_year  ASC,
    order_month ASC;


-- ============================================================
-- QUERY 2: Top 3 Months by Total Revenue
-- ============================================================
-- Purpose  : Identifies the three best-performing months
--            across all years, ranked by total revenue (DESC).
-- Key steps:
--   • Same aggregation logic as Query 1
--   • ORDER BY total_revenue DESC → highest revenue first
--   • LIMIT 3                     → only top 3 rows
-- ============================================================

SELECT
    EXTRACT(YEAR  FROM order_date)  AS order_year,
    EXTRACT(MONTH FROM order_date)  AS order_month,

    -- Total revenue for the month
    ROUND(SUM(amount), 2)           AS total_revenue,

    -- Unique orders placed in the month
    COUNT(DISTINCT order_id)        AS total_orders,

    -- Rank label for readability
    CONCAT('Rank #',
        RANK() OVER (
            ORDER BY SUM(amount) DESC
        )
    )                               AS revenue_rank

FROM
    online_sales

WHERE
    order_date IS NOT NULL
    AND amount IS NOT NULL

GROUP BY
    EXTRACT(YEAR  FROM order_date),
    EXTRACT(MONTH FROM order_date)

-- Sort by revenue descending to get the highest months first
ORDER BY
    total_revenue DESC

-- Return only the top 3 months
LIMIT 3;


-- ============================================================
-- QUERY 3 (Bonus): Monthly Revenue Growth Rate
-- ============================================================
-- Purpose  : Calculates month-over-month revenue change (%)
--            using a window function (LAG).
-- Note     : Works on PostgreSQL. For MySQL 8+, same syntax.
-- ============================================================

SELECT
    order_year,
    order_month,
    total_revenue,

    -- Previous month's revenue using LAG window function
    LAG(total_revenue) OVER (
        ORDER BY order_year, order_month
    )                                           AS prev_month_revenue,

    -- Month-over-month growth percentage
    ROUND(
        (
            (total_revenue - LAG(total_revenue) OVER (
                ORDER BY order_year, order_month
            ))
            /
            NULLIF(
                LAG(total_revenue) OVER (
                    ORDER BY order_year, order_month
                ), 0
            )
        ) * 100, 2
    )                                           AS mom_growth_pct

FROM (
    -- Subquery: monthly aggregation (reuse of Query 1 logic)
    SELECT
        EXTRACT(YEAR  FROM order_date)  AS order_year,
        EXTRACT(MONTH FROM order_date)  AS order_month,
        ROUND(SUM(amount), 2)           AS total_revenue
    FROM
        online_sales
    WHERE
        order_date IS NOT NULL
        AND amount IS NOT NULL
    GROUP BY
        EXTRACT(YEAR  FROM order_date),
        EXTRACT(MONTH FROM order_date)
    ORDER BY
        order_year, order_month
) AS monthly_summary

ORDER BY
    order_year  ASC,
    order_month ASC;

-- ============================================================
-- END OF SCRIPT
-- ============================================================
