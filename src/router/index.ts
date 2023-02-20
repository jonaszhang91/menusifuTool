
import { createRouter,createWebHistory } from "vue-router";
import HelloWorld from '../components/HelloWorld.vue';
import Header from '../components/Header.vue'

const routes:any = [
    {
        path: '/',
        component:HelloWorld
    },
    {
        path: '/test',
        component:Header
    }
]

const router = createRouter(
    {
        history: createWebHistory(),
        routes
    }
)
export default router