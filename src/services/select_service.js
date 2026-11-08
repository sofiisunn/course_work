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
