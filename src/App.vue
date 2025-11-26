<template>
  <nav class="card" style="margin: 1rem 2rem; border-radius: 99px; padding: 1rem 2rem; position: sticky; top: 1rem; z-index: 100;">
    <div class="flex-between">
      <router-link to="/" style="font-weight: bold; font-size: 1.5rem; color: var(--primary);">VueStore</router-link>
      <div style="display: flex; gap: 1.5rem; align-items: center;">
        <router-link to="/" style="font-weight: 500;">Home</router-link>
        <router-link to="/cart" class="btn btn-primary" style="position: relative; padding: 0.5rem 1rem; color: white;">
          Cart
          <span v-if="cart.count > 0" class="badge" style="position: absolute; top: -5px; right: -5px;">
            {{ cart.count }}
          </span>
        </router-link>
        <router-link to="/admin" style="font-size: 0.9rem; color: var(--text-light);">Admin</router-link>
      </div>
    </div>
  </nav>

  <router-view></router-view>

  <Toast /> 
</template>

<script setup>
import { useCartStore } from './stores/cart';
import Toast from './components/Toast.vue'; // Import komponen baru

const cart = useCartStore();
</script>