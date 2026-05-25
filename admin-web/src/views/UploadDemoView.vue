<template>
  <el-card>
    <template #header>OSS 预签名上传联调（00）</template>
    <input type="file" @change="onFileChange" />
    <el-button type="primary" :loading="loading" :disabled="!file" @click="upload">上传到 MinIO</el-button>
    <p v-if="ossKey" class="ok">ossKey：{{ ossKey }}</p>
  </el-card>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { ElMessage } from 'element-plus';
import request, { type ApiResult } from '@/utils/request';

interface PresignData {
  uploadUrl: string;
  ossKey: string;
  method: string;
}

const file = ref<File | null>(null);
const loading = ref(false);
const ossKey = ref('');

function onFileChange(e: Event) {
  const input = e.target as HTMLInputElement;
  file.value = input.files?.[0] ?? null;
}

async function upload() {
  if (!file.value) {
    return;
  }
  loading.value = true;
  try {
    const name = file.value.name;
    const ext = name.includes('.') ? name.split('.').pop()!.toLowerCase() : 'bin';
    const res = await request.post<ApiResult<PresignData>>('/api/common/v1/upload/presign', {
      module: 'platform',
      fileName: `demo.${ext}`,
      contentType: file.value.type || undefined,
    });
    const data = res.data.data;
    ossKey.value = data.ossKey;
    await fetch(data.uploadUrl, {
      method: 'PUT',
      body: file.value,
      headers: { 'Content-Type': file.value.type || 'application/octet-stream' },
    });
    ElMessage.success('上传成功');
  } catch (e) {
    console.error(e);
  } finally {
    loading.value = false;
  }
}
</script>

<style scoped>
.ok {
  margin-top: 12px;
  color: #67c23a;
}
</style>
