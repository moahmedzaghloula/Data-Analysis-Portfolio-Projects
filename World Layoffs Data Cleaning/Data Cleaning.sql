-- SQL Project - Data Cleaning


USE `world_layoffs`

-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values 
-- 4. remove any columns and rows that are not necessary - few ways


CREATE TABLE layoffs_staging 
LIKE layoffs ;


INSERT layoffs_staging 
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_staging ;  





-- 1. Remove Duplicates

# First let's check for duplicates


SELECT company , industry,total_laid_off,`date`,
ROW_NUMBER() OVER(
PARTITION BY company , industry,total_laid_off,`date`) AS row_num
FROM layoffs_staging ;  


SELECT * 
FROM (
	SELECT company , industry,total_laid_off,`date`,
	ROW_NUMBER() OVER(
	PARTITION BY company , industry,total_laid_off,`date`) AS row_num
	FROM layoffs_staging 
) Duplicates
WHERE row_num > 1 ;

-- let's just look at oda to confirm
SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Oda'
;

-- these are our real duplicates 
SELECT * 
FROM (
	SELECT company , industry,total_laid_off,`date`,stage, country, funds_raised_millions,
	ROW_NUMBER() OVER(
	PARTITION BY company , industry,total_laid_off,`date`) AS row_num
	FROM layoffs_staging 
) Duplicates
WHERE row_num > 1 ;


-- now we will write it in CTEs form :
WITH Delete_CTE AS
(
SELECT * 
FROM (
	SELECT company , industry,total_laid_off,`date`,stage, country, funds_raised_millions,
	ROW_NUMBER() OVER(
	PARTITION BY company , industry,total_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_staging 
) Duplicates
WHERE row_num > 1 
)
DELETE  
FROM Delete_CTE
;

WITH Delete_CTE AS (
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, 
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_staging
)
DELETE FROM layoffs_staging
WHERE (company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num) IN (
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num
	FROM Delete_CTE
) AND row_num > 1;



-- one solution, which I think is a good one. Is to create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column
-- so let's do it!!

ALTER TABLE layoffs_staging ADD row_num INT;

SELECT * 
FROM layoffs_staging ; 

CREATE TABLE `layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);


INSERT INTO `world_layoffs`.`layoffs_staging2`
(`company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, 
 `date`, `stage`, `country`, `funds_raised_millions`, `row_num`)
SELECT 
    `company`, 
    `location`, 
    `industry`, 
    NULLIF(`total_laid_off`, 'NULL'),
    `percentage_laid_off`, 
    `date`, 
    `stage`, 
    `country`, 
    NULLIF(`funds_raised_millions`, 'NULL'),
    ROW_NUMBER() OVER (
        PARTITION BY 
            company, 
            location, 
            industry, 
            NULLIF(`total_laid_off`, 'NULL'),
            percentage_laid_off, 
            `date`, 
            stage, 
            country, 
            NULLIF(`funds_raised_millions`, 'NULL')
    ) AS row_num
FROM world_layoffs.layoffs_staging;


SELECT * 
FROM layoffs_staging2

DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num >= 2;



-- 2. Standardize Data

-- Company Column

SELECT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);


-- Industry Column

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Country Column 

SELECT DISTINCT country , TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1 ;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'

-- Date

SELECT `date` ,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;


UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` != 'NULL' AND `date` IS NOT NULL;


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE ;
  
-- 3. Look at Null Values

-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions all look normal. I don't think I want to change that
-- I like having them null because it makes it easier for calculations during the EDA phase

-- so there isn't anything I want to change with the null values  


-- now we will look at the null values in industry column 

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry ='';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry ='' ;



SELECT t1.industry , t2.industry 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2 
   ON t1.company = t2.company 
   AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL ;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;

SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';


-- 4. remove any columns and rows we need to

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete Useless data we can't really use

UPDATE layoffs_staging2
SET total_laid_off = 0
WHERE total_laid_off IS NULL

UPDATE layoffs_staging2
SET percentage_laid_off = ''
WHERE percentage_laid_off = NULL


DELETE FROM layoffs_staging2
WHERE total_laid_off = 0 ;

DELETE FROM layoffs_staging2
WHERE percentage_laid_off = 'NULL';



SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


SELECT * 
FROM layoffs_staging2;











