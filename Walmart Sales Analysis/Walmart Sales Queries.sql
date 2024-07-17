/* 
Developer : Roshan Ashok Khulat
Date : 12th July 2024
Topic : Analysing the Walmart Sales
*/

CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(12 , 2 ) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_percentage FLOAT(11 , 9 ),
    gross_income DECIMAL(10 , 2 ) NOT NULL,
    rating FLOAT(2 , 1 )
);

desc sales;

SELECT * FROM sales;

/* Feature Enginering : This will help us to use genarate new columns from existing one. 

	Add new columns
    1) time_of_day 	: to give insight of the Sales 'Morning' , 'Afternoon', 'Evening'
					  this will help answer the question on which part of the day most sales are made.
    2) day_name		: that contains the extracted day of the week on which the given transaction is took place. 
					  (Mon,Tue,Wed,Thur,Fri,Sat,Sun)
	3) month_name	: that contains the extracted month of the year like
					  (Jan,Feb,March ... )	
*/

-- time_of_day ---------------- - ---------------------------- ---------------------------------- ----
SELECT time,(CASE WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
				  WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
				  ELSE 
                      'Evening' END 
			) as time_of_date FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
                      
-- --------------------------- ------------------ --------------------------------------------- -

-- day_name ------------ ------------------- -------------------- ---------------- 
SELECT  `date`,DAYNAME(`date`) as Weekdays FROM sales;

ALTER TABLE sales ADD day_name VARCHAR(30);

UPDATE sales
SET day_name = DAYNAME(`date`);

SELECT * FROM sales;

-- ----------------------- --------------------------------- -------------------------------

-- month_name --------   -------------------------------- ----------------------------- ------------------
SELECT  `date`,MONTHNAME(`date`) as `Month` FROM sales;

ALTER TABLE sales ADD `Month` VARCHAR(20);

UPDATE sales 
SET 
    `Month` = MONTHNAME(`date`);

ALTER TABLE sales
RENAME COLUMN `Month` to month_name;

-- ------------------------------------- -------------------------------------------------- --------------
-- Generic question
-- Q) How many unique cities does the data have?
SELECT 
    COUNT(DISTINCT city) AS unique_city_count
FROM
    sales;
    
-- Q) In which city is each branch ?
SELECT DISTINCT
    City, branch
FROM
    sales;

-- Product question
-- Q) How many unique product lines does the data have ?
SELECT 
    COUNT(DISTINCT product_line) AS unique_product_line_count
FROM
    sales;
    
-- Q) What is the Most Common Payment method ?
SELECT 
    payment_method, COUNT(payment_method) AS use_method
FROM
    sales
GROUP BY payment_method
ORDER BY use_method DESC
LIMIT 1; 

--  Q) Which is the most selling product line ?
SELECT 
    product_line,
    unit_price,
    quantity,
    (unit_price * quantity) AS Total_sale
FROM
    sales
ORDER BY Total_sale DESC
LIMIT 1;

SELECT 
    product_line, MAX(total) AS max_sales
FROM
    sales
GROUP BY product_line
ORDER BY max_sales DESC
LIMIT 1;

-- Q)  What is the Total Revenue by Month ?
SELECT 
    month_name, SUM(total) AS Total_Revenue
FROM
    sales
GROUP BY month_name
ORDER BY Total_Revenue DESC;

-- Q) Which month had the largest COGS ?

SELECT 
    month_name, SUM(cogs) AS COGS
FROM
    sales
GROUP BY month_name
ORDER BY COGS DESC;


-- Q) Which product line had the largest revenue ?
SELECT 
    product_line, SUM(total) AS Total_rev
FROM
    sales
GROUP BY product_line
ORDER BY Total_rev DESC
LIMIT 1;

-- Q) Which is the city with Maximum Revenue ?
SELECT 
    city, SUM(total) AS Max_Rev
FROM
    sales
GROUP BY city
ORDER BY Max_Rev DESC
LIMIT 1;

-- Q) Which Product line had largest VAT ?
SELECT 
    product_line, SUM(VAT) AS Max_VAT
