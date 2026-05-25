<template>
  <div>
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索姓名/地区/单位" clearable style="width: 220px" @keyup.enter="load" />
      <el-select v-model="certStatus" clearable placeholder="认证状态" style="width: 140px">
        <el-option label="已认证" value="CERTIFIED" />
        <el-option label="未认证" value="UNVERIFIED" />
        <el-option label="待审核" value="PENDING" />
      </el-select>
      <el-button type="primary" @click="load">查询</el-button>
      <el-button @click="openCreate">新建</el-button>
      <el-upload :show-file-list="false" accept=".xlsx,.xls" :http-request="onImport">
        <el-button type="success">导入 Excel</el-button>
      </el-upload>
      <el-button @click="onExport">导出 Excel</el-button>
    </div>

    <el-table :data="list" v-loading="loading" border>
      <el-table-column prop="realName" label="姓名" />
      <el-table-column prop="phone" label="手机" />
      <el-table-column prop="region" label="地区" />
      <el-table-column prop="orgName" label="单位" />
      <el-table-column prop="certStatus" label="认证状态" width="110" />
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

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑学员' : '新建学员'" width="520px">
      <el-form label-width="90px">
        <el-form-item label="姓名"><el-input v-model="form.realName" /></el-form-item>
        <el-form-item label="手机"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="身份证"><el-input v-model="form.idCard" /></el-form-item>
        <el-form-item label="地区"><el-input v-model="form.region" /></el-form-item>
        <el-form-item label="单位"><el-input v-model="form.orgName" /></el-form-item>
        <el-form-item label="认证状态">
          <el-select v-model="form.certStatus" style="width: 100%">
            <el-option label="已认证" value="CERTIFIED" />
            <el-option label="未认证" value="UNVERIFIED" />
            <el-option label="待审核" value="PENDING" />
            <el-option label="已拒绝" value="REJECTED" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="onSave">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="importVisible" title="导入结果" width="420px">
      <p>总计：{{ importResult?.totalCount ?? 0 }}</p>
      <p>成功：{{ importResult?.successCount ?? 0 }}</p>
      <p>失败：{{ importResult?.failCount ?? 0 }}</p>
      <el-button v-if="importResult?.failCount" type="warning" @click="onDownloadErrors">下载错误报告</el-button>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import type { UploadRequestOptions } from 'element-plus';
import {
  createStudent,
  deleteStudent,
  downloadImportErrors,
  exportStudents,
  fetchStudentPage,
  importStudents,
  updateStudent,
  type ImportResult,
  type StudentItem,
} from '@/api/student';

const keyword = ref('');
const certStatus = ref('');
const list = ref<StudentItem[]>([]);
const total = ref(0);
const page = ref(1);
const pageSize = 20;
const loading = ref(false);
const dialogVisible = ref(false);
const importVisible = ref(false);
const editingId = ref<number | null>(null);
const importResult = ref<ImportResult | null>(null);
const form = reactive({
  realName: '',
  phone: '',
  idCard: '',
  region: '',
  orgName: '',
  certStatus: 'CERTIFIED',
});

async function load() {
  loading.value = true;
  try {
    const res = await fetchStudentPage({
      keyword: keyword.value,
      certStatus: certStatus.value || undefined,
      page: page.value,
      pageSize,
    });
    list.value = res.data.data.list;
    total.value = res.data.data.total;
  } finally {
    loading.value = false;
  }
}

function openCreate() {
  editingId.value = null;
  form.realName = '';
  form.phone = '';
  form.idCard = '';
  form.region = '';
  form.orgName = '';
  form.certStatus = 'CERTIFIED';
  dialogVisible.value = true;
}

function openEdit(row: StudentItem) {
  editingId.value = row.id;
  form.realName = row.realName;
  form.phone = row.phone || '';
  form.idCard = row.idCard || '';
  form.region = row.region || '';
  form.orgName = row.orgName || '';
  form.certStatus = row.certStatus;
  dialogVisible.value = true;
}

async function onSave() {
  const payload = { ...form };
  if (editingId.value) {
    await updateStudent(editingId.value, payload);
    ElMessage.success('已更新');
  } else {
    await createStudent(payload);
    ElMessage.success('已创建');
  }
  dialogVisible.value = false;
  await load();
}

async function onDelete(id: number) {
  await ElMessageBox.confirm('确认删除该学员？', '提示', { type: 'warning' });
  await deleteStudent(id);
  ElMessage.success('已删除');
  await load();
}

async function onImport(options: UploadRequestOptions) {
  const file = options.file as File;
  const res = await importStudents(file);
  importResult.value = res.data.data;
  importVisible.value = true;
  await load();
}

async function onExport() {
  await exportStudents({ keyword: keyword.value, certStatus: certStatus.value || undefined });
}

async function onDownloadErrors() {
  if (importResult.value?.batchId) {
    await downloadImportErrors(importResult.value.batchId);
  }
}

onMounted(load);
</script>

<style scoped>
.toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 16px;
}
.pager {
  margin-top: 16px;
  justify-content: flex-end;
}
</style>
