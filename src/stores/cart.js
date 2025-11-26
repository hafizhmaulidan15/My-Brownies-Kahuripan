// src/stores/cart.js
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useCartStore = defineStore('cart', () => {
  const items = ref(JSON.parse(localStorage.getItem('cart')) || []);

  const total = computed(() => items.value.reduce((sum, item) => sum + (item.totalPrice * item.quantity), 0));
  const count = computed(() => items.value.reduce((sum, item) => sum + item.quantity, 0));

  function addToCart(product, selectedToppings = []) {
    const toppingPrice = selectedToppings.reduce((sum, t) => sum + t.price, 0);
    const finalPrice = product.price + toppingPrice;

    items.value.push({
      cartId: Date.now(),
      ...product,
      selectedToppings: selectedToppings,
      totalPrice: finalPrice,
      quantity: 1
    });
    save();
  }

  function removeFromCart(cartId) {
    items.value = items.value.filter(i => i.cartId !== cartId);
    save();
  }

  // --- INI FUNGSI PENTING BUAT CHECKOUT ---
  function clearCart() {
    items.value = [];
    save();
  }

  function save() { localStorage.setItem('cart', JSON.stringify(items.value)); }

  // Jangan lupa export clearCart disini
  return { items, addToCart, removeFromCart, clearCart, total, count };
});