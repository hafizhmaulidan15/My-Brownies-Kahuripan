<template>
  <div class="admin-wrapper">
    <!-- Sidebar -->
    <aside class="admin-sidebar">
      <div class="sidebar-header">
        <div class="brand-logo">🍫</div>
        <h2 class="brand-title">Admin Panel</h2>
        <p class="brand-subtitle">My Brownies Telaga Kahuripan</p>
      </div>
      
      <nav class="sidebar-nav">
        <router-link to="/admin" class="nav-link">
          <span class="nav-icon">📊</span>
          <span class="nav-text">Dashboard</span>
        </router-link>
        <router-link to="/admin/products" class="nav-link">
          <span class="nav-icon">📦</span>
          <span class="nav-text">Kelola Produk</span>
        </router-link>
        <router-link to="/admin/orders" class="nav-link">
          <span class="nav-icon">📝</span>
          <span class="nav-text">Pesanan Masuk</span>
        </router-link>
        
        <button @click="handleLogout" class="nav-link logout-link">
          <span class="nav-icon">🚪</span>
          <span class="nav-text">Logout</span>
        </button>
      </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
      <div class="page-header">
        <div>
          <h1 class="page-title">📊 Dashboard Overview</h1>
          <p class="page-subtitle">Ringkasan bisnis brownies Anda</p>
        </div>
      </div>

      <!-- Stats Grid -->
      <div class="stats-container">
        <div class="stat-card stat-revenue">
          <div class="stat-icon">💰</div>
          <div class="stat-content">
            <p class="stat-label">Total Pendapatan</p>
            <h3 class="stat-value">Rp {{ orderStore.totalRevenue.toLocaleString('id-ID') }}</h3>
          </div>
        </div>

        <div class="stat-card stat-orders">
          <div class="stat-icon">📦</div>
          <div class="stat-content">
            <p class="stat-label">Total Pesanan</p>
            <h3 class="stat-value">{{ orderStore.orders.length }}</h3>
            <p class="stat-detail">Pesanan masuk</p>
          </div>
        </div>

        <div class="stat-card stat-products">
          <div class="stat-icon">🍫</div>
          <div class="stat-content">
            <p class="stat-label">Total Produk</p>
            <h3 class="stat-value">{{ productStore.products.length }}</h3>
            <p class="stat-detail">Menu tersedia</p>
          </div>
        </div>

        <div class="stat-card stat-stock">
          <div class="stat-icon">📊</div>
          <div class="stat-content">
            <p class="stat-label">Total Stok</p>
            <h3 class="stat-value">{{ totalStock }}</h3>
            <p class="stat-detail">Unit brownies</p>
          </div>
        </div>
      </div>

      <!-- Recent Orders -->
      <div class="content-card">
        <h3 class="card-title">📝 Pesanan Terbaru</h3>
        
        <div v-if="recentOrders.length === 0" class="empty-state">
          <div class="empty-icon">📦</div>
          <p>Belum ada pesanan masuk</p>
        </div>

        <div v-else class="orders-list">
          <div 
            v-for="order in recentOrders" 
            :key="order.id" 
            class="order-row"
          >
            <div class="order-info">
              <span class="order-id">#{{ order.id }}</span>
              <span class="order-date">{{ formatDate(order.created_at) }}</span>
            </div>
            <div class="order-total">
              Rp {{ order.total.toLocaleString('id-ID') }}
            </div>
          </div>
        </div>

        <router-link to="/admin/orders" class="btn-view-all">
          Lihat Semua Pesanan →
        </router-link>
      </div>

      <!-- Low Stock Alert -->
      <div class="content-card alert-card" v-if="lowStockProducts.length > 0">
        <h3 class="card-title">⚠️ Peringatan Stok Menipis</h3>
        
        <div class="alert-list">
          <div 
            v-for="product in lowStockProducts" 
            :key="product.id" 
            class="alert-item"
          >
            <span class="product-name">{{ product.name }}</span>
            <span class="stock-badge">{{ product.stock }} unit tersisa</span>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../../stores/auth';
import { useOrderStore } from '../../stores/orders';
import { useProductStore } from '../../stores/products';

const router = useRouter();
const auth = useAuthStore();
const orderStore = useOrderStore();
const productStore = useProductStore();

const totalStock = computed(() => {
  return productStore.products.reduce((sum, p) => sum + p.stock, 0);
});

const recentOrders = computed(() => {
  return orderStore.orders.slice(0, 5);
});

const lowStockProducts = computed(() => {
  return productStore.products.filter(p => p.stock > 0 && p.stock < 5);
});

function handleLogout() {
  if (confirm('Yakin ingin logout?')) {
    auth.logout();
    router.push('/admin/login');
  }
}

function formatDate(dateString) {
  const date = new Date(dateString);
  return date.toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
}
</script>

<style scoped>
/* ========================================
   ADMIN WRAPPER
   ======================================== */
.admin-wrapper {
  display: flex;
  min-height: 100vh;
  background: #f5f5f5;
}

/* ========================================
   SIDEBAR
   ======================================== */
