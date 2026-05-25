import axios, { type AxiosInstance } from 'axios';
import { ElMessage } from 'element-plus';

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

request.interceptors.response.use(
  (response) => {
    const body = response.data as ApiResult;
    if (body && typeof body.code === 'number' && body.code !== 0) {
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
