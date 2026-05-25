# admin-web — 管理端（前后端分离）

独立 Vue3 工程，**不嵌入**后端仓库。

## 配置

`.env.development`：

```
VITE_API_BASE_URL=http://127.0.0.1:8081
```

所有请求直连后端（无 Vite 代理）。

## 启动

```powershell
npm install
npm run dev
```

需先启动 `../jiangsu-tcm-api` 中的 API 服务。
