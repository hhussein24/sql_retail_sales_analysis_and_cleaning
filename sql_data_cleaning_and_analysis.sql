-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
            (
		transactions_id INT PRIMARY KEY, 
		sale_date DATE,	
		sale_time TIME,	
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),	
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
);

select * from retail_sales;

SELECT COUNT(*) FROM retail_sales;

-- 
SELECT * FROM retail_sales
WHERE transactions_id is NULL;

SELECT * FROM retail_sales
WHERE sale_date is NULL;

SELECT * FROM retail_sales
WHERE sale_time is NULL;

SELECT * FROM retail_sales
WHERE transactions_id is NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender is null
OR AGE IS NULL
OR category IS NULL
OR quantity IS NULL
OR COGS IS NULL
OR price_per_unit IS NULL
OR total_sale IS NULL;

-- 
DELETE FROM retail_sales
WHERE transactions_id is NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender is null
OR AGE IS NULL
OR category IS NULL
OR quantity IS NULL
OR COGS IS NULL
OR price_per_unit IS NULL
OR total_sale IS NULL;

-- Data Exploration

-- How many sales we have
SELECT COUNT(*) as total_sale from retail_sales;

-- How many unique customers do we have
SELECT COUNT(distinct customer_id) from retail_sales;

-- How many unique catgories do we have
SELECT COUNT(distinct category) from retail_sales;

-- Data analysis & Buissness key problems & Answers

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL uqery to retrive all transactions where the category is 'Clothing' and the 
-- qunatity sold is more than 4 in the month of NOV-2022

SELECT 
	*
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantity >= 4;

-- q3 Write a SQL query to calculate the total sales (total_sale) for each category

SELECT 
	category,
	sum(total_sale) as net_sale,
	COUNT(*) as total_orders
from retail_sales
group by category;

-- q4 Write a SQL query to find the average age of customers who purchased items 
--from the 'Beauty' category

SELECT 
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

--Q5 write a SQL query to find all transactions where the total_sale is greater than 1000 

SELECT * FROM retail_sales
WHERE total_sale > 1000;


--Q6 Write a SQL query to find the total number of transactions (transaction_id)
-- made by each gender in each category

SELECT
	category,
	gender,
	COUNT(*) as total_trans
from retail_sales
GROUP BY category,
	gender
order by category;

-- Q7 write a SQL query to calculate the average sale for each month.
-- find out best selling month in each year

SELECT
		year,
		month,
		avg_sale
from
(
SELECT
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	rank() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER by AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1;

--Q8 write a SQL query to find the top 5 customers based on the highest total sales
SELECT
	customer_id,
	SUM(total_sale) as total_sale
FROM retail_sales
group by 1
order by 2 DESC
LIMIT 5;

--q9 Write a SQL query to find the number of unique customers who purchased items from 
-- each category
SELECT 
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY category;

--q10 Write a SQL query to categorize sales into shifts (Morning, Afternoon, Evening) 
--based on the sale_time and calculate the total number of orders for each shift.

WITH hourly_sale
AS
(
SELECT *,
CASE
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;

-- End of Project
