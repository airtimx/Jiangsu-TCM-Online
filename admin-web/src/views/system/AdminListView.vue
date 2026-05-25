<template>
  <div>
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索账号/姓名" clearable style="width: 240px" @keyup.enter="load" />
      <el-button type="primary" @click="openCreate">新建管理员</el-button>
    </div>
    <el-table :data="list" v-loading="loading" border>
      <el-table-column prop="username" label="账号" />
      <el-table-column prop="realName" label="姓名" />
      <el-table-column prop="roleCodes" label="角色">
        <template #default="{ row }">{{ row.roleCodes?.join(', ') }}</template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">{{ row.status === 1 ? '启用' : '禁用' }}</template>
      </el-table-column>
      <el-table-column label="操作" width="160">
        <template #default="{ row }">
          <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
          <el-button link type="danger" @click="onDelete(row.id)">删除</el-button>
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

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑管理员' : '新建管理员'" width="520px">
      <el-form label-width="90px">
        <el-form-item label="账号"><el-input v-model="form.username" /></el-form-item>
        <el-form-item :label="editingId ? '新密码' : '密码'">
          <el-input v-model="form.password" type="password" show-password :placeholder="editingId ? '留空则不修改' : ''" />
        </el-form-item>
        <el-form-item label="姓名"><el-input v-model="form.realName" /></el-form-item>
        <el-form-item label="角色">
          <el-select v-model="form.roleIds" multiple style="width: 100%">
            <el-option v-for="r in roles" :key="r.id" :label="r.name" :value="r.id" />
          </el-select>
        </el-form-item>
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
import { ElMessage, ElMessageBox } from 'element-plus';
import { createAdmin, deleteAdmin, fetchAdminPage, updateAdmin, type AdminItem } from '@/api/admin';
import { fetchAllRoles, type RoleItem } from '@/api/role';

const keyword = ref('');
const list = ref<AdminItem[]>([]);
const total = ref(0);
const page = ref(1);
const pageSize = 20;
const loading = ref(false);
const roles = ref<RoleItem[]>([]);
const dialogVisible = ref(false);
const editingId = ref<number | null>(null);
const form = reactive({
  username: '',
  password: '',
  realName: '',
  status: 1,
  roleIds: [] as number[],
});

async function load() {
  loading.value = true;
  try {
    const res = await fetchAdminPage({ keyword: keyword.value, page: page.value, pageSize });
    list.value = res.data.data.list;
    total.value = res.data.data.total;
  } finally {
    loading.value = false;
  }
}

function openCreate() {
  editingId.value = null;
  form.username = '';
  form.password = '';
  form.realName = '';
  form.status = 1;
  form.roleIds = [];
  dialogVisible.value = true;
}

function openEdit(row: AdminItem) {
  editingId.value = row.id;
  form.username = row.username;
  form.password = '';
  form.realName = row.realName || '';
  form.status = row.status;
  form.roleIds = roles.value.filter((r) => row.roleCodes.includes(r.code)).map((r) => r.id);
  dialogVisible.value = true;
}

async function onSave() {
  const payload = {
    username: form.username,
    password: form.password || undefined,
    realName: form.realName,
    status: form.status,
    roleIds: form.roleIds,
  };
  if (editingId.value) {
    await updateAdmin(editingId.value, payload);
    ElMessage.success('已更新');
  } else {
    await createAdmin(payload);
    ElMessage.success('已创建');
  }
  dialogVisible.value = false;
  await load();
}

async function onDelete(id: number) {
  await ElMessageBox.confirm('确认删除该管理员？', '提示', { type: 'warning' });
  await deleteAdmin(id);
  ElMessage.success('已删除');
  await load();
}

onMounted(async () => {
  const roleRes = await fetchAllRoles();
  roles.value = roleRes.data.data;
  await load();
});
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
