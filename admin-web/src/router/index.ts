import { createRouter, createWebHistory } from 'vue-router';
import AdminLayout from '@/layouts/AdminLayout.vue';
import { getToken, hasPermission } from '@/utils/auth';

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
      path: '/403',
      name: 'forbidden',
      component: () => import('@/views/ForbiddenView.vue'),
      meta: { public: true },
    },
    {
      path: '/',
      component: AdminLayout,
      children: [
        { path: '', name: 'home', component: () => import('@/views/HomeView.vue') },
        { path: 'account', redirect: '/account/users' },
        { path: 'system', redirect: '/system/admins' },
        {
          path: 'upload-demo',
          name: 'upload-demo',
          component: () => import('@/views/UploadDemoView.vue'),
          meta: { permission: 'system:upload:demo' },
        },
        {
          path: 'account/users',
          name: 'account-users',
          component: () => import('@/views/account/UserListView.vue'),
          meta: { permission: 'account:user:list' },
        },
        {
          path: 'account/students',
          name: 'account-students',
          component: () => import('@/views/account/StudentListView.vue'),
          meta: { permission: 'account:student:list' },
        },
        {
          path: 'system/admins',
          name: 'system-admins',
          component: () => import('@/views/system/AdminListView.vue'),
          meta: { permission: 'system:admin:list' },
        },
        {
          path: 'system/roles',
          name: 'system-roles',
          component: () => import('@/views/system/RoleListView.vue'),
          meta: { permission: 'system:role:list' },
        },
      ],
    },
  ],
});

router.beforeEach((to, _from, next) => {
  if (to.meta.public) {
    next();
    return;
  }
  if (!getToken()) {
    next('/login');
    return;
  }
  const permission = to.meta.permission as string | undefined;
  if (permission && !hasPermission(permission)) {
    next('/403');
    return;
  }
  next();
});

export default router;
