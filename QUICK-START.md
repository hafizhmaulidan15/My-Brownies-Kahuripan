# 🚀 Quick Start - CRUD Produk Admin Panel

## Setup Database (WAJIB - Lakukan Sekali Saja!)

### 1. Login ke Supabase
- Buka https://supabase.com
- Login ke project Anda

### 2. Jalankan SQL Script
1. Klik **SQL Editor** di sidebar
2. Copy semua isi file `database-setup.sql`
3. Paste dan klik **Run**
4. Tunggu sampai selesai (✅ Success)

### 3. Verifikasi Tabel
Cek di **Table Editor**, pastikan ada:
- ✅ `products`
- ✅ `toppings`

---

## Cara Pakai Admin Panel

### Login Admin
```
URL: http://localhost:5173/admin/login
Email: admin@example.com (sesuaikan dengan user Supabase Anda)
Password: (password Anda)
```

### Kelola Produk
```
URL: http://localhost:5173/admin/products
```

**Tambah Produk:**
1. Isi form di bagian atas
2. Klik "Simpan Produk"

**Edit Produk:**
1. Klik tombol "✏️ Edit"
2. Ubah data di modal
3. Klik "Update Produk"

**Hapus Produk:**
1. Klik tombol "🗑️ Hapus"
2. Konfirmasi

**Tambah Topping:**
1. Scroll ke bawah
2. Isi nama & harga
3. Klik "Tambah"

---

## Struktur Database

### Tabel: products
| Field    | Type    | Keterangan           |
|----------|---------|----------------------|
| id       | bigint  | Auto increment (PK)  |
| name     | text    | Nama produk          |
| category | text    | Kategori produk      |
| price    | integer | Harga (Rupiah)       |
| stock    | integer | Jumlah stok          |
| image    | text    | URL gambar           |

### Tabel: toppings
| Field | Type    | Keterangan          |
|-------|---------|---------------------|
| id    | bigint  | Auto increment (PK) |
| name  | text    | Nama topping        |
| price | integer | Harga tambahan      |

---

## Troubleshooting Cepat

### ❌ Error: "Failed to add product"
**Solusi:** Pastikan sudah login sebagai admin

### ❌ Produk tidak muncul
**Solusi:** 
1. Refresh halaman (F5)
2. Cek console (F12) untuk error
3. Pastikan tabel `products` ada di Supabase

### ❌ Topping tidak tersimpan
**Solusi:** 
1. Jalankan script `database-setup.sql`
2. Pastikan tabel `toppings` ada

---

## File Penting

| File | Fungsi |
|------|--------|
| `src/stores/products.js` | Logic CRUD produk & topping |
| `src/views/admin/AdminProducts.vue` | UI admin panel |
| `database-setup.sql` | Script setup database |
| `PANDUAN-CRUD.md` | Dokumentasi lengkap |

---

## Fitur yang Sudah Jalan

✅ Create - Tambah produk baru  
✅ Read - Lihat semua produk  
✅ Update - Edit produk  
✅ Delete - Hapus produk  
✅ Manajemen topping  
✅ Upload gambar via URL  
✅ Preview gambar  
✅ Status stok real-time  
✅ Notifikasi sukses/error  

---

**Selamat mencoba! 🎉**

Baca `PANDUAN-CRUD.md` untuk dokumentasi lengkap.
