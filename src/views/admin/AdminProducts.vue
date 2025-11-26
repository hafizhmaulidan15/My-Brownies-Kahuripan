<template>
  <div class="admin-layout">
    <aside class="sidebar">
      <h2 style="color: white; margin-bottom: 2rem;">Admin Panel</h2>
      <nav>
        <router-link to="/admin" class="nav-item">📊 Dashboard</router-link>
        <router-link to="/admin/products" class="nav-item">📦 Kelola Menu</router-link>
        <router-link to="/admin/orders" class="nav-item">📝 Order Masuk</router-link>
      </nav>
    </aside>

    <main class="content">
      <h1>Kelola Produk & Stok</h1>

      <div class="card" style="margin-bottom: 2rem; margin-top: 1rem;">
        <h3>Tambah Menu Baru</h3>
        <form @submit.prevent="handleSubmit" style="display: grid; gap: 1rem; grid-template-columns: 2fr 1.5fr 1fr 1fr auto; align-items: end;">
          
          <div>
            <label style="font-size: 0.8rem;">Nama Produk</label>
            <input v-model="newProduct.name" placeholder="Contoh: Brownies Keju" required style="margin:0;">
          </div>
          
          <div>
            <label style="font-size: 0.8rem;">Kategori</label>
            <input v-model="newProduct.category" placeholder="Best Seller" required style="margin:0;">
          </div>

          <div>
            <label style="font-size: 0.8rem;">Harga (Rp)</label>
            <input v-model.number="newProduct.price" type="number" placeholder="50000" required style="margin:0;">
          </div>

          <div>
            <label style="font-size: 0.8rem;">Stok Awal</label>
            <input v-model.number="newProduct.stock" type="number" placeholder="20" required style="margin:0;">
          </div>

          <button type="submit" class="btn btn-primary">Simpan</button>
        </form>
      </div>

      <div class="card">
        <table style="width: 100%; border-collapse: collapse;">
          <thead>
            <tr style="text-align: left; border-bottom: 2px solid #eee;">
              <th style="padding: 1rem;">Produk</th>
              <th>Kategori</th>
              <th>Harga</th>
              <th>Stok</th> <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="p in store.products" :key="p.id" style="border-bottom: 1px solid #eee;">
              <td style="padding: 1rem; font-weight: bold;">{{ p.name }}</td>
              <td>{{ p.category }}</td>
              <td>Rp {{ p.price.toLocaleString() }}</td>
              
              <td>
                <span v-if="p.stock === 0" style="color: red; font-weight: bold; background: #fee2e2; padding: 2px 8px; border-radius: 4px;">HABIS</span>
                <span v-else-if="p.stock < 5" style="color: #d97706; font-weight: bold;">{{ p.stock }} (Menipis!)</span>
                <span v-else style="color: #16a34a; font-weight: bold;">{{ p.stock }} Unit</span>
              </td>

              <td>
                <button @click="store.deleteProduct(p.id)" class="btn btn-danger" style="padding: 0.3rem 0.8rem; font-size: 0.8rem;">Hapus</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="card" style="margin-top: 2rem;">
        <div class="flex-between">
          <h3>Daftar Topping</h3>
          <div style="display: flex; gap: 1rem;">
            <input v-model="newToppingName" placeholder="Nama Topping" style="margin: 0; width: 150px;">
            <input v-model.number="newToppingPrice" placeholder="Harga" style="margin: 0; width: 100px;">
            <button @click="handleAddTopping" class="btn btn-primary">Tambah</button>
          </div>
        </div>
        <div style="margin-top: 1rem; display: flex; flex-wrap: wrap; gap: 1rem;">
          <div v-for="t in store.toppings" :key="t.id" style="background: #fff; border: 1px solid #ddd; padding: 0.5rem 1rem; border-radius: 99px; display: flex; align-items: center; gap: 1rem;">
            <span>{{ t.name }} (Rp {{ t.price }})</span>
            <span @click="store.deleteTopping(t.id)" style="cursor: pointer; color: red; font-weight: bold;">×</span>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useProductStore } from '../../stores/products';
const store = useProductStore();

const newProduct = ref({ name: '', price: '', category: '', stock: '', image: 'https://placehold.co/400x400' });
const newToppingName = ref('');
const newToppingPrice = ref('');

function handleSubmit() {
  store.addProduct(newProduct.value);
  newProduct.value = { name: '', price: '', category: '', stock: '', image: 'https://placehold.co/400x400' };
}

function handleAddTopping() {
  if(!newToppingName.value) return;
  store.addTopping({ name: newToppingName.value, price: newToppingPrice.value || 0 });
  newToppingName.value = '';
  newToppingPrice.value = '';
}
</script>