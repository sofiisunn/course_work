INSERT INTO supplier (
    supplier_name,
    supplier_phone_number,
    supplier_email
)
VALUES
    ('Beauty Supply', '+380687563948', 'beauty.supply@example.com'),
    ('Cosmetics Trade', '+380507845638', 'cosmetics.trade@example.com');

INSERT INTO brand (
    brand_title,
    supplier_id
)
VALUES
    ('Kiko Milano', 1),
    ('Dior', 2),
    ('Cerave', 1),
    ('Loreal Paris', 2);

INSERT INTO category (
    category_title
)
VALUES
    ('Makeup'),
    ('Skincare'),
    ('Haircare');

INSERT INTO product (
    brand_id,
    product_title,
    product_price,
    product_expiration_date,
    product_pao_months,
    product_volume_value,
    product_volume_unit,
    product_application_method,
    product_stock_quantity
)
VALUES
    (1, 'Lipgloss', 450.00, '2027-12-31', 24, 5, 'g', 'Apply evenly to lips.', 25),
    (2, 'Mascara', 1250.00, '2028-06-30', 6, 10, 'ml', 'Apply to eyelashes from roots to tips.', 15),
    (3, 'Moisturizing Cream', 620.00, '2028-03-31', 12, 50, 'ml', 'Apply to clean facial skin.', 30),
    (3, 'Facial Cleanser', 480.00, '2028-05-31', 12, 236, 'ml', 'Apply to wet skin and rinse with water.', 20),
    (4, 'Shampoo', 350.00, '2028-08-31', 12, 250, 'ml', 'Apply to wet hair, massage and rinse.', 40),
    (4, 'Hair Mask', 420.00, '2028-09-30', 12, 300, 'ml', 'Apply to washed hair and rinse after several minutes.', 18);

INSERT INTO customer (
    customer_first_name,
    customer_last_name,
    customer_email,
    customer_phone_number,
    customer_birth_date,
    customer_bonuses,
    customer_deleted_at
)
VALUES
    ('Anna', 'Smith', 'anna.smith@example.com', '+380967804738', '2000-04-12', 120, NULL),
    ('Emma', 'Johnson', 'emma.johnson@example.com', '+380682630580', '1998-08-25', 50, NULL),
    ('Olivia', 'Brown', 'olivia.brown@example.com', '+380684305968', '2002-01-17', 200, NULL),
    ('James', 'Wilson', 'james.wilson@example.com', '+380509876758', '1999-11-03', 80, NULL),
    ('Michael', 'Taylor', 'michael.taylor@example.com', '+380345968570', '1997-06-21', 30, '2026-11-10');

INSERT INTO orders (
    customer_id,
    orders_date,
    orders_status,
    orders_delivery_address
)
VALUES
    (1, '2026-10-20', 'Delivered', 'Kyiv, vul. Khreshchatyk, 15'),
    (2, '2026-10-21', 'Delivered', 'Lviv, vul. Shevchenka, 24'),
    (3, '2026-10-22', 'Delivered', 'Odesa, vul. Deribasivska, 8'),
    (1, '2026-10-23', 'Delivered', 'Kyiv, vul. Saksahanskoho, 42'),
    (2, '2026-10-24', 'Delivered', 'Lviv, vul. Halytska, 17'),
    (3, '2026-11-01', 'New', 'Odesa, vul. Rishelievska, 31'),
    (1, '2026-11-02', 'Shipped', 'Dnipro, vul. Yavornytskoho, 56'),
    (1, '2026-11-03', 'Cancelled', 'Kyiv, vul. Volodymyrska, 19');

INSERT INTO order_item (
    orders_id,
    product_id,
    order_item_quantity,
    order_item_price
)
VALUES
    (1, 1, 2, 450.00),
    (1, 2, 1, 1250.00),
    (1, 3, 1, 620.00),
    (1, 4, 1, 480.00),

    (2, 1, 1, 450.00),
    (2, 2, 1, 1250.00),
    (2, 3, 2, 620.00),
    (2, 5, 1, 350.00),

    (3, 1, 3, 450.00),
    (3, 2, 1, 1250.00),
    (3, 3, 1, 620.00),
    (3, 4, 2, 480.00),
    (3, 6, 1, 420.00),

    (4, 1, 1, 450.00),
    (4, 2, 2, 1250.00),
    (4, 3, 1, 620.00),
    (4, 5, 2, 350.00),

    (5, 1, 2, 450.00),
    (5, 2, 1, 1250.00),
    (5, 3, 2, 620.00),
    (5, 6, 1, 420.00),

    (6, 4, 1, 480.00),

    (7, 5, 1, 350.00),

    (8, 1, 4, 450.00);

INSERT INTO product_category (
    product_id,
    category_id
)
VALUES
    (1, 1), 
    (2, 1), 
    (3, 2), 
    (4, 2), 
    (5, 3), 
    (6, 3); 

INSERT INTO review (
    review_rating,
    review_comment,
    product_id,
    customer_id
)
VALUES
    (5, 'Love the mascara! It gives great volume.', 2, 1),
    (4, 'Lightweight cream with good moisturizing effect.', 3, 1),
    (5, 'Beautiful color and easy application.', 1, 2),
    (3, 'The mascara is good, but it dries quickly.', 2, 2),
    (5, 'Gentle cleanser. My skin feels fresh after use.', 4, 3),
    (4, 'Makes my hair soft and easy to comb.', 6, 3);