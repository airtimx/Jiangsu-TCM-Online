<template>
  <div class="login-wrap">
    <el-card class="login-card">
      <h2>管理端登录</h2>
      <p class="hint">模块 00 占位页，不调用真实认证 API（01 模块接入）</p>
      <el-form @submit.prevent="onSubmit">
        <el-form-item label="账号">
          <el-input v-model="username" placeholder="admin" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="password" type="password" placeholder="任意" show-password />
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="remember">记住账号</el-checkbox>
        </el-form-item>
        <el-button type="primary" native-type="submit" style="width: 100%">进入系统</el-button>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const username = ref('admin');
const password = ref('');
const remember = ref(true);

function onSubmit() {
  if (remember.value) {
    localStorage.setItem('tcm_admin_username', username.value);
  }
  localStorage.setItem('tcm_admin_token', 'mock-token-00');
  router.push('/');
}
</script>

<style scoped>
.login-wrap {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f0f2f5;
}
.login-card {
  width: 400px;
}
.hint {
  color: #909399;
  font-size: 13px;
  margin-bottom: 16px;
}
</style>
