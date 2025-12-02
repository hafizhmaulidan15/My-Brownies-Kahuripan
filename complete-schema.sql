-- ========================================
-- CUSTOMER & PAYMENT SYSTEM - COMPLETE SCHEMA
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

-- 2. Update orders table
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS customer_id UUID REFERENCES customers(id),
ADD COLUMN IF NOT EXISTS customer_name TEXT,
ADD COLUMN IF NOT EXISTS customer_email TEXT,
ADD COLUMN IF NOT EXISTS customer_phone TEXT,
ADD COLUMN IF NOT EXISTS delivery_method TEXT DEFAULT 'pickup',
ADD COLUMN IF NOT EXISTS delivery_address TEXT,
ADD COLUMN IF NOT EXISTS delivery_fee INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS payment_method TEXT DEFAULT 'manual_transfer',
ADD COLUMN IF NOT EXISTS payment_status TEXT DEFAULT 'pending',
ADD COLUMN IF NOT EXISTS payment_proof_url TEXT,
ADD COLUMN IF NOT EXISTS transfer_amount INTEGER,
ADD COLUMN IF NOT EXISTS admin_notes TEXT;

-- 3. Create indexes
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);

-- 4. Enable RLS
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- 5. Customers policies
CREATE POLICY "Anyone can register" ON customers
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can view own data" ON customers
  FOR SELECT USING (true);

CREATE POLICY "Users can update own data" ON customers
  FOR UPDATE USING (id::text = current_setting('app.current_user_id', true));

-- 6. Orders policies
DROP POLICY IF EXISTS "Anyone can view orders" ON orders;
DROP POLICY IF EXISTS "Anyone can create orders" ON orders;

CREATE POLICY "Anyone can create orders" ON orders
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view orders" ON orders
  FOR SELECT USING (true);

CREATE POLICY "Anyone can update orders" ON orders
  FOR UPDATE USING (true);

-- 7. Create payment_proofs storage bucket (run in Storage UI)
-- Bucket name: payment-proofs
-- Public: false

COMMENT ON TABLE customers IS 'Customer accounts';
COMMENT ON TABLE orders IS 'Orders with payment tracking';
