<template>
  <div class="container">
    <div style="text-align: center; margin-bottom: 3rem;">
      <h1 style="font-size: 3rem; margin-bottom: 0.5rem; color: #3e2723;">Brownies Sultan</h1>
      <p style="color: var(--text-light); margin-bottom: 2rem;">Cek stok sebelum kehabisan!</p>
      
      <div style="max-width: 500px; margin: 0 auto; position: relative;">
        <input 
          v-model="searchQuery" 
          placeholder="🔍 Cari rasa favoritmu..." 
          style="width: 100%; padding: 1rem 1.5rem; border-radius: 99px; border: 1px solid #ddd; box-shadow: 0 4px 12px rgba(0,0,0,0.05); font-size: 1rem; transition: 0.3s;"
        >
      </div>

      <div style="margin-top: 1.5rem; display: flex; gap: 0.5rem; justify-content: center; flex-wrap: wrap;">
        <button 
          v-for="cat in uniqueCategories" 
          :key="cat"
          @click="selectedCategory = cat"
          :class="['filter-btn', selectedCategory === cat ? 'active' : '']"
        >
          {{ cat }}
        </button>
      </div>
    </div>

    <div v-if="filteredProducts.length === 0" style="text-align: center; padding: 4rem; opacity: 0.6;">
      <div style="font-size: 3rem;">🍂</div>
      <h3>Yah, Brownies yang dicari gak ketemu...</h3>
      <p>Coba kata kunci lain atau cek kategori "All"</p>
    </div>

    <div v-else class="grid">
      <div v-for="product in filteredProducts" :key="product.id" class="card" style="display: flex; flex-direction: column; position: relative;">
        
        <div v-if="product.stock === 0" class="sold-overlay">
          <span class="sold-badge">SOLD OUT</span>
        </div>

        <img :src="product.image" :class="{ 'grayscale': product.stock === 0 }" style="width: 100%; border-radius: 0.5rem; margin-bottom: 1rem; transition: 0.3s;">
        
        <h3 style="color: #3e2723;">{{ product.name }}</h3>
        
        <div style="margin: 0.5rem 0; font-size: 0.9rem;">
            <span class="category-pill">{{ product.category }}</span>
            <span style="margin: 0 5px;">•</span>
            
            <span v-if="product.stock === 0" style="color: #ef4444; font-weight: bold;">Stok Habis</span>
            <span v-else-if="product.stock < 5" style="color: #d97706; font-weight: bold; animation: pulse 1.5s infinite;">Sisa {{ product.stock }} aja! 🔥</span>
            <span v-else style="color: #16a34a; font-weight: bold;">Stok: {{ product.stock }}</span>
        </div>
        
        <div style="margin-top: auto; padding-top: 1rem;">
          <div class="flex-between">
            <span style="font-weight: bold; font-size: 1.1rem; color: var(--primary);">Rp {{ product.price.toLocaleString() }}</span>
            
            <button 
              @click="openModal(product)" 
              class="btn"
              :disabled="product.stock === 0"
              :class="product.stock === 0 ? 'btn-disabled' : 'btn-primary'"
            >
              {{ product.stock === 0 ? 'Habis' : 'Beli +' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <div v-if="showModal" class="modal-backdrop">
      <div class="card modal-card">
        <h2 style="margin-bottom: 1rem;">Customize: {{ selectedProduct.name }}</h2>
        <p style="margin-bottom: 1rem;">Pilih Tambahan Topping:</p>
        
        <div style="display: grid; gap: 0.5rem; margin-bottom: 2rem;">
          <label v-for="topping in store.toppings" :key="topping.id" class="topping-option">
            <div style="display: flex; gap: 0.5rem;">
              <input type="checkbox" :value="topping" v-model="selectedToppings" style="width: auto; margin: 0;">
              <span>{{ topping.name }}</span>
            </div>
            <span style="color: var(--primary);">+Rp {{ topping.price.toLocaleString() }}</span>
          </label>
        </div>

        <div class="flex-between">
          <div>
            <p>Total Harga:</p>
            <p style="font-size: 1.5rem; font-weight: bold;">Rp {{ calculateTotal().toLocaleString() }}</p>
          </div>
          <div style="display: flex; gap: 1rem;">
            <button @click="closeModal" class="btn" style="background: #e5e7eb;">Batal</button>
            <button @click="confirmAddToCart" class="btn btn-primary">Masuk Keranjang</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'; // Tambah computed
import { useProductStore } from '../stores/products';
import { useCartStore } from '../stores/cart';
import { useNotificationStore } from '../stores/notification';

const store = useProductStore();
const cart = useCartStore();
const notify = useNotificationStore();

// --- LOGIC SEARCH & FILTER ---
const searchQuery = ref('');
const selectedCategory = ref('All');

// 1. Ambil Kategori Unik secara Otomatis dari data Produk
const uniqueCategories = computed(() => {
  const cats = new Set(store.products.map(p => p.category));
  return ['All', ...cats]; // Tambah 'All' di depan
});

// 2. Filter Produk Real-time
const filteredProducts = computed(() => {
  return store.products.filter(product => {
    // Filter by Nama (Case insensitive)
    const matchName = product.name.toLowerCase().includes(searchQuery.value.toLowerCase());
    
    // Filter by Kategori
    const matchCat = selectedCategory.value === 'All' || product.category === selectedCategory.value;

    return matchName && matchCat;
  });
});

// --- LOGIC MODAL & CART (Tetap Sama) ---
const showModal = ref(false);
const selectedProduct = ref(null);
const selectedToppings = ref([]);

function openModal(product) {
  if (product.stock <= 0) return;
  selectedProduct.value = product;
  selectedToppings.value = [];
  showModal.value = true;
}

function closeModal() { showModal.value = false; selectedProduct.value = null; }

function calculateTotal() {
  if (!selectedProduct.value) return 0;
  return selectedProduct.value.price + selectedToppings.value.reduce((sum, t) => sum + t.price, 0);
}

function confirmAddToCart() {
  cart.addToCart(selectedProduct.value, selectedToppings.value);
  closeModal();
  notify.showToast('Berhasil masuk keranjang! 🍫', 'success');
}
</script>

<style scoped>
/* STYLE KHUSUS HALAMAN INI */
.filter-btn {
  padding: 0.5rem 1.2rem;
  border-radius: 99px;
  border: 1px solid #ddd;
  background: white;
  cursor: pointer;
  transition: all 0.2s;
  color: var(--text-light);
}
.filter-btn:hover { border-color: var(--primary); color: var(--primary); }
.filter-btn.active { background: var(--primary); color: white; border-color: var(--primary); box-shadow: 0 4px 10px rgba(79, 70, 229, 0.3); }

.category-pill { background: #f3f4f6; padding: 2px 8px; border-radius: 4px; font-size: 0.8rem; color: var(--text-main); }
.sold-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.6); z-index: 10; display: flex; align-items: center; justify-content: center; pointer-events: none; }
.sold-badge { background: #ef4444; color: white; padding: 0.5rem 2rem; font-weight: bold; transform: rotate(-10deg); font-size: 1.5rem; border: 2px solid white; box-shadow: 0 4px 10px rgba(0,0,0,0.2); }
.grayscale { filter: grayscale(100%); }
.btn-disabled { background: #d1d5db; color: #6b7280; cursor: not-allowed; }
.modal-backdrop { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-card { width: 90%; max-width: 500px; background: white; animation: slideUp 0.3s ease; }
.topping-option { display: flex; justify-content: space-between; padding: 0.8rem; border: 1px solid #ddd; border-radius: 0.5rem; cursor: pointer; }

@keyframes slideUp { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
@keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.5; } 100% { opacity: 1; } }
</style>