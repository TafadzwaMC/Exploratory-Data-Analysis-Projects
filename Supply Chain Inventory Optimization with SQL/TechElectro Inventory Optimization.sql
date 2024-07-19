-- Preliminaries- creation of Schema/Database
CREATE SCHEMA TechElectro;
SHOW DATABASES;
USE TechElectro;


-- DATA EXPLORATION
-- Load the data into the tables using the table import data wizard.
SHOW TABLES;
-- Table inspection
SELECT * FROM external_factors LIMIT 5;
SELECT * FROM product_data LIMIT 5;
SELECT * FROM sales_data LIMIT 5;
-- Understanding the structure of the datasets
SHOW COLUMNS FROM external_factors;
DESCRIBE product_data;
DESC sales_data;


-- DATA CLEANING
-- Changing to the right data type for all columns and assigned primary columns
-- External data should be like this ideally
-- SalesDate DATE, GDP DECIMAL(15, 2), InflationRate DECIMAL(5, 2), SeasonalFactor DECIMAL(5, 2), PRIMARY KEY (SalesDate)
ALTER TABLE external_factors
ADD COLUMN New_Sales_Date DATE;
SET SQL_SAFE_UPDATES = 0; -- turning off safe updates
UPDATE external_factors
SET New_Sales_Date = STR_TO_DATE(Sales_Date, '%d/%m/%Y');
ALTER TABLE external_factors
DROP COLUMN Sales_Date;
ALTER TABLE external_factors
CHANGE COLUMN New_Sales_Date Sales_Date DATE;

ALTER TABLE external_factors
MODIFY COLUMN GDP DECIMAL(15, 2);

ALTER TABLE external_factors
MODIFY COLUMN Inflation_Rate DECIMAL(5, 2);

ALTER TABLE external_factors
MODIFY COLUMN Seasonal_Factor DECIMAL(5, 2);

-- Product data should be like this ideally
-- Product_ID INT NOT NULL, Product_Category TEXT, Promotions ENUM('yes', 'no')
ALTER TABLE product_data
ADD COLUMN NewPromotions ENUM('yes', 'no');
UPDATE product_data
SET NewPromotions = CASE
  WHEN Promotions = 'yes' THEN 'yes'
  WHEN Promotions = 'no' THEN 'no'
  ELSE NULL
END;
ALTER TABLE product_data
DROP COLUMN Promotions;
ALTER TABLE product_data
CHANGE COLUMN NewPromotions Promotions ENUM('yes', 'no');

-- Sales_data should be like this ideally
--  Product_ID INT NOT NULL, Sales_Date DATE, Inventory_Quantity INT, Product_Cost DECIMAL(10, 2)
ALTER TABLE Sales_data
ADD COLUMN New_Sales_Date DATE;
UPDATE Sales_data
SET New_Sales_Date = STR_TO_DATE(Sales_Date, '%d/%m/%Y');
ALTER TABLE Sales_data
DROP COLUMN Sales_Date;
ALTER TABLE Sales_data
CHANGE COLUMN New_Sales_Date Sales_Date DATE;

ALTER TABLE Sales_Date
MODIFY COLUMN Product_Cost DECIMAL(15, 2);

-- Identify missing values using `IS NULL` or `COALESCE` functions.
-- external_factor
SELECT 
    SUM(CASE WHEN Sales_Date IS NULL THEN 1 ELSE 0 END) AS missing_sales_date,
    SUM(CASE WHEN GDP IS NULL THEN 1 ELSE 0 END) AS missing_gdp,
    SUM(CASE WHEN Inflation_Rate IS NULL THEN 1 ELSE 0 END) AS missing_inflation_rate,
    SUM(CASE WHEN Seasonal_Factor IS NULL THEN 1 ELSE 0 END) AS missing_seasonal_factor
FROM external_factors;
-- Product_data
SELECT 
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS missing_product_category,
    SUM(CASE WHEN Promotions IS NULL THEN 1 ELSE 0 END) AS missing_promotions
