import { prisma } from "../db.js";

export async function getProductsByBrand(brand_id, limit = 10, offset = 0) {
    // перевірка вхідних даних
    if (!Number.isInteger(brand_id) || brand_id <= 0) {
        throw new Error("brand_id is required and must be a positive integer");
    }
    if (!Number.isInteger(limit) || limit <= 0) {
        throw new Error("limit must be a positive integer");
    }
    if (!Number.isInteger(offset) || offset < 0) {
        throw new Error("offset must be a non-negative integer");
    }

    //запит для отримання товарів за брендом
    const products = await prisma.$queryRaw`
    SELECT p.product_id, p.product_title, p.product_price, p.product_stock_quantity, b.brand_title 
    FROM product AS p
    INNER JOIN brand AS b ON b.brand_id = p.brand_id
    WHERE p.product_stock_quantity > 0 AND p.brand_id = ${brand_id}
    ORDER BY p.product_price DESC, p.product_id 
    LIMIT ${limit}
    OFFSET ${offset}
    `;

    return products;
}

export async function getActiveCustomers(limit = 10, offset = 0) {
    // перевірка вхідних даних
    if (!Number.isInteger(limit) || limit <= 0) {
        throw new Error("limit must be a positive integer");
    }
    if (!Number.isInteger(offset) || offset < 0) {
        throw new Error("offset must be a non-negative integer");
    }

    //запит для отримання активних клієнтів
    const customers = await prisma.$queryRaw`
    SELECT c.customer_id, c.customer_first_name || ' ' || c.customer_last_name AS customer_full_name, c.customer_email, o.orders_id, o.orders_date, o.orders_status
    FROM customer AS c
    LEFT JOIN orders AS o ON c.customer_id = o.customer_id
    WHERE c.customer_deleted_at IS NULL
    ORDER BY c.customer_id, o.orders_id
    LIMIT ${limit}
    OFFSET ${offset}
     `;

    return customers;
}