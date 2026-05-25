# 江苏中医在线

**前后端分离** 多工程布局（同一 Git 仓库，独立构建与部署）。

```
JiangsuTCMOnline/
├── jiangsu-tcm-api/      # 后端（Spring Boot，P1）
├── admin-web/            # 管理端（Vue3 + Vite，P2）
├── miniapp/              # 小程序（uni-app，P3）
├── jiangsu-tcm-web/      # 网页端（Nuxt 3，P4）
├── database/             # 参考 SQL
├── codestatrFirst/       # 需求与设计
└── docs/START.md         # 四端启动说明
```

## 原则

| 项 | 说明 |
|----|------|
| 通信 | 前端通过 **HTTP + 环境变量** 访问后端，端口独立 |
| 后端 | 仅 `jiangsu-tcm-api/`，不含 Vue/小程序/Nuxt 源码 |
| CORS | 后端已开启 `localhost` 跨域（开发） |
| 生产 | 建议 Nginx 反代 API；前端静态资源独立 CDN/桶 |

## 快速启动

见 [docs/START.md](docs/START.md)。

> 若仍存在旧目录 `Jiangsu-TCM-Online-JavaBase/`，与 `jiangsu-tcm-api/` 内容重复，**关闭 IDE 后可删除旧目录**，统一使用 `jiangsu-tcm-api/`。
