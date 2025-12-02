-- ========================================
-- FIX TOPPING ERROR - CREATE TOPPINGS TABLE
-- ========================================

-- Create toppings table if not exists
CREATE TABLE IF NOT EXISTS toppings (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE toppings ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view toppings
CREATE POLICY "Anyone can view toppings" ON toppings
  FOR SELECT USING (true);

-- Policy: Only authenticated users can insert toppings
CREATE POLICY "Authenticated users can insert toppings" ON toppings
  FOR INSERT WITH CHECK (true);

-- Policy: Only authenticated users can update toppings
CREATE POLICY "Authenticated users can update toppings" ON toppings
  FOR UPDATE USING (true);

-- Policy: Only authenticated users can delete toppings
CREATE POLICY "Authenticated users can delete toppings" ON toppings
  FOR DELETE USING (true);

-- Insert sample toppings
INSERT INTO toppings (name, price) VALUES
  ('Extra Cheese', 5000),
  ('Almond Slice', 5000),
  ('Chocolate Chips', 7000),
  ('Oreo Crumble', 8000)
ON CONFLICT DO NOTHING;

COMMENT ON TABLE toppings IS 'Topping options for products';
