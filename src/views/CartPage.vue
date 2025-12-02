<template>
  <div class="cart-page">
    <div class="container">
      <!-- Page Header -->
      <div class="page-header">
        <h1 class="page-title">
          <span class="title-icon">🛒</span>
          Keranjang Belanja
        </h1>
        <p class="page-subtitle">Review pesanan Anda sebelum checkout</p>
      </div>

      <!-- Empty Cart State -->
      <div v-if="cart.items.length === 0" class="empty-cart">
        <div class="empty-icon">🛒</div>
        <h2>Keranjang Anda Kosong</h2>
        <p>Belum ada produk yang ditambahkan ke keranjang</p>
        <router-link to="/" class="btn btn-primary">
          <span class="btn-icon">🍫</span>
          Mulai Belanja
        </router-link>
      </div>

      <!-- Cart Items -->
      <div v-else class="cart-content">
        <div class="cart-items">
          <div 
            v-for="item in cart.items" 
            :key="item.cartId" 
            class="cart-item"
          >
            <div class="item-image-wrapper">
              <img :src="item.image" :alt="item.name" class="item-image">
            </div>

            <div class="item-details">
              <h3 class="item-name">{{ item.name }}</h3>
              
              <!-- Toppings -->
              <div v-if="item.selectedToppings && item.selectedToppings.length > 0" class="item-toppings">
                <span class="topping-label">Topping:</span>
                <span class="topping-list">
                  {{ item.selectedToppings.map(t => t.name).join(', ') }}
                </span>
              </div>

              <!-- Price Breakdown -->
              <div class="price-breakdown">
                <div class="price-row">
                  <span class="price-label">Harga Produk:</span>
                  <span class="price-value">Rp {{ item.price.toLocaleString('id-ID') }}</span>
                </div>
                <div 
                  v-if="item.selectedToppings && item.selectedToppings.length > 0" 
                  class="price-row"
                >
                  <span class="price-label">Topping:</span>
                  <span class="price-value">
                    +Rp {{ item.selectedToppings.reduce((sum, t) => sum + t.price, 0).toLocaleString('id-ID') }}
                  </span>
                </div>
                <div class="price-row total">
                  <span class="price-label">Total per item:</span>
                  <span class="price-value">Rp {{ item.totalPrice.toLocaleString('id-ID') }}</span>
                </div>
              </div>

              <!-- Quantity -->
              <div class="quantity-section">
                <span class="quantity-label">Jumlah:</span>
                <span class="quantity-value">{{ item.quantity }} pcs</span>
              </div>
            </div>

            <!-- Remove Button -->
            <button 
              @click="cart.removeFromCart(item.cartId)" 
              class="btn-remove"
              title="Hapus dari keranjang"
            >
              <span class="remove-icon">🗑️</span>
            </button>
          </div>
        </div>

        <!-- Cart Summary -->
        <div class="cart-summary">
          <div class="summary-card">
            <h3 class="summary-title">Ringkasan Pesanan</h3>
            
            <div class="summary-details">
              <div class="summary-row">
                <span class="summary-label">Total Item:</span>
                <span class="summary-value">{{ cart.count }} pcs</span>
              </div>
              
              <div class="summary-row">
                <span class="summary-label">Subtotal:</span>
                <span class="summary-value">Rp {{ cart.total.toLocaleString('id-ID') }}</span>
              </div>

              <div class="summary-divider"></div>

              <div class="summary-row total">
                <span class="summary-label">Total Pembayaran:</span>
                <span class="summary-value">Rp {{ cart.total.toLocaleString('id-ID') }}</span>
              </div>
            </div>

            <button @click="handleCheckout" class="btn btn-primary btn-checkout">
              <span class="btn-icon">✓</span>
              Checkout Sekarang
            </button>

            <router-link to="/" class="btn-continue-shopping">
              ← Lanjut Belanja
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <!-- Checkout Modal -->
    <Transition name="modal">
      <div v-if="showCheckoutModal" class="modal-overlay" @click.self="showCheckoutModal = false">
        <div class="modal-content checkout-modal">
          <div class="modal-header">
            <h2>🛍️ Checkout</h2>
            <button @click="showCheckoutModal = false" class="modal-close">×</button>
          </div>

          <div class="modal-body">
            <!-- Delivery Method -->
            <div class="form-section">
              <h3>Metode Pengambilan</h3>
              <div class="delivery-options">
                <label class="delivery-option" :class="{ active: deliveryMethod === 'pickup' }">
                  <input type="radio" v-model="deliveryMethod" value="pickup">
                  <div class="option-content">
                    <span class="option-icon">🏪</span>
                    <div>
                      <div class="option-title">Ambil Sendiri</div>
                      <div class="option-desc">Gratis - Ambil di toko</div>
                    </div>
                  </div>
                </label>

                <label class="delivery-option" :class="{ active: deliveryMethod === 'delivery' }">
                  <input type="radio" v-model="deliveryMethod" value="delivery">
                  <div class="option-content">
                    <span class="option-icon">🚚</span>
                    <div>
                      <div class="option-title">Antar ke Alamat</div>
                      <div class="option-desc">Rp 10,000 - Khusus Telaga Kahuripan</div>
                    </div>
                  </div>
                </label>
              </div>
            </div>

            <!-- Delivery Address (if delivery) -->
            <div v-if="deliveryMethod === 'delivery'" class="form-section">
              <h3>Alamat Pengiriman</h3>
              <textarea 
                v-model="deliveryAddress"
                placeholder="Masukkan alamat lengkap Anda di Telaga Kahuripan..."
                rows="3"
                class="form-textarea"
              ></textarea>
              <small class="form-hint">
                ⚠️ Kami hanya melayani pengiriman di area Telaga Kahuripan
              </small>
            </div>

            <!-- Order Summary -->
            <div class="form-section">
              <h3>Ringkasan Pembayaran</h3>
              <div class="checkout-summary">
                <div class="checkout-row">
                  <span>Subtotal ({{ cart.count }} item)</span>
                  <span>Rp {{ cart.total.toLocaleString('id-ID') }}</span>
                </div>
                <div class="checkout-row">
                  <span>Ongkir</span>
                  <span>Rp {{ deliveryFee.toLocaleString('id-ID') }}</span>
                </div>
                <div class="checkout-divider"></div>
                <div class="checkout-row total">
                  <span>Total</span>
                  <span>Rp {{ grandTotal.toLocaleString('id-ID') }}</span>
                </div>
              </div>
            </div>

            <!-- Payment Info -->
            <div class="form-section payment-info">
              <h3>💳 Informasi Pembayaran</h3>
              <div class="bank-info">
                <div class="bank-row">
                  <span class="bank-label">Bank:</span>
                  <span class="bank-value">BCA</span>
                </div>
                <div class="bank-row">
                  <span class="bank-label">No. Rekening:</span>
                  <span class="bank-value">1234567890</span>
                </div>
                <div class="bank-row">
                  <span class="bank-label">Atas Nama:</span>
                  <span class="bank-value">My Brownies Telaga Kahuripan</span>
                </div>
              </div>
              <p class="payment-note">
                ℹ️ Silakan transfer sesuai total pembayaran. Setelah checkout, Anda akan diminta upload bukti transfer.
              </p>
            </div>
          </div>

          <div class="modal-actions">
            <button @click="showCheckoutModal = false" class="btn-secondary">
              Batal
            </button>
            <button @click="processCheckout" class="btn-primary" :disabled="processing">
              {{ processing ? '⏳ Memproses...' : '✓ Konfirmasi Pesanan' }}
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
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

