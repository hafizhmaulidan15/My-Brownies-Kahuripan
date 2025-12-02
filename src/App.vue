<template>
  <div class="app-wrapper">
    <!-- Navigation Bar - Customer Only -->
    <nav class="navbar" v-if="!isAdminRoute">
      <div class="container">
        <div class="navbar-content">
          <router-link to="/" class="brand">
            <span class="brand-icon">🍫</span>
            <span class="brand-name">My Brownies Telaga Kahuripan</span>
          </router-link>
          
          <div class="nav-links">
            <router-link to="/" class="nav-link">
              <span class="nav-icon">🏠</span>
              <span>Home</span>
            </router-link>
            
            <router-link to="/cart" class="nav-link cart-link">
              <span class="nav-icon">🛒</span>
              <span>Cart</span>
              <span v-if="cart.count > 0" class="cart-badge">{{ cart.count }}</span>
            </router-link>

            <!-- Customer Auth -->
            <router-link v-if="!customerAuth.customer" to="/auth" class="nav-link auth-link">
              <span class="nav-icon">👤</span>
              <span>Login</span>
            </router-link>

            <div v-else class="customer-menu">
              <span class="customer-name">{{ customerAuth.customer.name }}</span>
              <button @click="handleLogout" class="btn-logout">
                <span>Logout</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content" :class="{ 'no-nav': isAdminRoute }">
      <router-view></router-view>
    </main>

    <!-- Toast Notifications -->
    <Toast />
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useCartStore } from './stores/cart';
import { useCustomerAuthStore } from './stores/customerAuth';
import Toast from './components/Toast.vue';

const cart = useCartStore();
const customerAuth = useCustomerAuthStore();
const route = useRoute();
const router = useRouter();

const isAdminRoute = computed(() => route.path.startsWith('/admin'));

function handleLogout() {
  customerAuth.logout();
  router.push('/');
}
</script>

<style scoped>
.app-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #FFF8F0;
}

/* ========================================
   NAVBAR STYLES
   ======================================== */
.navbar {
  background: linear-gradient(135deg, #8B4513 0%, #A0522D 100%);
  box-shadow: 0 4px 20px rgba(139, 69, 19, 0.2);
  position: sticky;
  top: 0;
  z-index: 100;
  backdrop-filter: blur(10px);
}

.navbar-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.25rem 0;
}

/* Brand */
.brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-family: var(--font-display);
  font-weight: 800;
  font-size: 1.35rem;
  color: white;
  text-decoration: none;
  transition: all 0.3s;
  padding: 0.5rem 1rem;
  border-radius: 12px;
}

.brand:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateY(-2px);
}

.brand-icon {
  font-size: 2rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
}

.brand-name {
  color: white;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  letter-spacing: -0.5px;
}

/* Navigation Links */
.nav-links {
  display: flex;
  gap: 0.75rem;
  align-items: center;
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.25rem;
  border-radius: 12px;
  font-weight: 600;
  color: white;
  text-decoration: none;
  transition: all 0.3s;
  position: relative;
  background: rgba(255, 255, 255, 0.1);
  border: 2px solid transparent;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.nav-link.router-link-active {
  background: rgba(255, 255, 255, 0.25);
  border-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.nav-icon {
  font-size: 1.25rem;
}

/* Cart Badge */
.cart-link {
  position: relative;
}

.cart-badge {
  position: absolute;
  top: -6px;
  right: -6px;
  background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
  color: #2D1810;
  font-size: 0.7rem;
  font-weight: 800;
  padding: 0.25rem 0.5rem;
  border-radius: 50px;
  min-width: 1.35rem;
  height: 1.35rem;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(255, 215, 0, 0.5);
  animation: pulse 2s infinite;
  border: 2px solid #8B4513;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

/* Customer Menu */
.customer-menu {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem 1.25rem;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 12px;
  border: 2px solid rgba(255, 255, 255, 0.2);
}

.customer-name {
  color: white;
  font-weight: 700;
  font-size: 0.95rem;
}

.btn-logout {
  padding: 0.5rem 1rem;
  background: rgba(220, 38, 38, 0.9);
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.85rem;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-logout:hover {
  background: #dc2626;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.4);
}


/* Main Content */
.main-content {
  flex: 1;
}

.main-content.no-nav {
  padding-top: 0;
}

/* ========================================
   RESPONSIVE
   ======================================== */
@media (max-width: 768px) {
  .brand-name {
    font-size: 1rem;
  }
  
  .nav-link span:not(.nav-icon):not(.cart-badge) {
    display: none;
  }
  
  .nav-link {
    padding: 0.75rem;
  }
  
  .brand-icon {
    font-size: 1.5rem;
  }
}

@media (max-width: 480px) {
  .navbar-content {
    padding: 1rem 0;
  }
  
  .brand {
    font-size: 1.1rem;
    padding: 0.5rem 0.75rem;
  }
  
  .brand-name {
    max-width: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}
</style>