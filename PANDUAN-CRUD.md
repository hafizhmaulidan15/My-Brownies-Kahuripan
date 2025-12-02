# 📦 Panduan CRUD Produk - Admin Panel

## ✅ Fitur yang Sudah Ditambahkan

### 1. **CREATE (Tambah Produk)**
- Form tambah produk baru dengan field:
  - Nama Produk
  - Kategori
  - Harga
  - Stok Awal
  - URL Gambar
- Data langsung tersimpan ke database Supabase
- Notifikasi sukses/gagal

### 2. **READ (Lihat Produk)**
- Tabel produk dengan informasi lengkap
- Thumbnail gambar produk
- Status stok dengan warna:
  - 🔴 Merah = Habis
  - 🟡 Kuning = Menipis (< 5)
  - 🟢 Hijau = Aman
- Auto-refresh dari database

### 3. **UPDATE (Edit Produk)**
- Tombol Edit di setiap produk
- Modal dialog yang modern
- Preview gambar real-time
- Update langsung ke database
- Notifikasi sukses/gagal

### 4. **DELETE (Hapus Produk)**
- Tombol Hapus dengan konfirmasi
- Hapus langsung dari database
- Notifikasi sukses/gagal

### 5. **Manajemen Topping**
- Tambah topping baru
- Hapus topping
- Tersimpan di database Supabase

---

## 🗄️ Setup Database

### Langkah 1: Buka Supabase Dashboard
1. Login ke [supabase.com](https://supabase.com)
2. Pilih project Anda
3. Klik **SQL Editor** di sidebar kiri

### Langkah 2: Jalankan SQL Script
1. Copy semua isi file `database-setup.sql`
2. Paste di SQL Editor
3. Klik **Run** atau tekan `Ctrl + Enter`

Script ini akan membuat:
- ✅ Tabel `products` (jika belum ada)
- ✅ Tabel `toppings` (baru)
- ✅ Row Level Security policies
- ✅ Sample data topping
- ✅ Index untuk performa

### Langkah 3: Verifikasi
Cek di **Table Editor** apakah tabel sudah muncul:
- `products`
- `toppings`

---

## 🚀 Cara Menggunakan

### Tambah Produk Baru
1. Buka `/admin/products`
2. Isi form "Tambah Menu Baru"
3. Klik **Simpan Produk**
4. Produk langsung muncul di tabel

### Edit Produk
1. Klik tombol **✏️ Edit** di produk yang ingin diubah
2. Modal akan muncul dengan data produk
3. Ubah data yang diperlukan
4. Klik **Update Produk**

### Hapus Produk
1. Klik tombol **🗑️ Hapus**
2. Konfirmasi penghapusan
3. Produk akan dihapus dari database

### Tambah Topping
1. Scroll ke section "Daftar Topping"
2. Isi nama dan harga topping
3. Klik **Tambah**

### Hapus Topping
1. Klik tombol **×** di topping yang ingin dihapus
2. Konfirmasi penghapusan

---

## 📁 File yang Diubah/Ditambahkan

### 1. `src/stores/products.js` ⭐ UPDATED
**Fungsi baru:**
- `fetchProducts()` - Ambil data produk dari Supabase
- `fetchToppings()` - Ambil data topping dari Supabase
- `addProduct(product)` - Tambah produk baru
- `updateProduct(id, updatedProduct)` - Update produk
- `deleteProduct(id)` - Hapus produk
- `addTopping(topping)` - Tambah topping baru
- `deleteTopping(id)` - Hapus topping
- `decreaseStock(productId, quantity)` - Kurangi stok (untuk checkout)

### 2. `src/views/admin/AdminProducts.vue` ⭐ UPDATED
**Fitur baru:**
- Form tambah produk dengan input gambar
- Tabel produk dengan thumbnail
- Modal edit produk yang modern
- Preview gambar di modal
- Tombol aksi (Edit & Hapus)
- Manajemen topping

### 3. `database-setup.sql` ⭐ NEW
Script SQL untuk setup database di Supabase

---

## 🎨 Fitur UI/UX

### Design Improvements:
- ✨ Modal edit yang smooth dengan animasi
- 🖼️ Preview gambar produk
- 🎨 Badge status stok berwarna
- 📱 Responsive design
- 🔄 Loading states
- ✅ Notifikasi sukses/error
- 🎯 Hover effects di tombol

---

## 🔐 Keamanan

### Row Level Security (RLS)
Database sudah dilindungi dengan RLS policies:
- **READ**: Semua orang bisa lihat produk
- **INSERT/UPDATE/DELETE**: Hanya user yang authenticated (login)

### Authentication
Pastikan user login sebagai admin sebelum bisa:
- Tambah produk
- Edit produk
- Hapus produk
- Kelola topping

---

## 🐛 Troubleshooting

### Error: "Failed to add product"
**Solusi:**
1. Pastikan sudah login sebagai admin
2. Cek koneksi internet
3. Verifikasi Supabase credentials di `src/supabase.js`
4. Pastikan RLS policies sudah di-setup

### Produk tidak muncul
**Solusi:**
1. Cek console browser (F12) untuk error
2. Pastikan tabel `products` ada di Supabase
3. Refresh halaman (F5)

### Topping tidak tersimpan
**Solusi:**
1. Pastikan tabel `toppings` sudah dibuat
2. Jalankan script `database-setup.sql`
3. Cek RLS policies

---

## 📝 Contoh Data Produk

```javascript
{
  name: "Brownies Keju Premium",
  category: "Best Seller",
  price: 75000,
  stock: 20,
  image: "https://images.unsplash.com/photo-1607920591413-4ec007e70023"
}
```

## 📝 Contoh Data Topping

```javascript
{
  name: "Extra Cheese",
  price: 5000
}
```

---

## 🎯 Next Steps (Opsional)

Fitur yang bisa ditambahkan nanti:
- [ ] Upload gambar langsung (bukan URL)
- [ ] Bulk edit produk
- [ ] Export data ke Excel
- [ ] Filter & search produk
- [ ] Kategori dropdown
- [ ] History perubahan produk
- [ ] Statistik produk terlaris

---

## 💡 Tips

1. **URL Gambar**: Gunakan layanan seperti:
   - Unsplash: `https://images.unsplash.com/...`
   - Imgur: `https://i.imgur.com/...`
   - Cloudinary
   - Supabase Storage (advanced)

2. **Backup Data**: Export data produk secara berkala dari Supabase

3. **Testing**: Test semua fitur CRUD sebelum production

---

## 📞 Support

Jika ada masalah atau pertanyaan, cek:
1. Console browser (F12) untuk error messages
2. Supabase logs di dashboard
3. Network tab untuk request yang gagal

---

**Happy Coding! 🚀**
