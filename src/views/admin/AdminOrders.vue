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
      </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
      <div class="page-header">
        <h1 class="page-title">📝 Pesanan Masuk</h1>
        <p class="page-subtitle">Kelola dan pantau semua pesanan pelanggan</p>
      </div>

      <!-- Stats Summary -->
      <div class="stats-container">
        <div class="stat-card">
          <div class="stat-icon">📦</div>
          <div class="stat-content">
            <p class="stat-label">Total Pesanan</p>
            <h3 class="stat-value">{{ orderStore.orders.length }}</h3>
          </div>
        </div>
        
        <div class="stat-card">
          <div class="stat-icon">💰</div>
          <div class="stat-content">
            <p class="stat-label">Total Pendapatan</p>
            <h3 class="stat-value">Rp {{ orderStore.totalRevenue.toLocaleString('id-ID') }}</h3>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-if="orderStore.orders.length === 0" class="content-card">
        <div class="empty-state">
          <div class="empty-icon">📦</div>
          <h3>Belum Ada Pesanan</h3>
          <p>Pesanan dari pelanggan akan muncul di sini</p>
        </div>
      </div>

      <!-- Orders List -->
      <div v-else class="orders-container">
        <div 
          v-for="order in orderStore.orders" 
          :key="order.id" 
          class="order-card"
        >
          <!-- Order Header -->
          <div class="order-header">
            <div class="order-meta">
              <h3 class="order-id">Pesanan #{{ order.id }}</h3>
              <span class="order-date">{{ formatDate(order.created_at) }}</span>
            </div>
            <div class="order-total-badge">
              Rp {{ order.total.toLocaleString('id-ID') }}
            </div>
          </div>

          <!-- Order Items -->
          <div class="order-items">
            <div 
              v-for="(item, index) in order.items" 
              :key="index" 
              class="order-item"
            >
              <div class="item-main">
                <span class="item-name">{{ item.name }}</span>
                <span class="item-quantity">x{{ item.quantity }}</span>
              </div>
              
              <!-- Toppings -->
              <div v-if="item.selectedToppings && item.selectedToppings.length > 0" class="item-toppings">
                <span class="topping-label">Topping:</span>
                <span class="topping-list">
                  {{ item.selectedToppings.map(t => t.name).join(', ') }}
                </span>
              </div>
              
              <div class="item-price">
                Rp {{ (item.totalPrice * item.quantity).toLocaleString('id-ID') }}
              </div>
            </div>
          </div>

          <!-- Order Footer -->
          <div class="order-footer">
            <div class="order-summary">
              <span class="summary-label">Subtotal:</span>
              <span class="summary-value">Rp {{ order.total.toLocaleString('id-ID') }}</span>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { useOrderStore } from '../../stores/orders';

const orderStore = useOrderStore();

function formatDate(dateString) {
  const date = new Date(dateString);
  return date.toLocaleDateString('id-ID', {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
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
}

.nav-text {
  flex: 1;
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
  border-left: 4px solid #8B4513;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

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
  margin: 0;
  line-height: 1;
}

/* ========================================
   CONTENT CARD
   ======================================== */
.content-card {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.empty-state {
  text-align: center;
  padding: 4rem 2rem;
}

.empty-icon {
  font-size: 5rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.empty-state h3 {
  color: #2D1810;
  margin-bottom: 0.5rem;
}

.empty-state p {
  color: #9C7A5C;
}

/* ========================================
   ORDERS CONTAINER
   ======================================== */
.orders-container {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.order-card {
  background: white;
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: all 0.25s;
  border: 2px solid transparent;
}

.order-card:hover {
  border-color: #8B4513;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

/* Order Header */
.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem 2rem;
  background: linear-gradient(135deg, rgba(139, 69, 19, 0.05) 0%, rgba(139, 69, 19, 0.02) 100%);
  border-bottom: 2px solid rgba(139, 69, 19, 0.1);
}

.order-meta {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.order-id {
  font-size: 1.35rem;
  color: #2D1810;
  font-weight: 800;
  margin: 0;
}

.order-date {
  font-size: 0.9rem;
  color: #9C7A5C;
  font-weight: 500;
}

.order-total-badge {
  background: linear-gradient(135deg, #8B4513 0%, #6B3410 100%);
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 999px;
  font-weight: 800;
  font-size: 1.25rem;
  box-shadow: 0 2px 8px rgba(139, 69, 19, 0.3);
}

/* Order Items */
.order-items {
  padding: 1.5rem 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.order-item {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 1rem;
  padding: 1rem;
  background: rgba(139, 69, 19, 0.03);
  border-radius: 12px;
  transition: all 0.25s;
}

.order-item:hover {
  background: rgba(139, 69, 19, 0.08);
}

.item-main {
  display: flex;
  align-items: center;
  gap: 1rem;
  grid-column: 1 / -1;
}

.item-name {
  font-weight: 700;
  color: #2D1810;
  font-size: 1.05rem;
  flex: 1;
}

.item-quantity {
  background: #8B4513;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 8px;
  font-weight: 700;
  font-size: 0.9rem;
}

.item-toppings {
  grid-column: 1 / -1;
  display: flex;
  gap: 0.5rem;
  align-items: center;
  padding-left: 1rem;
  border-left: 3px solid #8B4513;
}

.topping-label {
  font-size: 0.85rem;
  font-weight: 600;
  color: #9C7A5C;
}

.topping-list {
  font-size: 0.9rem;
  color: #8B4513;
  font-weight: 600;
}

.item-price {
  grid-column: 1 / -1;
  text-align: right;
  font-weight: 800;
  color: #8B4513;
  font-size: 1.15rem;
}

/* Order Footer */
.order-footer {
  padding: 1.5rem 2rem;
  background: rgba(139, 69, 19, 0.03);
  border-top: 2px solid rgba(139, 69, 19, 0.1);
}

.order-summary {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.summary-label {
  font-size: 1.1rem;
  font-weight: 700;
  color: #2D1810;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.summary-value {
  font-size: 1.75rem;
  font-weight: 800;
  color: #8B4513;
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
    grid-template-columns: 1fr;
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
  
  .order-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }
  
  .order-total-badge {
    align-self: flex-end;
  }
  
  .item-main {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>