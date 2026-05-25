<template>
  <div>
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索角色" clearable style="width: 240px" @keyup.enter="load" />
    </div>
    <el-table :data="list" v-loading="loading" border>
      <el-table-column prop="code" label="编码" />
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="description" label="说明" />
      <el-table-column label="操作" width="120">
        <template #default="{ row }">
          <el-button link type="primary" @click="openPerm(row)">配置权限</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="permVisible" :title="`权限配置 - ${currentRole?.name}`" width="480px">
      <el-tree
        ref="treeRef"
        :data="permTree"
        node-key="id"
        show-checkbox
        default-expand-all
        :props="{ label: 'name', children: 'children' }"
      />
      <template #footer>
        <el-button @click="permVisible = false">取消</el-button>
        <el-button type="primary" @click="savePerm">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { ElMessage } from 'element-plus';
import type { ElTree } from 'element-plus';
import {
  fetchPermissionTree,
  fetchRolePage,
  fetchRolePermissions,
  updateRolePermissions,
  type PermissionTreeNode,
  type RoleItem,
} from '@/api/role';

const keyword = ref('');
const list = ref<RoleItem[]>([]);
const loading = ref(false);
const permVisible = ref(false);
const permTree = ref<PermissionTreeNode[]>([]);
const currentRole = ref<RoleItem | null>(null);
const treeRef = ref<InstanceType<typeof ElTree>>();

async function load() {
  loading.value = true;
  try {
    const res = await fetchRolePage({ keyword: keyword.value, page: 1, pageSize: 50 });
    list.value = res.data.data.list;
  } finally {
    loading.value = false;
  }
}

async function openPerm(row: RoleItem) {
  currentRole.value = row;
  const [treeRes, checkedRes] = await Promise.all([
    fetchPermissionTree(),
    fetchRolePermissions(row.id),
  ]);
  permTree.value = treeRes.data.data;
  permVisible.value = true;
  setTimeout(() => {
    treeRef.value?.setCheckedKeys(checkedRes.data.data, false);
  }, 0);
}

async function savePerm() {
  if (!currentRole.value || !treeRef.value) {
    return;
  }
  const checked = treeRef.value.getCheckedKeys(false) as number[];
  const half = treeRef.value.getHalfCheckedKeys() as number[];
  await updateRolePermissions(currentRole.value.id, [...checked, ...half]);
  ElMessage.success('权限已更新');
  permVisible.value = false;
}

onMounted(load);
</script>

<style scoped>
.toolbar {
  margin-bottom: 16px;
}
</style>
