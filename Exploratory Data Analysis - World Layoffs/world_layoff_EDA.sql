-- Exploratory Data Analysis
-- NOTE: You need to undergo the data cleaning process in world_layoff file first using the dataset provided 
-- 			to utilize this exploration

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Total Laid off of a company arrange in DESC
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
group by company
ORDER by 2 desc; -- 2 means that the second column will be arrange either ASC or 

-- Total Laid off count from the first year up to the last year in the dataset
SELECT MIN(`date`), max(`date`), SUM(total_laid_off)
FROM layoffs_staging2;

-- The industry which has the highest layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
group by industry
ORDER by 2 desc;

-- The country which has the highest layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
group by country
ORDER by 2 desc;

-- Annual Layoffs
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by YEAR(`date`)
ORDER by 1 desc;

-- Stage of the layoffs
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
group by stage
ORDER by 2 desc;

-- Layoff count per month since the starting month
SELECT SUBSTRING(`date`, 1,7) AS MONTH, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) is not null
group by `MONTH`
ORDER by 1;


-- Rolling total count per month Globally
WITH Rolling_total AS 
(
SELECT SUBSTRING(`date`, 1,7) AS MONTH, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) is not null
group by `MONTH`
ORDER by 1
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;


-- Rolling total count of Layoffs per month in any Country
WITH Rolling_total_country AS 
(
SELECT country, SUBSTRING(`date`, 1,7) AS MONTH, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) is not null
AND country = 'United States' -- Change the country name to see their total and rolling total
group by `MONTH`
ORDER by 1
)
SELECT country,`MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total_country;


-- Ranking the COMPANIES with Most Layoffs per Year
WITH Company_Layoffs_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Layoff_Rank AS 
(
-- dense_rank continuous the rank count while rank skips a number in case there are same rankings
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as Layoff_Rankings
FROM Company_Layoffs_Year
WHERE years is not null
)
-- Top 5 Most Company Layoffs per Year
SELECT *
FROM Company_Layoff_Rank
WHERE Layoff_Rankings <= 5
;


-- Ranking the INDUSTRIES with Most Layoffs per Year
WITH industry_Layoffs_Year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
), Industry_Layoff_Rank AS 
(
-- dense_rank continuous the rank count while rank skips a number in case there are same rankings
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as Layoff_Rankings
FROM Industry_Layoffs_Year
WHERE years is not null
)
-- Top 5 Most Industry Layoffs per Year
SELECT *
FROM Industry_Layoff_Rank
WHERE Layoff_Rankings <= 5
;





