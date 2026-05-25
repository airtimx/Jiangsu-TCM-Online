import request, { type ApiResult } from '@/utils/request';
import type { PageResult } from '@/api/admin';

export interface StudentItem {
  id: number;
  userId: number;
  realName: string;
  phone?: string;
  idCard?: string;
  region?: string;
  orgName?: string;
  certStatus: string;
  certTime?: string;
  remark?: string;
}

export interface StudentSavePayload {
  userId?: number;
  realName: string;
  phone?: string;
  idCard?: string;
  region?: string;
  orgName?: string;
  certStatus?: string;
  remark?: string;
}

export interface ImportResult {
  batchId: number;
  totalCount: number;
  successCount: number;
  failCount: number;
  errorDownloadPath?: string;
}

export function fetchStudentPage(params: {
  keyword?: string;
  certStatus?: string;
  page?: number;
  pageSize?: number;
}) {
  return request.get<ApiResult<PageResult<StudentItem>>>('/api/admin/v1/students', { params });
}

export function createStudent(data: StudentSavePayload) {
  return request.post<ApiResult<number>>('/api/admin/v1/students', data);
}

export function updateStudent(id: number, data: StudentSavePayload) {
  return request.put<ApiResult<null>>(`/api/admin/v1/students/${id}`, data);
}

export function deleteStudent(id: number) {
  return request.delete<ApiResult<null>>(`/api/admin/v1/students/${id}`);
}

export function importStudents(file: File) {
  const form = new FormData();
  form.append('file', file);
  return request.post<ApiResult<ImportResult>>('/api/admin/v1/students/import', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
}

export function exportStudents(params: { keyword?: string; certStatus?: string }) {
  return request.get('/api/admin/v1/students/export', {
    params,
    responseType: 'blob',
  }).then((res) => {
    const blob = new Blob([res.data as BlobPart]);
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'students.xlsx';
    a.click();
    window.URL.revokeObjectURL(url);
  });
}

export function downloadImportErrors(batchId: number) {
  return request.get(`/api/admin/v1/students/import/${batchId}/errors`, {
    responseType: 'blob',
  }).then((res) => {
    const blob = new Blob([res.data as BlobPart]);
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `import-errors-${batchId}.xlsx`;
    a.click();
    window.URL.revokeObjectURL(url);
  });
}
