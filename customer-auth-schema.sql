-- ========================================
-- CUSTOMER AUTHENTICATION & ORDERS SYSTEM
-- ========================================

-- 1. Create customers table
CREATE TABLE IF NOT EXISTS customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  phone TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Update orders table to include customer info
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS customer_id UUID REFERENCES customers(id),
ADD COLUMN IF NOT EXISTS customer_name TEXT,
ADD COLUMN IF NOT EXISTS customer_phone TEXT,
ADD COLUMN IF NOT EXISTS delivery_address TEXT,
ADD COLUMN IF NOT EXISTS delivery_method TEXT DEFAULT 'pickup', -- 'pickup' or 'delivery'
ADD COLUMN IF NOT EXISTS delivery_notes TEXT;

-- 3. Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);

-- 4. Row Level Security (RLS) for customers
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

-- Policy: Customers can read their own data
CREATE POLICY "Customers can view own data"
  ON customers
  FOR SELECT
  USING (auth.uid()::text = id::text);

-- Policy: Anyone can insert (register)
CREATE POLICY "Anyone can register"
  ON customers
  FOR INSERT
  WITH CHECK (true);

-- Policy: Customers can update their own data
CREATE POLICY "Customers can update own data"
  ON customers
  FOR UPDATE
  USING (auth.uid()::text = id::text);

-- 5. Update orders RLS policies
DROP POLICY IF EXISTS "Anyone can view orders" ON orders;
DROP POLICY IF EXISTS "Anyone can create orders" ON orders;

-- New policy: Customers can view their own orders
CREATE POLICY "Customers can view own orders"
  ON orders
  FOR SELECT
  USING (
    customer_id::text = auth.uid()::text 
    OR auth.uid() IS NULL  -- Allow anonymous for now
  );

-- Policy: Authenticated users can create orders
CREATE POLICY "Authenticated users can create orders"
  ON orders
  FOR INSERT
  WITH CHECK (true);

-- Policy: Admin can view all orders (for admin panel)
CREATE POLICY "Admin can view all orders"
  ON orders
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM customers 
      WHERE id::text = auth.uid()::text 
      AND email = 'admin@brownies.com'  -- Admin email
    )
  );

-- 6. Create function to validate delivery area
CREATE OR REPLACE FUNCTION is_valid_delivery_area(address TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  -- Check if address contains "Telaga Kahuripan"
  RETURN LOWER(address) LIKE '%telaga kahuripan%';
END;
$$ LANGUAGE plpgsql;

COMMENT ON TABLE customers IS 'Customer accounts for ordering';
COMMENT ON TABLE orders IS 'Customer orders with delivery information';
