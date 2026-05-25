<template>
  <el-container class="layout">
    <el-aside width="220px" class="aside">
      <div class="logo">江苏中医在线</div>
      <el-menu router :default-active="route.path">
        <el-menu-item index="/">基座首页</el-menu-item>
        <el-menu-item index="/upload-demo">上传联调</el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <span>管理端（模块 00 壳）</span>
        <el-button link type="primary" @click="logout">退出</el-button>
      </el-header>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();

function logout() {
  localStorage.removeItem('tcm_admin_token');
  router.push('/login');
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
