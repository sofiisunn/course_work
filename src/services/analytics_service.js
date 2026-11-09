import { prisma } from "../db.js";

export async function getTopProductsByRevenue(limit = 10) {
    // перевірка вхідних даних
    if (!Number.isInteger(limit) || limit <= 0) {
        throw new Error("limit must be a positive integer");
    }

    //запит для отримання товарів за продажами
    const products = await prisma.$queryRaw`
        WITH product_sales AS (
        SELECT 
            p.product_id, 
            p.product_title, 
            b.brand_title, 
            COUNT(DISTINCT o.orders_id) AS total_orders,
            SUM(oi.order_item_quantity) AS total_quantity_sold,
            ROUND(SUM(oi.order_item_quantity * oi.order_item_price), 2) AS total_revenue,
            ROUND(AVG(oi.order_item_price), 2) AS average_item_price
        FROM product AS p
        INNER JOIN brand AS b ON b.brand_id = p.brand_id
        INNER JOIN order_item AS oi ON p.product_id = oi.product_id
        INNER JOIN orders AS o ON o.orders_id = oi.orders_id
        WHERE o.orders_status = 'Delivered'
        GROUP BY p.product_id, p.product_title, b.brand_title
        HAVING COUNT(DISTINCT o.orders_id) >= 5
        )
        SELECT
            product_sales.*,
            ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC, product_id 
        ) AS product_rank
        FROM product_sales
        ORDER BY total_revenue DESC, product_id 
        LIMIT ${limit}
    `;

    return products;
}