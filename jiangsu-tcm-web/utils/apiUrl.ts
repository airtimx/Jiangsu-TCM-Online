/**
 * 拼接 API 地址。开发时 apiBase 留空，走 Vite 代理到后端（默认 8081）。
 */
export function resolveApiUrl(path: string, apiBase?: string): string {
  const normalized = path.startsWith('/') ? path : `/${path}`;
  const base = (apiBase ?? '').replace(/\/$/, '');
  return base ? `${base}${normalized}` : normalized;
}
