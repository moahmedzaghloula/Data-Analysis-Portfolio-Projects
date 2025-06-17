-- Exploratory Data Analysis 

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers
-- normally when you start the EDA process you have some idea of what you're looking for
-- with this info we are just going to look around and see what we find!

USE `world_layoffs` ;

SELECT * 
FROM layoffs_staging2;



-- Looking at Percentage to see how big these layoffs were

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

-- if we order by funcs_raised_millions we can see how big some of these companies were

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC ;
-- BritishVolt looks like an EV company, Quibi! I recognize that company - wow raised like 2 billion dollars and went under - ouch




-- Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY 2 DESC

-- Companies with the most Total Layoffs

SELECT company ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC ;


-- by location 

SELECT location ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location 
ORDER BY 2 DESC ;


-- this it total in the past 3 years or in the dataset

SELECT MIN(`date`) ,  MAX(`date`)
FROM layoffs_staging2 ;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
    
SELECT industry ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry 
ORDER BY 2 DESC ;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.
-- I want to look at 

SELECT SUBSTRING(`date` ,1,7) AS `MONTH` , SUM(total_laid_off) 
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY `MONTH` 
ORDER BY 1 ASC ;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date` ,1,7) AS `MONTH` , SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY `MONTH` 
ORDER BY 1 ASC 
)
SELECT `MONTH` ,total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total ;


WITH Company_Year (company,years,total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),Company_Year_Rank AS 
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;











