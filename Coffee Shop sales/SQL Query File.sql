SELECT * FROM Coffee_Shop_Sales;

SELECT DISTINCT(YEAR(transaction_date)) as 'Year' 
FROM Coffee_Shop_Sales;

SELECT DISTINCT(DATENAME(MONTH, transaction_date)) as 'Month', MONTH(transaction_date) as 'Month_num' 
FROM Coffee_Shop_Sales
ORDER BY Month_num;


-- Q) Monthly Total Sales/Trend  of Coffee Shop.
SELECT	MONTH(transaction_date) as Month_num,
		DATENAME(MONTH, transaction_date) as 'Month',
		ROUND(SUM(unit_price * transaction_qty),2) as Total_Sales		
FROM  Coffee_Shop_Sales
GROUP BY	DATENAME(MONTH, transaction_date),
			MONTH(transaction_date)
ORDER BY Month_num;



-- Q)Which days of the week tend to be busiest, and why do you think that's the case?

-- ANS :: i) Sales By Days / Week 
SELECT	DATEPART(DW, transaction_date) as day_num,
		DATENAME(WEEKDAY, transaction_date) as day_of_week,
		ROUND(SUM(unit_price * transaction_qty),2) as Total_sales
FROM Coffee_Shop_Sales
GROUP BY	DATENAME(WEEKDAY, transaction_date),
			DATEPART(DW, transaction_date)
ORDER BY day_num

-- ANS :: ii) Which days of the week tend to be busiest
SELECT	DATEPART(DW, transaction_date) as day_num,
		DATENAME(WEEKDAY, transaction_date) as day_of_week,
		ROUND(SUM(unit_price * transaction_qty),2) as Total_sales
FROM Coffee_Shop_Sales
GROUP BY	DATENAME(WEEKDAY, transaction_date),
			DATEPART(DW, transaction_date)
ORDER BY Total_sales DESC;

-- DATENAME(WEEKDAY, transaction_date) : Provides the Day of the week.
-- DATEPART(DW, transaction_date) : Provides the Number of week days.
-- DATENAME(MONTH, transaction_date) : Provides the Month Name.
-- MONTH(transaction_date) : Provides the Month Number.


-- 3 Which products are sold most and least often? Which drive the most revenue for the business?
SELECT	product_category,
		SUM(transaction_qty) as Product_sold_count,
		ROUND(SUM(transaction_qty * unit_price),2) as Total_revenue
FROM Coffee_Shop_Sales
GROUP BY product_category
ORDER BY Product_sold_count;


-- Q) Total Sales By Hours?
SELECT	
		DATEPART(HOUR ,transaction_time) as Peek_hour,
		ROUND(SUM(transaction_qty * unit_price),2) as Total_revenue
FROM Coffee_Shop_Sales
GROUP BY DATEPART(HH,transaction_time)
ORDER BY Peek_hour


-- Q) Find the Total Revenue by Store along with its location ?
SELECT	DISTINCT store_id,
		store_location,
		ROUND(SUM(transaction_qty * unit_price),2) as Total_revenue  
FROM Coffee_Shop_Sales
GROUP BY store_id,store_location;

-- Q) Which product type has max demand?
SELECT 
		product_category,
		product_type,
		COUNT(product_type) as deamand_count 
FROM Coffee_Shop_Sales
GROUP BY	product_type,
			product_category
ORDER BY deamand_count DESC;


-- Q) Find the Minimum and Maximum unit price along with category.
SELECT	product_category,
		ROUND(MIN(unit_price),2) as Min_unit_price,
		ROUND(MAX(unit_price),2) as Max_unit_price
FROM Coffee_Shop_Sales
GROUP BY product_category

-- Q) Privious month Sales/Revenue
SELECT	
		ROUND(SUM(transaction_qty * unit_price),2) as Total_revenue
FROM Coffee_Shop_Sales
WHERE MONTH(transaction_date) = 5



