<template>
  <div>
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索昵称/手机/openid" clearable style="width: 260px" @keyup.enter="load" />
      <el-button type="primary" @click="load">查询</el-button>
    </div>
    <el-table :data="list" v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="nickname" label="昵称" />
      <el-table-column prop="phone" label="手机" />
      <el-table-column prop="openid" label="OpenID" show-overflow-tooltip />
      <el-table-column prop="userType" label="类型" width="100" />
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">{{ row.status === 1 ? '正常' : '禁用' }}</template>
      </el-table-column>
      <el-table-column label="操作" width="100">
        <template #default="{ row }">
          <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      class="pager"
      layout="total, prev, pager, next"
      :total="total"
      v-model:current-page="page"
      :page-size="pageSize"
      @current-change="load"
    />

    <el-dialog v-model="dialogVisible" title="编辑用户" width="480px">
      <el-form label-width="80px">
        <el-form-item label="昵称"><el-input v-model="form.nickname" /></el-form-item>
        <el-form-item label="手机"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="onSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { ElMessage } from 'element-plus';
import { fetchUserPage, updateUser, type AppUserItem } from '@/api/user';

const keyword = ref('');
const list = ref<AppUserItem[]>([]);
const total = ref(0);
const page = ref(1);
const pageSize = 20;
const loading = ref(false);
const dialogVisible = ref(false);
const editingId = ref(0);
const form = reactive({ nickname: '', phone: '', status: 1 });

async function load() {
  loading.value = true;
  try {
    const res = await fetchUserPage({ keyword: keyword.value, page: page.value, pageSize });
    list.value = res.data.data.list;
    total.value = res.data.data.total;
  } finally {
    loading.value = false;
  }
}

function openEdit(row: AppUserItem) {
  editingId.value = row.id;
  form.nickname = row.nickname || '';
  form.phone = row.phone || '';
  form.status = row.status;
  dialogVisible.value = true;
}

async function onSave() {
  await updateUser(editingId.value, { ...form });
  ElMessage.success('已保存');
  dialogVisible.value = false;
  await load();
}

onMounted(load);
</script>

<style scoped>
.toolbar {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}
.pager {
  margin-top: 16px;
  justify-content: flex-end;
}
</style>
