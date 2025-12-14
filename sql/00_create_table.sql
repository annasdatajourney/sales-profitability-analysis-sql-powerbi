-- 00_create_table.sql
-- Dialect: SQLite (works in DB Browser for SQLite or sqlite3 CLI)

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  Row_ID            INTEGER,
  Order_ID          TEXT,
  Order_Date        TEXT,   -- ISO: YYYY-MM-DD
  Ship_Date         TEXT,   -- ISO: YYYY-MM-DD
  Ship_Mode         TEXT,
  Customer_ID       TEXT,
  Customer_Name     TEXT,
  Segment           TEXT,
  Postal_Code       TEXT,
  City              TEXT,
  State             TEXT,
  Country           TEXT,
  Region            TEXT,
  Market            TEXT,
  Product_ID        TEXT,
  Category          TEXT,
  Sub_Category      TEXT,
  Product_Name      TEXT,
  Sales             REAL,
  Quantity          INTEGER,
  Discount          REAL,
  Profit            REAL,
  Shipping_Cost     REAL,
  Order_Priority    TEXT
);

-- Helpful indexes for typical analysis queries
CREATE INDEX IF NOT EXISTS idx_orders_order_date     ON orders (Order_Date);
CREATE INDEX IF NOT EXISTS idx_orders_region         ON orders (Region);
CREATE INDEX IF NOT EXISTS idx_orders_market         ON orders (Market);
CREATE INDEX IF NOT EXISTS idx_orders_customer       ON orders (Customer_ID);
CREATE INDEX IF NOT EXISTS idx_orders_product        ON orders (Product_ID);
CREATE INDEX IF NOT EXISTS idx_orders_category       ON orders (Category, Sub_Category);