FROM product_data;
-- sales_data
SELECT 
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN Sales_Date IS NULL THEN 1 ELSE 0 END) AS missing_sales_date,
    SUM(CASE WHEN Inventory_Quantity IS NULL THEN 1 ELSE 0 END) AS missing_inventory_quantity,
    SUM(CASE WHEN Product_Cost IS NULL THEN 1 ELSE 0 END) AS missing_product_cost
FROM sales_data;

-- Check for duplicates using `GROUP BY` and `HAVING` clauses and remove them if necessary.
-- external_factor
SELECT Sales_Date, COUNT(*) as count
FROM external_factors
GROUP BY Sales_Date
HAVING count > 1;
-- product_data
SELECT Product_ID, Product_Category, COUNT(*) as count
FROM product_data
GROUP BY Product_ID
HAVING count > 1;
-- sales_data
SELECT Product_ID, Sales_Date, COUNT(*) as count
FROM sales_data
GROUP BY Product_ID, Sales_Date
HAVING count > 1;

-- Dealing with duplicates for external_facctors and Products_data
-- external factor
DELETE e1 FROM external_factors e1
INNER JOIN (
    SELECT Sales_Date,
           ROW_NUMBER() OVER (PARTITION BY Sales_Date ORDER BY Sales_Date) as rn
    FROM external_factors
) e2 ON e1.Sales_Date = e2.Sales_Date
WHERE e2.rn > 1;
SELECT COUNT(*) FROM external_factors;

-- product data
DELETE p1 FROM product_data p1
INNER JOIN (
    SELECT Product_ID,
           ROW_NUMBER() OVER (PARTITION BY Product_ID ORDER BY Product_ID) as rn
    FROM product_data
) p2 ON p1.Product_ID = p2.Product_ID
WHERE p2.rn > 1;
SELECT COUNT(*) FROM product_data;


-- DATA INTREGATION
-- Combine relevant datasets using SQL joins (`INNER JOIN`, `LEFT JOIN`, etc.).
-- Integrate `External_Factors`, `Product_data`, and `Sales_data` to create a unified dataset for analysis.
--  sales_data and product_data first    
CREATE VIEW sales_product_data AS
SELECT 
    s.Product_ID,
    s.Sales_Date,
    s.Inventory_Quantity,
    s.Product_Cost,
    p.Product_Category,
    p.Promotions
FROM sales_data s
JOIN product_data p ON s.Product_ID = p.Product_ID;

-- sale_product_data and external_Factors
CREATE VIEW Inventory_data AS
SELECT 
    sp.Product_ID,
    sp.Sales_Date,
    sp.Inventory_Quantity,
    sp.Product_Cost,
    sp.Product_Category,
    sp.Promotions,
    e.GDP,
    e.Inflation_Rate,
    e.Seasonal_Factor
FROM sales_product_data sp
LEFT JOIN external_factors e ON sp.Sales_Date = e.Sales_Date;
DESC INVENTORY_DATA;


-- DESCRIPTIVE ANALYSIS
-- Basic Statistics:
-- Average sales (calculated as the product of "Inventory Quantity" and "Product Cost").
SELECT Product_ID,
       ROUND(AVG(Inventory_Quantity * Product_Cost))as avg_sales
FROM Inventory_data
GROUP BY Product_ID
ORDER BY avg_sales DESC;

-- Median stock levels (i.e., "Inventory Quantity").
SELECT Product_ID, AVG(Inventory_Quantity) as median_stock
FROM (
     SELECT Product_ID,
            Inventory_Quantity,
            ROW_NUMBER() OVER(PARTITION BY Product_ID ORDER BY Inventory_Quantity) as row_num_asc,
            ROW_NUMBER() OVER(PARTITION BY Product_ID ORDER BY Inventory_Quantity DESC) as row_num_desc
     FROM Inventory_data
) AS subquery
WHERE row_num_asc IN (row_num_desc, row_num_desc - 1, row_num_desc + 1)
GROUP BY Product_ID;

-- Product performance metrics (total sales per product).
SELECT Product_ID,
       ROUND(SUM(Inventory_Quantity * Product_Cost))as total_sales
FROM inventory_data
GROUP BY Product_ID
ORDER BY total_sales DESC;

