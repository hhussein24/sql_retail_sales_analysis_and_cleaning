# Sales Analysis

## Analysis Overview

This Analysis showcases my expertise in data analytics by leveraging SQL to extract, process, and evaluate transaction data. It involves constructing a structured database, conducting in-depth assessments of sales trends, and generating insights to support strategic decision-making. Through advanced query techniques, this analysis highlights my ability to work with complex datasets, optimize data workflows, and derive meaningful business intelligence.

## Objectives

1. **Database Setup**: Establish and populate a database using the provided dataset.
2. **Data Cleaning Process**: Detect and eliminate records containing missing or null values to ensure data integrity.
3. **Exploratory Data Analysis**: Conduct initial data exploration to gain insights into the dataset's structure and trends.
4. **Business Insights Extraction**: Leverage SQL to address key business questions and extract actionable insights from the data.

## Analysis Structure

### 1. Database Setup

- **Creating the Database**: The analysis begins with the creation of a database named `retail_db`.
- **Table Creation**: A table named `retail_sales` is designed to store the data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_db;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
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
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
      gender IS NULL OR age IS NULL OR category IS NULL OR 
      quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
      gender IS NULL OR age IS NULL OR category IS NULL OR 
      quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were crafted to address specific business questions and uncover insights:

1. **Retrieve all columns for sales made on '2022-01-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-01-05';
```

2. **Retrieve Transactions for Clothing Purchases with Quantity Greater Than 5 in March 2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-03'
    AND
    quantity >= 5
```

3. **Calculate the Total Sales Amount for Each Product Category**:
```sql
SELECT 
    category, 
    SUM(total_sale) AS net_sale, 
    COUNT(*) AS total_orders 
FROM retail_sales 
GROUP BY category;
```

4. **Write a SQL query to calculate the average age of customers who made purchases in the 'Beauty' category.**:
```sql
SELECT 
    ROUND(AVG(age), 2) AS avg_age 
FROM retail_sales 
WHERE category = 'Beauty';
```

5. **Write a SQL query to retrieve all transactions with a total sale amount exceeding 2000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 2000;
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
ORDER BY category;
```

7. **Write a SQL query to compute the average sales for each month and identify the best-selling month for each year.**:
```sql
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS ranked_sales
WHERE rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id, 
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Write a SQL query to retrieve the top 5 customers with the highest total sales.**:
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to classify sales into shifts (Morning: before 12 PM, Afternoon: 12-5 PM, Evening: after 5 PM) and count the total orders for each shift.**:
```sql
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift;
```

## Conclusion

# Findings

- **Diverse Customer Base**: The dataset includes a wide range of age groups, with purchases spanning multiple categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions exceeded $1,000, indicating premium product sales and high-spending customers.
- **Sales Trends**: A month-by-month analysis highlights seasonal fluctuations, helping identify peak sales periods.
- **Consumer Behavior**: The data reveals top-spending customers and the most frequently purchased product categories, aiding in business strategy.

# Reports & Analysis

- **Revenue Overview**: A summary of total sales, customer demographics, and product performance.
- **Trend Analysis**: A breakdown of sales variations across months and different time shifts (morning, afternoon, evening).
- **Customer Insights**: An in-depth look at high-value customers and engagement levels across various categories.
