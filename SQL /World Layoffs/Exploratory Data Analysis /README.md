# Exploratory Data Analysis 📊

## Project Description 📝
This project performs an exploratory data analysis (EDA) on a dataset of company layoffs. The analysis aims to uncover trends, patterns, and interesting insights related to layoffs across various companies, industries, locations, and timeframes.

## Data Source 📁
The primary data source for this analysis is `layoffs.csv`, which contains detailed information about company layoffs.

### `layoffs.csv` Columns:
- `company`: Name of the company.
- `location`: Location of the company.
- `industry`: Industry sector of the company.
- `total_laid_off`: Total number of employees laid off.
- `percentage_laid_off`: Percentage of employees laid off.
- `date`: Date of the layoff.
- `stage`: Funding stage of the company (e.g., Post-IPO, Series A, Series B).
- `country`: Country where the company is located.
- `funds_raised_millions`: Funds raised by the company in millions of USD.

## SQL Analysis 🔍
The `ExploratoryDataAnalysis.sql` file contains a series of SQL queries used to perform the exploratory data analysis. Key areas of analysis include:

- **Layoff Magnitude**: Identifying the maximum and minimum percentage of employees laid off, and pinpointing companies that laid off 100% of their workforce.
- **Top Layoffs**: Ranking companies by the total number of employees laid off in single events and cumulatively.
- **Geographical and Industrial Impact**: Analyzing layoffs by location, country, and industry to understand regional and sector-specific trends.
- **Funding Stage Analysis**: Examining layoff data based on the company\'s funding stage.
- **Temporal Trends**: Investigating layoff patterns over time, including monthly and yearly breakdowns, and identifying top companies by layoffs per year.

## How to Use 🚀
1. Ensure you have a SQL database (e.g., MySQL) set up.
2. Load the `layoffs.csv` dataset into a table named `layoffs_staging2` in your database.
3. Execute the queries in `ExploratoryDataAnalysis.sql` to perform the analysis.

## Contributing 🤝
Feel free to fork this repository and contribute to the analysis.

## License 📜
This project is open source and available under the MIT License.