-- Identify high-demand products based on average sales
-- We'll consider the top 5% of products in terms of average sales as high-demand products
WITH HighDemandProducts AS (
    SELECT Product_ID, AVG(Inventory_Quantity) as avg_sales
    FROM Inventory_data
    GROUP BY Product_ID
    HAVING avg_sales > (
        SELECT AVG(Inventory_Quantity) * 0.95 FROM Sales_data  -- This approximates the top 5% threshold
    )
)

-- Calculate stockout frequency for high-demand products
SELECT s.Product_ID,
       COUNT(*) as stockout_frequency
FROM Inventory_data s
WHERE s.Product_ID IN (SELECT Product_ID FROM HighDemandProducts)
AND s.Inventory_Quantity = 0
GROUP BY s.Product_ID;


-- INFLUENCE OF EXTERNAL FACTORS
-- GDP-  the overall economic health and growth of a country. it's 
SELECT Product_ID,
    AVG(CASE WHEN `GDP` > 0 THEN Inventory_Quantity ELSE NULL END) AS avg_sales_positive_gdp,
    AVG(CASE WHEN `GDP` <= 0 THEN Inventory_Quantity ELSE NULL END) AS avg_sales_non_positive_gdp
FROM Inventory_table
GROUP BY Product_ID
HAVING avg_sales_positive_gdp IS NOT NULL;


-- Inflation influence on the Sales
SELECT Product_ID, 
       AVG(CASE WHEN Inflation_Rate > 0 THEN Inventory_Quantity ELSE NULL END) AS avg_sales_positive_inflation,
       AVG(CASE WHEN Inflation_Rate <= 0 THEN Inventory_Quantity ELSE NULL END) AS avg_sales_non_positive_inflation
FROM Inventory_table
GROUP BY Product_ID
HAVING avg_sales_positive_inflation IS NOT NULL;



-- OPTIMIZING INVENTORY
-- Define an SQL query to compute the Lead Time Demand, Safety Stock, and Reorder Point
WITH InventoryCalculations AS (
     SELECT Product_ID,
            AVG(rolling_avg_sales) as avg_rolling_sales,
            AVG(rolling_variance) as avg_rolling_variance
     FROM (
         SELECT Product_ID,
                AVG(daily_sales) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as rolling_avg_sales,
                AVG(squared_diff) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as rolling_variance
         FROM (
             SELECT Product_ID,
                    Sales_Date,
                    Inventory_Quantity * Product_Cost as daily_sales,
                    (Inventory_Quantity * Product_Cost - AVG(Inventory_Quantity * Product_Cost) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)) * (Inventory_Quantity * Product_Cost - AVG(Inventory_Quantity * Product_Cost) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)) as squared_diff
             FROM Inventory_data
         ) subquery -- Add an alias for the subquery
     ) subquery2 -- Add an alias for the subquery
     GROUP BY Product_ID
)
SELECT Product_ID,
       avg_rolling_sales * 7 as lead_time_demand,
       1.645 * (avg_rolling_variance * 7) as safety_stock,
       (avg_rolling_sales * 7) + (1.645 * (avg_rolling_variance * 7)) as reorder_point
FROM InventoryCalculations;

-- Automate the Calculate of Reorder points when new rows are added to the inventory table to ensure optimal inventory
-- Step 1: Create the Inventory Optimization Table
CREATE TABLE inventory_optimization (
    Product_ID INT PRIMARY KEY,
    Reorder_Point DOUBLE
);