const showCheckoutModal = ref(false);
const deliveryMethod = ref('pickup');
const deliveryAddress = ref('');
const processing = ref(false);

const deliveryFee = computed(() => {
  return deliveryMethod.value === 'delivery' ? 10000 : 0;
});

const grandTotal = computed(() => {
  return cart.total + deliveryFee.value;
});

function handleCheckout() {
  // Check if customer is logged in
  if (!customerAuth.customer) {
    notify.showToast('Silakan login terlebih dahulu untuk checkout', 'error');
    router.push('/auth');
    return;
  }

  if (cart.items.length === 0) {
    notify.showToast('Keranjang masih kosong!', 'error');
    return;
  }

  // Set default address from customer profile
  if (customerAuth.customer.address) {
    deliveryAddress.value = customerAuth.customer.address;
  }

  showCheckoutModal.value = true;
}

async function processCheckout() {
  // Validate delivery address if delivery method
  if (deliveryMethod.value === 'delivery' && !deliveryAddress.value.trim()) {
    notify.showToast('Silakan masukkan alamat pengiriman', 'error');
    return;
  }

  processing.value = true;

  try {
    // Create order with customer data
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
      throw new Error(result.error);
    }

    // Decrease stock for each product
    for (const item of cart.items) {
      await productStore.decreaseStock(item.id, item.quantity);
    }

    // Clear cart
    cart.clearCart();

    notify.showToast('Pesanan berhasil dibuat! Silakan upload bukti transfer 📸', 'success');

    // Close modal
    showCheckoutModal.value = false;

    // Redirect to home with success message
    setTimeout(() => {
      router.push('/');
    }, 2000);

  } catch (error) {
    console.error('Checkout error:', error);
    notify.showToast('Terjadi kesalahan saat checkout: ' + error.message, 'error');
  } finally {
    processing.value = false;
  }
}
</script>

