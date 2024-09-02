CREATE DATABASE `Sales and Expences`;

CREATE table company_report(sales_key int primary key,
                            channnel_key int,
                            store_key int,
                            product_key int,
                            geography_key int,
                            unit_cost double,
                            unit_price double,
                            sales_qty int,
                            return_qty int,
                            return_amt double,
                            discount_qty int,
                            discount_amt double,
                            total_cost double,
                            sales_amt double,
                            sales_date date
                            );
                            
show tables;

CREATE table product_cat(product_cat_key int Primary key, `Product_cat_name` varchar(100));

insert into product_cat values
(1,"Audio"),
(2,"TV and Video"),
(3,"Computers"),
(4,"Cameras and camcorders"), 
(5,"Cell phones"),
(6,"Music, Movies and Audio Books"),
(7,"Games and Toys"),
(8,"Home Appliances");


Create table Channel(channel_key int primary key, Channel_name varchar(100));

Create table store(store_key int primary key, 
					store_manager int,
                    store_name varchar(200),
                    open_date date,
                    close_date date,
                    zip_code int,
                    store_phone varchar(120),
                    Address_line1 varchar(300),
                    Address_line2 varchar(300),
                    employee_count int,
                    selling_area_size int,
                    manager_first_name varchar(100),
					manager_last_name varchar(100));


Create table Geography(geography_key int,
						continent_name varchar(100),
                        city_name varchar(100),
                        State_proviance_name varchar(150),
						Region_country_name varchar(150));


desc channel;

insert into `Channel` values
	(1,"Store"),
    (2,"Online"),
    (3,"Catalog"),
    (4,"Reseller");


CREATE table product_sub_cat(product_sub_cat_key int primary key,
								product_sub_cat_name varchar(150), 
								product_cat_key int,
                                FOREIGN KEY (product_cat_key) REFERENCES product_cat(product_cat_key));
                                
CREATE table product(product_key int primary key,
						product_name varchar(700),
                        product_discription varchar(3500),
                        Manufacture varchar(700),
                        brand_name varchar(780),
                        class_name varchar(700),
                        color_name varchar(700),
                        size varchar(700),
                        weight double,
                        unit_cost double,
                        unit_price double,
                        product_sub_cat_key int,
                        FOREIGN KEY (product_sub_cat_key) REFERENCES product_sub_cat(product_sub_cat_key));

DESC product;

SELECT * FROM geography;

create table sales(sales_key int primary key,
					channel_key int,
                    FOREIGN KEY(channel_key) REFERENCES channel(channel_key),
                    store_key int,
                    FOREIGN KEY (store_key) REFERENCES store(store_key),
                    product_key int,
                    FOREIGN KEY (product_key) REFERENCES product(product_key),
                    unit_cost double,
                    unit_price double,
                    sales_qty int,
                    return_qty int,
                    return_amt double,
                    discount_qty int,
                    discount_amt double,
                    total_cost double,
                    total_sale double,
                    sales_date date
                    );
                    
ALTER TABLE sales ADD column geography_key int;

ALTER TABLE sales ADD FOREIGN KEY(geography_key) REFERENCES geography(geography_key);
 
 desc product_cat;
 
 SELECT distinct( monthname(sales_date)) FROM Sales;

SELECT * FROM Sales;

SELECT 
    total_sale,
    ROUND(unit_price * sales_qty, 1) AS calculated_sales
FROM
    sales;

SELECT 
    ROUND(SUM(total_sale),2) as total_sales
FROM
    sales;

SELECT 
    total_cost,
    ROUND(unit_cost * sales_qty, 1) AS calculated_sales
FROM
    sales;
    
SELECT 
    ROUND(SUM(total_cost),2) as total_cost
FROM
    sales;
    
 SELECT * FROM Sales;
 
SELECT 
    ROUND(SUM(return_amt), 2) AS  total_return_amt
FROM
    sales;
    
SELECT 
    ROUND(SUM(return_amt), 2) + ROUND(SUM(discount_amt), 2) + ROUND(SUM(total_cost), 2) AS total_expenses
FROM
    sales;
    
SELECT 
    ROUND(ROUND(SUM(total_sale), 2) - ROUND(SUM(return_amt) + SUM(discount_amt) + SUM(total_cost),
                    2),
            2) AS net_profit
FROM
    sales;
    
    
SELECT * FROM Sales;

SELECT 
    YEAR(sales_date) AS sales_year,
    ROUND(SUM(return_amt), 2) + ROUND(SUM(discount_amt), 2) + ROUND(SUM(total_cost), 2) AS total_expenses,
    ROUND(SUM(total_sale), 2) AS total_sale
