import request, { type ApiResult } from '@/utils/request';

export interface PageResult<T> {
  list: T[];
  total: number;
  page: number;
  pageSize: number;
}

export interface AdminItem {
  id: number;
  username: string;
  realName?: string;
  phone?: string;
  email?: string;
  status: number;
  roleCodes: string[];
  lastLoginAt?: string;
  createdAt?: string;
}

export interface AdminSavePayload {
  username: string;
  password?: string;
  realName?: string;
  phone?: string;
  email?: string;
  status?: number;
  roleIds: number[];
}

export function fetchAdminPage(params: { keyword?: string; page?: number; pageSize?: number }) {
  return request.get<ApiResult<PageResult<AdminItem>>>('/api/admin/v1/admins', { params });
}

export function createAdmin(data: AdminSavePayload) {
  return request.post<ApiResult<number>>('/api/admin/v1/admins', data);
}

export function updateAdmin(id: number, data: AdminSavePayload) {
  return request.put<ApiResult<null>>(`/api/admin/v1/admins/${id}`, data);
}

export function deleteAdmin(id: number) {
  return request.delete<ApiResult<null>>(`/api/admin/v1/admins/${id}`);
}
