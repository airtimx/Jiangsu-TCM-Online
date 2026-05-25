# jiangsu-tcm-web — 网页端（Nuxt 3）

江苏中医在线 **官方网站 / 网页端** 独立工程，与后端 `jiangsu-tcm-api` 分离部署。

| 项 | 说明 |
|----|------|
| 框架 | **Nuxt 3.16** + **Vue 3.5** + **TypeScript** |
| 版本 | `1.0.0`（`package.json` versionName） |
| 模块 | 00 工程壳 + 16 官网展示（业务页） |
| API | 环境变量 `NUXT_PUBLIC_API_BASE` |

## 目录结构

```
jiangsu-tcm-web/
├── assets/css/          # 全局样式
├── composables/         # useWebApi 等
├── layouts/default.vue  # 默认布局
├── pages/               # 路由页面
├── types/               # ApiResult 等类型
├── utils/request.ts     # 统一请求封装
├── nuxt.config.ts
└── .env
```

## 启动

```powershell
cd jiangsu-tcm-web
npm install
npm run dev
```

访问 http://127.0.0.1:3000

## 环境变量

复制 `.env.example` 为 `.env`。开发默认 `NUXT_PUBLIC_API_BASE` 留空，由 Vite 代理到 `8081`。

需先启动 `../jiangsu-tcm-api` 后端（及 MySQL）。

## 开发异常（503 / 端口占用 / EPERM）

**不要同时开两个** `npm run dev`（会与 Cursor/IDEA 后台各起一个 Nuxt）。

```powershell
npm run dev:reset   # 结束 3000/HMR 进程并删除 .nuxt
npm run dev
```

## 生产 Nginx 示例

```nginx
location / {
  proxy_pass http://127.0.0.1:3000;
}
location /api/ {
  proxy_pass http://127.0.0.1:8081;
}
```

## 规范

《江苏中医在线项目 — 代码编写规范》V2.0 · Nuxt **3.16.x**
