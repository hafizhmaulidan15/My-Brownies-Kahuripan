import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './assets/main.css' // CSS design kita
import App from './App.vue'
import router from './router' // Router navigasi

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')