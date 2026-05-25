<template>
  <div class="login-wrap">
    <el-card class="login-card">
      <h2>管理端登录</h2>
      <p class="hint">模块 01 · 默认账号 admin / admin123456</p>
      <el-form @submit.prevent="onSubmit">
        <el-form-item label="账号">
          <el-input v-model="username" placeholder="admin" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="password" type="password" placeholder="admin123456" show-password />
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="remember">记住账号</el-checkbox>
        </el-form-item>
        <el-button type="primary" native-type="submit" style="width: 100%" :loading="loading">登录</el-button>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import { loginApi } from '@/api/auth';
import { getRememberedUsername, rememberUsername, setSession } from '@/utils/auth';

const router = useRouter();
const username = ref('');
const password = ref('');
const remember = ref(true);
const loading = ref(false);

onMounted(() => {
  username.value = getRememberedUsername() || 'admin';
});

async function onSubmit() {
  loading.value = true;
  try {
    const res = await loginApi({ username: username.value, password: password.value });
    const data = res.data.data;
    if (remember.value) {
      rememberUsername(username.value);
    }
    setSession(data.accessToken, data.refreshToken, data.admin, data.menus);
    router.push('/');
  } finally {
    loading.value = false;
  }
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
