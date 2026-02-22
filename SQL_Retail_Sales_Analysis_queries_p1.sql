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

SELECT
	COUNT(*)
FROM
	RETAIL_SALES;

-- DATA CLEANING --

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


-- ******* DATA EXPLORATION ******* --

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


--******* Data Analysis & Business Key Problems & Answers *******--

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM 
	retail_sales 
WHERE
	sale_date = '2022-11-05' ;


 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in 

SELECT *
FROM 
	retail_sales 
WHERE
	 category = 'Clothing'
	 AND quantity > 3 
	 AND TO_CHAR(sale_date,'yyyy-mm')='2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category,
	SUM(total_sale) AS net_sale,
	count(*) AS total_orde
FROM
	retail_sales
GROUP BY category
ORDER BY 2 DESC;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(age),2) AS avg_age
FROM 
	retail_sales
WHERE 
	category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT
	*
FROM 
	retail_sales
WHERE 
	total_sale >1000 ;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANSACTIONS
FROM
	RETAIL_SALES
GROUP BY
	1,
	2
ORDER BY
	1;
	
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

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
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT
	customer_id ,
	SUM(total_sale) AS net_sale
FROM
	retail_sales
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 5;
















