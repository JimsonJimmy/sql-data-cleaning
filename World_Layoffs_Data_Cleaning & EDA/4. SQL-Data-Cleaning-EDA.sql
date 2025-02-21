-- Get all data from layoffs_staging2 table
SELECT * 
FROM layoffs_staging2; 

-- Find the maximum layoffs and maximum percentage of layoffs
SELECT max(total_laid_off), max(percentage_laid_off) 
FROM layoffs_staging2;

-- Get companies where 100% employees were laid off, ordered by funds raised
SELECT * 
FROM layoffs_staging2 
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC; 

-- Total layoffs per company, sorted in descending order
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 DESC;

-- Find the earliest and latest layoff dates
SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;

-- Total layoffs per industry, sorted in descending order
SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY industry 
ORDER BY 2 DESC;

-- Total layoffs per country, sorted in descending order
SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY country 
ORDER BY 2 DESC;

-- Total layoffs per year, sorted by year
SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY YEAR(`date`) 
ORDER BY 1 DESC;

-- Total layoffs by company stage, sorted in descending order
SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY stage 
ORDER BY 2 DESC;

-- Total layoffs per month, filtering out null values
SELECT substr(`date`,1,7) AS `MONTH`, SUM(total_laid_off) 
FROM layoffs_staging2 
WHERE substr(`date`,1,7) IS NOT NULL 
GROUP BY `MONTH` 
ORDER BY 1;

-- Calculate cumulative (rolling) layoffs over months
WITH Rolling_total AS  
(SELECT substr(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off 
 FROM layoffs_staging2 
 WHERE substr(`date`,1,7) IS NOT NULL 
 GROUP BY `MONTH` 
 ORDER BY 1 ASC)
SELECT `MONTH`, total_off, 
       SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total 
FROM Rolling_total;

-- Total layoffs per company, sorted in descending order
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 DESC;

-- Total layoffs per company per year, sorted in descending order
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company, YEAR(`date`) 
ORDER BY 3 DESC;

-- Find top 5 companies with the highest layoffs each year
WITH Company_Year(company, years, total_laid_off) AS  
(
    SELECT company, YEAR(`date`), SUM(total_laid_off) 
    FROM layoffs_staging2 
    GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(
    SELECT *, 
           DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking 
    FROM Company_Year 
    WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank 
WHERE Ranking <= 5;













