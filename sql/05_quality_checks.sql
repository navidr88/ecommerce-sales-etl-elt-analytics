USE ecommerce_dw;

SELECT COUNT(*) AS raw_count
FROM raw_orders;

SELECT COUNT(*) AS valid_count
FROM stg_valid_orders;

SELECT COUNT(*) AS dim_customers_count
FROM dim_customers;

SELECT COUNT(*) AS dim_products_count
FROM dim_products;

SELECT COUNT(*) AS fact_orders_count
FROM fact_orders;

SHOW TABLES;