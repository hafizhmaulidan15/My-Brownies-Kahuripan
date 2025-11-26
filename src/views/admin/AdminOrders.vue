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
      <div class="flex-between" style="margin-bottom: 2rem;">
        <h1>Manajemen Order</h1>
        
        <button @click="downloadReport" class="btn" style="background: #10b981; color: white; display: flex; align-items: center; gap: 0.5rem;">
          <span>📥</span> Download Laporan (.csv)
        </button>
      </div>

      <div class="card">
        <table style="width: 100%; border-collapse: collapse;">
          <thead>
            <tr style="text-align: left; background: #f8fafc; color: #64748b;">
              <th style="padding: 1rem;">ID & Waktu</th>
              <th>Customer</th>
              <th>Total</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in orderStore.orders" :key="order.id" style="border-bottom: 1px solid #eee;">
              <td style="padding: 1rem;">
                <div style="font-weight: bold; font-family: monospace;">#{{ order.id.slice(-6) }}</div>
                <div style="font-size: 0.8rem; color: #888;">{{ order.displayDate }}</div>
              </td>
              <td>
                <div style="font-weight: bold;">{{ order.customer.name }}</div>
                <div style="font-size: 0.8rem;">{{ order.customer.phone }}</div>
              </td>
              <td style="font-weight: bold;">Rp {{ order.total.toLocaleString() }}</td>
              <td>
                <select 
                  @change="orderStore.updateStatus(order.id, $event.target.value)" 
                  :value="order.status"
                  :class="['status-select', order.status.toLowerCase()]"
                >
                  <option>Pending</option>
                  <option>Processed</option>
                  <option>Completed</option>
                  <option>Cancelled</option>
                </select>
              </td>
              <td>
                <button @click="openReceipt(order)" class="btn" style="background: #6366f1; color: white; padding: 0.4rem 0.8rem; font-size: 0.9rem;">
                  🖨️ Struk
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </main>

    <div v-if="showReceiptModal" class="modal-overlay" @click.self="closeReceipt">
      <div class="receipt-card">
        <div id="printable-area" class="thermal-paper">
          <div style="text-align: center; margin-bottom: 1rem; border-bottom: 2px dashed #000; padding-bottom: 1rem;">
            <h2 style="margin: 0; font-size: 1.2rem;">BROWNIES SULTAN</h2>
            <p style="margin: 0; font-size: 0.8rem;">Jl. Koding Vue No. 123</p>
            <p style="margin: 0; font-size: 0.8rem;">Telp: 0812-3456-7890</p>
          </div>

          <div style="font-size: 0.8rem; margin-bottom: 1rem;">
            <div class="flex-between"><span>No:</span> <span>#{{ activeOrder.id.slice(-6) }}</span></div>
            <div class="flex-between"><span>Tgl:</span> <span>{{ activeOrder.displayDate }}</span></div>
            <div class="flex-between"><span>Cust:</span> <span>{{ activeOrder.customer.name }}</span></div>
          </div>

          <div style="border-top: 1px dashed #000; border-bottom: 1px dashed #000; padding: 0.5rem 0; margin-bottom: 1rem;">
            <div v-for="(item, idx) in activeOrder.items" :key="idx" style="margin-bottom: 0.5rem; font-size: 0.85rem;">
              <div style="font-weight: bold;">{{ item.name }}</div>
              
              <div v-if="item.selectedToppings?.length" style="font-size: 0.75rem; color: #444; margin-left: 0.5rem;">
                + {{ item.selectedToppings.map(t => t.name).join(', ') }}
              </div>

              <div class="flex-between">
                <span>{{ item.quantity }} x {{ (item.totalPrice/item.quantity).toLocaleString() }}</span>
                <span>{{ item.totalPrice.toLocaleString() }}</span>
              </div>
            </div>
          </div>

          <div style="font-size: 0.9rem; font-weight: bold;">
            <div class="flex-between" style="margin-bottom: 0.5rem;">
              <span>TOTAL</span>
              <span style="font-size: 1.1rem;">Rp {{ activeOrder.total.toLocaleString() }}</span>
            </div>
            <div class="flex-between" style="font-size: 0.8rem; font-weight: normal;">
              <span>Bayar (Cash)</span>
              <span>Rp {{ activeOrder.total.toLocaleString() }}</span>
            </div>
          </div>

          <div style="text-align: center; margin-top: 1.5rem; font-size: 0.8rem;">
            <p>Terima Kasih sudah belanja!</p>
            <p>Follow IG: @brownies.sultan</p>
          </div>
        </div>

        <div class="receipt-actions">
          <button @click="triggerPrint" class="btn btn-primary" style="width: 100%;">🖨️ Cetak Sekarang</button>
          <button @click="closeReceipt" class="btn" style="background: #ef4444; color: white; width: 100%; margin-top: 0.5rem;">Tutup</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useOrderStore } from '../../stores/orders';

