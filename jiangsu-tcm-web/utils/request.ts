import type { ApiResult } from '~/types/api';
import { resolveApiUrl } from '~/utils/apiUrl';

/**
 * 统一 HTTP 客户端（对接后端 Result 契约，规范 §4.2）。
 */
export async function apiRequest<T>(
  path: string,
  options: { method?: 'GET' | 'POST' | 'PUT' | 'DELETE'; body?: unknown } = {},
): Promise<ApiResult<T>> {
  const config = useRuntimeConfig();
  const url = resolveApiUrl(path, config.public.apiBase as string);

  const res = await $fetch<ApiResult<T>>(url, {
    method: options.method ?? 'GET',
    body: options.body,
  });

  if (res.code !== 0) {
    throw new Error(res.message || '请求失败');
  }
  return res;
}
