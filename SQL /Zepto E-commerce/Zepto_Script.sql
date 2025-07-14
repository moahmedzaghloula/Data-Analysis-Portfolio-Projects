USE `Zepto_SQL_Project`

DROP TABLE IF EXISTS Zepto;

CREATE TABLE Zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC (8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER ,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';


LOAD DATA LOCAL INFILE '/home/mohamed-zaghloula/zepto_v2.csv'
INTO TABLE Zepto
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, outOfStock, quantity);



-- Data Exploration

-- Count of Rows 
SELECT COUNT(*) FROM Zepto;

-- Sample Data
SELECT * FROM Zepto 
LIMIT 10;

-- Null Values
SELECT * FROM Zepto
WHERE 
   category IS NULL OR name IS NULL OR mrp IS NULL OR discountPercent IS NULL 
   OR discountedSellingPrice IS NULL OR weightInGms IS NULL 
   OR availableQuantity IS NULL OR outOfStock IS NULL OR quantity IS NULL;

-- Different Product Categories
SELECT DISTINCT category
FROM Zepto
ORDER BY category;

-- Products In Stock Vs Out Of Stock 
SELECT outOfStock , COUNT(sku_id)
FROM Zepto 
GROUP BY outOfStock;
-- Product NAmes Present Multible Times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM Zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

-- Data Cleaning 


-- Products With Price = 0
SELECT * FROM Zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- Convert paise to rupees
UPDATE Zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM Zepto;

-- Data Analysis 

-- Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name , mrp , discountPercent 
FROM Zepto 
ORDER BY discountPercent DESC 
LIMIT 10 ;

-- What are the Products with High MRP but not Out of Stock?
SELECT DISTINCT name , mrp 
FROM Zepto 
WHERE outOfStock = FALSE and mrp > 300
ORDER BY mrp;

-- Calculate Estimated Revenue for Each Category
SELECT
category, 
SUM(discountedSellingPrice * availableQuantity) AS Total_Revenue
FROM Zepto
GROUP BY category
ORDER BY Total_Revenue;

-- Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT name, mrp, discountPercent
FROM Zepto
WHERE mrp > 500
  AND discountPercent < 10;

SELECT DISTINCT name, mrp, discountPercent
FROM Zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Identify the top 5 categories offering the highest average discount percentage.
SELECT category, AVG(discountPercent) AS avg_discount
FROM Zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS Price_Per_Gram
FROM Zepto
WHERE weightInGms >= 100
ORDER BY Price_Per_Gram;

-- Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM Zepto;

-- What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS Total_weight
FROM Zepto
GROUP BY category
ORDER BY Total_weight;

-- Thanks 


