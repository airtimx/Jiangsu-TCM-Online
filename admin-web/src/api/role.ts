import request, { type ApiResult } from '@/utils/request';
import type { PageResult } from '@/api/admin';

export interface RoleItem {
  id: number;
  code: string;
  name: string;
  description?: string;
  status: number;
  sortNo: number;
}

export interface PermissionTreeNode {
  id: number;
  code: string;
  name: string;
  children?: PermissionTreeNode[];
}

export function fetchRolePage(params: { keyword?: string; page?: number; pageSize?: number }) {
  return request.get<ApiResult<PageResult<RoleItem>>>('/api/admin/v1/roles', { params });
}

export function fetchAllRoles() {
  return request.get<ApiResult<RoleItem[]>>('/api/admin/v1/roles/all');
}

export function fetchPermissionTree() {
  return request.get<ApiResult<PermissionTreeNode[]>>('/api/admin/v1/roles/permissions/tree');
}

export function fetchRolePermissions(roleId: number) {
  return request.get<ApiResult<number[]>>(`/api/admin/v1/roles/${roleId}/permissions`);
}

export function updateRolePermissions(roleId: number, permissionIds: number[]) {
  return request.put<ApiResult<null>>(`/api/admin/v1/roles/${roleId}/permissions`, { permissionIds });
}
