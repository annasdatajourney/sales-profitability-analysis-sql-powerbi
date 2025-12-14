-- 01_analysis_queries.sql
-- Business-led SQL analysis (SQLite)

-- A) Executive snapshot: sales, profit, margin, avg discount
SELECT
  ROUND(SUM(Sales), 2)                     AS total_sales,
  ROUND(SUM(Profit), 2)                    AS total_profit,
  ROUND(SUM(Profit) / NULLIF(SUM(Sales),0), 4) AS profit_margin,
  ROUND(AVG(Discount), 4)                  AS avg_discount,
  COUNT(DISTINCT Order_ID)                 AS orders,
  COUNT(DISTINCT Customer_ID)              AS customers
FROM orders;

-- B) Trend over time (by year)
SELECT
  substr(Order_Date, 1, 4) AS year,
  ROUND(SUM(Sales), 2)     AS sales,
  ROUND(SUM(Profit), 2)    AS profit,
  ROUND(SUM(Profit) / NULLIF(SUM(Sales),0), 4) AS margin
FROM orders
GROUP BY year
ORDER BY year;

-- C) Regions: where we sell vs where we actually make money
SELECT
  Region,
  ROUND(SUM(Sales), 2)  AS sales,
  ROUND(SUM(Profit), 2) AS profit,
  ROUND(SUM(Profit) / NULLIF(SUM(Sales),0), 4) AS margin
FROM orders
GROUP BY Region
ORDER BY profit DESC;

-- D) Category profitability (with margin)
SELECT
  Category,
  Sub_Category,
  ROUND(SUM(Sales), 2)  AS sales,
  ROUND(SUM(Profit), 2) AS profit,
  ROUND(SUM(Profit) / NULLIF(SUM(Sales),0), 4) AS margin
FROM orders
GROUP BY Category, Sub_Category
ORDER BY profit DESC;

-- E) “Discount is not profit”: bucket discounts and compare margin
WITH bucketed AS (
  SELECT
    CASE
      WHEN Discount = 0 THEN '0%'
      WHEN Discount <= 0.10 THEN '0–10%'
      WHEN Discount <= 0.20 THEN '10–20%'
      WHEN Discount <= 0.30 THEN '20–30%'
      WHEN Discount <= 0.40 THEN '30–40%'
      ELSE '40%+'
    END AS discount_bucket,
    Sales,
    Profit
  FROM orders
)
SELECT
  discount_bucket,
  COUNT(*)                               AS rows,
  ROUND(SUM(Sales), 2)                   AS sales,
  ROUND(SUM(Profit), 2)                  AS profit,
  ROUND(SUM(Profit) / NULLIF(SUM(Sales),0), 4) AS margin
FROM bucketed
GROUP BY discount_bucket
ORDER BY
  CASE discount_bucket
    WHEN '0%' THEN 1
    WHEN '0–10%' THEN 2
    WHEN '10–20%' THEN 3
    WHEN '20–30%' THEN 4
    WHEN '30–40%' THEN 5
    ELSE 6
  END;

-- F) Top customers by profit (who you want to retain)
SELECT
  Customer_ID,
  Customer_Name,
  Segment,
  Region,
  ROUND(SUM(Sales), 2)  AS sales,
  ROUND(SUM(Profit), 2) AS profit
FROM orders
GROUP BY Customer_ID, Customer_Name, Segment, Region
ORDER BY profit DESC
LIMIT 15;

-- G) Loss-makers: products that destroy profit (focus for pricing / discount policy)
SELECT
  Product_ID,
  Product_Name,
  Category,
  Sub_Category,
  ROUND(SUM(Sales), 2)  AS sales,
  ROUND(SUM(Profit), 2) AS profit
FROM orders
GROUP BY Product_ID, Product_Name, Category, Sub_Category
HAVING SUM(Profit) < 0
ORDER BY profit ASC
LIMIT 20;

-- H) Shipping speed (days) and profitability (are slow deliveries costing margin?)
WITH ship AS (
  SELECT
    (julianday(Ship_Date) - julianday(Order_Date)) AS ship_days,
    Sales, Profit
  FROM orders
  WHERE Ship_Date IS NOT NULL AND Order_Date IS NOT NULL
)
SELECT
  CAST(ship_days AS INT)                 AS ship_days,
  COUNT(*)                               AS rows,
  ROUND(SUM(Sales), 2)                   AS sales,
  ROUND(SUM(Profit), 2)                  AS profit,
  ROUND(SUM(Profit) / NULLIF(SUM(Sales),0), 4) AS margin
FROM ship
GROUP BY CAST(ship_days AS INT)
ORDER BY ship_days;
