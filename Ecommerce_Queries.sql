#Select Query
select customer_id,customer_city,customer_state
from customers;

select * from customers;

#Where clause
select * from customers where customer_state ="MG";
select * from orders where order_status="canceled";
select * from payments where payment_type = "UPI";

#AND operator 
select * from payments where payment_type = "UPI" and payment_value >=500;
select * from payments where payment_type = "credit_card" and payment_value >=1000 and payment_installments =2;

#OR operator
select * from customers where customer_state ="MG" or customer_state="SP";

#NOT operator
select * from customers where not(customer_state ="MG" or customer_state="SP");

#BETWEEN operator
select * from payments where payment_value between 150 and 200;

#IN operator 
select * from customers where customer_state in ("SC","SP","MG","PR");

#NOT IN operator 
select * from customers where customer_state not in ("SC","SP","MG","PR");

#LIKE operator
select customer_city from customers where customer_city like "%r";
select customer_city from customers where customer_city like "r%";
select customer_city from customers where customer_city like "%de%";

#ORDER BY clause

select * from payments order by payment_value;  #by default it will give from asc to desc
select * from payments order by payment_type desc , payment_value;

#to beautify the code like below , ctrl + B
SELECT 
    *
FROM
    payments
WHERE
    payment_installments = 1
ORDER BY payment_value desc;

#Limit operator
select * from payments limit 5;  #displays first 5 rows
select * from payments limit 2,3; #leaves 2 rows from top and displays 3 rows

#Aggregate functions

#SUM
select payment_value from payments;
select sum(payment_value) from payments;
select sum(payment_value) as total_revenue from payments;

#ROUND
select round(sum(payment_value), 2) as total_revenue from payments;

#MAX
select max(payment_value) from payments;

#MIN
select min(payment_value) from payments;

#AVG 
select avg(payment_value) from payments;
select round(avg(payment_value),5) from payments; #where 5 is the number of the decimal places.

#COUNT
select count(customer_id) as total_customers from customers;
select count(customer_city) as total_cities from customers;
select count(distinct customer_city) as total_distinct_cities from customers;


#Textual Functions

#LENGTH
select seller_city, length(seller_city) from sellers;  
select seller_city, length(trim(seller_city)) from sellers; #trim to remove whitespaces

#UPPER and LOWER
select upper(seller_city), lower(seller_city) from sellers;

#REPLACE
select seller_city, replace(seller_city, "a", "i") from sellers; #replaces all a's with i's

#CONCAT
select seller_city, seller_state from sellers;
select concat(seller_city, " - ", seller_state) as city_state from sellers;
select *, concat(seller_city, " - ", seller_state) as city_state from sellers;

#Date Functions

select * from orders;
select order_delivered_customer_date from orders;
SELECT order_delivered_customer_date,
DAY(order_delivered_customer_date),
MONTH(order_delivered_customer_date),
monthname(order_delivered_customer_date),
year(order_delivered_customer_date),
dayname(order_delivered_customer_date)
FROM orders;

#Time functions
select * from orders;
select datediff(order_delivered_customer_date, order_estimated_delivery_date) from orders;
select datediff(order_estimated_delivery_date, order_delivered_customer_date) from orders; #because order_estimated_delivery_date is bigger than theorder_delivered_customer_date

#Numeric functions
select * from payments;
select payment_value, ceil(payment_value) from payments;
select payment_value, floor(payment_value) from payments;

#Handling NULL values
select * from orders where order_delivered_customer_date is null;
select count(*) from orders where order_delivered_customer_date is null;

#GROUB BY clause (used when single aggregated values are used, eg: sum)
select order_status from orders;
select order_status, count(order_status) order_count from orders
group by order_status order by order_count desc;  #it counts the order status as either delivered,shipped,etc using group by clause and sorting it in desc order with order by clause

select payment_type, round(avg(payment_value),2) from payments
group by payment_type;
select payment_type, round(max(payment_value),2) from payments
group by payment_type;
select payment_type, round(min(payment_value),2) from payments
group by payment_type;

select payment_type, round(avg(payment_value),2) from payments
where avg(payment_value) >=150 group by payment_type;  #throws an error, cannot use where with aggregate function avg

#HAVING clause
select payment_type, round(avg(payment_value),2) from payments
group by payment_type having avg(payment_value) >=100;
