-- ============================================================
-- PROJECT 1: SALES PERFORMANCE DASHBOARD
-- All SQL Queries — Ready to Run
-- Tool: DB Browser for SQLite (free) or MySQL
-- Table name: sales_data  (import from CSV)
-- ============================================================


-- ── QUERY 1: Overall KPIs ────────────────────────────────────
-- Shows total sales, profit, orders, and margin
SELECT
  ROUND(SUM(Sales), 0)             AS Total_Sales_PKR,
  ROUND(SUM(Profit), 0)            AS Total_Profit_PKR,
  COUNT(Order_ID)                  AS Total_Orders,
  SUM(Units_Sold)                  AS Total_Units_Sold,
  ROUND(AVG(Profit * 1.0 / Sales) * 100, 1) AS Avg_Profit_Margin_Pct
FROM sales_data;


-- ── QUERY 2: Monthly Sales Trend ────────────────────────────
-- Use this for the line chart in Power BI
SELECT
  STRFTIME('%Y-%m', Order_Date)    AS Month,
  COUNT(Order_ID)                  AS Orders,
  ROUND(SUM(Sales), 0)             AS Monthly_Sales,
  ROUND(SUM(Profit), 0)            AS Monthly_Profit,
  ROUND(AVG(Profit * 1.0 / Sales) * 100, 1) AS Margin_Pct
FROM sales_data
GROUP BY Month
ORDER BY Month ASC;

-- ⚠ If using MySQL, replace STRFTIME with:
-- DATE_FORMAT(Order_Date, '%Y-%m') AS Month


-- ── QUERY 3: Sales by Region ─────────────────────────────────
SELECT
  Region,
  COUNT(Order_ID)                  AS Total_Orders,
  ROUND(SUM(Sales), 0)             AS Total_Sales,
  ROUND(SUM(Profit), 0)            AS Total_Profit,
  ROUND(AVG(Profit * 1.0 / Sales) * 100, 1) AS Profit_Margin_Pct
FROM sales_data
GROUP BY Region
ORDER BY Total_Sales DESC;


-- ── QUERY 4: Top 10 Products by Revenue ──────────────────────
SELECT
  Product_Name,
  Product_Category,
  SUM(Units_Sold)                  AS Units_Sold,
  ROUND(SUM(Sales), 0)             AS Total_Sales,
  ROUND(SUM(Profit), 0)            AS Total_Profit,
  ROUND(AVG(Profit * 1.0 / Sales) * 100, 1) AS Profit_Margin_Pct
FROM sales_data
GROUP BY Product_Name, Product_Category
ORDER BY Total_Sales DESC
LIMIT 10;


-- ── QUERY 5: Sales by Product Category ───────────────────────
SELECT
  Product_Category,
  COUNT(Order_ID)                  AS Orders,
  ROUND(SUM(Sales), 0)             AS Total_Sales,
  ROUND(SUM(Profit), 0)            AS Total_Profit,
  ROUND(SUM(Sales) * 100.0 / (SELECT SUM(Sales) FROM sales_data), 1) AS Sales_Share_Pct
FROM sales_data
GROUP BY Product_Category
ORDER BY Total_Sales DESC;


-- ── QUERY 6: Sales by Customer Segment ───────────────────────
SELECT
  Customer_Segment,
  COUNT(Order_ID)                  AS Orders,
  ROUND(SUM(Sales), 0)             AS Total_Sales,
  ROUND(SUM(Profit), 0)            AS Total_Profit,
  ROUND(AVG(Sales), 0)             AS Avg_Order_Value
FROM sales_data
GROUP BY Customer_Segment
ORDER BY Total_Sales DESC;


-- ── QUERY 7: Discount Impact on Profit ───────────────────────
SELECT
  CASE
    WHEN Discount = 0      THEN '1. No Discount (0%)'
    WHEN Discount <= 0.05  THEN '2. Low Discount (1-5%)'
    WHEN Discount <= 0.10  THEN '3. Medium Discount (6-10%)'
    ELSE                        '4. High Discount (11%+)'
  END AS Discount_Band,
  COUNT(*)                         AS Orders,
  ROUND(SUM(Sales), 0)             AS Total_Sales,
  ROUND(SUM(Profit), 0)            AS Total_Profit,
  ROUND(AVG(Profit * 1.0 / Sales) * 100, 1) AS Avg_Margin_Pct
FROM sales_data
GROUP BY Discount_Band
ORDER BY Discount_Band;


-- ── QUERY 8: Quarterly Performance ───────────────────────────
SELECT
  CASE
    WHEN CAST(STRFTIME('%m', Order_Date) AS INT) BETWEEN 1  AND 3  THEN 'Q1 (Jan-Mar)'
    WHEN CAST(STRFTIME('%m', Order_Date) AS INT) BETWEEN 4  AND 6  THEN 'Q2 (Apr-Jun)'
    WHEN CAST(STRFTIME('%m', Order_Date) AS INT) BETWEEN 7  AND 9  THEN 'Q3 (Jul-Sep)'
    ELSE                                                                 'Q4 (Oct-Dec)'
  END AS Quarter,
  COUNT(Order_ID)                  AS Orders,
  ROUND(SUM(Sales), 0)             AS Total_Sales,
  ROUND(SUM(Profit), 0)            AS Total_Profit
FROM sales_data
GROUP BY Quarter
ORDER BY Quarter;


-- ── QUERY 9: City-Level Performance ──────────────────────────
SELECT
  City,
  Region,
  COUNT(Order_ID)                  AS Orders,
  ROUND(SUM(Sales), 0)             AS Total_Sales,
  ROUND(SUM(Profit), 0)            AS Total_Profit
FROM sales_data
GROUP BY City, Region
ORDER BY Total_Sales DESC;


-- ── QUERY 10: Region + Category Breakdown ────────────────────
SELECT
  Region,
  Product_Category,
  ROUND(SUM(Sales), 0)             AS Total_Sales,
  ROUND(SUM(Profit), 0)            AS Total_Profit
FROM sales_data
GROUP BY Region, Product_Category
ORDER BY Region, Total_Sales DESC;
