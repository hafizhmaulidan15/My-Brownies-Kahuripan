# ✅ Checklist Setup & Testing CRUD Produk

## 📋 Checklist Setup Database

### 1. Setup Tabel di Supabase
- [ ] Login ke Supabase Dashboard
- [ ] Buka SQL Editor
- [ ] Copy & paste isi file `database-setup.sql`
- [ ] Klik Run/Execute
- [ ] Verifikasi tabel `products` sudah ada
- [ ] Verifikasi tabel `toppings` sudah ada
- [ ] Cek RLS (Row Level Security) sudah enabled

### 2. Insert Sample Data (Opsional)
- [ ] Buka SQL Editor lagi
- [ ] Copy & paste isi file `sample-data.sql`
- [ ] Klik Run/Execute
- [ ] Refresh Table Editor
- [ ] Pastikan ada 10 produk sample
- [ ] Pastikan ada 8 topping sample

---

## 🧪 Checklist Testing Fitur

### A. Testing CREATE (Tambah Produk)
- [ ] Buka `http://localhost:5173/admin/login`
- [ ] Login dengan akun admin
- [ ] Buka `http://localhost:5173/admin/products`
- [ ] Isi form "Tambah Menu Baru":
  - [ ] Nama Produk: "Test Brownies"
  - [ ] Kategori: "Test"
  - [ ] Harga: 50000
  - [ ] Stok: 10
  - [ ] URL Gambar: (kosongkan atau isi URL)
- [ ] Klik "Simpan Produk"
- [ ] Muncul alert "Produk berhasil ditambahkan!"
- [ ] Produk muncul di tabel
- [ ] Cek di Supabase Table Editor, produk tersimpan

### B. Testing READ (Lihat Produk)
- [ ] Refresh halaman admin products
- [ ] Semua produk muncul di tabel
- [ ] Gambar produk tampil dengan benar
- [ ] Harga format Rupiah benar (Rp 50.000)
- [ ] Status stok tampil dengan warna:
  - [ ] Hijau untuk stok >= 5
  - [ ] Kuning untuk stok < 5
  - [ ] Merah untuk stok = 0

### C. Testing UPDATE (Edit Produk)
- [ ] Klik tombol "✏️ Edit" di salah satu produk
- [ ] Modal edit muncul
- [ ] Data produk sudah terisi di form
- [ ] Ubah nama produk menjadi "Test Brownies EDITED"
- [ ] Ubah harga menjadi 60000
- [ ] Klik "Update Produk"
- [ ] Muncul alert "Produk berhasil diupdate!"
- [ ] Modal tertutup
- [ ] Perubahan langsung terlihat di tabel
- [ ] Cek di Supabase, data sudah terupdate

### D. Testing DELETE (Hapus Produk)
- [ ] Klik tombol "🗑️ Hapus" di produk test
- [ ] Muncul konfirmasi "Yakin ingin menghapus?"
- [ ] Klik OK
- [ ] Muncul alert "Produk berhasil dihapus!"
- [ ] Produk hilang dari tabel
- [ ] Cek di Supabase, data sudah terhapus

### E. Testing Topping
- [ ] Scroll ke section "Daftar Topping"
- [ ] Isi nama topping: "Test Topping"
- [ ] Isi harga: 5000
- [ ] Klik "Tambah"
- [ ] Muncul alert "Topping berhasil ditambahkan!"
- [ ] Topping muncul di list
- [ ] Klik "×" untuk hapus
- [ ] Konfirmasi hapus
- [ ] Topping hilang dari list
- [ ] Cek di Supabase tabel `toppings`

### F. Testing di Homepage (Customer View)
- [ ] Buka `http://localhost:5173/`
- [ ] Semua produk muncul
- [ ] Klik "Beli +" di salah satu produk
- [ ] Modal topping muncul
- [ ] Topping dari database tampil
- [ ] Pilih beberapa topping
- [ ] Total harga bertambah sesuai topping
- [ ] Klik "Masuk Keranjang"
- [ ] Muncul notifikasi sukses
- [ ] Badge keranjang bertambah

### G. Testing Stok Management
- [ ] Buka halaman Cart
- [ ] Checkout produk
- [ ] Kembali ke admin products
- [ ] Stok produk berkurang sesuai qty yang dibeli
- [ ] Jika stok < 5, tampil warning kuning
- [ ] Jika stok = 0, produk tampil "SOLD OUT"

---

## 🔍 Checklist Error Handling

### Cek Error Scenarios:
- [ ] Tambah produk tanpa isi nama → Error validation
- [ ] Tambah produk dengan harga negatif → Error validation
- [ ] Edit produk tanpa login → Redirect ke login
- [ ] Hapus produk tanpa konfirmasi → Tidak terhapus
- [ ] Network error → Muncul alert error
- [ ] Cek console browser (F12) → Tidak ada error merah

---

## 🎨 Checklist UI/UX

### Visual & Interaksi:
- [ ] Form input responsive
- [ ] Modal edit smooth animation
- [ ] Preview gambar tampil di modal edit
- [ ] Tombol hover effect berfungsi
- [ ] Badge stok warna sesuai kondisi
- [ ] Table responsive di mobile
- [ ] Loading state saat fetch data
- [ ] Alert/notification tampil jelas

---

## 📊 Checklist Performance

- [ ] Halaman load < 2 detik
- [ ] Fetch products < 1 detik
- [ ] CRUD operation < 1 detik
- [ ] Tidak ada memory leak
- [ ] Gambar load dengan lazy loading
- [ ] Tidak ada console warning

---

## 🔐 Checklist Security

- [ ] RLS enabled di Supabase
- [ ] Hanya authenticated user bisa CRUD
- [ ] Public user hanya bisa READ
- [ ] Password tidak tersimpan di localStorage
- [ ] API key tidak exposed di frontend
- [ ] HTTPS enabled (production)

---

## 📱 Checklist Responsive

### Test di berbagai ukuran:
- [ ] Desktop (1920x1080)
- [ ] Laptop (1366x768)
- [ ] Tablet (768x1024)
- [ ] Mobile (375x667)

---

## 🚀 Checklist Production Ready

- [ ] Semua fitur CRUD berfungsi
- [ ] Tidak ada bug critical
- [ ] Error handling lengkap
- [ ] UI/UX smooth
- [ ] Database schema final
- [ ] Sample data sudah dihapus (jika perlu)
- [ ] Environment variables aman
- [ ] Build production berhasil (`npm run build`)
- [ ] Deploy ke hosting (Vercel/Netlify)

---

## 📝 Notes

**Jika ada yang tidak berfungsi:**
1. Cek console browser (F12)
2. Cek Supabase logs
3. Cek network tab untuk failed requests
4. Baca file PANDUAN-CRUD.md untuk troubleshooting

**Setelah semua checklist ✅:**
- Aplikasi siap digunakan!
- Bisa mulai tambah produk real
- Bisa deploy ke production

---

**Progress: [ ] / [ ] items completed**

Good luck! 🎉
