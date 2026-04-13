-- 1. Basic SELECT + WHERE
SELECT * 
FROM superstore
WHERE Region = 'West';

-- 2. GROUP BY + SUM
SELECT Category, SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category;

-- 3. ORDER BY
SELECT Customer_Name, Sales
FROM superstore
ORDER BY Sales DESC;

-- 4. JOIN (example logic)
-- (Assume Orders + Customers)
SELECT o.Order_ID, c.Customer_Name
FROM Orders o
INNER JOIN Customers c
ON o.Customer_ID = c.Customer_ID;

-- 5. SUBQUERY
SELECT Category, SUM(Sales)
FROM superstore
WHERE Sales > (
    SELECT AVG(Sales) FROM superstore
)
GROUP BY Category;

-- 6. VIEW
CREATE VIEW sales_summary AS
SELECT Category, SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category;

-- 7. NULL handling
SELECT Customer_Name, COALESCE(Postal_Code, 'Unknown')
FROM superstore;

-- 8. INDEX (optimization)
CREATE INDEX idx_category ON superstore(Category);