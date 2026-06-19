USE ecommerce_dw;

-- Revenue by category
SELECT
    dp.category,
    ROUND(SUM(fo.total_sales), 2) AS revenue
FROM fact_orders fo
JOIN dim_products dp
    ON fo.product_id = dp.product_id
GROUP BY dp.category
ORDER BY revenue DESC;

-- Top 10 products by revenue
SELECT
    dp.product_name,
    ROUND(SUM(fo.total_sales), 2) AS revenue
FROM fact_orders fo
JOIN dim_products dp
    ON fo.product_id = dp.product_id
GROUP BY dp.product_name
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 customers by revenue
SELECT
    dc.customer_name,
    ROUND(SUM(fo.total_sales), 2) AS revenue
FROM fact_orders fo
JOIN dim_customers dc
    ON fo.customer_id = dc.customer_id
GROUP BY dc.customer_name
ORDER BY revenue DESC
LIMIT 10;

-- Payment method distribution
SELECT
    payment_method,
    COUNT(*) AS order_count
FROM fact_orders
GROUP BY payment_method
ORDER BY order_count DESC;

-- Monthly revenue
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    ROUND(SUM(total_sales), 2) AS revenue
FROM fact_orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;