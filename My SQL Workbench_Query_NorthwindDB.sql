# Product and price list order by product name
SELECT product_name, list_price FROM products ORDER BY product_name ASC;

#Total quantity by order
SELECT id, SUM(quantity) FROM order_details GROUP BY id;

#Product name and price if list price is between 10 and 15
SELECT product_name, list_price FROM products WHERE list_price BETWEEN 10 AND 15;

#Product with higher price
SELECT product_name, MAX(list_price) FROM products; 

#Orders entered in march
SELECT id,order_date FROM orders WHERE MONTH(order_date)=03;

#Count Distinct Products by category
SELECT category, COUNT(DISTINCT product_name) AS QbyCategory FROM products GROUP BY category ORDER BY category;

#Employee name begining with M
SELECT CONCAT(first_name," ",last_name) AS Full_name FROM employees WHERE first_name LIKE "M%";

#Stored Procedure as "Updated_Price" that increase list price by 10%
CREATE PROCEDURE Updated_Price() 
SELECT product_name, list_price*1.10 FROM products;

CALL Updated_Price;

#Stock by category
SELECT category, SUM(stock) FROM products 
GROUP BY category;

#Product by supplier
SELECT products.product_name,suppliers.company FROM products
JOIN suppliers ON products.supplier_ids = suppliers.id
ORDER BY suppliers.company;

#Employee privilegescustomers
SELECT employees.last_name, privileges.privilege_name
FROM employees 
JOIN employee_privileges ON employees.id=employee_privileges.employee_id
JOIN privileges ON privileges.id=employee_privileges.privilege_id;

#For invoices with no due date set 30 days from invoice_date
SELECT id, DATE_FORMAT(invoice_date, "%d-%m-%Y") AS invoice_date,
COALESCE(due_date, DATE_ADD(invoice_date, interval 30 day)) AS due_date
FROM invoices;

#select orders from customers with no debt
SELECT orders.id, orders.customer_id FROM orders
WHERE NOT EXISTS(SELECT debt FROM customers WHERE customers.id=orders.customer_id);

#Show total orders by customer
SELECT customers.company, SUM(order_details.quantity*order_details.unit_price) AS total_order FROM orders
JOIN customers ON customers.id=orders.customer_id 
JOIN order_details ON orders.id=order_details.order_id
GROUP BY customers.company;

#Create Table inactive_customers
CREATE TABLE inactive_customers(
customer_id INT NOT NULL,
company VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
first_name VARCHAR(50) NOT NULL
);

#Insert customers without active orders into inactive_customers table
INSERT INTO inactive_customers
SELECT customers.id, customers.company, customers.last_name, customers.first_name FROM customers
WHERE NOT EXISTS(SELECT id FROM orders WHERE customers.id=orders.customer_id);

SELECT * FROM northwind.inactive_customers;