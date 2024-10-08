use amazon;
                                  ### checking the dataset ###
select * from amazon;

                               ### Convert columns to proper formats(data types) ###
ALTER TABLE amazon 
MODIFY COLUMN `Date` DATE;
ALTER TABLE amazon 
MODIFY COLUMN `Time` TIME;
ALTER TABLE amazon 
MODIFY COLUMN `Unit price` DECIMAL(10, 2);
ALTER TABLE amazon 
MODIFY COLUMN Quantity INT;
ALTER TABLE amazon 
MODIFY COLUMN `Tax 5%` DECIMAL(10, 2);
ALTER TABLE amazon 
MODIFY COLUMN Total DECIMAL(10, 2);
ALTER TABLE amazon 
MODIFY COLUMN Payment DECIMAL(10, 2);
ALTER TABLE amazon 
MODIFY COLUMN `gross margin percentage` FLOAT(11, 9);
ALTER TABLE amazon 
MODIFY COLUMN `gross income` DECIMAL(10, 2);
ALTER TABLE amazon 
MODIFY COLUMN Rating FLOAT(3,1);



                                               ###Feature engineering###
#Adding new column timeofday
ALTER TABLE amazon 
Add COLUMN time_of_day varchar (50);
SET SQL_SAFE_UPDATES= 0;
Update amazon
SET time_of_day = case
	   when HOUR(amazon.Time) >= 0 AND HOUR(amazon.Time) < 12 THEN "Morning"
       when HOUR(amazon.Time) >= 12 AND HOUR(amazon.Time) < 0 THEN "Afternoon"
       ELSE "Evening"
End;

#Adding new column day_name
ALTER TABLE amazon 
Add COLUMN day_name varchar(50);
Update amazon
SET day_name = date_format(amazon.Date,'%a');

#Adding new column month name
ALTER TABLE amazon
Add COLUMN month_name varchar(50);
Update amazon
SET month_name = date_format(amazon.Date,'%b');
SET SQL_SAFE_UPDATES= 1;   

                                       ###Exploratory Data Analysis (EDA)###
                                              ##questions to explore##
# 1.What is the count of distinct cities in the dataset?
SELECT COUNT(DISTINCT city) FROM amazon;
# there are 3 distinct cities 

#2.For each branch, what is the corresponding city?
SELECT Branch, City
FROM amazon
GROUP BY Branch, City;
#corresponding branch a is yangon
#corresponding brand c is naypyitaw
#corresponding brand b is mandalay

#3.Count of Distinct Product Lines in the Dataset
SELECT COUNT(DISTINCT `Product line`) AS distinct_product_lines
FROM amazon;
# there are 6 distinct product lines
 
#4.most frequent payment method
SELECT `Payment`, COUNT(*) AS frequency
FROM amazon
GROUP BY `Payment`
limit 1;
# most of the payment is  from ewallet with frequency 345.

#5.Product Line with the Highest Sales
select `Product line`, 
SUM(Quantity) AS total_sales
FROM amazon
GROUP BY `Product line`
ORDER BY total_sales DESC
LIMIT 1;
# the product line called electronic accessories  is having highest sales.

#6.Revenue Generated Each Month & year
SELECT 
    MONTH(Date) AS month, 
    YEAR(Date) AS year, 
    SUM(Total) AS total_revenue
FROM amazon
GROUP BY month, year
ORDER BY year, month;
# the total revenue generated by 1st month is 116292.11
# the total revenue generated by 2nd month is 97219.58
# the total revenue generated by 3 rd month is 109455.74
 
#7.Month When the Cost of Goods Sold (COGS) Reached Its Peak
SELECT 
    MONTH(Date) AS month, 
    YEAR(Date) AS year, 
    SUM(cogs) AS total_cogs
FROM amazon
GROUP BY month, year
ORDER BY total_cogs DESC
LIMIT 1;
# in first month the cost of the goods (cogs) reached at peakes.

# 8.Product Line that Generated the Highest Revenue
SELECT `Product line`, SUM(Total) AS total_revenue
FROM amazon
GROUP BY `Product line`
ORDER BY total_revenue DESC
LIMIT 1;
# the product line called food and bevarages have generated the highest revenue-56144.96.

