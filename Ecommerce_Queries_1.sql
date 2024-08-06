#JOINS 

/*Query: creating a join between customers and orders table on the basis
of customer_id column. i.e to know what is the order status of each customer_id*/

#inner join: which has similiar columns in both the tables.
select customers.customer_id, orders.order_status
from customers join orders 
on customers.customer_id =orders.customer_id;
 
select customers.customer_id, orders.order_status
from customers join orders 
on customers.customer_id =orders.customer_id
where order_status ="canceled";

/* to know payment value in each year */
select * from orders;
select year(orders.order_purchase_timestamp) as years,
round(sum(payments.payment_value),2) 
from orders join payments 
on orders.order_id =payments.order_id
group by years  #group by is used bcz there is single aggregated value :SUM
order by years desc;

#self join
/*Query: creating a self join where it has same payment type)*/
select t1.order_id, t2.order_id
from payments as t1, payments as t2
where t1.payment_type = t2.payment_type;

select year(orders.order_purchase_timestamp) as years,
round(sum(payments.payment_value),2) 
from orders left join payments 
on orders.order_id =payments.order_id
group by years  #group by is used bcz there is single aggregated value :SUM
order by years desc;

#SUBQUERY: query inside a query
/*Query: i want payment value of each product category
product and payments does not have any common column
therefore we will use the intermediate table order_items
to establish a connection between products table and payments table
on the basis of order_id. */
select upper((products.product_category)) Products, round(sum(payments.payment_value)) Sales
from products join order_items
on products.product_id =order_items.product_id
join payments on 
payments.order_id = order_items.order_id
group by Products
order by Sales desc, Products
limit 1;

#to only display the product name; we will use subquery
select Products from 
(select upper((products.product_category)) Products, round(sum(payments.payment_value)) Sales
from products join order_items
on products.product_id =order_items.product_id
join payments on 
payments.order_id = order_items.order_id
group by Products
order by Sales desc, Products
limit 1) as A;

#Alternative way to write
with A as (select upper((products.product_category)) Products, round(sum(payments.payment_value)) Sales
from products join order_items
on products.product_id =order_items.product_id
join payments on 
payments.order_id = order_items.order_id
group by Products
order by Sales desc, Products
limit 1) 
select Products from A;

#CASE operator( to categorised )
/* using the above query, lets categorised the sales as low, medium, high) */

with A as (select upper((products.product_category)) Products, round(sum(payments.payment_value)) Sales
from products join order_items
on products.product_id =order_items.product_id
join payments on 
payments.order_id = order_items.order_id
group by Products
order by Sales desc, Products) 
select * , case 
when Sales <= 5000 then "Low"
when Sales >= 100000 then "High"
else "Medium"
end as Sales_type from A;

#Window Functions
/*query: dispalying cummulative sales according to the order date)*/

select orders_date, sales, sum(sales) over(order by orders_date) from (
select date(orders.order_purchase_timestamp) orders_date,
round(sum(payments.payment_value),2) sales from orders 
join payments on orders.order_id=payments.order_id
group by orders_date) as B;

/*using 2 sbqueries */
with A as (select upper((products.product_category)) Products, round(sum(payments.payment_value)) Sales
from products join order_items
on products.product_id =order_items.product_id
join payments on 
payments.order_id = order_items.order_id
group by Products
order by Sales desc, Products),

B as (select Products, Sales, rank() over(order by Sales desc) rk
from A)

select Products, Sales from B where rk <= 3;

#creating views
/* it creates a virtual table , on which we can further perform the analysis */
create view Product_Sales_Table as 
select upper((products.product_category)) Products, round(sum(payments.payment_value)) Sales
from products join order_items
on products.product_id =order_items.product_id
join payments on 
payments.order_id = order_items.order_id
group by Products
order by Sales desc, Products;