FROM
    sales
GROUP BY YEAR(sales_date)
ORDER BY sales_year;

SELECT 
    YEAR(sales_date) AS sales_year,
    ROUND(SUM(return_amt), 2) + ROUND(SUM(discount_amt), 2) + ROUND(SUM(total_cost), 2) AS total_expenses,
    ROUND(SUM(total_sale), 2) AS total_sale
FROM
    sales
WHERE YEAR(sales_date) = 2008
GROUP BY YEAR(sales_date)
ORDER BY sales_year;


SELECT * FROM sales;

SELECT 
    MONTHNAME(sales_date) AS month_name,
    ROUND(SUM(total_sale), 2) AS Total_sales,
    ROUND(SUM(total_cost), 2) AS Total_expense
FROM
    sales
GROUP BY MONTHNAME(sales_date),MONTH(sales_date)
ORDER BY MONTH(sales_date);

SELECT 
    MONTHNAME(sales_date) AS month_name,
    ROUND(SUM(total_sale), 2) AS Total_sales
FROM
    sales
GROUP BY MONTHNAME(sales_date)
ORDER BY Total_sales DESC LIMIT 1;


-- Q) Find Top 10 product which haviving the max sales?
SELECT 
    product_name, ROUND(SUM(total_sale), 2) AS total_sales
FROM
    product
        JOIN
    sales ON product.product_key = sales.product_key
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Q) How many products we sold ? also find the total sales and expenses over them give your conclusion on them.
-- ans i) 
SELECT 
    COUNT(product_key) AS total_product
FROM
    product;

SELECT 
    COUNT(sales_key) AS product_demand,
    product_name,
    ROUND(SUM(total_sale), 2) AS total_sales,
    ROUND(SUM(total_cost), 2) AS total_expense
FROM
    sales
        JOIN
    product ON sales.product_key = product.product_key
GROUP BY product_name
ORDER BY product_demand ASC LIMIT 10;


-- Q) Find the total sales and expense over the product category.
SELECT 
    Product_cat_name,
    ROUND(SUM(total_sale), 2) AS Total_sales,
    ROUND(SUM(total_cost), 2) AS Total_cost
FROM
    product_cat
        JOIN
    product_sub_cat ON product_cat.product_cat_key = product_sub_cat.product_cat_key
        JOIN
    product ON product_sub_cat.product_sub_cat_key = product.product_sub_cat_key
        JOIN
    sales ON product.product_key = sales.product_key
GROUP BY Product_cat_name
ORDER BY Total_sales DESC;

-- Q) Find the total sales, total expenses done through which channel.
SELECT 
    Channel_name,
    ROUND(SUM(total_sale),2) as Total_sales,
    ROUND(SUM(total_cost),2) as Total_expenses
FROM
    channel
        JOIN
    sales ON channel.channel_key = sales.channel_key
GROUP BY Channel_name;

-- Q) Which store is most demanded and its total sales and total expenses along with the selling place.
SELECT 
    continent_name,
    store_name,
    COUNT(*) AS cust_prefer_store,
    ROUND(SUM(total_sale), 2) AS Total_sales,
    ROUND(SUM(total_cost), 2) AS Total_cost
FROM
    sales
        JOIN
    store ON sales.store_key = store.store_key
        JOIN
    geography ON geography.geography_key = sales.geography_key
GROUP BY continent_name , store_name
ORDER BY cust_prefer_store DESC;

-- Q) Find the Total Sales and expenses over continent.
SELECT 
    continent_name,
    ROUND(SUM(total_sale),2) AS Total_sales,
    ROUND(SUM(total_cost),2) AS Total_cost
FROM
    geography
        JOIN
    sales ON geography.geography_key = sales.geography_key
GROUP BY continent_name
ORDER BY Total_sales DESC;

-- Q) Find the total sales, total expenses over cities of Asia.
 
SELECT 
    city_name,
    ROUND(SUM(total_sale), 2) AS total_sales,
    ROUND(SUM(total_cost),2) as total_expense
FROM
    sales
        JOIN
    geography ON sales.geography_key = geography.geography_key
WHERE geography.continent_name = "Asia" 
GROUP BY city_name
ORDER BY total_sales DESC;

-- Q) What is the Average sale? Also find average sales over year.
SELECT 
    ROUND(AVG(total_sale),2) AS avarage_sale
FROM
    sales;
    
SELECT 
    YEAR(sales_date) AS sales_year,
    ROUND(AVG(total_sale), 2) AS avg_sales
FROM
    sales
GROUP BY YEAR(sales_date)
ORDER BY sales_year ASC;