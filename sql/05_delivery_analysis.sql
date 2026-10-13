
-- ==================================================
-- 05 - DELIVERY & OPERATIONS ANALYSIS
-- ==================================================

-- Q1. On-time vs late delivery performance
SELECT
    CASE
        WHEN order_delivered_customer_date::date >
             order_estimated_delivery_date::date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status
ORDER BY total_orders DESC;


-- Q2. Average and maximum delivery delay
SELECT
    COUNT(*) AS late_orders,
    ROUND(
        AVG(
            order_delivered_customer_date::date
            - order_estimated_delivery_date::date
        ), 2
    ) AS avg_days_late,
    MAX(
        order_delivered_customer_date::date
        - order_estimated_delivery_date::date
    ) AS max_days_late
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date::date >
      order_estimated_delivery_date::date;


-- Q3. Late-delivery rate by customer state
SELECT
    c.customer_state,
    COUNT(*) AS total_deliveries,
    COUNT(*) FILTER (
        WHERE o.order_delivered_customer_date::date >
              o.order_estimated_delivery_date::date
    ) AS late_deliveries,
    ROUND(
        COUNT(*) FILTER (
            WHERE o.order_delivered_customer_date::date >
                  o.order_estimated_delivery_date::date
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY late_delivery_percentage DESC;


-- Q4. Review scores by delivery status
WITH review_per_order AS (
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    CASE
        WHEN o.order_delivered_customer_date::date >
             o.order_estimated_delivery_date::date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS reviewed_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN review_per_order r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status
ORDER BY avg_review_score DESC;


-- Q5. Customer satisfaction by delay duration
WITH delivery_analysis AS (
    SELECT
        o.order_id,
        o.order_delivered_customer_date::date
            - o.order_estimated_delivery_date::date
            AS delay_days,
        r.review_score
    FROM orders o
    JOIN (
        SELECT
            order_id,
            AVG(review_score) AS review_score
        FROM order_reviews
        GROUP BY order_id
    ) r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),
categorised AS (
    SELECT
        CASE
            WHEN delay_days <= 0 THEN 'On Time'
            WHEN delay_days <= 3 THEN '1-3 Days Late'
            WHEN delay_days <= 7 THEN '4-7 Days Late'
            WHEN delay_days <= 14 THEN '8-14 Days Late'
            ELSE '15+ Days Late'
        END AS delay_category,
        CASE
            WHEN delay_days <= 0 THEN 1
            WHEN delay_days <= 3 THEN 2
            WHEN delay_days <= 7 THEN 3
            WHEN delay_days <= 14 THEN 4
            ELSE 5
        END AS sort_order,
        review_score
    FROM delivery_analysis
)
SELECT
    delay_category,
    COUNT(*) AS total_orders,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM categorised
GROUP BY delay_category, sort_order
ORDER BY sort_order;


-- Q6. Late-delivery rates by product category
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Uncategorised'
    ) AS product_category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.order_delivered_customer_date::date >
              o.order_estimated_delivery_date::date
    ) AS late_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) FILTER (
            WHERE o.order_delivered_customer_date::date >
                  o.order_estimated_delivery_date::date
        ) * 100.0 /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS late_delivery_percentage
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Uncategorised'
    )
ORDER BY late_delivery_percentage DESC;


