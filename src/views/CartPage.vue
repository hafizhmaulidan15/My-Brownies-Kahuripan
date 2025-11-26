<template>
  <div class="container">
    <h2 style="margin-bottom: 2rem;">Keranjang Brownies</h2>
    
    <div v-if="!cart.items || cart.items.length === 0" class="card" style="text-align: center; padding: 3rem;">
      <p style="margin-bottom: 1rem;">Belum ada brownies di sini.</p>
      <router-link to="/" class="btn btn-primary">Pesan Sekarang</router-link>
    </div>
    
    <div v-else style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem;">
      <div class="card">
        <div v-for="item in cart.items" :key="item.cartId" class="flex-between" style="border-bottom: 1px solid #eee; padding: 1.5rem 0; align-items: flex-start;">
          
          <div>
            <h3 style="font-size: 1.1rem; color: #3e2723;">{{ item.name }}</h3>
            
            <div v-if="item.selectedToppings?.length > 0" style="margin: 0.5rem 0;">
              <span v-for="t in item.selectedToppings" :key="t.name" style="display: inline-block; background: #fff3e0; color: #e65100; font-size: 0.8rem; padding: 2px 8px; border-radius: 4px; margin-right: 5px; margin-bottom: 2px;">
                + {{ t.name }}
              </span>
            </div>
            <div v-else style="font-size: 0.8rem; color: #aaa; margin: 0.5rem 0;">Original (Tanpa Topping)</div>

            <p style="color: var(--primary); font-weight: bold;">Rp {{ (item.totalPrice || item.price).toLocaleString() }}</p>
          </div>

          <button @click="cart.removeFromCart(item.cartId)" class="btn btn-danger" style="padding: 0.4rem 0.8rem; font-size: 0.9rem;">
            Hapus
          </button>
        </div>
      </div>

      <div class="card" style="height: fit-content;">
        <h3>Total Pesanan</h3>
        <div class="flex-between" style="margin: 1rem 0; padding: 1rem 0; border-top: 2px dashed #eee; border-bottom: 2px dashed #eee;">
          <span style="font-size: 1.2rem;">Total Bayar</span>
          <span style="font-size: 1.5rem; font-weight: bold; color: var(--primary);">Rp {{ cart.total.toLocaleString() }}</span>
        </div>
        <button class="btn btn-primary" style="width: 100%;" @click="handleCheckout">
          Checkout Sekarang
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useCartStore } from '../stores/cart';
import { useOrderStore } from '../stores/orders';
import { useNotificationStore } from '../stores/notification';
import { useRouter } from 'vue-router';
import { useProductStore } from '../stores/products'; // <--- JANGAN LUPA INI

const cart = useCartStore();
const orderStore = useOrderStore();
const productStore = useProductStore(); // <--- DAN INI
const notify = useNotificationStore();
const router = useRouter();

function handleCheckout() {
  if(cart.items.length === 0) return;
  
  // 1. KURANGI STOK REAL-TIME
  // Kita loop setiap barang di keranjang, terus potong stoknya di productStore
  cart.items.forEach(item => {
    productStore.decreaseStock(item.id, item.quantity);
  });
  
  // 2. Buat Order (sama kayak sebelumnya)
  const customer = { name: 'Guest User', phone: '08123456789' };
  orderStore.createOrder(customer, cart.items, cart.total);
  
  // 3. Bersihkan Keranjang
  cart.clearCart();
  
  notify.showToast('Order berhasil! Stok produk otomatis berkurang.', 'success');
  router.push('/');
}
</script>