<style scoped>
/* Previous styles remain the same... */
.cart-page {
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
  font-size: clamp(2rem, 5vw, 3rem);
  color: var(--text-main);
  margin-bottom: 0.5rem;
}

.title-icon {
  font-size: 3rem;
}

.page-subtitle {
  color: var(--text-light);
  font-size: 1.1rem;
}

.empty-cart {
  text-align: center;
  padding: 4rem 2rem;
  background: var(--bg-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  max-width: 600px;
  margin: 0 auto;
}

.empty-icon {
  font-size: 6rem;
  margin-bottom: 1.5rem;
  opacity: 0.5;
}

.empty-cart h2 {
  color: var(--text-main);
  margin-bottom: 0.75rem;
}

.empty-cart p {
  color: var(--text-muted);
  margin-bottom: 2rem;
  font-size: 1.05rem;
}

.cart-content {
  display: grid;
  grid-template-columns: 1fr 400px;
  gap: 2rem;
  align-items: start;
}

.cart-items {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.cart-item {
  background: var(--bg-card);
  border-radius: var(--radius-lg);
  padding: 1.5rem;
  box-shadow: var(--shadow-sm);
  display: grid;
  grid-template-columns: 120px 1fr auto;
  gap: 1.5rem;
  align-items: start;
  transition: all var(--transition-base);
  position: relative;
}

.cart-item:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.item-image-wrapper {
  width: 120px;
  height: 120px;
  border-radius: var(--radius-md);
  overflow: hidden;
  background: var(--bg-overlay);
}

.item-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.item-details {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.item-name {
  font-size: 1.35rem;
  color: var(--text-main);
  font-weight: 700;
  margin: 0;
}

.item-toppings {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  align-items: center;
}

.topping-label {
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--text-muted);
}

.topping-list {
  font-size: 0.9rem;
  color: var(--primary);
  font-weight: 600;
}

.price-breakdown {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  padding: 1rem;
  background: var(--bg-overlay);
  border-radius: var(--radius-md);
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.9rem;
}

.price-row.total {
  padding-top: 0.5rem;
  border-top: 2px solid rgba(139, 69, 19, 0.2);
  margin-top: 0.25rem;
}

.price-row.total .price-label {
  font-weight: 700;
  color: var(--text-main);
}

.price-row.total .price-value {
  font-size: 1.15rem;
  font-weight: 800;
  color: var(--primary);
}

.price-label {
  color: var(--text-light);
}

.price-value {
  font-weight: 600;
  color: var(--text-main);
}

.quantity-section {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 1rem;
  background: var(--bg-card);
  border: 2px solid var(--primary);
  border-radius: var(--radius-md);
  width: fit-content;
}

.quantity-label {
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--text-light);
}

.quantity-value {
  font-size: 1.1rem;
  font-weight: 800;
  color: var(--primary);
}

.btn-remove {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  border: none;
  background: #fee2e2;
  color: var(--danger);
  cursor: pointer;
  transition: all var(--transition-base);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
}

.btn-remove:hover {
  background: var(--danger);
  color: white;
  transform: scale(1.1) rotate(10deg);
}

.cart-summary {
  position: sticky;
  top: 100px;
}

.summary-card {
  background: var(--bg-card);
  border-radius: var(--radius-lg);
  padding: 2rem;
  box-shadow: var(--shadow-md);
  border: 2px solid var(--primary);
}

.summary-title {
  font-size: 1.5rem;
  color: var(--text-main);
  margin-bottom: 1.5rem;
  text-align: center;
}

.summary-details {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 2rem;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.summary-label {
  font-size: 1rem;
  color: var(--text-light);
  font-weight: 500;
}

.summary-value {
  font-size: 1rem;
  font-weight: 700;
  color: var(--text-main);
}

.summary-divider {
  height: 2px;
  background: var(--bg-overlay);
  margin: 0.5rem 0;
}

.summary-row.total {
  padding-top: 1rem;
  border-top: 2px solid var(--primary);
}

.summary-row.total .summary-label {
  font-size: 1.15rem;
  font-weight: 700;
  color: var(--text-main);
}

.summary-row.total .summary-value {
  font-size: 1.75rem;
  font-weight: 800;
  color: var(--primary);
  font-family: var(--font-display);
}

.btn-checkout {
  width: 100%;
  padding: 1.25rem;
  font-size: 1.1rem;
  margin-bottom: 1rem;
}

.btn-continue-shopping {
  display: block;
  text-align: center;
  padding: 0.75rem;
  color: var(--primary);
  font-weight: 600;
  transition: all var(--transition-base);
  border-radius: var(--radius-md);
  text-decoration: none;
}

.btn-continue-shopping:hover {
  background: var(--bg-overlay);
}

/* Checkout Modal */
.checkout-modal {
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-body {
  padding: 2rem;
}

.form-section {
  margin-bottom: 2rem;
}

.form-section h3 {
  font-size: 1.15rem;
  color: var(--text-main);
  margin-bottom: 1rem;
  font-weight: 700;
}

.delivery-options {
  display: flex;
  flex-direction: column;
  gap: 1rem;
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

.form-textarea {
  width: 100%;
  padding: 1rem;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  font-family: inherit;
  resize: vertical;
  transition: all 0.25s;
}

.form-textarea:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 4px rgba(139, 69, 19, 0.1);
}

.form-hint {
  display: block;
  margin-top: 0.5rem;
  color: #d97706;
  font-size: 0.85rem;
}

.checkout-summary {
  background: var(--bg-overlay);
  padding: 1.25rem;
  border-radius: 12px;
}

.checkout-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.75rem;
  font-size: 0.95rem;
}

.checkout-row.total {
  padding-top: 0.75rem;
  border-top: 2px solid rgba(139, 69, 19, 0.2);
  margin-top: 0.5rem;
  font-size: 1.15rem;
  font-weight: 700;
  color: var(--primary);
}

.checkout-divider {
  height: 1px;
  background: rgba(139, 69, 19, 0.2);
  margin: 0.5rem 0;
}

.payment-info {
  background: rgba(139, 69, 19, 0.05);
  padding: 1.5rem;
  border-radius: 12px;
  border: 2px solid rgba(139, 69, 19, 0.2);
}

.bank-info {
  background: white;
  padding: 1.25rem;
  border-radius: 8px;
  margin-bottom: 1rem;
}

.bank-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.75rem;
}

.bank-row:last-child {
  margin-bottom: 0;
}

.bank-label {
  font-weight: 600;
  color: var(--text-light);
}

.bank-value {
  font-weight: 700;
  color: var(--text-main);
  font-family: monospace;
}

.payment-note {
  font-size: 0.9rem;
  color: var(--text-light);
  margin: 0;
  line-height: 1.6;
}

.modal-actions {
  display: flex;
  gap: 1rem;
  padding: 1.5rem 2rem;
  border-top: 2px solid rgba(139, 69, 19, 0.1);
}

.modal-actions button {
  flex: 1;
  padding: 1rem;
  font-size: 1.05rem;
  border-radius: 12px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.25s;
}

.btn-secondary {
  background: #f3f4f6;
  color: #2D1810;
  border: 2px solid #E5E7EB;
}

.btn-secondary:hover {
  background: #e5e7eb;
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
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

/* Responsive */
@media (max-width: 1024px) {
  .cart-content {
    grid-template-columns: 1fr;
  }
  
  .cart-summary {
    position: static;
  }
}

@media (max-width: 768px) {
  .cart-item {
    grid-template-columns: 80px 1fr;
    gap: 1rem;
  }
  
  .btn-remove {
    position: absolute;
    top: 1rem;
    right: 1rem;
    width: 36px;
    height: 36px;
  }
  
  .item-image-wrapper {
    width: 80px;
    height: 80px;
  }
  
  .item-name {
    font-size: 1.1rem;
  }

  .modal-body {
    padding: 1.5rem;
  }

  .modal-actions {
    flex-direction: column;
    padding: 1rem 1.5rem;
  }
}
</style>