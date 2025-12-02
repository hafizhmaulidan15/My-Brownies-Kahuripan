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
        <h1 class="page-title">📦 Kelola Produk & Stok</h1>
        <p class="page-subtitle">Tambah, edit, dan kelola produk brownies Anda</p>
      </div>

      <!-- FORM TAMBAH PRODUK -->
      <div class="content-card">
        <h3 class="card-title">➕ Tambah Produk Baru</h3>
        <form @submit.prevent="handleSubmit" class="product-form">
          <div class="form-group">
            <label>Nama Produk</label>
            <input 
              v-model="newProduct.name" 
              placeholder="Contoh: Brownies Keju Premium" 
              required
            >
          </div>
          
          <div class="form-group">
            <label>Kategori</label>
            <input 
              v-model="newProduct.category" 
              placeholder="Best Seller, Premium, dll" 
              required
            >
          </div>

          <div class="form-group">
            <label>Harga (Rp)</label>
            <input 
              v-model.number="newProduct.price" 
              type="number" 
              placeholder="75000" 
              required
              min="0"
            >
          </div>

          <div class="form-group">
            <label>Stok Awal</label>
            <input 
              v-model.number="newProduct.stock" 
              type="number" 
              placeholder="20" 
              required
              min="0"
            >
          </div>

          <div class="form-group full-width">
            <label>URL Gambar</label>
            <input 
              v-model="newProduct.image" 
              type="url" 
              placeholder="https://example.com/image.jpg"
            >
            <small class="form-hint">Kosongkan untuk menggunakan gambar default</small>
          </div>

          <button type="submit" class="btn-submit full-width">
            <span class="btn-icon">💾</span>
            Simpan Produk
          </button>
        </form>
      </div>

      <!-- TABEL PRODUK -->
      <div class="content-card">
        <h3 class="card-title">📋 Daftar Produk</h3>
        
        <div class="table-wrapper">
          <table class="products-table">
            <thead>
              <tr>
                <th>Gambar</th>
                <th>Nama Produk</th>
                <th>Kategori</th>
                <th>Harga</th>
                <th>Stok</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="p in store.products" :key="p.id">
                <td>
                  <img :src="p.image" :alt="p.name" class="product-thumbnail">
                </td>
                <td class="product-name">{{ p.name }}</td>
                <td>
                  <span class="category-badge">{{ p.category }}</span>
                </td>
                <td class="price-cell">Rp {{ p.price.toLocaleString('id-ID') }}</td>
                <td>
                  <span v-if="p.stock === 0" class="stock-badge out-of-stock">HABIS</span>
                  <span v-else-if="p.stock < 5" class="stock-badge low-stock">{{ p.stock }} (Menipis!)</span>
                  <span v-else class="stock-badge in-stock">{{ p.stock }} Unit</span>
                </td>
                <td>
                  <div class="action-buttons">
                    <button @click="openEditModal(p)" class="btn-action btn-edit" title="Edit">
                      ✏️
                    </button>
                    <button @click="store.deleteProduct(p.id)" class="btn-action btn-delete" title="Hapus">
                      🗑️
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- SECTION TOPPING -->
      <div class="content-card">
        <h3 class="card-title">🍰 Kelola Topping</h3>
        <p class="card-subtitle">Tambah dan kelola topping untuk produk</p>

        <!-- Form Tambah Topping -->
        <form @submit.prevent="handleAddTopping" class="topping-form">
          <input 
            v-model="newToppingName" 
            placeholder="Nama Topping" 
            required
            class="topping-input"
          >
          <input 
            v-model.number="newToppingPrice" 
            type="number" 
            placeholder="Harga" 
            required
            min="0"
            class="topping-input"
          >
          <button type="submit" class="btn-submit">
            <span class="btn-icon">➕</span>
            Tambah Topping
          </button>
        </form>

        <!-- Daftar Topping -->
        <div class="topping-list" v-if="store.toppings.length > 0">
          <div v-for="t in store.toppings" :key="t.id" class="topping-item">
            <div class="topping-info">
              <span class="topping-name">{{ t.name }}</span>
              <span class="topping-price">Rp {{ t.price.toLocaleString('id-ID') }}</span>
            </div>
            <button @click="store.deleteTopping(t.id)" class="btn-delete-topping" title="Hapus">
              ×
            </button>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="empty-state">
          <p>Belum ada topping. Tambahkan topping pertama Anda!</p>
        </div>
      </div>
    </main>

    <!-- MODAL EDIT PRODUK -->
    <Transition name="modal">
      <div v-if="showEditModal" class="modal-overlay" @click.self="closeEditModal">
        <div class="modal-content">
          <div class="modal-header">
            <h2>✏️ Edit Produk</h2>
            <button @click="closeEditModal" class="modal-close">×</button>
          </div>
          
          <form @submit.prevent="handleUpdate" class="modal-form">
            <div class="form-group">
              <label>Nama Produk</label>
              <input v-model="editingProduct.name" required>
            </div>

            <div class="form-group">
              <label>Kategori</label>
              <input v-model="editingProduct.category" required>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label>Harga (Rp)</label>
                <input v-model.number="editingProduct.price" type="number" required min="0">
              </div>

              <div class="form-group">
                <label>Stok</label>
                <input v-model.number="editingProduct.stock" type="number" required min="0">
              </div>
            </div>

            <div class="form-group">
              <label>URL Gambar</label>
              <input v-model="editingProduct.image" type="url">
            </div>

            <div class="form-group" v-if="editingProduct.image">
              <label>Preview Gambar</label>
              <img :src="editingProduct.image" alt="Preview" class="image-preview">
            </div>

            <div class="modal-actions">
              <button type="button" @click="closeEditModal" class="btn-secondary">
                Batal
              </button>
              <button type="submit" class="btn-submit">
                <span class="btn-icon">💾</span>
                Update Produk
              </button>
            </div>
          </form>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useProductStore } from '../../stores/products';

