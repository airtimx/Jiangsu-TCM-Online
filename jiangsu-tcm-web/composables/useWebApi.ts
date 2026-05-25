import { apiRequest } from '~/utils/request';
import { resolveApiUrl } from '~/utils/apiUrl';

/**
 * 官网 Web API（一期 public 读接口，模块 00/16）。
 */
export function useWebApi() {
  async function fetchEnums() {
    return apiRequest<Record<string, unknown>>('/api/common/v1/enums');
  }

  async function checkHealth() {
    const config = useRuntimeConfig();
    return $fetch<{ status: string }>(
      resolveApiUrl('/actuator/health', config.public.apiBase as string),
    );
  }

  return { fetchEnums, checkHealth };
}
