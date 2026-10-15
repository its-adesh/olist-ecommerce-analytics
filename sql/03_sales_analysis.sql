-- ==================================================
-- 03 - SALES PERFORMANCE ANALYSIS
-- ==================================================

-- Q1. Total payment value from delivered orders
SELECT
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(SUM(p.payment_value)::numeric, 2)
        AS total_payment_value
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';



-- Q2. Monthly sales trend
SELECT
    DATE_TRUNC(
        'month', o.order_purchase_timestamp
    ) AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value)::numeric, 2)
        AS total_payment_value
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC(
    'month', o.order_purchase_timestamp
)
ORDER BY sales_month;


-- Q3. Delivered-order product sales by category
-- Product prices exclude freight.
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Uncategorised'
    ) AS category,
    ROUND(SUM(oi.price)::numeric, 2)
        AS product_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Uncategorised'
    )
ORDER BY product_sales DESC
LIMIT 10;



-- Q4. Order status distribution
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- Q5. Average payment value per delivered order
SELECT
    ROUND(
        SUM(p.payment_value)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_payment_per_paid_order
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';

