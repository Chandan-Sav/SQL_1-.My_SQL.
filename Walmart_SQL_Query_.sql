create	table Walmart_sales(
  Invoice_id varchar(40) not null primary key,
  Branch varchar(30) not null,
  City varchar(30) not null,
  Customer_type varchar(30) not null,
  Gender varchar(10) not null,
  Product_line varchar(100) not null,
  Unit_price decimal(10,2) not null,
  Quantity int not null,
  VAT float(6, 4) not null,
  Total decimal(12,4) not null,
  Date datetime not null,
  Time time not null,
  Payment_method varchar(15) not null,
  Cogs decimal(10,2) not null,
  Gross_margin_pct float(11, 9),
  Gross_income decimal(12,4) not null,
  Rating float(2, 1)
);







-- -------------------------- New Column Addition ------------------------------------------

select
      time,
      (case
           when`time` between "00:00:00" and "12:00:00" then "Morning"
           when`time` between "12:01:00" and "16:00:00" then "Afternoon"
           else "evening"
      end) as time_of_date
from walmart_sales;

alter table walmart_sales add column time_of_day varchar(20);
update walmart_sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);
    
-- -------------------------------------------------------- ----------------------- ------
-- ----------------------------- day_name -------------------------------------------

select
      date,
      dayname(date) as day_name
      from walmart_sales;
      
alter table walmart_sales add column day_name varchar(10);

update walmart_sales
set day_name = dayname(date);

-- -------------------------------------------------------- ----------------------- ------
-- ----------------------------- month_name -------------------------------------------

select
      date,
      monthname(date) as month_name
      from walmart_sales;
      
alter table walmart_sales add column month_name varchar(15);

update walmart_sales
set month_name = monthname(date);

-- -------- ----------- -------------- ----------------- ------------- ----------------------
-- ---------------------------------- General Question -------------------------------------
-- -------- ----------- -------------- ----------------- ------------- ----------------------


-- How many unique cities do data have ?
select
      distinct city
      from walmart_sales;
      
-- How many branches do data have ?
select
      distinct Branch
      from walmart_sales;
      
-- In which city is each branch ?
select
      distinct city,Branch
      from walmart_sales;
      
      
-- -------- ----------- -------------- ----------------- ------------- ----------------------
-- ---------------------------------- Product Question -------------------------------------
-- -------- ----------- -------------- ----------------- ------------- ----------------------


-- How many unique product lines do data have ?
select
      count(distinct Product_line) as Total_Prod_line
      from walmart_sales;
      
-- What is the most common payment method ?
select
      payment_method,
      count(Payment_method) as Common_Pay_Method
      from walmart_sales
      group by payment_method
      order by Common_Pay_Method desc;
      
      
-- What is the most selling product line ?
select
      Product_line,
      count(Product_line) as Most_sold_pdtline
      from walmart_sales
      group by Product_line
      order by Most_sold_pdtline desc;
      
-- What is the total revenue by month ?
select
      month_name as mnt,
      sum(Total) as Total_revenue
      from walmart_sales
      group by mnt
      order by Total_revenue desc;
      
-- Which Month has the largest COGS ?
select
      month_name as mnt,
      sum(Cogs) as cg
      from walmart_sales
      group by mnt
      order by cg desc;
      
-- Which product line has the largest revenue ?
select
      product_line,
      sum(total) as total_revenue
      from walmart_sales
      group by Product_line
      order by total_revenue desc;
      
-- Which is the city with largest revenue ?
select
      branch,
      city,
      sum(total) as total_revenue
      from walmart_sales
      group by city , branch
      order by total_revenue desc;
      
-- Which product line has the highest vat ?
select
      product_line,
      avg(VAT) as Highest_VAT
      from walmart_sales
      group by product_line
      order by Highest_VAT desc;
      
-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
-- to find average of quantity :
select
      avg(quantity) as avg_qty
      from walmart_sales;
-- case :
select
      product_line,
      case
          when avg(quantity) > 6 then "good"
          else "bad"
          end  as remark
          from walmart_sales
          group by product_line;
      
      
      
      
      
      
-- Which branch sold more products than the average products sold ?
select
      branch,
      sum(quantity) as Avg_Qty
      from walmart_sales
      group by branch
      having sum(quantity) > (select avg(Quantity) from walmart_sales);
      
-- Which is the most common product line among gender ?
select
      gender,
      product_line,
      count(gender) as cnt
      from walmart_sales
      group by gender,Product_line
      order by cnt desc;
      
-- What is the average rating of each product line ?
select
      product_line,
      avg(rating) as avg_rating
      from walmart_sales
      group by Product_line
      order by avg_rating desc;

-- -------- ----------- -------------- ----------------- ------------- ----------------------
-- ---------------------------------- Sales Question -------------------------------------
-- -------- ----------- -------------- ----------------- ------------- ----------------------


