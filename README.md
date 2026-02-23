
<img src="Retail_sales.png" width="100%">



# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(15),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTITY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

SELECT
    SUM(CASE WHEN transactions_id IS NULL THEN 1 ELSE 0 END) AS null_transactions_id,
    SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS null_sale_date,
    SUM(CASE WHEN sale_time IS NULL THEN 1 ELSE 0 END) AS null_sale_time,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS null_price_per_unit,
    SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS null_cogs,
    SUM(CASE WHEN total_sale IS NULL THEN 1 ELSE 0 END) AS null_total_sale
FROM retail_sales;

DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

--Total number of transactions 

SELECT 
	COUNT(*) AS Total_transactions
FROM
	retail_sales ;

-- total number of customers 
SELECT 
	COUNT(DISTINCT(customer_id)) AS Unique_customers
FROM
	retail_sales ;

-- how many categories we have ?
SELECT 
	DISTINCT(category) AS Total_transactions
FROM
	retail_sales ;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM 
	retail_sales 
WHERE
	sale_date = '2022-11-05' ;
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
SELECT *
FROM 
	retail_sales 
WHERE
	 category = 'Clothing'
	 AND quantity > 3 
	 AND TO_CHAR(sale_date,'yyyy-mm')='2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
	category,
	SUM(total_sale) AS net_sale,
	count(*) AS total_orde
FROM
	retail_sales
GROUP BY category
ORDER BY 2 DESC;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
	ROUND(AVG(age),2) AS avg_age
FROM 
	retail_sales
WHERE 
	category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql

SELECT
	*
FROM 
	retail_sales
WHERE 
	total_sale >1000 ;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANSACTIONS
FROM
	RETAIL_SALES
GROUP BY 1,2
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    ROUND(AVG(total_sale)::NUMERIC, 2) AS avg_sales,
	RANK() OVER( PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS Rank
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 desc;


SELECT * 
FROM
	(	SELECT
    		EXTRACT(YEAR FROM sale_date) AS year,
    		EXTRACT(MONTH FROM sale_date) AS month,
    		ROUND(AVG(total_sale)::NUMERIC, 2) AS avg_sales,
			RANK() OVER( PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS Rank
		FROM retail_sales
		GROUP BY 1, 2
		ORDER BY 1, 3 desc
	) AS t1
WHERE Rank = 1 ;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT
	customer_id ,
	SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 5;

```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
	category ,
	count(DISTINCT(customer_id))
FROM retail_sales
GROUP BY 1 ;

```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sales AS
		(
			SELECT 
				* ,
				CASE 
					WHEN EXTRACT(HOUR FROM sale_time ) < 12  THEN 'Morning'
					WHEN EXTRACT(HOUR FROM sale_time ) BETWEEN 12 AND 17 THEN 'Afternoon' 
					ELSE 'Evening'
				END AS shift
			FROM  retail_sales
		)
SELECT 
	COUNT(*) AS total_orders ,
	shift
FROM  hourly_sales
GROUP BY 2
ORDER BY 1 DESC 
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.