FROM
    sales
GROUP BY product_line
ORDER BY Max_VAT DESC
LIMIT 1;


-- Q) Which branch sold more than average product sold ?
SELECT 
    branch, SUM(quantity) AS Total_sold_product
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales)
ORDER BY Total_sold_product DESC
LIMIT 1;


-- Q) Which is the most common product line by gender ?
SELECT 
    *
FROM
    sales;
    
SELECT 
    gender, product_line, COUNT(gender) AS Gender_count
FROM
    sales
GROUP BY gender , product_line
ORDER BY Gender_count DESC;


SELECT * FROM sales;

-- Q) What is the Average rating of each product ?
SELECT 
    product_line, AVG(rating) AS Avg_rating
FROM
    sales
GROUP BY product_line;

-- ============================================================= =============================================================== ================
-- --------- Sales ----------------------------------------------------- --------------
-- Q) Number of sales made in each time of the day per weekday ?

SELECT 
    time_of_day, COUNT(invoice_id) AS sales_count
FROM
    sales
WHERE day_name = 'Sunday'
GROUP BY time_of_day
ORDER BY sales_count DESC;

-- Q) Which of the Customer types bring the most revenue ?
SELECT 
    customer_type, SUM(total) AS revenue
FROM
    sales
GROUP BY customer_type
ORDER BY Revenue DESC
LIMIT 1;

-- Q) Which city has the largest tax percentage / VAT (Value Added Tax) ?
SELECT 
    city, AVG(VAT) AS tax_percentage
FROM
    sales
GROUP BY city
ORDER BY tax_percentage DESC
LIMIT 1;

-- Q) Which customer type pays the most in VAT ?
SELECT 
    customer_type, SUM(VAT) AS total_vat
FROM
    sales
GROUP BY customer_type
ORDER BY total_vat DESC
LIMIT 1;

-- Customer Questiuons
--  Q) How many the unique customer types does the data have ?
SELECT 
    COUNT(DISTINCT customer_type) AS cust_type_cnt
FROM
    sales;
    
-- Q) How Many unique payment methods does the data have ?
SELECT 
    COUNT(DISTINCT payment_method) cnt_of_unique_method
FROM
    sales;
    
-- Q) Which Customer types buys the most ?    
SELECT 
    customer_type, SUM(total) AS total_sales
FROM
    sales
GROUP BY customer_type
ORDER BY total_sales DESC
LIMIT 1;

-- Q) What is the gender of most of the customer ?
SELECT 
    gender, COUNT(*) AS count_by_gen
FROM
    sales
GROUP BY gender
ORDER BY count_by_gen DESC;

-- Q) What is the gender distributuin per branch ?
SELECT 
    branch, gender, COUNT(*) AS gender_count
FROM
    sales
GROUP BY gender , branch
ORDER BY branch;

-- Q) Which time of the day do customer give most rating ?
SELECT 
    time_of_day, COUNT(rating) AS rating_count
FROM
    sales
GROUP BY time_of_day
ORDER BY rating_count DESC
LIMIT 1;

-- Q) Which time of the day do customer give most rating per branch ?
SELECT 
    branch, time_of_day, COUNT(rating) AS rating_count
FROM
    sales
GROUP BY branch , time_of_day
ORDER BY branch , rating_count;



/* 

SELECT branch,time_of_day,COUNT(rating) as rating_count FROM sales
WHERE branch ="A"
GROUP BY branch,time_of_day
ORDER BY branch,rating_count;

*/

-- Q) Which day of the week has the best avg rating ?
SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY day_name
ORDER BY avg_rating DESC;


-- Q) Which day of the week has the best average rating per branch ?
SELECT 
    branch,
    DAYNAME(`date`),
    AVG(rating) AS avg_rating,
    WEEKDAY(`date`) AS Day_num
FROM
    sales
GROUP BY branch , DAYNAME(`date`) , WEEKDAY(`date`)
ORDER BY branch , WEEKDAY(`date`);
