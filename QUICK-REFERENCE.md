# 🚀 Quick Reference - My Brownies Telaga Kahuripan

## 📍 URL Access

### Customer Pages (Public)
```
Homepage:  http://localhost:5173/
Cart:      http://localhost:5173/cart
```

### Admin Pages (Hidden - Direct URL Only)
```
Login:     http://localhost:5173/admin/login
Dashboard: http://localhost:5173/admin
Products:  http://localhost:5173/admin/products
Orders:    http://localhost:5173/admin/orders
```

---

## 🎨 Design System Quick Reference

### Colors
```css
--primary: #8B4513        /* Main brown */
--primary-dark: #6B3410   /* Dark brown */
--secondary: #D2691E      /* Chocolate */
--accent: #FFD700         /* Gold */
--bg-main: #FFF8F0        /* Warm cream */
--bg-card: #FFFFFF        /* White */
```

### Fonts
```css
--font-primary: 'Poppins'           /* Body text */
--font-display: 'Playfair Display'  /* Headings */
```

### Spacing
```css
--space-xs: 0.5rem   /* 8px */
--space-sm: 1rem     /* 16px */
--space-md: 1.5rem   /* 24px */
--space-lg: 2rem     /* 32px */
--space-xl: 3rem     /* 48px */
```

### Border Radius
```css
--radius-sm: 8px
--radius-md: 12px
--radius-lg: 16px
--radius-xl: 24px
--radius-full: 9999px
```

---

## 🔧 Common Tasks

### Start Development Server
```bash
npm run dev
```

### Build for Production
```bash
npm run build
```

### Setup Database (First Time Only)
1. Login to Supabase
2. Open SQL Editor
3. Run `database-setup.sql`
4. Run `sample-data.sql` (optional)

---

## 📦 Features Checklist

### Customer Features
- [x] Browse products with search & filter
- [x] View product details
- [x] Add to cart with toppings
- [x] Checkout & place order
- [x] Real-time stock updates

### Admin Features
- [x] Dashboard with stats
- [x] Add new products
- [x] Edit products
- [x] Delete products
- [x] Manage toppings
- [x] View all orders
- [x] Track revenue

---

## 🐛 Troubleshooting

### Topping not saving?
- Make sure `toppings` table exists in Supabase
- Run `database-setup.sql` if needed

### Products not showing?
- Check Supabase connection in `src/supabase.js`
- Make sure `products` table has data

### Can't login to admin?
- Create user in Supabase Authentication
- Use correct email/password

### Styles not loading?
- Clear browser cache
- Restart dev server
- Check `src/style.css` is imported

---

## 📝 File Structure

```
src/
├── App.vue                    # Main app with navbar
├── style.css                  # Global styles & design system
├── main.js                    # App entry point
├── supabase.js               # Database config
├── components/
│   └── Toast.vue             # Notification component
├── stores/
│   ├── auth.js               # Authentication
│   ├── cart.js               # Shopping cart
│   ├── orders.js             # Orders management
│   ├── products.js           # Products & toppings
│   └── notification.js       # Toast notifications
├── views/
│   ├── HomePage.vue          # Customer homepage
│   ├── CartPage.vue          # Shopping cart page
│   └── admin/
│       ├── LoginPage.vue     # Admin login
│       ├── AdminDashboard.vue # Admin dashboard
│       ├── AdminProducts.vue  # Product management
│       └── AdminOrders.vue    # Order management
└── router/
    └── index.js              # Route configuration
```

---

## 🎯 Key Changes Made

1. **Removed admin link** from customer navbar
2. **Fixed topping bug** - now saves correctly
3. **Complete UI redesign** - modern & professional
4. **Brand name changed** to "My Brownies Telaga Kahuripan"

---

## 💡 Tips

### For Best Experience:
- Use Chrome/Firefox for development
- Enable Vue DevTools extension
- Keep console open to catch errors
- Test on mobile view regularly

### For Production:
- Update Supabase RLS policies
- Add environment variables
- Enable HTTPS
- Add meta tags for SEO
- Optimize images
- Add loading states

---

## 📞 Quick Commands

```bash
# Install dependencies
npm install

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

---

## ✅ What's Working

- ✅ Product browsing with search & filter
- ✅ Shopping cart with toppings
- ✅ Checkout process
- ✅ Stock management
- ✅ Admin CRUD operations
- ✅ Order tracking
- ✅ Authentication
- ✅ Responsive design
- ✅ Smooth animations
- ✅ Database integration

---

**Server Status:** ✅ Running at http://localhost:5173

**Last Updated:** 2025-12-03

**Ready to use!** 🎉
