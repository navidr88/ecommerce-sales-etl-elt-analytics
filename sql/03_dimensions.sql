USE ecommerce_dw;

DROP TABLE IF EXISTS dim_customers;

CREATE TABLE dim_customers AS
SELECT
    customer_id,
    MIN(customer_name) AS customer_name,
    MIN(country) AS country,
    MIN(state) AS state,
    MIN(city) AS city
FROM stg_valid_orders
GROUP BY customer_id;

DROP TABLE IF EXISTS dim_products;

CREATE TABLE dim_products AS
SELECT
    product_id,
    MIN(product_name) AS product_name,
    MIN(category) AS category,
    MIN(sub_category) AS sub_category,
    MIN(brand) AS brand
FROM stg_valid_orders
GROUP BY product_id;