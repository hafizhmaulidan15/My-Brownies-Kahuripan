import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/auth';

// Views
import HomePage from '../views/HomePage.vue';
import CartPage from '../views/CartPage.vue';
import LoginPage from '../views/admin/LoginPage.vue';
import AdminDashboard from '../views/admin/AdminDashboard.vue';
import AdminProducts from '../views/admin/AdminProducts.vue'; // Baru
import AdminOrders from '../views/admin/AdminOrders.vue';     // Baru

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: HomePage },
    { path: '/cart', component: CartPage },
    { path: '/admin/login', component: LoginPage },
    // Admin Routes
    { path: '/admin', component: AdminDashboard, meta: { requiresAuth: true } },
    { path: '/admin/products', component: AdminProducts, meta: { requiresAuth: true } },
    { path: '/admin/orders', component: AdminOrders, meta: { requiresAuth: true } }
  ]
});

router.beforeEach((to, from, next) => {
  const auth = useAuthStore();
  if (to.meta.requiresAuth && !auth.user) next('/admin/login');
  else next();
});

export default router;