import request, { type ApiResult } from '@/utils/request';
import type { PageResult } from '@/api/admin';

export interface AppUserItem {
  id: number;
  openid: string;
  nickname?: string;
  phone?: string;
  userType: string;
  status: number;
  lastLoginAt?: string;
  createdAt?: string;
}

export interface AppUserUpdatePayload {
  nickname?: string;
  phone?: string;
  status?: number;
}

export function fetchUserPage(params: { keyword?: string; page?: number; pageSize?: number }) {
  return request.get<ApiResult<PageResult<AppUserItem>>>('/api/admin/v1/users', { params });
}

export function updateUser(id: number, data: AppUserUpdatePayload) {
  return request.put<ApiResult<null>>(`/api/admin/v1/users/${id}`, data);
}
