<template>
  <Transition name="toast">
    <div v-if="notify.show" class="toast-card">
      <div class="toast-icon">
        {{ notify.type === 'success' ? '✅' : '⚠️' }}
      </div>
      <div class="toast-content">
        <p class="toast-msg">{{ notify.message }}</p>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { useNotificationStore } from '../stores/notification';
const notify = useNotificationStore();
</script>

<style scoped>
.toast-card {
  position: fixed;
  top: 20px;
  right: 20px; /* Muncul di pojok kanan atas */
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(12px); /* Efek Glass */
  border: 1px solid rgba(255, 255, 255, 0.6);
  padding: 1rem 1.5rem;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
  display: flex;
  align-items: center;
  gap: 12px;
  z-index: 9999;
  min-width: 300px;
}

.toast-msg {
  color: #1f2937;
  font-weight: 600;
  font-size: 0.95rem;
  margin: 0;
}

/* Animasi Slide Masuk & Keluar */
.toast-enter-active,
.toast-leave-active {
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); /* Efek Bouncier */
}

.toast-enter-from,
.toast-leave-to {
  opacity: 0;
  transform: translateX(50px) scale(0.9);
}
</style>