#9.City with the Highest Revenue
SELECT City, SUM(Total) AS total_revenue
FROM amazon
GROUP BY City
ORDER BY total_revenue DESC
LIMIT 1;
# the city naypyitaw is having the highest revenue-110568.86.

#10.Product Line with the Highest Value Added Tax (VAT)
SELECT `Product line`, SUM(`Tax 5%`) AS total_vat
FROM amazon
GROUP BY `Product line`
ORDER BY total_vat DESC
LIMIT 1;
# the product line called food and bevarages have highest value added tax(vat)-2673.68

#11.Label Each Product Line as "Good" or "Bad" Based on Sales
SELECT `Product line`, 
       CASE 
           WHEN SUM(Quantity) > (SELECT AVG(Quantity) FROM amazon) THEN 'Good'
           ELSE 'Bad'
       END AS performance
FROM amazon
GROUP BY `Product line`;
# all the product line performance was good .

#12.Branch That Exceeded the Average Number of Products Sold
SELECT Branch, SUM(Quantity) AS total_quantity
FROM amazon
GROUP BY Branch
HAVING total_quantity > (SELECT AVG(Quantity) FROM amazon);
# branch a total_quantity-1859
#branch c total_quantity-1831
#branch b total_quantity-1820

#13.Most Frequent Product Line Associated with Each Gender
SELECT Gender, `Product line`, COUNT(*) AS frequency
FROM amazon
GROUP BY Gender, `Product line`
ORDER BY Gender, frequency DESC;
# females are higher than males in purchasing the products
#females-the product line called fashion accessories have highest frequency-96
#males-the product line called health and beauty have highest frequency-88.

#14.Average Rating for Each Product Line
SELECT `Product line`, AVG(Rating) AS average_rating
FROM amazon
GROUP BY `Product line`;
#Health and beauty   -   7.00329 
#Electronic accessories - 6.92471
#Home and lifestyle - 6.83750
#Sports and travel -  6.91627
#Food and beverages - 7.11322
#Fashion accessories - 7.11322

#15.Count Sales Occurrences for Each Time of Day on Every Weekday
SELECT `day_name`, `time_of_day`, COUNT(*) AS sales_count
FROM amazon
GROUP BY `day_name`, `time_of_day`
ORDER BY `day_name`, `time_of_day`;
# sat evening is having highest sales_count-136

#16.Customer Type Contributing the Highest Revenue
SELECT `Customer type`, SUM(Total) AS total_revenue
FROM amazon
GROUP BY `Customer type`
ORDER BY total_revenue DESC
LIMIT 1;
#the customer type  called 'member' having highest revenue-164223.81

#17.City with the Highest VAT Percentage
SELECT City, AVG(`Tax 5%`) AS average_vat
FROM amazon
GROUP BY City
ORDER BY average_vat DESC
LIMIT 1;
# the city 'naypyitaw' is having highest value added tax avg- percentage is-16.052835.

#18.Customer Type with the Highest value added tax(VAT) Payments
SELECT `Customer type`, SUM(`Tax 5%`) AS total_vat
FROM amazon
GROUP BY `Customer type`
ORDER BY total_vat DESC
LIMIT 1;
#the customer type 'member' having highest tax -7820.53

#19. Count of Distinct Customer Types in the Dataset
SELECT COUNT(DISTINCT `Customer type`) AS distinct_customer_types
FROM amazon;
# there are 2 distinct customer types in the dataset
select distinct `Customer type` from amazon;
# member
# normal

#20.Count of Distinct Payment Methods in the Dataset
SELECT COUNT(DISTINCT `Payment`) AS distinct_payment_methods
FROM amazon;
# there are 2 distinct payment methods in the dataset.
select distinct `Payment` from amazon;
#Ewallet
#Cash
#Credit card

#21.Customer Type with the Highest Purchase Frequency
SELECT `Customer type`, COUNT(*) AS purchase_count
FROM amazon
GROUP BY `Customer type`
ORDER BY purchase_count DESC
LIMIT 1;
# the customer type having highest frequency-501

#22.Predominant Gender Among Customers
SELECT Gender, COUNT(*) AS purchasing_count
FROM amazon
GROUP BY Gender
ORDER BY purchasing_count DESC
LIMIT 1;
# the female customers are purchasing high -501
SELECT Gender, COUNT(*) AS purchasing_count
FROM amazon
GROUP BY Gender
ORDER BY purchasing_count DESC
LIMIT 2;
#female purchasing_counts-501
#male purchasing_counts-499

