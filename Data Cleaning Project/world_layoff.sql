-- Data Cleaning

SELECT *
FROM layoffs;

-- Data Loading Steps
-- 1. Create new schema
-- 2. Import Table via Table Data Import


--  Data Cleaning Steps
-- 1. Remove Duplicates
-- 2. Standardize the data 
-- 3. Null and blank values
-- 4. Remove any columns with unnecessary data (Use the staging table to avoid removing delicate data) 

-- Creating and inserting values to the layoff_staging table
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;


-- Check what are the duplicate rows based on their distinct row no. from distinct column values
SELECT *, 
ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging; 


-- Isolating the duplicate rows
WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Double Checking the duplicate rows values 
SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';

-- Create a layoff_staging2 table where the duplicates will be deleted in this table
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserting the values from layoffs_staging but with additional row_num column 
INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

-- This simplifies the deletion process as the new table has the row_num which can narrow the copies
DELETE
from layoffs_staging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;
-- Now layoff_staging2 does not contain the duplicates anymore

-- 2. STANDARDIZING DATA - Finding issues in the data (usually string  formatting and data types)

-- Company col
SELECT company, trim(company)
FROM layoffs_staging2;

-- Removing the unnecessary spacing before and after the data
UPDATE layoffs_staging2
SET company = TRIM(company);
--

-- Industry col
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Update the industry names that are the same but has different naming
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- 

-- location col
SELECT distinct country
FROM layoffs_staging2
ORDER BY 1;

-- Means character that are after the word
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
WHERE country LIKE 'United States%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Updating data type of date from TEXT to DATE
SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y') as Formatted_date
FROM layoffs_staging2; 

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2
order by `date`;

-- We can now change the data type from TEXT to DATE format now that we have transformed the formatting 
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3. WORKING WITH NULL AND BLANK VALUES
-- Locate the null values is laid_off 
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Locate blank values
SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';


-- Populating blank values with rows that has values of the same company
SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 as t1
JOIN layoffs_staging2 as t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 as t1
JOIN layoffs_staging2 as t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE industry is null 
OR industry = '';


-- DELETING ROWS WITH EMPTY DATA 
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- DROP the row_num column as the duplicates are now removed
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Finalized Data Cleaning
SELECT *
FROM layoffs_staging2;




























