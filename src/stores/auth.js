import { defineStore } from 'pinia';
import { ref } from 'vue';

// Perhatikan kata "export" di depan const ini. Ini WAJIB ada.
export const useAuthStore = defineStore('auth', () => {
  const user = ref(localStorage.getItem('user'));

  function login(username, password) {
    if (username === 'admin' && password === 'admin123') {
      user.value = username;
      localStorage.setItem('user', username);
      return true;
    }
    return false;
  }

  function logout() {
    user.value = null;
    localStorage.removeItem('user');
    window.location.href = '/'; 
  }

  return { user, login, logout };
});