<template>
  <div class="auth-page">
    <div class="container">
      <div class="auth-card">
        <!-- Header -->
        <div class="auth-header">
          <div class="brand-logo">🍫</div>
          <h1 class="brand-title">My Brownies Telaga Kahuripan</h1>
          <p class="auth-subtitle">{{ isLogin ? 'Login ke Akun Anda' : 'Daftar Akun Baru' }}</p>
        </div>

        <!-- Toggle Tabs -->
        <div class="auth-tabs">
          <button 
            @click="isLogin = true" 
            :class="['tab', { active: isLogin }]"
          >
            Login
          </button>
          <button 
            @click="isLogin = false" 
            :class="['tab', { active: !isLogin }]"
          >
            Daftar
          </button>
        </div>

        <!-- Login Form -->
        <form v-if="isLogin" @submit.prevent="handleLogin" class="auth-form">
          <div class="form-group">
            <label>Email</label>
            <input 
              v-model="loginData.email" 
              type="email" 
              placeholder="email@example.com"
              required
            >
          </div>

          <div class="form-group">
            <label>Password</label>
            <input 
              v-model="loginData.password" 
              type="password" 
              placeholder="••••••••"
              required
            >
          </div>

          <button type="submit" class="btn-submit" :disabled="loading">
            {{ loading ? '⏳ Memproses...' : '🔑 Login' }}
          </button>
        </form>

        <!-- Register Form -->
        <form v-else @submit.prevent="handleRegister" class="auth-form">
          <div class="form-group">
            <label>Nama Lengkap</label>
            <input 
              v-model="registerData.name" 
              type="text" 
              placeholder="Nama Anda"
              required
            >
          </div>

          <div class="form-group">
            <label>Email</label>
            <input 
              v-model="registerData.email" 
              type="email" 
              placeholder="email@example.com"
              required
            >
          </div>

          <div class="form-group">
            <label>No. Telepon</label>
            <input 
              v-model="registerData.phone" 
              type="tel" 
              placeholder="08123456789"
              required
            >
          </div>

          <div class="form-group">
            <label>Alamat Lengkap</label>
            <textarea 
              v-model="registerData.address" 
              placeholder="Jl. Contoh No. 123, Telaga Kahuripan, Bogor"
              rows="3"
              required
            ></textarea>
            <small class="help-text">
              📍 Masukkan alamat lengkap untuk pengiriman
            </small>
          </div>

          <div class="form-group">
            <label>Password</label>
            <input 
              v-model="registerData.password" 
              type="password" 
              placeholder="Minimal 6 karakter"
              required
              minlength="6"
            >
          </div>

          <div class="form-group">
            <label>Konfirmasi Password</label>
            <input 
              v-model="registerData.confirmPassword" 
              type="password" 
              placeholder="Ulangi password"
              required
            >
          </div>

          <button type="submit" class="btn-submit" :disabled="loading">
            {{ loading ? '⏳ Memproses...' : '✨ Daftar Sekarang' }}
          </button>
        </form>

        <!-- Back to Home -->
        <div class="auth-footer">
          <router-link to="/" class="back-link">
            ← Kembali ke Beranda
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useCustomerAuthStore } from '../stores/customerAuth';
import { useNotificationStore } from '../stores/notification';

const router = useRouter();
const customerAuth = useCustomerAuthStore();
const notify = useNotificationStore();

const isLogin = ref(true);
const loading = ref(false);

const loginData = ref({
  email: '',
  password: ''
});

const registerData = ref({
  name: '',
  email: '',
  phone: '',
  address: '',
  password: '',
  confirmPassword: ''
});

async function handleLogin() {
  loading.value = true;
  
  const result = await customerAuth.login(loginData.value.email, loginData.value.password);
  
  if (result.success) {
    notify.showToast(`Selamat datang, ${result.customer.name}! 👋`, 'success');
    router.push('/');
  } else {
    notify.showToast(result.error || 'Login gagal!', 'error');
  }
  
  loading.value = false;
}

async function handleRegister() {
  // Validate password match
  if (registerData.value.password !== registerData.value.confirmPassword) {
    notify.showToast('Password tidak cocok!', 'error');
    return;
  }

  loading.value = true;
  
  const result = await customerAuth.register(registerData.value);
  
  if (result.success) {
    notify.showToast(`Pendaftaran berhasil! Selamat datang, ${result.customer.name}! 🎉`, 'success');
    
    // Auto redirect to home after 1 second
    setTimeout(() => {
      router.push('/');
    }, 1000);
  } else {
    notify.showToast(result.error || 'Pendaftaran gagal!', 'error');
  }
  
  loading.value = false;
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #6B3410 0%, #8B4513 50%, #A0522D 100%);
  padding: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.auth-card {
  background: white;
  border-radius: 24px;
  padding: 3rem;
  max-width: 550px;
  width: 100%;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

/* Header */
.auth-header {
  text-align: center;
  margin-bottom: 2rem;
}

.brand-logo {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.brand-title {
  font-size: 1.75rem;
  color: #2D1810;
  margin-bottom: 0.5rem;
  font-weight: 800;
  background: linear-gradient(135deg, #8B4513 0%, #6B3410 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.auth-subtitle {
  color: #6B4423;
  font-size: 1rem;
  font-weight: 600;
}

/* Tabs */
.auth-tabs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 2rem;
}

.tab {
  padding: 1rem;
  border: 2px solid #E5E7EB;
  background: white;
  border-radius: 12px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.25s;
  color: #6B4423;
}

.tab:hover {
  border-color: #8B4513;
}

.tab.active {
  background: linear-gradient(135deg, #8B4513 0%, #6B3410 100%);
  border-color: #8B4513;
  color: white;
}

/* Form */
.auth-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 700;
  color: #2D1810;
  font-size: 0.95rem;
}

.form-group input,
.form-group textarea {
  padding: 1rem;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.25s;
  font-family: inherit;
}

.form-group input:focus,
.form-group textarea:focus {
  border-color: #8B4513;
  box-shadow: 0 0 0 4px rgba(139, 69, 19, 0.1);
  outline: none;
}

.help-text {
  color: #d97706;
  font-size: 0.85rem;
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.btn-submit {
  padding: 1.25rem;
  background: linear-gradient(135deg, #8B4513 0%, #6B3410 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-weight: 700;
  font-size: 1.05rem;
  cursor: pointer;
  transition: all 0.25s;
  margin-top: 0.5rem;
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

.btn-submit:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(139, 69, 19, 0.4);
}

.btn-submit:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

/* Footer */
.auth-footer {
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 2px solid rgba(139, 69, 19, 0.1);
  text-align: center;
}

.back-link {
  color: #8B4513;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.25s;
}

.back-link:hover {
  color: #6B3410;
}

/* Responsive */
@media (max-width: 480px) {
  .auth-card {
    padding: 2rem 1.5rem;
  }
  
  .brand-logo {
    font-size: 3.5rem;
  }
  
  .brand-title {
    font-size: 1.5rem;
  }
}
</style>
