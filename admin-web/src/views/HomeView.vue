<template>
  <el-card>
    <template #header>工程基座联调</template>
    <p>API 健康检查：<el-tag :type="healthOk ? 'success' : 'danger'">{{ healthText }}</el-tag></p>
    <p v-if="traceId">traceId：{{ traceId }}</p>
    <el-button type="primary" @click="checkHealth">检测 /actuator/health</el-button>
  </el-card>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import request, { type ApiResult } from '@/utils/request';

const healthOk = ref(false);
const healthText = ref('未检测');
const traceId = ref('');

async function checkHealth() {
  try {
    const res = await request.get('/actuator/health');
    healthOk.value = res.data?.status === 'UP';
    healthText.value = healthOk.value ? 'UP' : JSON.stringify(res.data);
    const enums = await request.get<ApiResult>('/api/common/v1/enums');
    traceId.value = enums.data.traceId || '';
  } catch {
    healthOk.value = false;
    healthText.value = '不可用（请先启动 api-server + docker compose）';
  }
}
</script>
