import axios, { type AxiosInstance } from 'axios';
import { ElMessage } from 'element-plus';
import { clearSession, getToken } from '@/utils/auth';

export interface ApiResult<T = unknown> {
  code: number;
  message: string;
  data: T;
  traceId?: string;
}

const baseURL = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8081';

const request: AxiosInstance = axios.create({
  baseURL,
  timeout: 30000,
});

request.interceptors.request.use((config) => {
  const token = getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

request.interceptors.response.use(
  (response) => {
    if (response.config.responseType === 'blob') {
      return response;
    }
    const body = response.data as ApiResult;
    if (body && typeof body.code === 'number' && body.code !== 0) {
      if (body.code === 10002) {
        clearSession();
        if (!window.location.pathname.startsWith('/login')) {
          window.location.href = '/login';
        }
      }
      if (body.code === 10003) {
        if (!window.location.pathname.startsWith('/403')) {
          window.location.href = '/403';
        }
      }
      ElMessage.error(body.message || '请求失败');
      return Promise.reject(new Error(body.message));
    }
    return response;
  },
  (error) => {
    ElMessage.error(error.message || '网络异常');
    return Promise.reject(error);
  },
);

export default request;
