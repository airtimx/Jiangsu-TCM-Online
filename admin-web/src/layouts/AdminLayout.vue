<template>
  <el-container class="layout">
    <el-aside width="220px" class="aside">
      <div class="logo">江苏中医在线</div>
      <el-menu router :default-active="route.path">
        <template v-for="item in menus" :key="item.path">
          <el-sub-menu v-if="item.children?.length" :index="item.path">
            <template #title>{{ item.title }}</template>
            <el-menu-item v-for="child in item.children" :key="child.path" :index="child.path">
              {{ child.title }}
            </el-menu-item>
          </el-sub-menu>
          <el-menu-item v-else :index="item.path">{{ item.title }}</el-menu-item>
        </template>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <span>{{ profile?.realName || profile?.username || '管理端' }}</span>
        <el-button link type="primary" @click="onLogout">退出</el-button>
      </el-header>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { logoutApi } from '@/api/auth';
import { clearSession, getMenus, getProfile } from '@/utils/auth';

const route = useRoute();
const router = useRouter();
const menus = computed(() => getMenus());
const profile = computed(() => getProfile());

async function onLogout() {
  try {
    await logoutApi();
  } finally {
    clearSession();
    router.push('/login');
  }
}
</script>

<style scoped>
.layout {
  min-height: 100vh;
}
.aside {
  background: #304156;
  color: #fff;
}
.logo {
  height: 56px;
  line-height: 56px;
  text-align: center;
  font-weight: 600;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #ebeef5;
}
</style>
