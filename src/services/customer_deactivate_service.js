import { prisma } from "../db.js";

export async function deactivateCustomer(customer_id) {
    // перевірка вхідних даних
    if (!Number.isInteger(customer_id) || customer_id <= 0) {
        throw new Error("customer_id is required and must be a positive integer");
    }

    return prisma.$transaction(async (tx) => {
        const customer = await tx.customer.findUnique({
            where: {
                customer_id: customer_id
            },
            select: {
                customer_id: true,
                customer_deleted_at: true
            }
        });
        if (!customer) {
            throw new Error("Customer not found");
        }   
        if (customer.customer_deleted_at !== null) {
            throw new Error("Customer is already deactivated");
        }

        const deactivation = await tx.customer.updateMany({
            where: {
                customer_id: customer_id,
                customer_deleted_at: null
            },
            data: {
                customer_deleted_at: new Date()
            }
        });
        if (deactivation.count !== 1) {
            throw new Error("Customer was deactivated or changed by another request");
        }

        const updatedCustomer = await tx.customer.findUnique({
            where: {
                customer_id: customer_id
            },
            select: {
                customer_id: true,
                customer_deleted_at: true
            }
        });

        return updatedCustomer;
    });
}

export async function restoreCustomer(customer_id) {   
    // перевірка вхідних даних
    if (!Number.isInteger(customer_id) || customer_id <= 0) {
        throw new Error("customer_id is required and must be a positive integer");
    }

    return prisma.$transaction(async (tx) => {

        const customer = await tx.customer.findUnique({
            where: {
                customer_id: customer_id
            },              
            select: {
                customer_id: true,
                customer_deleted_at: true
            }   
        });
        if (!customer) {
            throw new Error("Customer not found");
        }
        if (customer.customer_deleted_at === null) {
            throw new Error("Customer is not deactivated");
        }

        const restoration = await tx.customer.updateMany({
            where: {
                customer_id: customer_id,
                customer_deleted_at: customer.customer_deleted_at
            },
            data: {
                customer_deleted_at: null
            }
        });
        if (restoration.count !== 1) {
            throw new Error("Customer was restored or changed by another request");
        }

        const updatedCustomer = await tx.customer.findUnique({
            where: {
                customer_id: customer_id
            },
            select: {
                customer_id: true,
                customer_deleted_at: true
            }
        });
        return updatedCustomer;
    });
}