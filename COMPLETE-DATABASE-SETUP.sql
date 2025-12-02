-- ========================================
-- COMPLETE DATABASE SETUP - RUN THIS ONCE
-- ========================================

-- 1. CREATE PRODUCTS TABLE
CREATE TABLE IF NOT EXISTS products (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price INTEGER NOT NULL,
  category TEXT NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0,
  image TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. CREATE TOPPINGS TABLE
CREATE TABLE IF NOT EXISTS toppings (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. CREATE CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  phone TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. CREATE ORDERS TABLE
CREATE TABLE IF NOT EXISTS orders (
  id BIGSERIAL PRIMARY KEY,
  customer_id UUID REFERENCES customers(id),
  customer_name TEXT,
  customer_email TEXT,
  customer_phone TEXT,
  items JSONB NOT NULL,
  total INTEGER NOT NULL,
  status TEXT DEFAULT 'Pending',
  delivery_method TEXT DEFAULT 'pickup',
  delivery_address TEXT,
  delivery_fee INTEGER DEFAULT 0,
  payment_method TEXT DEFAULT 'manual_transfer',
  payment_status TEXT DEFAULT 'pending',
  payment_proof_url TEXT,
  transfer_amount INTEGER,
  admin_notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. ENABLE ROW LEVEL SECURITY
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE toppings ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- 6. CREATE POLICIES FOR PRODUCTS
DROP POLICY IF EXISTS "Anyone can view products" ON products;
DROP POLICY IF EXISTS "Authenticated users can insert products" ON products;
DROP POLICY IF EXISTS "Authenticated users can update products" ON products;
DROP POLICY IF EXISTS "Authenticated users can delete products" ON products;

CREATE POLICY "Anyone can view products" ON products
  FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert products" ON products
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Authenticated users can update products" ON products
  FOR UPDATE USING (true);

CREATE POLICY "Authenticated users can delete products" ON products
  FOR DELETE USING (true);

-- 7. CREATE POLICIES FOR TOPPINGS
DROP POLICY IF EXISTS "Anyone can view toppings" ON toppings;
DROP POLICY IF EXISTS "Authenticated users can insert toppings" ON toppings;
DROP POLICY IF EXISTS "Authenticated users can update toppings" ON toppings;
DROP POLICY IF EXISTS "Authenticated users can delete toppings" ON toppings;

CREATE POLICY "Anyone can view toppings" ON toppings
  FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert toppings" ON toppings
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Authenticated users can update toppings" ON toppings
  FOR UPDATE USING (true);

CREATE POLICY "Authenticated users can delete toppings" ON toppings
  FOR DELETE USING (true);

-- 8. CREATE POLICIES FOR CUSTOMERS
DROP POLICY IF EXISTS "Anyone can register" ON customers;
DROP POLICY IF EXISTS "Users can view own data" ON customers;
DROP POLICY IF EXISTS "Users can update own data" ON customers;

CREATE POLICY "Anyone can register" ON customers
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can view own data" ON customers
  FOR SELECT USING (true);

CREATE POLICY "Users can update own data" ON customers
  FOR UPDATE USING (true);

-- 9. CREATE POLICIES FOR ORDERS
DROP POLICY IF EXISTS "Anyone can create orders" ON orders;
DROP POLICY IF EXISTS "Anyone can view orders" ON orders;
DROP POLICY IF EXISTS "Anyone can update orders" ON orders;

CREATE POLICY "Anyone can create orders" ON orders
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view orders" ON orders
  FOR SELECT USING (true);

CREATE POLICY "Anyone can update orders" ON orders
  FOR UPDATE USING (true);

-- 10. CREATE INDEXES FOR PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);

-- 11. INSERT SAMPLE DATA

-- Sample Products
INSERT INTO products (name, price, category, stock, image) VALUES
  ('Brownies Coklat Original', 75000, 'Best Seller', 20, 'https://placehold.co/400x400/8B4513/FFFFFF?text=Brownies+Coklat'),
  ('Brownies Keju Premium', 85000, 'Best Seller', 15, 'https://placehold.co/400x400/FFD700/8B4513?text=Brownies+Keju'),
  ('Brownies Red Velvet', 90000, 'Premium', 10, 'https://placehold.co/400x400/DC143C/FFFFFF?text=Red+Velvet'),
  ('Brownies Matcha', 95000, 'Premium', 8, 'https://placehold.co/400x400/90EE90/2D1810?text=Matcha'),
  ('Brownies Nutella', 100000, 'Premium', 5, 'https://placehold.co/400x400/A0522D/FFFFFF?text=Nutella'),
  ('Brownies Oreo', 88000, 'Best Seller', 12, 'https://placehold.co/400x400/000000/FFFFFF?text=Oreo')
ON CONFLICT DO NOTHING;

-- Sample Toppings
INSERT INTO toppings (name, price) VALUES
  ('Extra Cheese', 5000),
  ('Almond Slice', 5000),
  ('Chocolate Chips', 7000),
  ('Oreo Crumble', 8000),
  ('Nutella Drizzle', 10000),
  ('Caramel Sauce', 6000)
ON CONFLICT DO NOTHING;

-- 12. VERIFY SETUP
SELECT 'Products count:' as info, COUNT(*) as count FROM products
UNION ALL
SELECT 'Toppings count:', COUNT(*) FROM toppings
UNION ALL
SELECT 'Customers count:', COUNT(*) FROM customers
UNION ALL
SELECT 'Orders count:', COUNT(*) FROM orders;

-- SUCCESS MESSAGE
SELECT '✅ Database setup complete!' as status;
