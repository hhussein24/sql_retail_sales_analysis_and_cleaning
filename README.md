# Sales Analysis SQL Project

## Project Overview

This project is crafted to highlight essential SQL skills and methodologies commonly employed by data analysts to investigate, cleanse, and interpret retail sales data. It encompasses the creation of a retail sales database, conducting exploratory data analysis, and addressing targeted business inquiries using SQL queries. Through this project, I aim to demonstrate a strong proficiency in SQL and its practical applications in data analysis.

## Objectives

1. **Database Setup**: Establish and populate a retail sales database using the provided dataset.
2. **Data Cleaning Process**: Detect and eliminate records containing missing or null values to ensure data integrity.
3. **Exploratory Data Analysis (EDA)**: Conduct initial data exploration to gain insights into the dataset's structure and trends.
4. **Business Insights Extraction**: Leverage SQL to address key business questions and extract actionable insights from the sales data.

## Project Structure

### 1. Database Setup

- **Creating the Database**: The project begins with the creation of a database named `retail_db`.
- **Table Creation**: A table named `retail_sales` is designed to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Total Records**: Calculate the overall number of records present in the dataset.
- **Unique Customers**: Identify the count of distinct customers within the dataset.
- **Product Categories**: List all unique product categories available in the data.
- **Handling Missing Data**: Detect and remove records containing null or missing values to ensure data quality.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were crafted to address specific business questions and uncover insights:

1. **Retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Retrieve Transactions for Clothing Purchases with Quantity Greater Than 4 in November 2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Calculate the Total Sales Amount for Each Product Category**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to calculate the average age of customers who made purchases in the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to retrieve all transactions with a total sale amount exceeding 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to count the total number of transactions (transaction_id) for each gender within each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to compute the average sales for each month and identify the best-selling month for each year.**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to retrieve the top 5 customers with the highest total sales.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **WWrite a SQL query to categorize shifts (Morning: <12, Afternoon: 12-17, Evening: >17) and count the number of orders for each shift.**:
```sql
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
GROUP BY shift
```

## Findings

- **Customer Profiles**: The dataset represents a diverse range of age groups, with sales spanning multiple categories like Clothing and Beauty.
- **Large Transactions**: Multiple purchases exceeded 1000 in total sales, highlighting high-value transactions.
- **Sales Patterns**: A month-by-month analysis reveals fluctuations in sales, aiding in the identification of peak periods.
- **Consumer Behavior**: The data highlights top-spending customers and the most in-demand product categories.

## Reports

- **Revenue Overview**: A comprehensive summary of total sales, including customer demographics and category performance.
- **Sales Patterns**: Analyzes trends across various months and time shifts to identify peak sales periods.
- **Customer Analytics**: Highlights top-spending customers and tracks unique customer engagement by category.

## Conclusion

This project provides a thorough introduction to SQL for data analysts, encompassing database configuration, data preprocessing, exploratory analysis, and business-oriented queries. The insights derived from this analysis support data-driven decision-making by identifying sales trends, customer purchasing habits, and product performance metrics.

## Author - Hakeem Hussein

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Thank you for your support, and I look forward to connecting with you!