-- Step 2: Create the Stored Procedure to Recalculate Reorder Point
DELIMITER //
CREATE PROCEDURE RecalculateReorderPoint(productID INT)
BEGIN
    DECLARE avgRollingSales DOUBLE;
    DECLARE avgRollingVariance DOUBLE;
    DECLARE leadTimeDemand DOUBLE;
    DECLARE safetyStock DOUBLE;
    DECLARE reorderPoint DOUBLE;

    -- Calculate average rolling sales and variance for the product
    SELECT AVG(rolling_avg_sales), AVG(rolling_variance)
    INTO avgRollingSales, avgRollingVariance
    FROM (
        SELECT Product_ID,
               AVG(daily_sales) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as rolling_avg_sales,
               AVG(squared_diff) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as rolling_variance
        FROM (
            SELECT Product_ID,
                   Sales_Date,
                   Inventory_Quantity * Product_Cost as daily_sales,
                   (Inventory_Quantity * Product_Cost - 
                    AVG(Inventory_Quantity * Product_Cost) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)) * 
                   (Inventory_Quantity * Product_Cost - 
                    AVG(Inventory_Quantity * Product_Cost) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)) as squared_diff
            FROM inventory_data
            WHERE Product_ID = productID
        ) AS InnerDerived
    ) AS OuterDerived;

    SET leadTimeDemand = avgRollingSales * 7;  -- Assuming a lead time of 7 days
    SET safetyStock = 1.645 * SQRT(avgRollingVariance * 7);  -- Using Z value for 95% service level
    SET reorderPoint = leadTimeDemand + safetyStock;

    -- Insert or update the reorder point in the inventory_optimization table
    INSERT INTO inventory_optimization (Product_ID, Reorder_Point)
    VALUES (productID, reorderPoint)
    ON DUPLICATE KEY UPDATE Reorder_Point = reorderPoint;
END //
DELIMITER ;

-- Step 3: make inventory_data a permanent table
CREATE TABLE Inventory_table AS SELECT * FROM Inventory_data;

-- Step 4: Create the Trigger
DELIMITER //
CREATE TRIGGER AfterInsertUnifiedTable
AFTER INSERT ON Inventory_table
FOR EACH ROW 
BEGIN
    CALL RecalculateReorderPoint(NEW.Product_ID);
END //
DELIMITER ;


-- OVERSTOCKING AND UNDERSTOCKING
-- MySQL Query to identify overstocked and understocked products

-- Calculate rolling average sales for each product
WITH RollingSales AS (
    SELECT Product_ID,
           Sales_Date,
           AVG(Inventory_Quantity * Product_Cost) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as rolling_avg_sales
    FROM inventory_table
),

-- Calculate the number of days a product was out of stock
StockoutDays AS (
    SELECT Product_ID,
           COUNT(*) as stockout_days
    FROM inventory_table
    WHERE Inventory_Quantity  = 0
    GROUP BY Product_ID
)

-- Join the above CTEs with the main table to get the results
SELECT f.Product_ID,
       AVG(f.Inventory_Quantity  * f.Product_Cost) as avg_inventory_value,
       AVG(rs.rolling_avg_sales) as avg_rolling_sales,
       COALESCE(sd.stockout_days, 0) as stockout_days
FROM inventory_table f
JOIN RollingSales rs ON f.Product_ID = rs.Product_ID AND f.Sales_Date = rs.Sales_Date
LEFT JOIN StockoutDays sd ON f.Product_ID = sd.Product_ID
GROUP BY f.Product_ID, sd.stockout_days;

-- MONITOR AND ADJUST
-- Monitor inventory levels
DELIMITER //
CREATE PROCEDURE MonitorInventoryLevels()
BEGIN
    SELECT Product_ID, AVG(Inventory_Quantity) as AvgInventory
    FROM Inventory_table
    GROUP BY Product_ID
    ORDER BY AvgInventory DESC;
END//
DELIMITER ;

-- Monitor Sales Trends
DELIMITER //
CREATE PROCEDURE MonitorSalesTrends()
BEGIN
    SELECT Product_ID, Sales_Date,
           AVG(Inventory_Quantity * Product_Cost) OVER (PARTITION BY Product_ID ORDER BY Sales_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as RollingAvgSales
    FROM inventory_table
    ORDER BY Product_ID, Sales_Date;
END//
DELIMITER ;

-- Monitor Stockout frequencies
DELIMITER //
CREATE PROCEDURE MonitorStockouts()
BEGIN
    SELECT Product_ID, COUNT(*) as StockoutDays
    FROM full_integrated_data
    WHERE Inventory_Quantity = 0
    GROUP BY Product_ID
    ORDER BY StockoutDays DESC;
END//
DELIMITER ;



























