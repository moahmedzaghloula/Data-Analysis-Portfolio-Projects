# Data Cleaning Project: World Layoffs Analysis

## 📌 Project Overview

This SQL project focuses on cleaning and preparing a dataset of global company layoffs for analysis. The dataset contains comprehensive information about companies, industries, locations, layoff numbers, dates, and funding details. The primary goal was to transform raw, messy data into a clean, standardized, and reliable format suitable for in-depth exploratory data analysis and trend identification.

## 🛠️ Data Cleaning Steps

The data cleaning process involved several crucial steps to ensure data integrity and consistency:

### 1. Removing Duplicates

*   **Staging Table:** A staging table was created to preserve the original dataset, allowing for safe transformations without altering the source data.
*   **Identification:** Duplicates were identified using the `ROW_NUMBER()` window function with `PARTITION BY` on key columns (e.g., company, location, industry, total\_laid\_off, percentage\_laid\_off, date, stage, country, funds\_raised\_millions) to assign a unique row number within each partition of identical rows.
*   **Removal:** A solution was implemented to safely remove duplicates by creating a new table that included the row numbers. Subsequently, rows where the row number was greater than 1 (indicating a duplicate) were deleted.

### 2. Standardizing Data

*   **Company Names:** Leading and trailing whitespace was removed from company names using `TRIM()` to ensure consistent naming.
*   **Industry:** Variations of "Crypto" (e.g., 'Crypto Currency', 'Crypto') were standardized to a single, consistent category "Crypto" to facilitate easier aggregation and analysis.
*   **Countries:** Trailing periods were removed from country names (e.g., "United States." became "United States") for uniformity.
*   **Dates:**
    *   Text-based date formats were converted to a proper `DATE` format using `STR_TO_DATE()`.
    *   The column data type was subsequently modified to `DATE` to ensure correct chronological sorting and date-based operations.

### 3. Handling Null Values

*   **Consistency:** Empty strings (`''`) were converted to `NULL` values across the dataset for consistency, as SQL treats empty strings differently from `NULL`.
*   **Data Imputation:** Missing industry data was populated by performing a self-join on the table. This involved matching companies with known industry information to fill in `NULL` industry values for the same company in other records.
*   **Analytical Integrity:** `NULL` values in numerical fields (e.g., `total_laid_off`, `percentage_laid_off`) were intentionally maintained where appropriate, as they convey meaningful information (e.g., data not available or not applicable) and are crucial for accurate analysis.

### 4. Removing Unnecessary Data

*   **Irrelevant Records:** Records where both `total_laid_off` and `percentage_laid_off` were `NULL` were deleted, as these rows provided insufficient information for layoff analysis.
*   **Temporary Columns:** The temporary row number column, which was used during the deduplication process, was removed after its purpose was served.

## 🔍 Key SQL Techniques Used

This project leveraged a variety of SQL techniques to achieve robust data cleaning:

*   **Window Functions:** Specifically `ROW_NUMBER()` for identifying and managing duplicate records.
*   **Common Table Expressions (CTEs):** Used for breaking down complex queries into more readable and manageable parts, particularly during deduplication.
*   **String Manipulation Functions:** `TRIM()` for cleaning whitespace and `STR_TO_DATE()` for date format conversion.
*   **Table Self-Joins:** Employed effectively for data imputation, specifically for populating missing industry information.
*   **Conditional Updates:** `NULLIF()` was used to convert empty strings to `NULL` values.
*   **Schema Modifications:** `ALTER TABLE` statements were used to modify column data types (e.g., to `DATE`).

## 📊 Dataset Structure

The final cleaned dataset, `layoffs_staging2`, contains the following columns:

| Column Name          | Description                                    |
| :------------------- | :--------------------------------------------- |
| `company`            | Name of the company                            |
| `location`           | Geographic location of the company             |
| `industry`           | Industry sector the company belongs to         |
| `total_laid_off`     | Total number of employees laid off             |
| `percentage_laid_off`| Percentage of the workforce laid off           |
| `date`               | Date of the layoff event                       |
| `stage`              | Company's funding stage at the time of layoff  |
| `country`            | Country where the layoff occurred              |
| `funds_raised_millions`| Total funding raised by the company (in millions USD) |

**Example of the final cleaned table structure (first 5 rows):**

```sql
SELECT * FROM layoffs_staging2 LIMIT 5;
