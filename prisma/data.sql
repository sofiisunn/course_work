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

