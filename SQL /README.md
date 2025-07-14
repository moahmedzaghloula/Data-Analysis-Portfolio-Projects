# 📊 Zepto Data Analysis Project

Welcome to the **Zepto Data Analysis Project** – a full-fledged data analytics pipeline built using **SQL** and **CSV data processing**. This project showcases the ability to clean, analyze, and extract business insights from a large retail dataset using SQL queries and automation scripts.

---

## 🧠 Project Description

This project focuses on analyzing product-level data from Zepto, a fast commerce platform. The dataset contains information about products, prices, discounts, categories, availability, and inventory. The goal is to extract key insights such as:

- Most frequent products
- Products with high MRP but low discounts
- Category-wise discount trends
- Missing or inconsistent data entries
- Overall stock and availability

The project uses a combination of:

- 📄 A **CSV file** containing raw data (`zepto_v2.csv`)
- 🧮 An **SQL script** (`Zepto_Script.sql`) with detailed queries and analysis logic

---

## 📁 Files Included

| File Name | Description |
|-----------|-------------|
| `zepto_v2.csv` | The main dataset containing product-related information |
| `Zepto_Script.sql` | SQL queries used to clean, validate, and analyze the dataset |

---

## 🛠️ Key Features

- ✅ **Data Cleaning:** Detect and handle NULL or missing values in key fields like name, category, MRP, discounts, etc.
- 📊 **Descriptive Analysis:** Identify the most duplicated products, most discounted categories, and items with abnormal pricing patterns.
- 🏷️ **Category Insights:** Find out which categories offer the best discounts on average.
- 🚫 **Validation Queries:** Filter out rows with incomplete or inconsistent data.

---

## 🧾 Example SQL Queries

- Find duplicate product names:
  ```sql
  SELECT name, COUNT(sku_id) AS "Number of SKUs"
  FROM zepto
  GROUP BY name
  HAVING count(sku_id) > 1
  ORDER BY count(sku_id) DESC;
  ```
  
- Check for missing or null values
  ```sql
  SELECT *
FROM zepto
WHERE name IS NULL OR category IS NULL OR mrp IS NULL
   OR discountPercent IS NULL OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL OR availableQuantity IS NULL
   OR outOfStock IS NULL OR quantity IS NULL;
  ```
  
## 📌 Tools & Technologies
 - SQL (MariaDB / MySQL)
 - CSV Data Processing
 - Data Cleaning
 - Query Optimization
 - Data Exploration
 
## ⭐ If you like this project, feel free to use it as inspiration for your own SQL data analysis work!


