
-- ==================================================
-- 01 - TABLE RELATIONSHIPS
-- Run after importing the CSV data.
-- ==================================================

-- Add two missing product categories discovered
-- during foreign-key validation.
INSERT INTO product_category_translation
    (product_category_name,
     product_category_name_english)
VALUES
    ('pc_gamer', 'gaming_pc'),
    ('portateis_cozinha_e_preparadores_de_alimentos',
     'portable_kitchen_and_food_preparation_appliances')
ON CONFLICT (product_category_name) DO NOTHING;


-- 1. Customers -> Orders
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);


-- 2. Orders -> Order Items
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- 3. Products -> Order Items
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);


-- 4. Sellers -> Order Items
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);


-- 5. Orders -> Order Payments
ALTER TABLE order_payments
ADD CONSTRAINT fk_order_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- 6. Orders -> Order Reviews
ALTER TABLE order_reviews
ADD CONSTRAINT fk_order_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- 7. Category Translation -> Products
ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (product_category_name)
REFERENCES product_category_translation(
    product_category_name
);

