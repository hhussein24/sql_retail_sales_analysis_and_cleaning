-- Create Table
DROP TABLE IF EXISTS sales_database;
CREATE TABLE sales_database (
    transaction_id INT PRIMARY KEY, 
    sale_date DATE,	
    sale_time TIME,	
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),	
    quantity INT,
    price_per_unit FLOAT,
    cost_of_goods_sold FLOAT,
    total_sale FLOAT
);

-- Check the table
SELECT * FROM sales_database;

-- Count total rows in the table
SELECT COUNT(*) AS total_rows FROM sales_database;

-- Check for NULL values in all columns
SELECT * FROM sales_database
WHERE transaction_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR cost_of_goods_sold IS NULL;

-- Delete rows with NULL values
DELETE FROM sales_database
WHERE sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR cost_of_goods_sold IS NULL;

-- Data Exploration

-- Total number of sales
SELECT COUNT(*) AS total_sales FROM sales_database;

-- Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM sales_database;

-- Number of unique categories
SELECT COUNT(DISTINCT category) AS unique_categories FROM sales_database;

-- Business Questions and Answers

-- 1. Retrieve all sales transactions that occurred on March 5, 2022
SELECT *
FROM sales_database
WHERE sale_date = '2022-03-05';

-- 2. Retrieve all transactions for the 'Clothing' category where more than 5 units were sold in March 2022
SELECT *
FROM sales_database
WHERE category = 'Clothing'
  AND EXTRACT(YEAR FROM sale_date) = 2022
  AND EXTRACT(MONTH FROM sale_date) = 3
  AND quantity > 5;

-- 3. Calculate the total sales revenue for each product category
SELECT 
    category, 
    SUM(total_sale) AS total_revenue, 
    COUNT(*) AS total_transactions
FROM sales_database
GROUP BY category;

-- 4. Find the average age of customers who purchased items from the 'Clothing' category
SELECT 
    ROUND(AVG(age), 2) AS average_age
FROM sales_database
WHERE category = 'Clothing';

-- 5. Identify all transactions where the total sale amount exceeded $2000
SELECT * 
FROM sales_database
WHERE total_sale > 2000;

-- 6. Analyze the total number of transactions by gender for each product category
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM sales_database
GROUP BY category, gender
ORDER BY category, gender;

-- 7. Determine the average sales revenue for each month and identify the best-performing month for each year
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS average_sale
    FROM sales_database
    GROUP BY year, month
),
ranked_months AS (
    SELECT 
        year,
        month,
        average_sale,
        RANK() OVER (PARTITION BY year ORDER BY average_sale DESC) AS rank
    FROM monthly_sales
)
SELECT 
    year,
    month,
    average_sale
FROM ranked_months
WHERE rank = 1;

-- 8. Identify the top 5 customers based on their total spending
SELECT 
    customer_id, 
    SUM(total_sale) AS total_spent
FROM sales_database
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 9. Calculate the number of unique customers who made purchases in each product category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales_database
GROUP BY category;

-- 10. Categorize sales transactions into shifts (Morning, Afternoon, Evening) based on the sale time and calculate the total number of orders for each shift
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM sales_database
GROUP BY shift;

-- End of Project
