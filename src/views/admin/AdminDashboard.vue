<template>
  <div class="admin-layout">
    <aside class="sidebar">
      <h2 style="color: white; margin-bottom: 2rem;">Admin Panel</h2>
      <nav>
        <router-link to="/admin" class="nav-item">📊 Dashboard</router-link>
        <router-link to="/admin/products" class="nav-item">📦 Kelola Menu</router-link>
        <router-link to="/admin/orders" class="nav-item">📝 Order Masuk</router-link>
        <button @click="auth.logout()" class="nav-item logout">🚪 Logout</button>
      </nav>
    </aside>

    <main class="content">
      <h1>Dashboard Overview</h1>
      
      <div class="stats-grid">
        <div class="card stat-card">
          <h3>Total Revenue</h3>
          <p class="value">Rp {{ orderStore.totalRevenue.toLocaleString() }}</p>
        </div>
        <div class="card stat-card">
          <h3>Total Orders</h3>
          <p class="value">{{ orderStore.orders.length }}</p>
        </div>
        <div class="card stat-card">
          <h3>Total Menu</h3>
          <p class="value">{{ productStore.products.length }} Items</p>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { useAuthStore } from '../../stores/auth';
import { useOrderStore } from '../../stores/orders';
import { useProductStore } from '../../stores/products';

const auth = useAuthStore();
const orderStore = useOrderStore();
const productStore = useProductStore();
</script>

<style>
/* CSS Admin Global */
.admin-layout { display: grid; grid-template-columns: 250px 1fr; min-height: 100vh; }
.sidebar { background: #1e1b4b; padding: 2rem; color: white; }
.content { padding: 2rem; background: #f3f4f6; }
.nav-item { display: block; padding: 1rem; color: #cbd5e1; margin-bottom: 0.5rem; border-radius: 8px; transition: 0.3s; text-decoration: none; }
.nav-item:hover, .router-link-active { background: #4f46e5; color: white; }
.logout { background: transparent; border: 1px solid #ef4444; width: 100%; text-align: left; cursor: pointer; color: #ef4444; margin-top: 2rem; }
.logout:hover { background: #ef4444; color: white; }
.stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; margin-top: 2rem; }
.stat-card .value { font-size: 2rem; font-weight: bold; color: #4f46e5; margin-top: 0.5rem; }
</style>