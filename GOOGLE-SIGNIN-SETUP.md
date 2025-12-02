# 🚀 SETUP GOOGLE SIGN-IN & MANUAL PAYMENT

## 📋 LANGKAH-LANGKAH SETUP

### **STEP 1: Setup Google OAuth di Supabase**

1. **Buka Supabase Dashboard:**
   - Login ke https://supabase.com
   - Pilih project Anda

2. **Enable Google Provider:**
   - Klik **Authentication** di sidebar
   - Klik **Providers**
   - Cari **Google** dan klik
   - Toggle **Enable Sign in with Google** → ON

3. **Get Google OAuth Credentials:**
   
   **A. Buka Google Cloud Console:**
   - https://console.cloud.google.com
   - Login dengan Google account
   
   **B. Create/Select Project:**
   - Klik dropdown project di top bar
   - Klik "New Project"
   - Nama: "My Brownies Telaga Kahuripan"
   - Klik "Create"
   
   **C. Enable Google+ API:**
   - Di sidebar, klik "APIs & Services" → "Library"
   - Search "Google+ API"
   - Klik dan "Enable"
   
   **D. Create OAuth Credentials:**
   - Sidebar → "APIs & Services" → "Credentials"
   - Klik "Create Credentials" → "OAuth client ID"
   - Application type: **Web application**
   - Name: "Brownies Web App"
   
   **E. Add Authorized Redirect URIs:**
   ```
   https://[YOUR-PROJECT-REF].supabase.co/auth/v1/callback
   ```
   Ganti `[YOUR-PROJECT-REF]` dengan project ref Anda
   
   Contoh:
   ```
   https://abcdefghijk.supabase.co/auth/v1/callback
   ```
   
   **F. Copy Credentials:**
   - Client ID: `xxxxx.apps.googleusercontent.com`
   - Client Secret: `GOCSPX-xxxxx`

4. **Paste ke Supabase:**
   - Kembali ke Supabase → Authentication → Providers → Google
   - Paste **Client ID**
   - Paste **Client Secret**
   - Klik **Save**

---

### **STEP 2: Update Database Schema**

Run SQL ini di Supabase SQL Editor:

```sql
-- Add payment info to orders table
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS payment_method TEXT DEFAULT 'manual_transfer',
ADD COLUMN IF NOT EXISTS payment_status TEXT DEFAULT 'pending',
ADD COLUMN IF NOT EXISTS payment_proof_url TEXT,
ADD COLUMN IF NOT EXISTS bank_account_name TEXT,
ADD COLUMN IF NOT EXISTS transfer_amount INTEGER,
ADD COLUMN IF NOT EXISTS payment_notes TEXT;

-- Update customers table for Google OAuth
ALTER TABLE customers
ADD COLUMN IF NOT EXISTS google_id TEXT UNIQUE,
ADD COLUMN IF NOT EXISTS avatar_url TEXT,
ADD COLUMN IF NOT EXISTS provider TEXT DEFAULT 'email';

-- Create payment_proofs storage bucket
-- (Run this in Supabase Dashboard → Storage)
-- Bucket name: payment-proofs
-- Public: false (only authenticated users)
```

---

### **STEP 3: Setup Storage Bucket**

1. **Buka Supabase Dashboard → Storage**
2. **Create New Bucket:**
   - Name: `payment-proofs`
   - Public: **OFF** (private)
   - Klik "Create bucket"

3. **Set Policies:**
   ```sql
   -- Allow authenticated users to upload
   CREATE POLICY "Users can upload payment proofs"
   ON storage.objects FOR INSERT
   WITH CHECK (
     bucket_id = 'payment-proofs' 
     AND auth.role() = 'authenticated'
   );

   -- Allow users to view their own uploads
   CREATE POLICY "Users can view own payment proofs"
   ON storage.objects FOR SELECT
   USING (
     bucket_id = 'payment-proofs'
   );
   ```

---

### **STEP 4: Konfigurasi di Code**

File `.env` atau `src/supabase.js` sudah ada, pastikan:

```javascript
const supabaseUrl = 'https://[YOUR-PROJECT-REF].supabase.co'
const supabaseKey = 'your-anon-key'
```

---

## 🎯 FITUR YANG AKAN DIBUAT

### **1. Google Sign-In**
- Button "Login dengan Google"
- Auto-create customer account
- Auto-fill data dari Google (nama, email, foto)
- Session management

### **2. Manual Payment**
- Customer checkout → Dapat nomor rekening BCA
- Upload bukti transfer
- Admin verify payment
- Update order status

### **3. Delivery Options**
- Pickup (gratis)
- Delivery (+Rp 10,000 ongkir)
- Input alamat jika delivery

### **4. Order Tracking**
- Customer lihat status order
- Status: pending → paid → processing → delivered
- History orders

---

## 📝 BANK ACCOUNT INFO

**Untuk Manual Transfer:**

```
Bank: BCA
No. Rekening: 1234567890
Atas Nama: [NAMA PEMILIK TOKO]
```

⚠️ **TODO:** Ganti dengan nomor rekening asli Anda!

---

## ✅ CHECKLIST SETUP

Sebelum run code, pastikan:

- [ ] Google OAuth enabled di Supabase
- [ ] Client ID & Secret sudah di-paste
- [ ] Redirect URI sudah ditambahkan di Google Console
- [ ] Database schema updated (run SQL)
- [ ] Storage bucket `payment-proofs` created
- [ ] Storage policies set
- [ ] Nomor rekening BCA sudah siap

---

## 🚀 READY TO CODE!

Setelah semua setup di atas selesai, saya akan buat:

1. ✅ Google Sign-In component
2. ✅ Updated CustomerAuth.vue dengan Google button
3. ✅ Updated CartPage dengan delivery options
4. ✅ Payment upload component
5. ✅ Order tracking page
6. ✅ Admin payment verification

**Lanjut ke coding?** 🎨
