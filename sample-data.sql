-- CONTOH DATA PRODUK UNTUK TESTING
-- Copy dan paste satu per satu di form admin, atau insert langsung via SQL Editor

-- ========================================
-- CARA 1: Insert via SQL Editor (Cepat)
-- ========================================
-- Copy script di bawah ini dan jalankan di Supabase SQL Editor

INSERT INTO products (name, category, price, stock, image) VALUES
  ('Brownies Keju Premium', 'Best Seller', 75000, 20, 'https://images.unsplash.com/photo-1607920591413-4ec007e70023?w=400'),
  ('Brownies Coklat Original', 'Best Seller', 65000, 15, 'https://images.unsplash.com/photo-1590841609987-4ac211afdde1?w=400'),
  ('Brownies Red Velvet', 'Premium', 85000, 10, 'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=400'),
  ('Brownies Oreo Crunch', 'Premium', 90000, 8, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400'),
  ('Brownies Matcha', 'Special', 80000, 12, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400'),
  ('Brownies Tiramisu', 'Special', 95000, 5, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400'),
  ('Brownies Nutella', 'Premium', 100000, 7, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400'),
  ('Brownies Pandan', 'Regular', 60000, 25, 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400'),
  ('Brownies Strawberry', 'Regular', 70000, 18, 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400'),
  ('Brownies Salted Caramel', 'Premium', 95000, 6, 'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?w=400');

-- ========================================
-- CARA 2: Input Manual via Form Admin
-- ========================================
-- Buka: http://localhost:5173/admin/products
-- Isi form dengan data di bawah:

/*
PRODUK 1:
Nama: Brownies Keju Premium
Kategori: Best Seller
Harga: 75000
Stok: 20
URL Gambar: https://images.unsplash.com/photo-1607920591413-4ec007e70023?w=400

PRODUK 2:
Nama: Brownies Coklat Original
Kategori: Best Seller
Harga: 65000
Stok: 15
URL Gambar: https://images.unsplash.com/photo-1590841609987-4ac211afdde1?w=400

PRODUK 3:
Nama: Brownies Red Velvet
Kategori: Premium
Harga: 85000
Stok: 10
URL Gambar: https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=400

PRODUK 4:
Nama: Brownies Oreo Crunch
Kategori: Premium
Harga: 90000
Stok: 8
URL Gambar: https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400

PRODUK 5:
Nama: Brownies Matcha
Kategori: Special
Harga: 80000
Stok: 12
URL Gambar: https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400

PRODUK 6:
Nama: Brownies Tiramisu
Kategori: Special
Harga: 95000
Stok: 5
URL Gambar: https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400

PRODUK 7:
Nama: Brownies Nutella
Kategori: Premium
Harga: 100000
Stok: 7
URL Gambar: https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400

PRODUK 8:
Nama: Brownies Pandan
Kategori: Regular
Harga: 60000
Stok: 25
URL Gambar: https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400

PRODUK 9:
Nama: Brownies Strawberry
Kategori: Regular
Harga: 70000
Stok: 18
URL Gambar: https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400

PRODUK 10:
Nama: Brownies Salted Caramel
Kategori: Premium
Harga: 95000
Stok: 6
URL Gambar: https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?w=400
*/

-- ========================================
-- CONTOH DATA TOPPING
-- ========================================

INSERT INTO toppings (name, price) VALUES
  ('Extra Cheese', 5000),
  ('Almond Slice', 5000),
  ('Chocolate Chips', 7000),
  ('Oreo Crumble', 8000),
  ('Nutella Drizzle', 10000),
  ('Caramel Sauce', 6000),
  ('Strawberry Topping', 7000),
  ('Whipped Cream', 5000);

-- ========================================
-- TIPS GAMBAR
-- ========================================
-- Gunakan URL gambar dari:
-- 1. Unsplash: https://unsplash.com (gratis, kualitas tinggi)
--    Format: https://images.unsplash.com/photo-xxxxx?w=400
-- 
-- 2. Pexels: https://pexels.com (gratis)
-- 
-- 3. Imgur: https://imgur.com (upload sendiri)
-- 
-- 4. Placeholder: https://placehold.co/400x400
--    Untuk testing saja

-- ========================================
-- KATEGORI YANG DIGUNAKAN
-- ========================================
-- - Best Seller (produk paling laris)
-- - Premium (harga tinggi, kualitas premium)
-- - Special (edisi khusus/seasonal)
-- - Regular (produk standar)

-- Anda bisa tambah kategori sendiri sesuai kebutuhan!
