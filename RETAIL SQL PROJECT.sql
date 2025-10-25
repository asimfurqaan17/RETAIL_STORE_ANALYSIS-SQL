-- Creating tables
CREATE TABLE retail_sales_tb
			(	
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15) ,
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
				);

SELECT * FROM retail_sales_tb
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
	OR
	customer_id IS NULL
    OR
    gender IS NULL
	OR
	age IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
	price_per_unit IS NULL
	OR
    cogs IS NULL
    OR
    total_sale IS NULL;

DELETE from retail_sales_tb
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
	OR
	customer_id IS NULL
    OR
    gender IS NULL
	OR
	age IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
	price_per_unit IS NULL
	OR
    cogs IS NULL
    OR
    total_sale IS NULL;
SELECT * FROM retail_sales_tb;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;
-- How many unique categories do we have?
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales_tb
WHERE sale_date IS '2022-11-05;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing'
and the quantity sold is more than 4 in the month of Nov-2022
SELECT * 
	FROM retail_sales_tb
	WHERE category ='Clothing'
	AND quantiy >=4
	AND EXTRACT(MONTH FROM sale_date) = 11
	AND EXTRACT(YEAR FROM sale_date) = 2022;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
category,
SUM(total_sale) AS net_sales
FROM retail_sales_tb
GROUP BY category;
 
-- Q.4 Write a SQL query to find the average age of customers who purchased items 
from the 'Beauty' category.

SELECT customer_id,
ROUND((age), 2) as avg_age
FROM retail_sales_tb
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales_tb
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each 
gender in each category.

SELECT
category,gender,
Count(*) as total_transactions
FROM retail_sales_tb
GROUP BY category, gender
ORDER BY category, gender;


-- Q.7 Write a SQL query to calculate the average sale for each month. 
Find out best selling month in each year

WITH average_cte AS (
SELECT 
EXTRACT(YEAR FROM sale_date) AS YEAR,
EXTRACT(MONTH FROM sale_date) AS MONTH,
AVG(total_sale) AS avg_sale,
RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales_tb
GROUP BY YEAR, MONTH
ORDER BY YEAR, MONTH, avg_sale DESC
)
SELECT
year, month, avg_sale
FROM average_cte
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
customer_id,
SUM(total_sale) AS highest_total
FROM retail_sales_tb
GROUP BY customer_id
ORDER BY highest_total DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers 
who purchased items from each category.

SELECT 
category,
count(DISTINCT(customer_id)) as count_category
FROM retail_sales_tb
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and
number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH shift_sales AS (
SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales_tb
)

SELECT
shift,
count(transactions_id) AS count_per_shift
FROM shift_sales
GROUP BY shift