// https://nuxt.com/docs/api/configuration/nuxt-config
const apiProxyTarget = process.env.NUXT_PROXY_API || 'http://127.0.0.1:8081';

export default defineNuxtConfig({
  compatibilityDate: '2025-05-25',
  devtools: { enabled: true },
  css: ['~/assets/css/main.css'],
  runtimeConfig: {
    public: {
      // 开发留空：请求走同源 + Vite 代理，避免端口/CORS 不一致
      apiBase: process.env.NUXT_PUBLIC_API_BASE ?? '',
    },
  },
  vite: {
    server: {
      strictPort: false,
      hmr: {
        // 避免多开 dev 时固定 24678 冲突；被占用时 Vite 会自动换端口
        port: 24679,
      },
      proxy: {
        '/api': { target: apiProxyTarget, changeOrigin: true },
        '/actuator': { target: apiProxyTarget, changeOrigin: true },
      },
    },
  },
  devServer: {
    host: '127.0.0.1',
    port: 3000,
  },
  app: {
    head: {
      title: '江苏中医在线',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: '江苏中医在线 — 官方网站' },
      ],
    },
  },
});
