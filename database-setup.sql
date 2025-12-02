-- Script SQL untuk membuat tabel products dan toppings di Supabase
-- Jalankan script ini di Supabase SQL Editor

-- 1. Tabel Products (jika belum ada)
CREATE TABLE IF NOT EXISTS products (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  price INTEGER NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0,
  image TEXT DEFAULT 'https://placehold.co/400x400',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Tabel Toppings (baru)
CREATE TABLE IF NOT EXISTS toppings (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Insert data sample untuk toppings (opsional)
INSERT INTO toppings (name, price) VALUES
  ('Extra Cheese', 5000),
  ('Almond Slice', 5000),
  ('Chocolate Chips', 7000),
  ('Oreo Crumble', 8000)
ON CONFLICT DO NOTHING;

-- 4. Enable Row Level Security (RLS) - PENTING untuk keamanan
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE toppings ENABLE ROW LEVEL SECURITY;

-- 5. Policy untuk products - semua orang bisa read, hanya admin bisa write
CREATE POLICY "Enable read access for all users" ON products
  FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users only" ON products
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users only" ON products
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Enable delete for authenticated users only" ON products
  FOR DELETE USING (auth.role() = 'authenticated');

-- 6. Policy untuk toppings - sama seperti products
CREATE POLICY "Enable read access for all users" ON toppings
  FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users only" ON toppings
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users only" ON toppings
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Enable delete for authenticated users only" ON toppings
  FOR DELETE USING (auth.role() = 'authenticated');

-- 7. Buat index untuk performa lebih baik
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at);
CREATE INDEX IF NOT EXISTS idx_toppings_created_at ON toppings(created_at);
