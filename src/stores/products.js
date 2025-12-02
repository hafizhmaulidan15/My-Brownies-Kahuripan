import { defineStore } from 'pinia';
import { ref } from 'vue';
import { supabase } from '../supabase'; // Import koneksi db

export const useProductStore = defineStore('products', () => {
  const products = ref([]);
  const toppings = ref([]);

  // 1. FUNGSI AMBIL DATA PRODUK DARI SUPABASE
  async function fetchProducts() {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .order('id', { ascending: true });

    if (data) products.value = data;
    if (error) console.error('Error fetching products:', error);
  }

  // 2. FUNGSI AMBIL DATA TOPPING DARI SUPABASE
  async function fetchToppings() {
    const { data, error } = await supabase
      .from('toppings')
      .select('*')
      .order('id', { ascending: true });

    if (data) toppings.value = data;
    if (error) console.error('Error fetching toppings:', error);
  }

  // 3. TAMBAH PRODUK BARU (CREATE)
  async function addProduct(product) {
    const { data, error } = await supabase
      .from('products')
      .insert([{
        name: product.name,
        price: product.price,
        category: product.category,
        stock: product.stock,
        image: product.image || 'https://placehold.co/400x400'
      }])
      .select();

    if (error) {
      console.error('Error adding product:', error);
      alert('Gagal menambahkan produk!');
    } else {
      alert('Produk berhasil ditambahkan!');
      fetchProducts(); // Refresh data
    }
  }

  // 4. UPDATE PRODUK (UPDATE)
  async function updateProduct(id, updatedProduct) {
    const { error } = await supabase
      .from('products')
      .update({
        name: updatedProduct.name,
        price: updatedProduct.price,
        category: updatedProduct.category,
        stock: updatedProduct.stock,
        image: updatedProduct.image
      })
      .eq('id', id);

    if (error) {
      console.error('Error updating product:', error);
      alert('Gagal mengupdate produk!');
    } else {
      alert('Produk berhasil diupdate!');
      fetchProducts(); // Refresh data
    }
  }

  // 5. HAPUS PRODUK (DELETE)
  async function deleteProduct(id) {
    if (!confirm('Yakin ingin menghapus produk ini?')) return;

    const { error } = await supabase
      .from('products')
      .delete()
      .eq('id', id);

    if (error) {
      console.error('Error deleting product:', error);
      alert('Gagal menghapus produk!');
    } else {
      alert('Produk berhasil dihapus!');
      fetchProducts(); // Refresh data
    }
  }

  // 6. KURANGI STOK REALTIME
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

  // 7. TAMBAH TOPPING BARU
  async function addTopping(topping) {
    const { error } = await supabase
      .from('toppings')
      .insert([{
        name: topping.name,
        price: topping.price || 0
      }]);

    if (error) {
      console.error('Error adding topping:', error);
      alert('Gagal menambahkan topping!');
    } else {
      alert('Topping berhasil ditambahkan!');
      fetchToppings(); // Refresh data
    }
  }

  // 8. HAPUS TOPPING
  async function deleteTopping(id) {
    if (!confirm('Yakin ingin menghapus topping ini?')) return;

    const { error } = await supabase
      .from('toppings')
      .delete()
      .eq('id', id);

    if (error) {
      console.error('Error deleting topping:', error);
      alert('Gagal menghapus topping!');
    } else {
      alert('Topping berhasil dihapus!');
      fetchToppings(); // Refresh data
    }
  }

  // Initial Fetch pas aplikasi jalan
  fetchProducts();
  fetchToppings();

  return {
    products,
    toppings,
    fetchProducts,
    fetchToppings,
    addProduct,
    updateProduct,
    deleteProduct,
    decreaseStock,
    addTopping,
    deleteTopping
  };
});