<template>
  <div class="login-page">
    <div class="login-container">
      <div class="login-card">
        <!-- Brand Header -->
        <div class="login-header">
          <div class="brand-logo">🍫</div>
          <h1 class="brand-title">My Brownies<br/>Telaga Kahuripan</h1>
          <p class="brand-subtitle">Admin Panel Login</p>
        </div>

        <!-- Login Form -->
        <form @submit.prevent="handleLogin" class="login-form">
          <div class="form-group">
            <label for="username">Username</label>
            <div class="input-wrapper">
              <span class="input-icon">👤</span>
              <input 
                id="username"
                v-model="username" 
                type="text" 
                placeholder="admin" 
                required
                autocomplete="username"
              >
            </div>
          </div>

          <div class="form-group">
            <label for="password">Password</label>
            <div class="input-wrapper">
              <span class="input-icon">🔒</span>
              <input 
                id="password"
                v-model="password" 
                type="password" 
                placeholder="••••••••" 
                required
                autocomplete="current-password"
              >
            </div>
          </div>

          <button type="submit" class="btn-login" :disabled="loading">
            <span v-if="loading">⏳ Memproses...</span>
            <span v-else>
              <span class="btn-icon">🔑</span>
              Login ke Admin Panel
            </span>
          </button>
        </form>

        <!-- Info Footer -->
        <div class="login-footer">
          <p class="info-text">
            <span class="info-icon">ℹ️</span>
            Hanya admin yang memiliki akses ke panel ini
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../../stores/auth';

const router = useRouter();
const auth = useAuthStore();

const username = ref('');
const password = ref('');
const loading = ref(false);

function handleLogin() {
  loading.value = true;
  
  const success = auth.login(username.value, password.value);
  
  if (success) {
    router.push('/admin');
  } else {
    alert('Login gagal! Username atau password salah');
  }
  
  loading.value = false;
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #6B3410 0%, #8B4513 50%, #A0522D 100%);
  padding: 2rem;
}

.login-container {
  width: 100%;
  max-width: 450px;
}

.login-card {
  background: white;
  border-radius: 24px;
  padding: 3rem;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

/* ========================================
   LOGIN HEADER
   ======================================== */
.login-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.brand-logo {
  font-size: 4rem;
  margin-bottom: 1rem;
  filter: drop-shadow(0 4px 8px rgba(139, 69, 19, 0.3));
}

.brand-title {
  font-size: 1.75rem;
  color: #2D1810;
  margin-bottom: 0.5rem;
  line-height: 1.2;
  font-weight: 800;
  background: linear-gradient(135deg, #8B4513 0%, #6B3410 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.brand-subtitle {
  color: #6B4423;
  font-size: 1rem;
  font-weight: 600;
}

/* ========================================
   LOGIN FORM
   ======================================== */
.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
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

.input-wrapper {
  position: relative;
}

.input-icon {
  position: absolute;
  left: 1.25rem;
  top: 50%;
  transform: translateY(-50%);
  font-size: 1.25rem;
  opacity: 0.6;
  pointer-events: none;
}

.input-wrapper input {
  width: 100%;
  padding: 1rem 1.25rem 1rem 3.5rem;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.25s;
  background: white;
}

.input-wrapper input:focus {
  border-color: #8B4513;
  box-shadow: 0 0 0 4px rgba(139, 69, 19, 0.1);
  outline: none;
}

.btn-login {
  width: 100%;
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
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.btn-login:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(139, 69, 19, 0.4);
}

.btn-login:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.btn-icon {
  font-size: 1.1rem;
}

/* ========================================
   LOGIN FOOTER
   ======================================== */
.login-footer {
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 2px solid rgba(139, 69, 19, 0.1);
}

.info-text {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  color: #9C7A5C;
  font-size: 0.9rem;
  text-align: center;
}

.info-icon {
  font-size: 1.1rem;
}

/* ========================================
   RESPONSIVE
   ======================================== */
@media (max-width: 480px) {
  .login-card {
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