// src/stores/orders.js
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useOrderStore = defineStore('orders', () => {
  const orders = ref(JSON.parse(localStorage.getItem('orders')) || []);

  const totalRevenue = computed(() => 
    orders.value.reduce((sum, order) => sum + order.total, 0)
  );

  function createOrder(customerData, cartItems, total) {
    const newOrder = {
      id: `ORD-${Date.now()}`, // ID Unik
      customer: customerData,
      items: cartItems,
      total: total,
      status: 'Pending', // Pending | Processed | Completed
      timestamp: new Date().toISOString(), // Waktu mentah
      displayDate: new Date().toLocaleString('id-ID', { 
        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', 
        hour: '2-digit', minute: '2-digit' 
      }) // Waktu cantik (Senin, 26 Nov 2025 14:30)
    };

    orders.value.unshift(newOrder); // Masukin ke paling atas
    save();
  }

  function updateStatus(orderId, status) {
    const order = orders.value.find(o => o.id === orderId);
    if (order) {
      order.status = status;
      save();
    }
  }

  function deleteOrder(orderId) {
    orders.value = orders.value.filter(o => o.id !== orderId);
    save();
  }

  function save() { localStorage.setItem('orders', JSON.stringify(orders.value)); }

  return { orders, totalRevenue, createOrder, updateStatus, deleteOrder };
});