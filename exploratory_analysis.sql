-- =====================================================
-- Brazil Market Entry Analysis (SQL Project)
-- Author: Khadija Barkaoui
-- Description: SQL analysis of Magist dataset
-- =====================================================


-- =====================================================
-- 1. PRODUCT ANALYSIS
-- =====================================================

-- 1.1 All product categories
SELECT 
    pt.product_category_name_english,
    COUNT(p.product_id) AS number_products
FROM products p
JOIN product_category_name_translation pt USING (product_category_name)
GROUP BY pt.product_category_name_english
ORDER BY number_products DESC;


-- 1.2 Tech categories (Eniac relevant)
SELECT DISTINCT product_category_name_english
FROM product_category_name_translation
WHERE product_category_name_english IN (
    'computers',
    'computers_accessories',
    'electronics',
    'telephony',
    'audio'
);


-- Alternative broader tech filter
SELECT DISTINCT product_category_name, product_category_name_english
FROM product_category_name_translation
WHERE (
    product_category_name_english LIKE '%tech%'
    OR product_category_name_english LIKE '%elec%'
    OR product_category_name_english LIKE '%computer%'
    OR product_category_name_english LIKE '%mobile%'
    OR product_category_name_english LIKE '%tel%'
    OR product_category_name_english LIKE '%audio%'
)
AND product_category_name_english != 'books_technical';


-- 1.3 Total products sold (delivered only)
SELECT COUNT(*) AS total_products_sold
FROM order_items oi
JOIN orders o USING (order_id)
WHERE o.order_status = 'delivered';


-- 1.4 Tech products sold + percentage (Method 1 - Yahya)
SELECT 
    COUNT(*) AS tech_products_sold,
    COUNT(*) * 100.0 / (
        SELECT COUNT(*) FROM order_items
    ) AS tech_percentage
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation pt 
    ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN (
    'electronics','computers','telephony','computers_accessories'
);


-- 1.4 Tech products sold + percentage (Method 2 - Mathias)
SELECT 
    count_tech.total_products_tech,
    count_all.total_products_all,
    count_tech.total_products_tech / count_all.total_products_all * 100 AS tech_percentage
FROM
    (SELECT COUNT(oi.product_id) AS total_products_tech
     FROM order_items oi
     JOIN products p USING (product_id)
     JOIN product_category_name_translation pt USING (product_category_name)
     WHERE (
        product_category_name_english LIKE '%tech%'
        OR product_category_name_english LIKE '%elec%'
        OR product_category_name_english LIKE '%computer%'
        OR product_category_name_english LIKE 'tel%'
     )
     AND product_category_name_english != 'books_technical'
    ) AS count_tech
JOIN
    (SELECT COUNT(product_id) AS total_products_all FROM order_items) AS count_all;


-- 1.5 Percentage of tech products (clean version - delivered only)
SELECT 
    ROUND(100 * SUM(p.product_category_name IN (
        'computers_accessories','electronics','telephony','computers'
    )) / COUNT(*), 2) AS tech_product_percentage
FROM order_items oi
JOIN orders o USING (order_id)
JOIN products p USING (product_id)
WHERE o.order_status = 'delivered';


-- 1.6 Average product price (delivered)
SELECT 
    ROUND(AVG(oi.price), 2) AS average_product_price
FROM order_items oi
JOIN orders o USING (order_id)
WHERE o.order_status = 'delivered';


-- 1.7 Average price of tech products
SELECT 
    ROUND(AVG(oi.price), 2) AS average_tech_price
FROM order_items oi
JOIN products p USING (product_id)
JOIN product_category_name_translation pt USING (product_category_name)
WHERE pt.product_category_name_english IN (
    'electronics','computers','telephony'
);


-- 1.8 Expensive tech products (>500€)
SELECT 
    p.product_category_name,
    COUNT(*) AS units_sold,
    ROUND(AVG(oi.price),2) AS avg_price
FROM order_items oi
JOIN orders o USING (order_id)
JOIN products p USING (product_id)
WHERE o.order_status = 'delivered'
AND p.product_category_name IN (
    'computers_accessories','electronics','telephony','computers'
)
AND oi.price > 500
GROUP BY p.product_category_name
ORDER BY units_sold DESC;


-- Alternative: price segmentation
SELECT 
    price_level,
    COUNT(*) AS total_sold
FROM (
    SELECT 
        oi.price,
        CASE
            WHEN oi.price > (
                SELECT AVG(oi2.price)
                FROM order_items oi2
            )
            THEN 'expensive'
            ELSE 'not_expensive'
        END AS price_level
    FROM order_items oi
) AS price_groups
GROUP BY price_level;



