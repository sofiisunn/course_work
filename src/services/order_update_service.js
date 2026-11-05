import { prisma } from "../db.js";
const ORDER_STATUSES = new Set([
    "New",
    "In_Progress",
    "Shipped",
    "Delivered",
    "Cancelled"
]);

const ALLOWED_TRANSITIONS = new Map([
    ["New", new Set(["In_Progress", "Cancelled"])],
    ["In_Progress", new Set(["Shipped", "Cancelled"])],
    ["Shipped", new Set(["Delivered"])],
    ["Delivered", new Set()],
    ["Cancelled", new Set()]
]);

export async function updateOrderStatus(orders_id, newStatus) {
    // перевірка вхідних даних
    if(!Number.isInteger(orders_id) || orders_id <= 0) {
        throw new Error("orders_id is required and must be a positive integer");
    }
    if(!ORDER_STATUSES.has(newStatus)) {
        throw new Error("Invalid order status");
    }

    return prisma.$transaction(async (tx) => {
        
        const order = await tx.orders.findUnique({
            where: {
                orders_id: orders_id
            },
            select: {
                orders_id: true,
                orders_status: true
            }
        });
        if (!order) {
            throw new Error("Order not found");
        }

    
        const allowedStatuses = ALLOWED_TRANSITIONS.get(order.orders_status);
        if (!allowedStatuses || !allowedStatuses.has(newStatus)) {
            throw new Error("Invalid status transition");
        }

        
        const statusUpdate = await tx.orders.updateMany({
            where: {
                orders_id: orders_id,
                orders_status: order.orders_status
            },
            data: {
                orders_status: newStatus
            }
        });
        return statusUpdate;
    });
}