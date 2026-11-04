import { prisma } from "../db.js";
const MAX_QUANTITY = 2147483647;

export async function createOrder(orderData) {

    // перевірка вхідних даних
    if (!orderData || typeof orderData !== "object" || Array.isArray(orderData)) {
        throw new Error("orderData is required and must be an object");
    }
    const { customer_id, orders_delivery_address, items } = orderData;
    if (!Number.isInteger(customer_id) || customer_id <= 0) {
        throw new Error("customer_id is required and must be a positive integer");
    }
    if (!orders_delivery_address || typeof orders_delivery_address !== "string" || orders_delivery_address.trim() === "") {
        throw new Error("orders_delivery_address is required and must be a non-empty string");
    }
    if (!Array.isArray(items) || items.length === 0) {
        throw new Error("items is required and must be a non-empty array");
    }

    // перевірка кожного товару
    for (const item of items) {
        if (!item || typeof item !== "object" || Array.isArray(item)) {
            throw new Error("Each item is required and must be an object");
        }
        if (!Number.isInteger(item.product_id) || item.product_id <= 0) {
            throw new Error("Each item's product_id is required and must be a positive integer");
        }
        if (!Number.isInteger(item.quantity) || item.quantity <= 0) {
            throw new Error("Each item's quantity is required and must be a positive integer");
        }
    }

    // об'єднання оданакових товарів
    const itemsMap = new Map();
    for (const item of items) {
        if (itemsMap.has(item.product_id)) {
            itemsMap.set(item.product_id, itemsMap.get(item.product_id) + item.quantity);
        }
        else {
            itemsMap.set(item.product_id, item.quantity);
        }
    }

    // перевірка загальної кількості товарів
    for (const [product_id, quantity] of itemsMap) {
        if (quantity > MAX_QUANTITY) {
            throw new Error("Quantity for product with ID " + product_id + " exceeds the maximum allowed value");
        }
    }


    // транзакція створення замовлення
    await prisma.$transaction(async (tx) => {

        // перевірка клієнта
        const customer = await tx.customer.findUnique({
            where: {
                customer_id: customer_id
            }
        });
        if (!customer) {
            throw new Error("Customer not found");
        }

        // перевірка товарів і їх кількості
        const productIds = [...itemsMap.keys()];
        const products = await tx.product.findMany({
            where: {
                product_id: {
                    in: productIds
                }
            },
            select: {
                product_id: true,
                product_price: true,
                product_stock_quantity: true
            }
        });
        if (products.length !== productIds.length) {
            throw new Error("One or more products not found");
        }   

        // перевірка товару на складі
        for (const product of products) {
            const orderedQuantity = itemsMap.get(product.product_id);
            if (orderedQuantity > product.product_stock_quantity) {
                throw new Error("Not enough stock for product with ID " + product.product_id);
            }
        }

        // створення позицій замовлення
        const order_items = products.map(product => ({
            product_id: product.product_id,
            order_item_quantity: itemsMap.get(product.product_id),
            order_item_price: product.product_price
        }));
    });
}