const store = useProductStore();

const newProduct = ref({ 
  name: '', 
  price: '', 
  category: '', 
  stock: '', 
  image: 'https://placehold.co/400x400' 
});

const newToppingName = ref('');
const newToppingPrice = ref('');

const showEditModal = ref(false);
const editingProduct = ref({});

function handleSubmit() {
  store.addProduct(newProduct.value);
  newProduct.value = { 
    name: '', 
    price: '', 
    category: '', 
    stock: '', 
    image: 'https://placehold.co/400x400' 
  };
}

function handleAddTopping() {
  if (!newToppingName.value || !newToppingPrice.value) {
    alert('Nama dan harga topping harus diisi!');
    return;
  }
  
  store.addTopping({ 
    name: newToppingName.value, 
    price: Number(newToppingPrice.value)
  });
  
  newToppingName.value = '';
  newToppingPrice.value = '';
}

function openEditModal(product) {
  editingProduct.value = { ...product };
  showEditModal.value = true;
}

function closeEditModal() {
  showEditModal.value = false;
  editingProduct.value = {};
}

function handleUpdate() {
  store.updateProduct(editingProduct.value.id, editingProduct.value);
  closeEditModal();
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

.card-subtitle {
  color: #6B4423;
  font-size: 0.95rem;
  margin: -0.5rem 0 1.5rem 0;
}

/* ========================================
   PRODUCT FORM
   ======================================== */
.product-form {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group.full-width {
  grid-column: 1 / -1;
}

.form-group label {
  font-weight: 600;
  color: #2D1810;
  font-size: 0.95rem;
}

.form-group input {
  padding: 0.875rem 1.25rem;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.25s;
}

.form-group input:focus {
  outline: none;
  border-color: #8B4513;
  box-shadow: 0 0 0 4px rgba(139, 69, 19, 0.1);
}

.form-hint {
  color: #9C7A5C;
  font-size: 0.85rem;
}

.btn-submit {
  padding: 1rem 1.5rem;
  background: linear-gradient(135deg, #8B4513 0%, #6B3410 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.25s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.btn-submit:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(139, 69, 19, 0.3);
}

.btn-icon {
  font-size: 1.1rem;
}

/* ========================================
   TABLE
   ======================================== */
.table-wrapper {
  overflow-x: auto;
  margin-top: 1rem;
}

.products-table {
  width: 100%;
  border-collapse: collapse;
}

.products-table thead {
  background: rgba(139, 69, 19, 0.05);
}

.products-table th {
  padding: 1rem;
  text-align: left;
  font-weight: 700;
  color: #2D1810;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.products-table tbody tr {
  border-bottom: 1px solid #E5E7EB;
  transition: all 0.25s;
}

.products-table tbody tr:hover {
  background: rgba(139, 69, 19, 0.03);
}

.products-table td {
  padding: 1rem;
  vertical-align: middle;
}

.product-thumbnail {
  width: 70px;
  height: 70px;
  object-fit: cover;
  border-radius: 12px;
  border: 2px solid #E5E7EB;
}

.product-name {
  font-weight: 700;
  color: #2D1810;
  font-size: 1.05rem;
}

.category-badge {
  display: inline-block;
  padding: 0.4rem 0.9rem;
  background: rgba(139, 69, 19, 0.1);
  color: #8B4513;
  border-radius: 8px;
  font-size: 0.85rem;
  font-weight: 600;
}

.price-cell {
  font-weight: 700;
  color: #8B4513;
  font-size: 1.05rem;
}

.stock-badge {
  display: inline-block;
  padding: 0.4rem 0.9rem;
  border-radius: 8px;
  font-size: 0.85rem;
  font-weight: 700;
}

.out-of-stock {
  background: #fee2e2;
  color: #dc2626;
}

.low-stock {
  background: #fef3c7;
  color: #d97706;
}

.in-stock {
  background: #dcfce7;
  color: #16a34a;
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
}

.btn-action {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.25s;
  font-size: 1.1rem;
}

.btn-edit {
  background: #dbeafe;
  color: #3b82f6;
}

.btn-edit:hover {
  background: #3b82f6;
  color: white;
  transform: translateY(-2px);
}

.btn-delete {
  background: #fee2e2;
  color: #dc2626;
}

.btn-delete:hover {
  background: #dc2626;
  color: white;
  transform: translateY(-2px);
}

/* ========================================
   TOPPING SECTION
   ======================================== */
.topping-form {
  display: grid;
  grid-template-columns: 2fr 1fr auto;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.topping-input {
  padding: 0.875rem 1.25rem;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
}

.topping-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1rem;
}

.topping-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.25rem;
  background: rgba(139, 69, 19, 0.05);
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  transition: all 0.25s;
}

.topping-item:hover {
  border-color: #8B4513;
  box-shadow: 0 2px 8px rgba(139, 69, 19, 0.1);
}

.topping-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.topping-name {
  font-weight: 700;
  color: #2D1810;
}

.topping-price {
  color: #8B4513;
  font-weight: 600;
  font-size: 0.95rem;
}

.btn-delete-topping {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: none;
  background: #fee2e2;
  color: #dc2626;
  font-size: 1.5rem;
  cursor: pointer;
  transition: all 0.25s;
  line-height: 1;
}

.btn-delete-topping:hover {
  background: #dc2626;
  color: white;
  transform: scale(1.15) rotate(90deg);
}

.empty-state {
  text-align: center;
  padding: 2rem;
  color: #9C7A5C;
  font-style: italic;
}

/* ========================================
   MODAL
   ======================================== */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background: white;
  border-radius: 16px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.modal-header {
  padding: 2rem;
  border-bottom: 2px solid rgba(139, 69, 19, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h2 {
  font-size: 1.75rem;
  color: #2D1810;
  margin: 0;
}

.modal-close {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  border: none;
  background: rgba(139, 69, 19, 0.1);
  color: #2D1810;
  font-size: 2rem;
  cursor: pointer;
  transition: all 0.25s;
  line-height: 1;
}

.modal-close:hover {
  background: #dc2626;
  color: white;
  transform: rotate(90deg);
}

.modal-form {
  padding: 2rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.image-preview {
  width: 100%;
  max-height: 250px;
  object-fit: cover;
  border-radius: 12px;
  border: 2px solid #E5E7EB;
}

.modal-actions {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 2px solid rgba(139, 69, 19, 0.1);
}

.modal-actions button {
  flex: 1;
  padding: 1rem;
  font-size: 1.05rem;
}

.btn-secondary {
  background: #f3f4f6;
  color: #2D1810;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.25s;
}

.btn-secondary:hover {
  background: #e5e7eb;
}

/* Modal Transitions */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.25s;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .modal-content,
.modal-leave-active .modal-content {
  transition: transform 0.25s;
}

.modal-enter-from .modal-content,
.modal-leave-to .modal-content {
  transform: scale(0.9) translateY(20px);
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
  
  .product-form {
    grid-template-columns: 1fr;
  }
  
  .topping-form {
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
  
  .table-wrapper {
    overflow-x: scroll;
  }
  
  .products-table {
    min-width: 800px;
  }
}
</style>