const orderStore = useOrderStore();

// --- LOGIC EXPORT EXCEL (CSV) ---
function downloadReport() {
  const headers = ['Order ID', 'Tanggal', 'Nama Customer', 'No HP', 'Items', 'Total Harga', 'Status'];
  
  const rows = orderStore.orders.map(o => {
    // Format items jadi string biar masuk 1 cell excel
    const itemsSummary = o.items.map(i => {
      const toppings = i.selectedToppings?.map(t => t.name).join('+') || '';
      return `${i.name} ${toppings ? '('+toppings+')' : ''} x${i.quantity}`;
    }).join(' | ');

    return [
      o.id,
      `"${o.displayDate}"`, // Pake kutip biar koma di tanggal gak ngerusak kolom
      `"${o.customer.name}"`,
      `'${o.customer.phone}`, // Pake petik satu biar excel baca sbg text (08...)
      `"${itemsSummary}"`,
      o.total,
      o.status
    ].join(',');
  });

  const csvContent = [headers.join(','), ...rows].join('\n');
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = `Laporan_Penjualan_${new Date().toISOString().slice(0,10)}.csv`;
  link.click();
}

// --- LOGIC PRINT STRUK ---
const showReceiptModal = ref(false);
const activeOrder = ref(null);

function openReceipt(order) {
  activeOrder.value = order;
  showReceiptModal.value = true;
}

function closeReceipt() {
  showReceiptModal.value = false;
  activeOrder.value = null;
}

function triggerPrint() {
  window.print(); // Ini perintah bawaan browser buat nge-print
}
</script>

<style scoped>
.status-select { padding: 0.3rem; border-radius: 4px; border: 1px solid #ddd; font-weight: 500; }
.status-select.pending { background: #fffbeb; color: #d97706; }
.status-select.completed { background: #dcfce7; color: #16a34a; }

/* MODAL STYLES */
.modal-overlay {
  position: fixed; top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,0.6); display: flex; align-items: center; justify-content: center; z-index: 1000;
}
.receipt-card {
  background: white; padding: 20px; border-radius: 8px; width: 350px;
}

/* STYLE STRUK ALA KASIR */
.thermal-paper {
  background: white; color: black; font-family: 'Courier New', Courier, monospace;
  padding: 10px; border: 1px solid #eee; margin-bottom: 1rem;
}

/* --- MAGIC CSS BUAT PRINT --- 
   CSS ini cuma jalan pas lu tekan Print (Ctrl+P atau tombol Print)
   Dia bakal nyembunyiin semua hal KECUALI Struknya.
*/
@media print {
  body * { visibility: hidden; } /* Sembunyikan SEMUA */
  .modal-overlay, .receipt-card, #printable-area, #printable-area * {
    visibility: visible; /* Munculin cuma area struk */
  }
  .modal-overlay {
    position: absolute; left: 0; top: 0; background: none;
  }
  .receipt-card {
    box-shadow: none; border: none; width: 100%; position: absolute; left: 0; top: 0;
  }
  .receipt-actions { display: none; } /* Sembunyikan tombol print/tutup pas nge-print */
  aside, .content { display: none; }
}
</style>