-- Number of sales made in each time of the day per weekday .
-- - Sunday
select
      time_of_day,
      count(*) as total_sale
      from walmart_sales
      where day_name = "Sunday"
      group by time_of_day
      order by total_sale desc;
      
-- - Monday      
select
      time_of_day,
      count(*) as total_sale
      from walmart_sales
      where day_name = "Monday"
      group by time_of_day
      order by total_sale desc;
      
-- - Tuesday
select
      time_of_day,
      count(*) as total_sale
      from walmart_sales
      where day_name = "Tuesday"
      group by time_of_day
      order by total_sale desc;
      
-- - Wednesday
select
      time_of_day,
      count(*) as total_sale
      from walmart_sales
      where day_name = "Wednesday"
      group by time_of_day
      order by total_sale desc;
      
-- - Thursday
select
      time_of_day,
      count(*) as total_sale
      from walmart_sales
      where day_name = "Thursday"
      group by time_of_day
      order by total_sale desc;
      
-- - Friday
select
      time_of_day,
      count(*) as total_sale
      from walmart_sales
      where day_name = "Friday"
      group by time_of_day
      order by total_sale desc;
      
-- - Saturday
select
      time_of_day,
      count(*) as total_sale
      from walmart_sales
      where day_name = "Saturday"
      group by time_of_day
      order by total_sale desc;
      
-- Which customer types bring the most revenue ?
select
      Customer_type,
      sum(Total) as Total_revenue
      from walmart_sales
      group by Customer_type
      order by Total_revenue desc;
     
-- Which city has the largest tax percentage (VAT) ?
select
      city,
      avg(VAT) as Tax_pct 
      from walmart_sales
      group by city
      order by Tax_pct desc;
      
-- Which customer type pays the most VAT ?
select
      Customer_type,
      avg(VAT) as Most_Tax 
      from walmart_sales
      group by Customer_type
      order by Most_Tax desc;
      
      
      
-- -------- ----------- -------------- ----------------- ------------- ----------------------
-- ---------------------------------- Customer Question -------------------------------------
-- -------- ----------- -------------- ----------------- ------------- ----------------------

-- How many unique customer types does data have ?
select
      distinct Customer_type as unique_ct
      from walmart_sales;
      
-- How many unique payment methods does data have ?
select
      distinct Payment_method as unique_pm
      from walmart_sales;
      
-- What is the most common customer type ?
select
      customer_type,
      sum(Customer_type) as common_ct
      from walmart_sales
      group by customer_type
      order by common_ct desc;
      
-- Which customer types buy the most ?
select
      Customer_type,
      sum(Quantity) as Qty
      from walmart_sales
      group by Customer_type
      order by Qty desc;
      
-- What is the gender of most of the customers ?
select
      gender,
      count(Gender) as Gender_cnt
      from walmart_sales
      group by Gender
      order by Gender_cnt desc;
      
-- What is gender distribution by each branch ?
-- A
select
      gender,
      count(Gender) as Gender_cnt
      from walmart_sales
      where Branch = "A"
      group by Gender
      order by Gender_cnt desc;
      
-- B
select
      gender,
      count(Gender) as Gender_cnt
      from walmart_sales
      where Branch = "B"
      group by Gender
      order by Gender_cnt desc;
      
-- C
select
      gender,
      count(Gender) as Gender_cnt
      from walmart_sales
      where Branch = "C"
      group by Gender
      order by Gender_cnt desc;
      
      
-- Which time of day customer give most of their ratings ?
select
      time_of_day,
      avg(rating) as avg_rating
      from walmart_sales
      group by time_of_day
      order by avg_rating desc;
      
-- Which time of day customer give most of their ratings as per branch ?
-- A
select
      time_of_day,
      avg(rating) as avg_rating
      from walmart_sales
      where Branch = "A"
      group by time_of_day
      order by avg_rating desc;
      
-- B
select
      time_of_day,
      avg(rating) as avg_rating
      from walmart_sales
      where Branch = "B"
      group by time_of_day
      order by avg_rating desc;
      
-- C
select
      time_of_day,
      avg(rating) as avg_rating
      from walmart_sales
      where Branch = "C"
      group by time_of_day
      order by avg_rating desc;
      

-- Which day of the week has best rating ?
select
      day_name,
      avg(Rating) as Rating
      from walmart_sales
      group by day_name
      order by Rating desc;
      
-- Which day of the week has best rating as per the branch ?
-- - A
select
      day_name,
      avg(Rating) as Rating
      from walmart_sales
      where branch = "A"
      group by day_name
      order by Rating desc;
      
-- - B
select
      day_name,
      avg(Rating) as Rating
      from walmart_sales
      where branch = "B"
      group by day_name
      order by Rating desc;
      
-- - C
select
      day_name,
      avg(Rating) as Rating
      from walmart_sales
      where branch = "C"
      group by day_name
      order by Rating desc;