import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { supabase } from '../supabase';

export const useOrderStore = defineStore('orders', () => {
  const orders = ref([]);

  const totalRevenue = computed(() =>
    orders.value
      .filter(o => o.payment_status === 'paid')
      .reduce((sum, order) => sum + order.total, 0)
  );

  const pendingPayments = computed(() =>
    orders.value.filter(o => o.payment_status === 'pending')
  );

  // 1. AMBIL ORDER DARI DB
  async function fetchOrders() {
    const { data, error } = await supabase
      .from('orders')
      .select('*')
      .order('created_at', { ascending: false });

    if (data) {
      orders.value = data.map(o => ({
        ...o,
        id: String(o.id),
        customer: {
          name: o.customer_name,
          phone: o.customer_phone,
          email: o.customer_email
        },
        displayDate: new Date(o.created_at).toLocaleString('id-ID', {
          weekday: 'short', day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit'
        })
      }));
    }
  }

  // 2. BIKIN ORDER BARU dengan Payment Info
  async function createOrder(orderData) {
    const { data, error } = await supabase
      .from('orders')
      .insert({
        customer_id: orderData.customer_id,
        customer_name: orderData.customer_name,
        customer_email: orderData.customer_email,
        customer_phone: orderData.customer_phone,
        items: orderData.items,
        total: orderData.total,
        delivery_method: orderData.delivery_method,
        delivery_address: orderData.delivery_address,
        delivery_fee: orderData.delivery_fee || 0,
        payment_method: 'manual_transfer',
        payment_status: 'pending',
        status: 'Menunggu Pembayaran'
      })
      .select()
      .single();

    if (error) {
      console.error('Gagal order:', error);
      return { success: false, error };
    }

    return { success: true, order: data };
  }

  // 3. UPLOAD BUKTI TRANSFER
  async function uploadPaymentProof(orderId, file) {
    try {
      const fileExt = file.name.split('.').pop();
      const fileName = `${orderId}_${Date.now()}.${fileExt}`;
      const filePath = `${fileName}`;

      // Upload to Supabase Storage
      const { error: uploadError } = await supabase.storage
        .from('payment-proofs')
        .upload(filePath, file);

      if (uploadError) throw uploadError;

      // Get public URL
      const { data: { publicUrl } } = supabase.storage
        .from('payment-proofs')
        .getPublicUrl(filePath);

      // Update order dengan payment proof URL
      const { error: updateError } = await supabase
        .from('orders')
        .update({
          payment_proof_url: publicUrl,
          status: 'Menunggu Konfirmasi'
        })
        .eq('id', orderId);

      if (updateError) throw updateError;

      return { success: true, url: publicUrl };
    } catch (error) {
      console.error('Upload error:', error);
      return { success: false, error: error.message };
    }
  }

  // 4. ADMIN: APPROVE PAYMENT
  async function approvePayment(orderId, notes = '') {
    const { error } = await supabase
      .from('orders')
      .update({
        payment_status: 'paid',
        status: 'Sedang Diproses',
        admin_notes: notes
      })
      .eq('id', orderId);

    if (error) {
      console.error('Approve error:', error);
      return { success: false, error };
    }

    return { success: true };
  }

  // 5. ADMIN: REJECT PAYMENT
  async function rejectPayment(orderId, reason) {
    const { error } = await supabase
      .from('orders')
      .update({
        payment_status: 'rejected',
        status: 'Pembayaran Ditolak',
        admin_notes: reason
      })
      .eq('id', orderId);

    if (error) {
      console.error('Reject error:', error);
      return { success: false, error };
    }

    return { success: true };
  }

  // 6. UPDATE STATUS (Admin)
  async function updateStatus(orderId, newStatus) {
    await supabase
      .from('orders')
      .update({ status: newStatus })
      .eq('id', orderId);
  }

  // 7. REALTIME LISTENER
  function initRealtime() {
    supabase
      .channel('orders_channel')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'orders' }, (payload) => {
        console.log('Order update:', payload);
        fetchOrders();
      })
      .subscribe();
  }

  // Init
  fetchOrders();
  initRealtime();

  return {
    orders,
    totalRevenue,
    pendingPayments,
    createOrder,
    uploadPaymentProof,
    approvePayment,
    rejectPayment,
    updateStatus
  };
});