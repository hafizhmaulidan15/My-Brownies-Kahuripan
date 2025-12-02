# 🔐 CUSTOMER AUTHENTICATION SYSTEM

## ✅ FITUR YANG DITAMBAHKAN

### 1. **Customer Registration & Login**
- Customer harus daftar/login sebelum checkout
- Data customer tersimpan di database
- Session management dengan localStorage

### 2. **Delivery Area Validation**
- Hanya melayani area **Telaga Kahuripan**
- Validasi alamat saat register
- Warning jika alamat di luar area

### 3. **Order Tracking**
- Setiap order terhubung dengan customer
- Customer bisa lihat history order mereka
- Admin bisa lihat data customer yang pesan

---

## 📁 FILES YANG DIBUAT

### 1. **customer-auth-schema.sql**
Database schema untuk:
- Table `customers` (customer accounts)
- Update table `orders` (tambah customer_id, delivery_address)
- RLS policies untuk keamanan
- Function validasi delivery area

### 2. **src/stores/customerAuth.js**
Pinia store untuk:
- `register()` - Daftar customer baru
- `login()` - Login customer
- `updateProfile()` - Update data customer
- `logout()` - Logout customer
- `isValidDeliveryArea()` - Validasi alamat Telaga Kahuripan

### 3. **src/views/CustomerAuth.vue**
Halaman login/register dengan:
- Toggle tabs (Login/Daftar)
- Form login (email + password)
- Form register (nama, email, phone, alamat, password)
- Validasi delivery area
- Password confirmation

---

## 🔄 FLOW CUSTOMER

### **New Customer:**
```
1. Browse products → Add to cart
2. Click "Checkout" → Redirect ke /auth
3. Pilih tab "Daftar"
4. Isi form:
   - Nama lengkap
   - Email
   - No. telepon
   - Alamat (HARUS Telaga Kahuripan)
   - Password
5. Submit → Auto login → Redirect ke checkout
6. Pilih delivery method → Place order
```

### **Existing Customer:**
```
1. Browse products → Add to cart
2. Click "Checkout" → Redirect ke /auth
3. Pilih tab "Login"
4. Input email + password
5. Submit → Redirect ke checkout
6. Pilih delivery method → Place order
```

---

## 🗄️ DATABASE SCHEMA

### **customers table:**
```sql
- id (UUID, primary key)
- name (TEXT)
- email (TEXT, unique)
- phone (TEXT)
- password_hash (TEXT)
- address (TEXT)
- created_at (TIMESTAMP)
```

### **orders table (updated):**
```sql
- ... existing columns ...
- customer_id (UUID, FK to customers)
- customer_name (TEXT)
- customer_phone (TEXT)
- delivery_address (TEXT)
- delivery_method (TEXT: 'pickup' or 'delivery')
- delivery_notes (TEXT)
```

---

## 🔒 SECURITY

### **Password:**
- Stored as Base64 hash (simple)
- **TODO:** Use bcrypt for production

### **RLS Policies:**
- Customers can only view their own data
- Customers can only view their own orders
- Admin can view all orders
- Anyone can register (public)

### **Session:**
- Stored in localStorage
- Auto-load on page refresh
- Clear on logout

---

## 📋 NEXT STEPS (TODO)

### **Yang Perlu Dilakukan:**

1. **Update Router** ✅
   - Add route `/auth` → CustomerAuth.vue
   - Add route `/profile` → Customer profile page
   - Add route `/my-orders` → Customer order history

2. **Update Navbar** ✅
   - Show "Login" jika belum login
   - Show "Profile" + "Logout" jika sudah login
   - Show customer name

3. **Update CartPage** ✅
   - Check if customer logged in
   - Redirect to /auth if not logged in
   - Show delivery options (pickup/delivery)
   - Validate delivery address
   - Include customer data in order

4. **Update OrdersStore** ✅
   - Include customer_id in createOrder
   - Include delivery_address
   - Include delivery_method

5. **Create Profile Page** ⏳
   - Show customer info
   - Edit profile
   - View order history

6. **Update Admin Dashboard** ⏳
   - Show customer info in orders
   - Filter by customer
   - Export customer data

---

## 🚀 DEPLOYMENT CHECKLIST

### **Database:**
- [ ] Run `customer-auth-schema.sql` di Supabase SQL Editor
- [ ] Verify tables created
- [ ] Test RLS policies

### **Frontend:**
- [ ] Update router dengan route baru
- [ ] Update navbar dengan auth state
- [ ] Update cart page dengan auth check
- [ ] Test register flow
- [ ] Test login flow
- [ ] Test checkout flow

### **Testing:**
- [ ] Register customer baru
- [ ] Login dengan customer
- [ ] Place order sebagai customer
- [ ] View order di admin panel
- [ ] Logout customer

---

## 📝 DELIVERY AREA VALIDATION

### **Valid Addresses:**
```
✅ "Jl. Mawar No. 10, Telaga Kahuripan, Bogor"
✅ "Perumahan Telaga Kahuripan Blok A1"
✅ "telaga kahuripan" (case insensitive)
```

### **Invalid Addresses:**
```
❌ "Jl. Sudirman, Jakarta"
❌ "Bogor Kota"
❌ "Cibinong"
```

### **Validation Logic:**
```javascript
function isValidDeliveryArea(address) {
  return address.toLowerCase().includes('telaga kahuripan');
}
```

---

## 🎯 BENEFITS

### **For Customer:**
- ✅ Tracked orders
- ✅ Order history
- ✅ Saved profile data
- ✅ Easy reorder

### **For Admin:**
- ✅ Customer database
- ✅ Contact information
- ✅ Delivery addresses
- ✅ Customer analytics

### **For Business:**
- ✅ Area-specific delivery
- ✅ Customer retention
- ✅ Marketing opportunities
- ✅ Better service

---

## 🔧 CONFIGURATION

### **Delivery Area:**
Current: `Telaga Kahuripan`

To change, update:
```javascript
// src/stores/customerAuth.js
function isValidDeliveryArea(address) {
  return address.toLowerCase().includes('your-area-here');
}
```

### **Password Security:**
Current: Base64 encoding (simple)

For production, use bcrypt:
```javascript
import bcrypt from 'bcryptjs';

// Hash
const hash = await bcrypt.hash(password, 10);

// Verify
const match = await bcrypt.compare(password, hash);
```

---

## 📞 SUPPORT

**Admin Contact:**
- Email: admin@brownies.com
- Phone: 08123456789

**Delivery Area:**
- Telaga Kahuripan, Bogor

**Operating Hours:**
- Mon-Sun: 08:00 - 20:00

---

**Status:** ✅ **READY TO IMPLEMENT**

**Next:** Update router, navbar, and cart page