#23.Distribution of Genders Within Each Branch
SELECT Branch, Gender, COUNT(*) AS frequency
FROM amazon
GROUP BY Branch, Gender
ORDER BY Branch, frequency DESC;
#A	Male	179
#A	Female	161
#B	Male	170
#B	Female	162
#C	Female	178
#C	Male	150

#24.Time of Day When Customers Provide the Most Ratings
SELECT `time_of_day`, AVG(Rating) AS average_rating
FROM amazon
GROUP BY `time_of_day`
ORDER BY average_rating DESC
limit 1;
#the evening has been getting most rating-6.97553.
SELECT `time_of_day`, AVG(Rating) AS average_rating
FROM amazon
GROUP BY `time_of_day`
ORDER BY average_rating DESC;
# the evening has been getting most rating-6.97553.
# the morning has been getting most rating-6.96073.

#26.Time of Day with the Highest Customer Ratings for Each Branch
SELECT Branch, `time_of_day`, AVG(Rating) AS average_rating
FROM amazon
GROUP BY Branch, `time_of_day`
ORDER BY Branch, average_rating DESC;
#the branch A is having the highest customer rating. 

#27.Day of the Week with the Highest Average Ratings
SELECT `day_name`, AVG(Rating) AS average_rating
FROM amazon
GROUP BY `day_name`
ORDER BY average_rating DESC;
# monday is having the  Highest Average Ratings.

#28.Day of the Week with the Highest Average Ratings for Each Branch
SELECT Branch, `day_name`, AVG(Rating) AS average_rating
FROM amazon
GROUP BY Branch, `day_name`
ORDER BY Branch, average_rating DESC;


						### summarization based on product,sales,customer analysis ###
#1. Product Analysis
#Distribution of Product Lines
SELECT `Product line`, COUNT(*) AS sales_count
FROM amazon
GROUP BY `Product line`
ORDER BY sales_count DESC;
#Revenue by Product Line
SELECT `Product line`, SUM(Total) AS total_revenue
FROM amazon
GROUP BY `Product line`
ORDER BY total_revenue DESC;
#Average Rating by Product Line
SELECT `Product line`, AVG(Rating) AS average_rating
FROM amazon
GROUP BY `Product line`
ORDER BY average_rating DESC;
#Product Lines that Need Improvement
SELECT `Product line`, SUM(Total) AS total_revenue, COUNT(*) AS sales_count
FROM amazon
GROUP BY `Product line`
HAVING total_revenue < (SELECT AVG(Total) FROM amazon) 
   OR sales_count < (SELECT AVG(sales_count) FROM (SELECT COUNT(*) AS sales_count FROM amazon 
   GROUP BY `Product line`) AS subquery);
   
   
#2.sales analysis
#Monthly Sales Trends
SELECT 
    MONTH(Date) AS month, 
    YEAR(Date) AS year, 
    SUM(Total) AS total_revenue
FROM amazon
GROUP BY year, month
ORDER BY year, month;
# Sales by Payment Method
SELECT `Payment`, SUM(Total) AS total_revenue
FROM amazon
GROUP BY `Payment`
ORDER BY total_revenue DESC;
# Peak Sales Times
SELECT `Time`, SUM(Total) AS total_revenue
FROM amazon
GROUP BY `Time`
ORDER BY total_revenue DESC;

#3.customer analysis
#Customer Segment Analysis
SELECT `Customer type`, COUNT(*) AS sales_count, SUM(Total) AS total_revenue
FROM amazon
GROUP BY `Customer type`
ORDER BY total_revenue DESC;
#. Customer Gender Analysis
SELECT Gender, COUNT(*) AS sales_count, SUM(Total) AS total_revenue
FROM amazon
GROUP BY Gender
ORDER BY total_revenue DESC;
#Customer Purchase Trends by Time of Day
SELECT `Customer type`, `Time`, COUNT(*) AS purchase_count, SUM(Total) AS total_revenue
FROM amazon
GROUP BY `Customer type`, `Time`
ORDER BY `Customer type`, `Time`;
#Most Profitable Customer Segment
SELECT `Customer type`, SUM(`Total`) AS total_revenue
FROM amazon
GROUP BY `Customer type`
ORDER BY total_revenue DESC
LIMIT 1;





















