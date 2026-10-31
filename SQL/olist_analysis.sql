/* BASIC QUEIRES */


-- 1) check number of orders
SELECT COUNT(*)
FROM olist_orders_dataset;

-- 2) check number of order items 
SELECT COUNT(*)
FROM olist_order_items_dataset;

-- 3) check number of payments 
SELECT COUNT(*)
FROM olist_order_payments_dataset;

-- 4) view first 10 orders 
SELECT * FROM olist_orders_dataset
LIMIT 10;

-- 5) check number of orders by month and the month with most orders
SELECT 
    MONTH(order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders
FROM
    olist_orders_dataset
GROUP BY MONTH(order_purchase_timestamp)
ORDER BY total_orders DESC;

-- 6) show delivered orders
SELECT 
    COUNT(*)
FROM
    olist_orders_dataset
WHERE
    order_status = 'delivered';
    
-- 7) show payments made by voucher
SELECT 
    *
FROM
    olist_order_payments_dataset
WHERE
    payment_type = 'voucher';

-- 8) show top 10 highrst payment value 
SELECT 
    payment_value
FROM
    olist_order_payments_dataset
ORDER BY payment_value DESC
LIMIT 10;


-- 9) show all the cities in the dataset
SELECT DISTINCT
    customer_city
FROM
    olist_customers_dataset
ORDER BY customer_city;


-- 10) show total sales of all time 
SELECT 
    ROUND(SUM(payment_value),2)
FROM
    olist_order_payments_dataset;
    


/* ADVANCE QUERIES */

-- 1) show top 5 most sold product categories

SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 5;

/* ENGLISH TRANSLATION IN ORDER 'bed,bath & table', 'beauty & health', 'sports & leisure', 'computer & accesories', 'furniture and home decor' */

-- 2) show all customers from rio de janeiro
SELECT 
    customer_id
FROM
    olist_customers_dataset
WHERE
    customer_city = 'rio de janeiro';
    

-- 3) show orders delivered in between christmas 2017 and new year 2018
SELECT 
    *
FROM
    olist_orders_dataset
WHERE
    order_delivered_customer_date >= '2017-12-25'
        AND order_delivered_customer_date < '2018-01-01';
        
        
-- 4) show customers who have placed more than 2 orders
SELECT 
    c.customer_unique_id, COUNT(*) AS total_orders
FROM
    olist_orders_dataset o
        JOIN
    olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(*) > 2
ORDER BY total_orders DESC;


-- 5) show the most expensive products from
SELECT 
    p.product_id, p.product_category_name, oi.price
FROM
    olist_products_dataset p
        JOIN
    olist_order_items_dataset oi ON p.product_id = oi.product_id
WHERE
    p.product_category_name = 'perfumaria'
ORDER BY oi.price DESC
LIMIT 3;


-- 6) find the customer who spent the most 
SELECT 
    o.customer_id, SUM(p.payment_value) AS total_spent
FROM
    olist_orders_dataset o
        JOIN
    olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 1;


-- 7) retrieve product categories with less than 3 stars
SELECT 
    p.product_category_name,
    ROUND(AVG(r.review_score), 2) AS average_review
FROM
    olist_order_reviews_dataset r
        JOIN
    olist_order_items_dataset oi ON r.order_id = oi.order_id
        JOIN
    olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING average_review < 3
ORDER BY average_review ASC; 


-- 8) retrieve the highest spending states
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT c.customer_unique_id),
            2) AS revenue_per_customer
FROM
    olist_orders_dataset o
        JOIN
    olist_customers_dataset c ON o.customer_id = c.customer_id
        JOIN
    olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 5;

