import request, { type ApiResult } from '@/utils/request';

export interface LoginPayload {
  username: string;
  password: string;
}

export interface AdminProfile {
  id: number;
  username: string;
  realName?: string;
  roles: string[];
  permissions: string[];
}

export interface MenuItem {
  path: string;
  title: string;
  icon?: string;
  permission?: string | null;
  children?: MenuItem[];
}

export interface LoginResult {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
  admin: AdminProfile;
  menus: MenuItem[];
}

export function loginApi(data: LoginPayload) {
  return request.post<ApiResult<LoginResult>>('/api/admin/v1/auth/login', data);
}

export function logoutApi() {
  return request.post<ApiResult<null>>('/api/admin/v1/auth/logout');
}

export function meApi() {
  return request.get<ApiResult<AdminProfile>>('/api/admin/v1/auth/me');
}

export function menusApi() {
  return request.get<ApiResult<MenuItem[]>>('/api/admin/v1/menus');
}
