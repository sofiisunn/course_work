import { prisma } from "../db.js";

export async function createOrder(orderData) {
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
    const itemsMap = new Map();
    for (const item of items) {
        if (itemsMap.has(item.product_id)) {
            itemsMap.set(item.product_id, itemsMap.get(item.product_id) + item.quantity);
        }
        else {
            itemsMap.set(item.product_id, item.quantity);
        }
    }
    const customer = await prisma.customer.findUnique({
        where: {
            customer_id: customer_id
        }
    });
    if (!customer) {
        throw new Error("Customer not found");
    }
    const productIds = [...itemsMap.keys()];
    const products = await prisma.product.findMany({
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
}