import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import { useCustomerAuthStore } from '../stores/customerAuth';

// Views
import HomePage from '../views/HomePage.vue';
import CartPage from '../views/CartPage.vue';
import CustomerAuth from '../views/CustomerAuth.vue';
import CheckoutPage from '../views/CheckoutPage.vue';
import LoginPage from '../views/admin/LoginPage.vue';
import AdminDashboard from '../views/admin/AdminDashboard.vue';
import AdminProducts from '../views/admin/AdminProducts.vue';
import AdminOrders from '../views/admin/AdminOrders.vue';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    // Customer Routes
    { path: '/', component: HomePage },
    { path: '/cart', component: CartPage },
    { path: '/checkout', component: CheckoutPage },
    { path: '/auth', component: CustomerAuth },

    // Admin Routes
    { path: '/admin/login', component: LoginPage },
    { path: '/admin', component: AdminDashboard, meta: { requiresAuth: true } },
    { path: '/admin/products', component: AdminProducts, meta: { requiresAuth: true } },
    { path: '/admin/orders', component: AdminOrders, meta: { requiresAuth: true } }
  ]
});

// Admin auth guard
router.beforeEach((to, from, next) => {
  const auth = useAuthStore();
  if (to.meta.requiresAuth && !auth.user) {
    next('/admin/login');
  } else {
    next();
  }
});

export default router;