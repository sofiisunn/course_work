## Діаграма сутність-зв'язок (ERD):

![ER-діаграма](./er_diagram.png)

## Опис таблиць:

### Таблиця: `supplier`

**Призначення:** Зберігає інформацію про постачальників брендів товарів

**Стовпці:**
| Стовпець | Тип | Обмеження | Опис |
|----------|-----|-----------|------|
| supplier_id | SERIAL | PRIMARY KEY | Ідентифікатор постачальника |
| supplier_name | VARCHAR(100) | UNIQUE, NOT NULL | Назва постачальника |
| supplier_phone_number | VARCHAR(16) | UNIQUE, NOT NULL | Номер телефону постачальника |
| supplier_email | VARCHAR(254) | UNIQUE, NOT NULL | Email постачальника |

**Зв'язки:**
- Один-до-багатьох з `brand` (один постачальник може постачати кілька брендів)

### Таблиця: `brand`

**Призначення:** Зберігає інформацію про бренди товарів

**Стовпці:**
| Стовпець | Тип | Обмеження | Опис |
|----------|-----|-----------|------|
| brand_id | SERIAL | PRIMARY KEY | Ідентифікатор бренду |
| supplier_id | INTEGER | FOREIGN KEY, NOT NULL | Ідентифікатор постачальника |
| brand_title | VARCHAR(100) | UNIQUE, NOT NULL | Назва бренду |

**Зв'язки:**
- Багато-до-одного з `supplier` (кілька брендів можуть бути пов'язані з одним постачальником)
- Один-до-багатьох з `product` (один бренд може мати кілька товарів)

### Таблиця: `category`

**Призначення:** Зберігає інформацію про категорії товарів

**Стовпці:**
| Стовпець | Тип | Обмеження | Опис |
|----------|-----|-----------|------|
| category_id | SERIAL | PRIMARY KEY | Ідентифікатор категорії |
| category_title | VARCHAR(100) | UNIQUE, NOT NULL | Назва категорії |

**Зв'язки:**
- Один-до-багатьох з `product_category` (одна категорія може мати кілька записів асоціативної сутності product_category). Через цей зв'язок відбувається реалізація зв'язку Багато-до-багатьох з `product`

### Таблиця: `product`

**Призначення:** Зберігає інформацію про товари

**Стовпці:**
| Стовпець | Тип | Обмеження | Опис |
|----------|-----|-----------|------|
| product_id | SERIAL | PRIMARY KEY | Ідентифікатор товару |
| brand_id | INTEGER | FOREIGN KEY, NOT NULL | Ідентифікатор бренду |
| product_title | VARCHAR(150) | NOT NULL | Назва товару |
| product_price | DECIMAL(8, 2) | NOT NULL, CHECK (product_price > 0) | Ціна товару |
| product_expiration_date | DATE | NULL | Дата закінчення терміну придатності товару |
| product_pao_months | SMALLINT | NULL, CHECK (product_pao_months > 0) | Tермін придатності товару в місяцях після відкриття упаковки |
| product_volume_value | INTEGER | NOT NULL, CHECK (product_volume_value > 0) | Числове значення об'єму, ваги або кількості товару |
| product_volume_unit | ENUM (product_volume_unit) | NOT NULL | Одиниця вимірювання товару (ml, g або pcs) |
| product_application_method | TEXT | NULL | Опис способу застосування товару |
| product_stock_quantity | INTEGER | NOT NULL, DEFAULT 0, CHECK (product_stock_quantity >= 0) | Кількість товару на складі |

**Індекси:**
- `product_brand_id_idx` на `brand_id` (для пошуку товарів за брендом).
- `product_product_price_idx` на `product_price` (для фільтрації товарів за ціною).

**Зв'язки:**
- Багато-до-одного з `brand` (кілька товарів можуть бути пов'язані з одним брендом)
- Один-до-багатьох з `product_category` (один товар може мати кілька записів асоціативної сутності product_category). Через цей зв'язок відбувається реалізація зв'язку Багато-до-багатьох з `category`
- Один-до-багатьох з `review` (один товар може мати кілька відгуків)
- Один-до-багатьох з `order_item` (один товар може належати багатьом позиціям замовлення)