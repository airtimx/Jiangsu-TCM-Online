<template>
  <section class="home">
    <h1>江苏中医在线</h1>
    <p class="lead">官方网站 · Nuxt 3 网页端（`jiangsu-tcm-web`）</p>

    <div class="status-card">
      <h2>后端联调</h2>
      <p>Health：<strong>{{ healthStatus }}</strong></p>
      <p>Enums API：<strong>{{ apiStatus }}</strong></p>
      <p v-if="traceId" class="trace">traceId：{{ traceId }}</p>
      <button type="button" class="btn" @click="refresh">重新检测</button>
    </div>

    <p class="hint">业务页面由模块 <strong>16 官网展示</strong> 扩展；API 前缀一期为 <code>/api/web/v1/*</code>（公开读）。</p>
  </section>
</template>

<script setup lang="ts">
const { fetchEnums, checkHealth } = useWebApi();
const healthStatus = ref('未检测');
const apiStatus = ref('未检测');
const traceId = ref('');

async function refresh() {
  try {
    const health = await checkHealth();
    healthStatus.value = health.status === 'UP' ? 'UP' : JSON.stringify(health);
  } catch {
    healthStatus.value = '不可用';
  }
  try {
    const res = await fetchEnums();
    apiStatus.value = '正常';
    traceId.value = res.traceId || '';
  } catch {
    apiStatus.value = '不可用';
    traceId.value = '';
  }
}

onMounted(refresh);
</script>

<style scoped>
.home {
  max-width: 640px;
}
h1 {
  margin: 0 0 8px;
  font-size: 28px;
}
.lead {
  color: var(--color-muted);
  margin: 0 0 24px;
}
.status-card {
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 24px;
}
.status-card h2 {
  margin: 0 0 12px;
  font-size: 16px;
}
.trace {
  font-size: 13px;
  color: var(--color-muted);
  word-break: break-all;
}
.btn {
  margin-top: 12px;
  padding: 8px 16px;
  background: var(--color-primary);
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.btn:hover {
  opacity: 0.9;
}
.hint {
  font-size: 14px;
  color: var(--color-muted);
}
code {
  font-size: 13px;
}
</style>
