import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import './style.css'
import App from './App.vue'
import './assets/reset.css'
import router from './router/index'
const app = createApp(App)
app.use(router).use(ElementPlus)

app.mount('#app')

