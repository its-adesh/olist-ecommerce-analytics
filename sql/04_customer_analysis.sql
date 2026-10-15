-- ==================================================
-- 04 - CUSTOMER ANALYTICS
-- ==================================================

-- Q1. Top 10 customers by spending
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value)::numeric, 2)
        AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;


-- Q2. Number of unique customers
SELECT
    COUNT(DISTINCT c.customer_unique_id)
        AS unique_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered';


-- Q3. Customers with multiple delivered orders
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;


-- Q4. Calculate repeat customer rate
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id)
            AS delivered_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS unique_customers,
    COUNT(*) FILTER (
        WHERE delivered_orders > 1
    ) AS repeat_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE delivered_orders > 1
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate
FROM customer_orders;


-- Q5. Average review score for delivered orders 
-- Calculate the average review score per order first 
-- so that each order contributes equally to the final average.
WITH review_per_order AS (
    SELECT
        order_id,
        AVG(review_score) AS order_review_score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    ROUND(AVG(r.order_review_score), 2)
        AS average_review_score
FROM orders o
JOIN review_per_order r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';
