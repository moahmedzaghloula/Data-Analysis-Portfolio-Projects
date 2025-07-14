# 📊 Zepto Data Analysis Project

Welcome to the **Zepto Data Analysis Project** – a comprehensive data analytics pipeline built using **SQL** and **CSV data processing**. This project demonstrates the ability to clean, analyze, and derive actionable business insights from a large retail dataset.

---

## 🧠 Project Overview

This project analyzes product-level data from Zepto, a fast-commerce platform. The dataset includes details about products, prices, discounts, categories, availability, and inventory. The primary objectives are to:

- Identify the most frequent products
- Highlight products with high MRP but low discounts
- Analyze category-wise discount trends
- Detect missing or inconsistent data entries
- Evaluate overall stock and availability

The pipeline leverages:

- 📄 A **CSV file** (`zepto_v2.csv`) containing raw product data
- 🧮 An **SQL script** (`Zepto_Script.sql`) with queries for cleaning, validation, and analysis

---

## 📁 Project Files

| File Name           | Description                                           |
|---------------------|-------------------------------------------------------|
| `zepto_v2.csv`      | Raw dataset with product-related information          |
| `Zepto_Script.sql`  | SQL queries for data cleaning, validation, and analysis |

---

## 🛠️ Key Features

- ✅ **Data Cleaning**: Identifies and handles NULL or missing values in fields like product name, category, MRP, discount percentage, and more.
- 📊 **Descriptive Analysis**: Uncovers the most duplicated products, highly discounted categories, and items with unusual pricing patterns.
- 🏷️ **Category Insights**: Determines which product categories offer the highest average discounts.
- 🚫 **Data Validation**: Filters out rows with incomplete or inconsistent data.

---

## 🧾 Example SQL Queries

1. **Find Duplicate Product Names**:
   ```sql
   SELECT name, COUNT(sku_id) AS "Number of SKUs"
   FROM zepto
   GROUP BY name
   HAVING COUNT(sku_id) > 1
   ORDER BY COUNT(sku_id) DESC;
   ```

2. **Check for Missing or NULL Values**:
   ```sql
   SELECT *
   FROM zepto
   WHERE name IS NULL 
      OR category IS NULL 
      OR mrp IS NULL
      OR discountPercent IS NULL 
      OR discountedSellingPrice IS NULL
      OR weightInGms IS NULL 
      OR availableQuantity IS NULL
      OR outOfStock IS NULL 
      OR quantity IS NULL;
   ```

---

## 🛠️ Tools & Technologies

- **SQL**: MariaDB / MySQL for querying and analysis
- **CSV Processing**: Handling raw data import and preprocessing
- **Data Cleaning**: Techniques to ensure data quality
- **Query Optimization**: Efficient SQL queries for large datasets
- **Data Exploration**: Extracting meaningful insights from raw data

---

## ⭐ Get Involved

If you find this project inspiring, feel free to use it as a foundation for your own SQL-based data analysis projects! Contributions, feedback, or suggestions are welcome.
