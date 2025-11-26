import { defineStore } from 'pinia';
import { ref } from 'vue';
import { supabase } from '../supabase'; // Import koneksi db

export const useProductStore = defineStore('products', () => {
  const products = ref([]);
  const toppings = ref([
    { id: 't1', name: 'Extra Cheese', price: 5000 },
    { id: 't2', name: 'Almond Slice', price: 5000 }
  ]);

  // 1. FUNGSI AMBIL DATA DARI SUPABASE
  async function fetchProducts() {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .order('id', { ascending: true });
      
    if (data) products.value = data;
    if (error) console.error(error);
  }

  // 2. KURANGI STOK REALTIME
  async function decreaseStock(productId, quantity) {
    // Ambil stok lama dulu
    const { data: currentProduct } = await supabase
      .from('products')
      .select('stock')
      .eq('id', productId)
      .single();

    if (currentProduct) {
      const newStock = Math.max(0, currentProduct.stock - quantity);
      
      // Update ke database
      await supabase
        .from('products')
        .update({ stock: newStock })
        .eq('id', productId);
        
      // Refresh data lokal biar sinkron
      fetchProducts(); 
    }
  }

  // Initial Fetch pas aplikasi jalan
  fetchProducts();

  // (Fitur Add/Delete produk di admin nanti lu update sendiri polanya sama kayak fetch)
  // Biar simple, admin products kita skip dulu editnya, fokus ke Stok & Order dulu.

  return { products, toppings, fetchProducts, decreaseStock };
});