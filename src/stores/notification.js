// src/stores/notification.js
import { defineStore } from 'pinia';
import { ref } from 'vue';

export const useNotificationStore = defineStore('notification', () => {
  const message = ref('');
  const show = ref(false);
  const type = ref('success'); // success | error

  function showToast(msg, msgType = 'success') {
    message.value = msg;
    type.value = msgType;
    show.value = true;

    // Otomatis ilang setelah 3 detik
    setTimeout(() => {
      show.value = false;
    }, 3000);
  }

  return { message, show, type, showToast };
});