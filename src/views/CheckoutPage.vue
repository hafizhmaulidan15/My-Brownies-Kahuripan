<template>
  <div class="checkout-page">
    <div class="container">
      <!-- Page Header -->
      <div class="page-header">
        <h1 class="page-title">
          <span class="title-icon">💳</span>
          Checkout & Payment
        </h1>
        <p class="page-subtitle">Lengkapi data dan pilih metode pembayaran</p>
      </div>

      <!-- Main Content -->
      <div class="checkout-content">
        <!-- Left: Order Summary -->
        <div class="order-summary-section">
          <div class="section-card">
            <h2 class="section-title">📦 Ringkasan Pesanan</h2>
            
            <!-- Cart Items -->
            <div class="cart-items">
              <div v-for="item in cart.items" :key="item.cartId" class="cart-item">
                <img :src="item.image" :alt="item.name" class="item-image">
                <div class="item-info">
                  <h3 class="item-name">{{ item.name }}</h3>
                  <p v-if="item.selectedToppings?.length" class="item-toppings">
                    + {{ item.selectedToppings.map(t => t.name).join(', ') }}
                  </p>
                  <p class="item-qty">{{ item.quantity }}x</p>
                </div>
                <div class="item-price">
                  Rp {{ item.totalPrice.toLocaleString('id-ID') }}
                </div>
              </div>
            </div>

            <!-- Price Summary -->
            <div class="price-summary">
              <div class="price-row">
                <span>Subtotal ({{ cart.count }} item)</span>
                <span>Rp {{ cart.total.toLocaleString('id-ID') }}</span>
              </div>
              <div class="price-row">
                <span>Ongkir</span>
                <span>Rp {{ deliveryFee.toLocaleString('id-ID') }}</span>
              </div>
              <div class="price-divider"></div>
              <div class="price-row total">
                <span>Total Pembayaran</span>
                <span>Rp {{ grandTotal.toLocaleString('id-ID') }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Right: Checkout Form -->
        <div class="checkout-form-section">
          <!-- Customer Info -->
          <div class="section-card">
            <h2 class="section-title">👤 Informasi Customer</h2>
            <div class="info-grid">
              <div class="info-item">
                <span class="info-label">Nama:</span>
                <span class="info-value">{{ customerAuth.customer.name }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">Email:</span>
                <span class="info-value">{{ customerAuth.customer.email }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">Telepon:</span>
                <span class="info-value">{{ customerAuth.customer.phone }}</span>
              </div>
            </div>
          </div>

          <!-- Delivery Method -->
          <div class="section-card">
            <h2 class="section-title">🚚 Metode Pengambilan</h2>
            <div class="delivery-options">
              <label class="delivery-option" :class="{ active: deliveryMethod === 'pickup' }">
                <input type="radio" v-model="deliveryMethod" value="pickup">
                <div class="option-content">
                  <span class="option-icon">🏪</span>
                  <div>
                    <div class="option-title">Ambil Sendiri</div>
                    <div class="option-desc">Gratis - Ambil di toko</div>
                  </div>
                  <div class="option-price">Gratis</div>
                </div>
              </label>

              <label class="delivery-option" :class="{ active: deliveryMethod === 'delivery' }">
                <input type="radio" v-model="deliveryMethod" value="delivery">
                <div class="option-content">
                  <span class="option-icon">🚚</span>
                  <div>
                    <div class="option-title">Antar ke Alamat</div>
                    <div class="option-desc">Khusus area Telaga Kahuripan</div>
                  </div>
                  <div class="option-price">Rp 10,000</div>
                </div>
              </label>
            </div>

            <!-- Delivery Address -->
            <div v-if="deliveryMethod === 'delivery'" class="delivery-address">
              <label class="address-label">Alamat Pengiriman</label>
              <textarea 
                v-model="deliveryAddress"
                placeholder="Masukkan alamat lengkap..."
                rows="3"
                class="address-input"
              ></textarea>
            </div>
          </div>

          <!-- Payment Info -->
          <div class="section-card payment-card">
            <h2 class="section-title">💰 Informasi Pembayaran</h2>
            <div class="bank-info">
              <div class="bank-header">
                <span class="bank-logo">🏦</span>
                <span class="bank-name">Bank BCA</span>
              </div>
              <div class="bank-details">
                <div class="bank-row">
                  <span class="bank-label">No. Rekening:</span>
                  <span class="bank-value">1234567890</span>
                </div>
                <div class="bank-row">
                  <span class="bank-label">Atas Nama:</span>
                  <span class="bank-value">My Brownies Telaga Kahuripan</span>
                </div>
                <div class="bank-row highlight">
                  <span class="bank-label">Total Transfer:</span>
                  <span class="bank-value">Rp {{ grandTotal.toLocaleString('id-ID') }}</span>
                </div>
              </div>
            </div>
            <div class="payment-note">
              <span class="note-icon">ℹ️</span>
              <p>Silakan transfer sesuai total pembayaran. Setelah konfirmasi, Anda akan diminta upload bukti transfer.</p>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="action-buttons">
            <router-link to="/cart" class="btn-back">
              ← Kembali ke Keranjang
            </router-link>
            <button @click="processCheckout" class="btn-confirm" :disabled="processing">
              {{ processing ? '⏳ Memproses...' : '✓ Konfirmasi Pesanan' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useCartStore } from '../stores/cart';
import { useOrderStore } from '../stores/orders';
import { useProductStore } from '../stores/products';
import { useCustomerAuthStore } from '../stores/customerAuth';
import { useNotificationStore } from '../stores/notification';

const router = useRouter();
const cart = useCartStore();
const orderStore = useOrderStore();
const productStore = useProductStore();
const customerAuth = useCustomerAuthStore();
const notify = useNotificationStore();

const deliveryMethod = ref('pickup');
const deliveryAddress = ref('');
const processing = ref(false);

const deliveryFee = computed(() => {
  return deliveryMethod.value === 'delivery' ? 10000 : 0;
});

const grandTotal = computed(() => {
  return cart.total + deliveryFee.value;
});

onMounted(() => {
  // Check if customer is logged in
  if (!customerAuth.customer) {
    notify.showToast('Silakan login terlebih dahulu', 'error');
    router.push('/auth');
    return;
  }

  // Check if cart is empty
  if (cart.items.length === 0) {
    notify.showToast('Keranjang kosong!', 'error');
    router.push('/cart');
    return;
  }

  // Set default address
  if (customerAuth.customer.address) {
    deliveryAddress.value = customerAuth.customer.address;
  }
});

async function processCheckout() {
  // Validate delivery address
  if (deliveryMethod.value === 'delivery' && !deliveryAddress.value.trim()) {
    notify.showToast('Silakan masukkan alamat pengiriman', 'error');
    return;
  }

  processing.value = true;

  try {
    // Create order
    const orderData = {
      customer_id: customerAuth.customer.id,
      customer_name: customerAuth.customer.name,
      customer_email: customerAuth.customer.email,
      customer_phone: customerAuth.customer.phone,
      items: cart.items,
      total: grandTotal.value,
      delivery_method: deliveryMethod.value,
      delivery_address: deliveryMethod.value === 'delivery' ? deliveryAddress.value : null,
      delivery_fee: deliveryFee.value
    };

    const result = await orderStore.createOrder(orderData);

    if (!result.success) {
      throw new Error(result.error?.message || 'Gagal membuat pesanan');
    }

    // Decrease stock
    for (const item of cart.items) {
      await productStore.decreaseStock(item.id, item.quantity);
    }

    // Clear cart
    cart.clearCart();

    // Success
    notify.showToast('Pesanan berhasil dibuat! 🎉', 'success');

    // Redirect to home
    setTimeout(() => {
      router.push('/');
    }, 2000);

  } catch (error) {
    console.error('Checkout error:', error);
    notify.showToast(error.message || 'Terjadi kesalahan saat checkout', 'error');
  } finally {
    processing.value = false;
  }
}
</script>

<style scoped>
.checkout-page {
  min-height: 100vh;
  padding: 3rem 0;
  background: var(--bg-main);
}

.page-header {
  text-align: center;
  margin-bottom: 3rem;
}

.page-title {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  font-size: clamp(2rem, 5vw, 2.5rem);
  color: var(--text-main);
  margin-bottom: 0.5rem;
}

.title-icon {
  font-size: 2.5rem;
}

.page-subtitle {
  color: var(--text-light);
  font-size: 1.1rem;
}

.checkout-content {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 2rem;
  align-items: start;
}

.section-card {
  background: var(--bg-card);
  border-radius: var(--radius-lg);
  padding: 2rem;
  box-shadow: var(--shadow-md);
  margin-bottom: 1.5rem;
}

.section-title {
  font-size: 1.35rem;
  color: var(--text-main);
  margin-bottom: 1.5rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* Cart Items */
.cart-items {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.cart-item {
  display: flex;
  gap: 1rem;
  align-items: center;
  padding: 1rem;
  background: var(--bg-overlay);
  border-radius: var(--radius-md);
}

.item-image {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 8px;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 1rem;
  font-weight: 700;
  color: var(--text-main);
  margin: 0 0 0.25rem 0;
}

.item-toppings {
  font-size: 0.85rem;
  color: var(--primary);
  margin: 0 0 0.25rem 0;
}

.item-qty {
  font-size: 0.85rem;
  color: var(--text-light);
  margin: 0;
}

.item-price {
  font-weight: 700;
  color: var(--primary);
  font-size: 1.05rem;
}

/* Price Summary */
.price-summary {
  background: var(--bg-overlay);
  padding: 1.25rem;
  border-radius: var(--radius-md);
}

.price-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.75rem;
  font-size: 0.95rem;
}

.price-row.total {
  font-size: 1.25rem;
  font-weight: 800;
  color: var(--primary);
  padding-top: 0.75rem;
  margin-top: 0.5rem;
}

.price-divider {
  height: 2px;
  background: rgba(139, 69, 19, 0.2);
  margin: 0.75rem 0;
}

/* Customer Info */
.info-grid {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.info-item {
  display: flex;
  justify-content: space-between;
  padding: 0.75rem;
  background: var(--bg-overlay);
  border-radius: 8px;
}

.info-label {
  font-weight: 600;
  color: var(--text-light);
}

.info-value {
  font-weight: 700;
  color: var(--text-main);
}

/* Delivery Options */
.delivery-options {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.delivery-option {
  display: block;
  padding: 1.25rem;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.25s;
}

.delivery-option:hover {
  border-color: var(--primary);
  background: rgba(139, 69, 19, 0.05);
}

.delivery-option.active {
  border-color: var(--primary);
  background: rgba(139, 69, 19, 0.1);
}

.delivery-option input[type="radio"] {
  display: none;
}

.option-content {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.option-icon {
  font-size: 2rem;
}

.option-title {
  font-weight: 700;
  color: var(--text-main);
  margin-bottom: 0.25rem;
}

.option-desc {
  font-size: 0.9rem;
  color: var(--text-light);
}

.option-price {
  margin-left: auto;
  font-weight: 700;
  color: var(--primary);
  font-size: 1.1rem;
}

/* Delivery Address */
.delivery-address {
  margin-top: 1rem;
}

.address-label {
  display: block;
  font-weight: 700;
  color: var(--text-main);
  margin-bottom: 0.5rem;
}

.address-input {
  width: 100%;
  padding: 1rem;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  font-family: inherit;
  resize: vertical;
  transition: all 0.25s;
}

.address-input:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 4px rgba(139, 69, 19, 0.1);
}

/* Payment Card */
.payment-card {
  background: linear-gradient(135deg, rgba(139, 69, 19, 0.05) 0%, rgba(139, 69, 19, 0.1) 100%);
  border: 2px solid rgba(139, 69, 19, 0.2);
}

.bank-info {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1rem;
}

.bank-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1.25rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid rgba(139, 69, 19, 0.1);
}

.bank-logo {
  font-size: 2rem;
}

.bank-name {
  font-size: 1.25rem;
  font-weight: 800;
  color: var(--text-main);
}

.bank-details {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.bank-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.bank-row.highlight {
  padding: 1rem;
  background: rgba(139, 69, 19, 0.1);
  border-radius: 8px;
  margin-top: 0.5rem;
}

.bank-label {
  font-weight: 600;
  color: var(--text-light);
}

.bank-value {
  font-weight: 700;
  color: var(--text-main);
  font-family: monospace;
  font-size: 1.05rem;
}

.bank-row.highlight .bank-value {
  color: var(--primary);
  font-size: 1.25rem;
}

.payment-note {
  display: flex;
  gap: 0.75rem;
  padding: 1rem;
  background: rgba(255, 193, 7, 0.1);
  border-radius: 8px;
  border-left: 4px solid #ffc107;
}

.note-icon {
  font-size: 1.25rem;
}

.payment-note p {
  margin: 0;
  font-size: 0.9rem;
  color: var(--text-light);
  line-height: 1.6;
}

/* Action Buttons */
.action-buttons {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
}

.btn-back {
  flex: 1;
  padding: 1.25rem;
  background: #f3f4f6;
  color: #2D1810;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-weight: 700;
  text-align: center;
  text-decoration: none;
  transition: all 0.25s;
}

.btn-back:hover {
  background: #e5e7eb;
}

.btn-confirm {
  flex: 2;
  padding: 1.25rem;
  background: linear-gradient(135deg, #8B4513 0%, #6B3410 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-weight: 700;
  font-size: 1.1rem;
  cursor: pointer;
  transition: all 0.25s;
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

.btn-confirm:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(139, 69, 19, 0.4);
}

.btn-confirm:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* Responsive */
@media (max-width: 1024px) {
  .checkout-content {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .section-card {
    padding: 1.5rem;
  }

  .action-buttons {
    flex-direction: column;
  }

  .cart-item {
    flex-wrap: wrap;
  }

  .item-price {
    width: 100%;
    text-align: right;
    margin-top: 0.5rem;
  }
}
</style>