.admin-sidebar {
  width: 280px;
  background: linear-gradient(180deg, #6B3410 0%, #8B4513 100%);
  padding: 2rem 1.5rem;
  box-shadow: 4px 0 12px rgba(0, 0, 0, 0.1);
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  overflow-y: auto;
  z-index: 100;
}

.sidebar-header {
  text-align: center;
  margin-bottom: 2.5rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.brand-logo {
  font-size: 3.5rem;
  margin-bottom: 1rem;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
}

.brand-title {
  color: white;
  font-size: 1.5rem;
  font-weight: 700;
  margin: 0 0 0.5rem 0;
}

.brand-subtitle {
  color: rgba(255, 255, 255, 0.85);
  font-size: 0.9rem;
  margin: 0;
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.25rem;
  border-radius: 12px;
  color: rgba(255, 255, 255, 0.85);
  text-decoration: none;
  font-weight: 600;
  transition: all 0.25s;
  border: none;
  background: transparent;
  cursor: pointer;
  width: 100%;
  text-align: left;
  font-size: 1rem;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.15);
  color: white;
  transform: translateX(4px);
}

.nav-link.router-link-active {
  background: rgba(255, 255, 255, 0.25);
  color: white;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.nav-icon {
  font-size: 1.5rem;
  width: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-text {
  flex: 1;
}

.logout-link {
  margin-top: 2rem;
  border: 2px solid rgba(239, 68, 68, 0.5);
  color: #fca5a5;
}

.logout-link:hover {
  background: #ef4444;
  color: white;
  border-color: #ef4444;
  transform: translateX(0);
}

/* ========================================
   MAIN CONTENT
   ======================================== */
.admin-main {
  flex: 1;
  margin-left: 280px;
  padding: 2.5rem;
  min-height: 100vh;
}

.page-header {
  margin-bottom: 2.5rem;
}

.page-title {
  font-size: 2.25rem;
  color: #2D1810;
  margin: 0 0 0.5rem 0;
  font-weight: 800;
}

.page-subtitle {
  color: #6B4423;
  font-size: 1.05rem;
  margin: 0;
}

/* ========================================
   STATS CONTAINER
   ======================================== */
.stats-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2.5rem;
}

.stat-card {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: center;
  gap: 1.5rem;
  transition: all 0.25s;
  border-left: 4px solid transparent;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.stat-revenue { border-left-color: #10b981; }
.stat-orders { border-left-color: #3b82f6; }
.stat-products { border-left-color: #8B4513; }
.stat-stock { border-left-color: #f59e0b; }

.stat-icon {
  font-size: 3rem;
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(139, 69, 19, 0.05);
  border-radius: 12px;
  flex-shrink: 0;
}

.stat-content {
  flex: 1;
  min-width: 0;
}

.stat-label {
  font-size: 0.85rem;
  color: #6B4423;
  font-weight: 600;
  margin: 0 0 0.5rem 0;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stat-value {
  font-size: 2rem;
  font-weight: 800;
  color: #2D1810;
  margin: 0 0 0.25rem 0;
  line-height: 1;
}

.stat-detail {
  font-size: 0.85rem;
  color: #9C7A5C;
  margin: 0;
}

/* ========================================
   CONTENT CARD
   ======================================== */
.content-card {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  margin-bottom: 2rem;
}

.card-title {
  font-size: 1.5rem;
  color: #2D1810;
  margin: 0 0 1.5rem 0;
  font-weight: 700;
}

.orders-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.order-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.25rem 1.5rem;
  background: rgba(139, 69, 19, 0.03);
  border-radius: 12px;
  transition: all 0.25s;
}

.order-row:hover {
  background: rgba(139, 69, 19, 0.08);
  transform: translateX(4px);
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.order-id {
  font-weight: 700;
  color: #2D1810;
  font-size: 1.05rem;
}

.order-date {
  font-size: 0.85rem;
  color: #9C7A5C;
}

.order-total {
  font-weight: 800;
  color: #8B4513;
  font-size: 1.35rem;
}

.btn-view-all {
  display: block;
  width: 100%;
  padding: 1rem;
  text-align: center;
  background: rgba(139, 69, 19, 0.05);
  color: #8B4513;
  border-radius: 12px;
  font-weight: 700;
  text-decoration: none;
  transition: all 0.25s;
}

.btn-view-all:hover {
  background: #8B4513;
  color: white;
}

/* Alert Card */
.alert-card {
  border: 2px solid #f59e0b;
  background: linear-gradient(135deg, #fef3c7 0%, #fef9e7 100%);
}

.alert-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.alert-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.25rem;
  background: white;
  border-radius: 12px;
  border-left: 3px solid #f59e0b;
}

.product-name {
  font-weight: 600;
  color: #2D1810;
}

.stock-badge {
  background: #f59e0b;
  color: white;
  padding: 0.4rem 0.9rem;
  border-radius: 8px;
  font-size: 0.85rem;
  font-weight: 700;
}

.empty-state {
  text-align: center;
  padding: 3rem 2rem;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.empty-state p {
  color: #9C7A5C;
  font-style: italic;
}

/* ========================================
   RESPONSIVE
   ======================================== */
@media (max-width: 1024px) {
  .admin-sidebar {
    width: 240px;
  }
  
  .admin-main {
    margin-left: 240px;
    padding: 2rem;
  }
  
  .stats-container {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .admin-sidebar {
    width: 100%;
    position: relative;
    padding: 1.5rem;
  }
  
  .admin-main {
    margin-left: 0;
    padding: 1.5rem;
  }
  
  .stats-container {
    grid-template-columns: 1fr;
  }
  
  .stat-card {
    padding: 1.5rem;
  }
  
  .stat-icon {
    width: 60px;
    height: 60px;
    font-size: 2.5rem;
  }
  
  .stat-value {
    font-size: 1.75rem;
  }
}
</style>