-- AlterTable
ALTER TABLE "customer" ADD COLUMN     "customer_deleted_at" TIMESTAMP(0);

-- AlterTable
ALTER TABLE "orders" ALTER COLUMN "orders_date" SET DATA TYPE TIMESTAMP(0);
