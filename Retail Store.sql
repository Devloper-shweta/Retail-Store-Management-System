CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
select * from customers;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price BIGINT CHECK (price > 0),
    stock INT CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount BIGINT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1,'Amit Sharma','Pune','amit@gmail.com','9876543210',CURRENT_TIMESTAMP),
(2,'Priya Verma','Mumbai','priya@gmail.com','9876543211',CURRENT_TIMESTAMP),
(3,'Rahul Mehta','Delhi','rahul@gmail.com','9876543212',CURRENT_TIMESTAMP),
(4,'Sneha Patil','Pune','sneha@gmail.com','9876543213',CURRENT_TIMESTAMP),
(5,'Karan Singh','Bangalore','karan@gmail.com','9876543214',CURRENT_TIMESTAMP),
(6,'Neha Joshi','Mumbai','neha@gmail.com','9876543215',CURRENT_TIMESTAMP),
(7,'Vikas Gupta','Delhi','vikas@gmail.com','9876543216',CURRENT_TIMESTAMP),
(8,'Anjali Rao','Pune','anjali@gmail.com','9876543217',CURRENT_TIMESTAMP);

INSERT INTO products VALUES
(101,'Laptop','Electronics',60000,10),
(102,'Mobile','Electronics',30000,20),
(103,'Headphones','Accessories',2000,50),
(104,'Office Chair','Furniture',8000,15),
(105,'Desk','Furniture',12000,10),
(106,'Smart Watch','Electronics',15000,25),
(107,'Backpack','Accessories',2500,40),
(108,'Monitor','Electronics',18000,12);

INSERT INTO orders VALUES
(1001,1,'2024-01-10',62000),
(1002,2,'2024-02-12',30000),
(1003,3,'2024-03-15',20000),
(1004,1,'2024-04-01',15000),
(1005,4,'2024-05-20',8000),
(1006,5,'2024-06-18',18000);

INSERT INTO order_items VALUES
(1,1001,101,1),
(2,1001,103,1),
(3,1002,102,1),
(4,1003,106,1),
(5,1003,103,2),
(6,1004,107,3),
(7,1005,104,1),
(8,1006,108,1);

--Show all customers
select * from customers;

--Show all products
select * from products;

--Show products with price > 20000
select * from products
where price>2000;

--Show customers from Pune
select * from customers
where city = 'Pune';

--Show orders placed after 2024-03-01
select * from orders
where order_date> '2024-03-01';

--Show products with stock < 15
select * from products
where stock < 15;

--Show distinct cities from customers
select distinct(city) from customers;

--Show products ordered by price desc
select * from products
order by price desc;

--Show top 3 expensive products
select * from products
order by price desc
limit 3;

--Show orders with total_amount between 10000 and 50000
select * from orders
where total_amount between 10000 and 50000;

--Count total customers
select count(customer_id) from customers;

--Find average product price
select avg(price) from products;

--Find max product price
select max(price) from products;

--Count products category-wise
SELECT category, COUNT(*) FROM products 
GROUP BY category;

--Find total stock category-wise
SELECT category, COUNT(stock) FROM products 
GROUP BY category;

--Find customers who placed more than 1 order
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

--Find total sales amount
SELECT SUM(total_amount) as total_sales
from orders;

--Find total sales per customer
SELECT c.customer_name,
       SUM(o.total_amount) AS total_sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC;

--Find highest order amount
select * from orders
order by total_amount desc
limit 1;

--Find category with highest average price
SELECT Category, AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category
ORDER BY AveragePrice DESC
LIMIT 1;

--Find customers who never placed orders
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

--Find products never ordered
SELECT p.product_name
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

--Show customer name with their orders
SELECT c.customer_name,
       o.order_id,
       o.order_date,
       o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

--Show product name with quantity sold
select p.product_name, sum(oi.quantity) as total_quantity
from products p
join order_items oi
on p.product_id= oi.product_id
group by p.product_name
order by total_quantity desc;

--Find total quantity sold per product
select p.product_name, sum(oi.quantity) as total_quantity
from products p
left join order_items oi 
on p.product_id= oi.product_id
group by p.product_name
ORDER BY total_quantity DESC;

--Find customer who spent highest amount
select c.customer_id,c.customer_name, sum(o.total_amount) as total_spent
from customers c
join orders o
on c.customer_id= o.customer_id
group by c.customer_id,c.customer_name
order by total_spent desc
limit 1

--Find second highest order amount
SELECT total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 1 OFFSET 1;

--Find most ordered product
SELECT p.product_id,
       p.product_name,
       SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

--Find city with highest number of customers
select city,count(*) total_customers from customers
group by city
order by total_customers desc
limit 1;

--Find total revenue per category
SELECT p.category,
       SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

--Find orders having more than 2 items
select order_id,sum (quantity) as total_quantity
from order_items 
group by order_id
HAVING SUM(quantity) > 2;

--Find customers who bought Electronics
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Electronics';

--2️⃣ Find products with stock less than average stock
SELECT product_id, product_name, stock
FROM products
WHERE stock < (
    SELECT AVG(stock)
    FROM products
);

--3️⃣ Find total orders month-wise
SELECT EXTRACT(MONTH FROM order_date) AS month,
       COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

--4️⃣ Find products ordered more than 3 times
SELECT p.product_id,
       p.product_name,
       SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) > 3;

--5️⃣ Find customers who placed order in last 3 months
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '3 months';

--6️⃣ Find category having more than 2 products
SELECT category,
       COUNT(*) AS total_products
FROM products
GROUP BY category
HAVING COUNT(*) > 2;

--7️⃣ Find customers who ordered Laptop
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_name = 'Laptop';

--8️⃣ Find revenue generated by each product
SELECT p.product_id,
       p.product_name,
       SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

--9️⃣ Find top 2 customers by spending
SELECT c.customer_id,
       c.customer_name,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 2;

--Find product contributing highest revenue
SELECT p.product_id, p.product_name,
       SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 1;

--Find customers who bought more than 1 category
SELECT c.customer_id, c.customer_name,
       COUNT(DISTINCT p.category) AS categories_bought
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.category) > 1;

--Find average order value per customer
SELECT c.customer_id, c.customer_name,
       AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

--Find customer who bought most quantity
SELECT c.customer_id, c.customer_name,
       SUM(oi.quantity) AS total_quantity
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_quantity DESC
LIMIT 1;

--Create view for customer order summary
CREATE VIEW customer_order_summary AS
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

--Create view for product sales summary
CREATE VIEW product_sales_summary AS
SELECT p.product_id, p.product_name,
       SUM(oi.quantity) AS total_quantity_sold,
       SUM(oi.quantity * p.price) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

--Use UNION to combine Pune & Mumbai customers
SELECT * FROM customers
WHERE city = 'Pune'

UNION

SELECT * FROM customers
WHERE city = 'Mumbai';

--Increase price of Electronics by 10%
UPDATE products
SET price = price * 1.10
WHERE category = 'Electronics';

--Delete products with zero stock
DELETE FROM products
WHERE stock = 0;






