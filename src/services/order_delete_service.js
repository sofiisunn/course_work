import { prisma } from "../db.js";

export async function deleteCancelledOrder(orders_id) {
    // перевірка вхідних даних
    if(!Number.isInteger(orders_id) || orders_id <= 0) {
        throw new Error("orders_id is required and must be a positive integer");
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
        if (order.orders_status !== "Cancelled") {
            throw new Error("Only cancelled orders can be deleted");
        }
        const deletion = await tx.orders.deleteMany({
            where: {
                orders_id: orders_id,
                orders_status: "Cancelled"
            }
        });
        if (deletion.count !== 1) {
            throw new Error("Order was deleted or changed by another request");
        }
        return {
            orders_id: orders_id,
            message: "Order deleted successfully"
        };
    });
}