-- =====================================================
-- 2. SELLER ANALYSIS
-- =====================================================

-- 2.1 Dataset time coverage
SELECT 
    MIN(order_purchase_timestamp) AS first_date,
    MAX(order_purchase_timestamp) AS last_date,
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp)) + 1 AS total_months
FROM orders;


-- 2.2 Total sellers
SELECT COUNT(*) AS total_sellers FROM sellers;


-- 2.3 Tech sellers by category
SELECT 
    product_category_name_english,
    COUNT(DISTINCT seller_id) AS number_sellers
FROM sellers s
LEFT JOIN order_items oi USING (seller_id)
LEFT JOIN products USING (product_id)
LEFT JOIN product_category_name_translation pt USING (product_category_name)
WHERE product_category_name_english IN (
    'computers','computers_accessories','electronics','telephony','audio'
)
GROUP BY product_category_name_english;


-- 2.4 % of tech sellers
SELECT 
    ROUND(
        COUNT(DISTINCT CASE
            WHEN pt.product_category_name_english IN (
                'computers','computers_accessories','electronics','telephony','audio'
            )
            THEN s.seller_id
        END) / COUNT(DISTINCT s.seller_id) * 100,
    2) AS tech_seller_percentage
FROM sellers s
LEFT JOIN order_items oi USING (seller_id)
LEFT JOIN products p USING (product_id)
LEFT JOIN product_category_name_translation pt USING (product_category_name);


-- 2.5 Total revenue (all sellers)
SELECT ROUND(SUM(price), 2) AS total_revenue
FROM order_items;


-- 2.6 Revenue from tech sellers (CTE version - clean)
WITH revenue_table AS (
    SELECT 
        (SELECT SUM(price) FROM order_items) AS total_revenue,
        (SELECT SUM(oi.price)
         FROM order_items oi
         JOIN products p USING (product_id)
         JOIN product_category_name_translation pt USING (product_category_name)
         WHERE pt.product_category_name_english LIKE '%tech%'
         OR pt.product_category_name_english LIKE '%elec%'
         OR pt.product_category_name_english LIKE '%computer%'
         OR pt.product_category_name_english LIKE 'tel%'
        ) AS tech_revenue
)
SELECT 
    total_revenue,
    tech_revenue,
    ROUND(tech_revenue / total_revenue * 100, 2) AS tech_revenue_percentage
FROM revenue_table;


-- 2.7 Average monthly revenue (all sellers)
SELECT 
    ROUND(AVG(monthly_total), 2) AS avg_monthly_income
FROM (
    SELECT 
        YEAR(order_purchase_timestamp) AS year,
        MONTH(order_purchase_timestamp) AS month,
        SUM(price) AS monthly_total
    FROM orders o
    JOIN order_items oi USING (order_id)
    GROUP BY year, month
) AS monthly_revenue;


-- 2.8 Average monthly revenue (tech sellers)
SELECT 
    ROUND(AVG(monthly_total), 2) AS avg_monthly_income_tech
FROM (
    SELECT 
        YEAR(o.order_purchase_timestamp) AS year,
        MONTH(o.order_purchase_timestamp) AS month,
        SUM(oi.price) AS monthly_total
    FROM orders o
    JOIN order_items oi USING (order_id)
    JOIN products p USING (product_id)
    JOIN product_category_name_translation pt USING (product_category_name)
    WHERE pt.product_category_name_english IN (
        'computers','computers_accessories','electronics','telephony'
    )
    GROUP BY year, month
) AS monthly_revenue;



-- =====================================================
-- 3. DELIVERY ANALYSIS
-- =====================================================

-- 3.1 Average delivery time
SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)),2) 
    AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- 3.2 On-time vs delayed orders
SELECT 
    SUM(CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1
        ELSE 0
    END) AS on_time_orders,
    SUM(CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
        ELSE 0
    END) AS delayed_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- 3.3 Delivery vs product size
SELECT 
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'on_time'
        ELSE 'delayed'
    END AS delivery_status,
    CASE
        WHEN product_weight_g > 5000 THEN 'large'
        WHEN product_weight_g > 1000 THEN 'medium'
        ELSE 'small'
    END AS product_size,
    COUNT(*) AS total_orders
FROM orders o
JOIN order_items oi USING (order_id)
JOIN products p USING (product_id)
GROUP BY delivery_status, product_size
ORDER BY total_orders DESC;



-- =====================================================
-- 4. ORDER VALUE ANALYSIS
-- =====================================================

-- 4.1 Average order value
SELECT 
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT order_id, SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals;


-- =====================================================
-- END OF SCRIPT
-- =====================================================