<template>
  <div class="container" style="max-width: 400px; margin-top: 5rem;">
    <div class="card">
      <h2 style="margin-bottom: 1.5rem; text-align: center;">Admin Login</h2>
      <form @submit.prevent="handleLogin">
        <div style="margin-bottom: 1rem;">
          <input v-model="username" placeholder="Username (admin)" required style="width: 100%;">
        </div>
        <div style="margin-bottom: 1rem;">
          <input v-model="password" type="password" placeholder="Password (admin123)" required style="width: 100%;">
        </div>
        <button type="submit" class="btn btn-primary" style="width: 100%;">Login Masuk</button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useAuthStore } from '../../stores/auth';
import { useRouter } from 'vue-router';

const auth = useAuthStore();
const router = useRouter();
const username = ref('');
const password = ref('');

const handleLogin = () => {
  // Hardcode credential: user=admin, pass=admin123
  if (auth.login(username.value, password.value)) {
    router.push('/admin');
  } else {
    alert('Username atau Password salah bro!');
  }
};
</script>