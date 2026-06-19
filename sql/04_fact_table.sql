USE ecommerce_dw;

DROP TABLE IF EXISTS fact_orders;

CREATE TABLE fact_orders AS
SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    ship_date,
    delivery_date,
    order_status,
    payment_method,
    quantity,
    unit_price,
    discount,
    shipping_cost,
    total_sales
FROM stg_valid_orders;