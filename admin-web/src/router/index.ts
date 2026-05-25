import { createRouter, createWebHistory } from 'vue-router';
import AdminLayout from '@/layouts/AdminLayout.vue';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: () => import('@/views/LoginView.vue'),
      meta: { public: true },
    },
    {
      path: '/',
      component: AdminLayout,
      children: [
        { path: '', name: 'home', component: () => import('@/views/HomeView.vue') },
        { path: 'upload-demo', name: 'upload-demo', component: () => import('@/views/UploadDemoView.vue') },
      ],
    },
  ],
});

router.beforeEach((to, _from, next) => {
  if (to.meta.public) {
    next();
    return;
  }
  const token = localStorage.getItem('tcm_admin_token');
  if (!token && to.path !== '/login') {
    next('/login');
    return;
  }
  next();
});

export default router;
