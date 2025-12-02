-- ========================================
-- FIX RLS POLICIES - MAKE IT WORK
-- ========================================

-- Disable RLS temporarily for testing
ALTER TABLE products DISABLE ROW LEVEL SECURITY;
ALTER TABLE toppings DISABLE ROW LEVEL SECURITY;
ALTER TABLE customers DISABLE ROW LEVEL SECURITY;
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;

-- Or if you want to keep RLS enabled, use these permissive policies:

-- Products - Allow all operations
DROP POLICY IF EXISTS "Allow all for products" ON products;
CREATE POLICY "Allow all for products" ON products
  FOR ALL USING (true) WITH CHECK (true);

-- Toppings - Allow all operations
DROP POLICY IF EXISTS "Allow all for toppings" ON toppings;
CREATE POLICY "Allow all for toppings" ON toppings
  FOR ALL USING (true) WITH CHECK (true);

-- Customers - Allow all operations
DROP POLICY IF EXISTS "Allow all for customers" ON customers;
CREATE POLICY "Allow all for customers" ON customers
  FOR ALL USING (true) WITH CHECK (true);

-- Orders - Allow all operations
DROP POLICY IF EXISTS "Allow all for orders" ON orders;
CREATE POLICY "Allow all for orders" ON orders
  FOR ALL USING (true) WITH CHECK (true);

SELECT '✅ RLS policies fixed!' as status;
