USE ecommerce_dw;

CREATE OR REPLACE VIEW stg_valid_orders AS
SELECT *
FROM raw_orders
WHERE ship_date >= order_date
  AND delivery_date >= ship_date;