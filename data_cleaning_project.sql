# Data Cleaning Project

select*
from layoffs;


#Step 1: Remove Duplicates
#Step 2: Standardize the data
#Step 3: Null values or blank values
#Step 4: Remove any columns

#paste the data from layoff to layoffs_staging

create table layoffs_staging  
like layoffs;

insert layoffs_staging
select *
from layoffs;

select*
from layoffs_staging;

#Identify duplicates

select*,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging; #if it has two or more it means it has duplicates

with duplicate_cte as
(
select*,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select* 
from duplicate_cte
where row_num > 1
;

#Delete duplicates

with duplicate_cte as
(
select*,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
delete
from duplicate_cte
where row_num > 1
;








CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select*
from layoffs_staging2
where row_num>1;

insert into layoffs_staging2
select*,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, 
funds_raised_millions) as row_num
from layoffs_staging
;


delete
from layoffs_staging2
where row_num>1;

select*
from layoffs_staging2
;


#Standardizing data

select company, trim(company)
from layoffs_staging2
;

update layoffs_staging2
set company = trim(company)
;

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct country
from layoffs_staging2
order by 1
;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
where country like 'United States%'
;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%'
;


#change date column

select `date`
from layoffs_staging2;

update layoffs_staging2
set `date`= str_to_date(`date`, '%m/%d/%Y')
;

alter table layoffs_staging2
modify column `date` date;


# NULL and Blank values

select*
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

update layoffs_staging2
set industry = null
where industry = '';

select *
from layoffs_staging2
where industry is null
or industry = ''
;

select*
from layoffs_staging2
where company like 'Bally%'
;

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company = t2.company
where t1.industry is null
and t2.industry is not null
;

update layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null)
and t2.industry is not null
;
#note: we cannot populate other stuff because of how specific the data is

select*
from layoffs_staging2
;

#Remove any column or rows

select*
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

alter table layoffs_staging2
drop column row_num;

select*
from layoffs_staging2;
