// src/stores/products.js
import { defineStore } from 'pinia';
import { ref } from 'vue';

export const useProductStore = defineStore('products', () => {
  // Data Brownies dengan Stok
  // Kita kasih default stock: 20 buat data lama
  const products = ref(JSON.parse(localStorage.getItem('products_data')) || [
    { id: 1, name: 'Fudgy Choco Melt', price: 45000, category: 'Best Seller', stock: 15, image: 'https://placehold.co/400x400/3e2723/FFF?text=Fudgy' },
    { id: 2, name: 'Red Velvet Cheese', price: 55000, category: 'Special', stock: 5, image: 'https://placehold.co/400x400/b71c1c/FFF?text=Red+Velvet' }, // Stok dikit biar keliatan urgency
    { id: 3, name: 'Matcha Green Tea', price: 52000, category: 'Japanese', stock: 0, image: 'https://placehold.co/400x400/33691e/FFF?text=Matcha' } // Stok 0 buat tes Sold Out
  ]);

  const toppings = ref(JSON.parse(localStorage.getItem('toppings_data')) || [
    { id: 't1', name: 'Extra Cheese', price: 5000 },
    { id: 't2', name: 'Almond Slice', price: 5000 }
  ]);

  // --- ACTIONS PRODUCT ---
  function addProduct(item) {
    // Pastiin ada stok pas nambah baru
    products.value.push({ ...item, id: Date.now(), stock: parseInt(item.stock) || 0 });
    save();
  }

  function deleteProduct(id) {
    products.value = products.value.filter(p => p.id !== id);
    save();
  }

  // FUNGSI BARU: Kurangi Stok
  function decreaseStock(productId, quantity) {
    const product = products.value.find(p => p.id === productId);
    if (product) {
      product.stock -= quantity;
      if (product.stock < 0) product.stock = 0; // Jaga-jaga biar gak minus
      save();
    }
  }

  // --- ACTIONS TOPPING ---
  function addTopping(item) {
    toppings.value.push({ ...item, id: `t${Date.now()}` });
    save();
  }
  function deleteTopping(id) {
    toppings.value = toppings.value.filter(t => t.id !== id);
    save();
  }

  function save() { 
    localStorage.setItem('products_data', JSON.stringify(products.value));
    localStorage.setItem('toppings_data', JSON.stringify(toppings.value));
  }

  return { products, toppings, addProduct, deleteProduct, decreaseStock, addTopping, deleteTopping };
});