import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { supabase } from '../supabase';

export const useOrderStore = defineStore('orders', () => {
  const orders = ref([]);

  const totalRevenue = computed(() => 
    orders.value.reduce((sum, order) => sum + order.total, 0)
  );

  // 1. AMBIL ORDER DARI DB
  async function fetchOrders() {
    const { data, error } = await supabase
      .from('orders')
      .select('*')
      .order('created_at', { ascending: false }); // Yang baru diatas

    if (data) {
      // Format data biar cocok sama tampilan kita
      orders.value = data.map(o => ({
        ...o,
        id: String(o.id), // Pastikan ID string
        customer: { name: o.customer_name, phone: o.customer_phone },
        // Format Tanggal Cantik
        displayDate: new Date(o.created_at).toLocaleString('id-ID', { 
          weekday: 'short', day: 'numeric', month: 'short', hour: '2-digit', minute:'2-digit'
        })
      }));
    }
  }

  // 2. BIKIN ORDER BARU (Pas User Checkout)
  async function createOrder(customerData, cartItems, total) {
    const { error } = await supabase
      .from('orders')
      .insert({
        customer_name: customerData.name,
        customer_phone: customerData.phone,
        items: cartItems, // JSONB otomatis handle array object
        total: total,
        status: 'Pending'
      });

    if (error) console.error('Gagal order:', error);
    // Gak perlu fetchOrders() manual, karena kita pake Realtime Subscription dibawah
  }

  // 3. UPDATE STATUS (Admin)
  async function updateStatus(orderId, newStatus) {
    await supabase
      .from('orders')
      .update({ status: newStatus })
      .eq('id', orderId);
  }

  // 🔥 4. REALTIME LISTENER (FITUR DEWA) 🔥
  // Ini bikin Admin Panel otomatis update sendiri
  function initRealtime() {
    supabase
      .channel('orders_channel')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'orders' }, (payload) => {
        console.log('Ada update database!', payload);
        fetchOrders(); // Refresh data otomatis
      })
      .subscribe();
  }

  // Jalankan saat store diload
  fetchOrders();
  initRealtime();

  return { orders, totalRevenue, createOrder, updateStatus };
});