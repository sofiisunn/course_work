-- CreateEnum
CREATE TYPE "order_status_type" AS ENUM ('New', 'In Progress', 'Shipped', 'Delivered', 'Cancelled');

-- CreateEnum
CREATE TYPE "product_volume_unit" AS ENUM ('ml', 'g', 'pcs');

-- CreateTable
CREATE TABLE "supplier" (
    "supplier_id" SERIAL NOT NULL,
    "supplier_name" VARCHAR(100) NOT NULL,
    "supplier_phone_number" VARCHAR(16) NOT NULL,
    "supplier_email" VARCHAR(254) NOT NULL,

    CONSTRAINT "supplier_pkey" PRIMARY KEY ("supplier_id")
);

-- CreateTable
CREATE TABLE "brand" (
    "brand_id" SERIAL NOT NULL,
    "brand_title" VARCHAR(100) NOT NULL,
    "supplier_id" INTEGER NOT NULL,

    CONSTRAINT "brand_pkey" PRIMARY KEY ("brand_id")
);

-- CreateTable
CREATE TABLE "category" (
    "category_id" SERIAL NOT NULL,
    "category_title" VARCHAR(100) NOT NULL,

    CONSTRAINT "category_pkey" PRIMARY KEY ("category_id")
);

-- CreateTable
CREATE TABLE "product" (
    "product_id" SERIAL NOT NULL,
    "brand_id" INTEGER NOT NULL,
    "product_title" VARCHAR(150) NOT NULL,
    "product_price" DECIMAL(8,2) NOT NULL,
    "product_expiration_date" DATE,
    "product_pao_months" SMALLINT,
    "product_volume_value" INTEGER NOT NULL,
    "product_volume_unit" "product_volume_unit" NOT NULL,
    "product_application_method" TEXT,
    "product_stock_quantity" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "product_pkey" PRIMARY KEY ("product_id")
);

-- CreateTable
CREATE TABLE "customer" (
    "customer_id" SERIAL NOT NULL,
    "customer_first_name" VARCHAR(100) NOT NULL,
    "customer_last_name" VARCHAR(100) NOT NULL,
    "customer_email" VARCHAR(254) NOT NULL,
    "customer_phone_number" VARCHAR(16) NOT NULL,
    "customer_birth_date" DATE NOT NULL,
    "customer_bonuses" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "customer_pkey" PRIMARY KEY ("customer_id")
);

-- CreateTable
CREATE TABLE "orders" (
    "orders_id" SERIAL NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "orders_date" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "orders_price" DECIMAL(8,2) NOT NULL,
    "orders_status" "order_status_type" NOT NULL,
    "orders_delivery_address" TEXT NOT NULL,

    CONSTRAINT "orders_pkey" PRIMARY KEY ("orders_id")
);

-- CreateTable
CREATE TABLE "order_item" (
    "orders_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "order_item_quantity" INTEGER NOT NULL,
    "order_item_price" DECIMAL(8,2) NOT NULL,

    CONSTRAINT "order_item_pkey" PRIMARY KEY ("orders_id","product_id")
);

-- CreateTable
CREATE TABLE "product_category" (
    "product_id" INTEGER NOT NULL,
    "category_id" INTEGER NOT NULL,

    CONSTRAINT "product_category_pkey" PRIMARY KEY ("product_id","category_id")
);

-- CreateTable
CREATE TABLE "review" (
    "review_id" SERIAL NOT NULL,
    "review_rating" INTEGER NOT NULL,
    "review_comment" TEXT,
    "product_id" INTEGER NOT NULL,
    "customer_id" INTEGER NOT NULL,

    CONSTRAINT "review_pkey" PRIMARY KEY ("review_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "supplier_supplier_name_key" ON "supplier"("supplier_name");

-- CreateIndex
CREATE UNIQUE INDEX "supplier_supplier_phone_number_key" ON "supplier"("supplier_phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "supplier_supplier_email_key" ON "supplier"("supplier_email");

-- CreateIndex
CREATE UNIQUE INDEX "brand_brand_title_key" ON "brand"("brand_title");

-- CreateIndex
CREATE UNIQUE INDEX "category_category_title_key" ON "category"("category_title");

-- CreateIndex
CREATE INDEX "product_brand_id_idx" ON "product"("brand_id");

-- CreateIndex
CREATE INDEX "product_product_price_idx" ON "product"("product_price");

-- CreateIndex
CREATE UNIQUE INDEX "customer_customer_email_key" ON "customer"("customer_email");

-- CreateIndex
CREATE UNIQUE INDEX "customer_customer_phone_number_key" ON "customer"("customer_phone_number");

-- CreateIndex
CREATE INDEX "orders_customer_id_orders_date_idx" ON "orders"("customer_id", "orders_date");

-- CreateIndex
CREATE INDEX "product_category_category_id_idx" ON "product_category"("category_id");

-- CreateIndex
CREATE INDEX "review_product_id_idx" ON "review"("product_id");

-- CreateIndex
CREATE UNIQUE INDEX "review_customer_id_product_id_key" ON "review"("customer_id", "product_id");

-- AddForeignKey
ALTER TABLE "brand" ADD CONSTRAINT "brand_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "supplier"("supplier_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "brand"("brand_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_orders_id_fkey" FOREIGN KEY ("orders_id") REFERENCES "orders"("orders_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("product_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_category" ADD CONSTRAINT "product_category_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "category"("category_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_category" ADD CONSTRAINT "product_category_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("product_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("product_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- CHECK constraints for product
ALTER TABLE "product"
ADD CONSTRAINT "product_price_positive"
CHECK ("product_price" > 0);

ALTER TABLE "product"
ADD CONSTRAINT "product_pao_positive"
CHECK ("product_pao_months" > 0);

ALTER TABLE "product"
ADD CONSTRAINT "product_volume_positive"
CHECK ("product_volume_value" > 0);

ALTER TABLE "product"
ADD CONSTRAINT "product_stock_nonnegative"
CHECK ("product_stock_quantity" >= 0);

-- CHECK constraints for customer
ALTER TABLE "customer"
ADD CONSTRAINT "customer_bonuses_nonnegative"
CHECK ("customer_bonuses" >= 0);

-- CHECK constraints for orders
ALTER TABLE "orders"
ADD CONSTRAINT "orders_price_positive"
CHECK ("orders_price" > 0);

-- CHECK constraints for order_item
ALTER TABLE "order_item"
ADD CONSTRAINT "order_item_quantity_positive"
CHECK ("order_item_quantity" > 0);

ALTER TABLE "order_item"
ADD CONSTRAINT "order_item_price_positive"
CHECK ("order_item_price" > 0);

-- CHECK constraints for review
ALTER TABLE "review"
ADD CONSTRAINT "review_rating_range"
CHECK ("review_rating" BETWEEN 1 AND 5);