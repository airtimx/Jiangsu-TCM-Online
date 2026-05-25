# Tasks — 00 工程基座



## 认领

| 角色 | 姓名 | 分支 | 状态 |

|---|---|---|---|

| BE | 蒋玉泽 | feature/00-platform-be | 已完成 |

| AD | 沈宇 | feature/00-platform-admin | 已完成 |

| MP | 江嵩岭 | feature/00-platform-mp | 已完成 |

| WEB | 张美润 | feature/00-platform-web | 已完成 |



## Backend（可并行，BE-1）

- [x] 初始化 Spring Boot 3 + Java 17 多模块 Maven（`jiangsu-tcm-api/`，前后端分离）

- [x] 实现 `Result` / `GlobalExceptionHandler` / `traceId` 过滤器

- [x] Flyway V00100001 基线 + V00100002 `sys_config` 占位

- [x] Docker Compose：MySQL 8、Redis 7、MinIO

- [x] OSS 预签名上传 API + 单元/接口测试

- [x] OpenAPI 3 配置 + `/docs` 静态页

- [x] MyBatis-Plus 3.5.9 父 POM + 分页插件

- [x] GitHub Actions：`java-api-ci.yml`（mvn test）



## Admin FE（可并行，AD-1，仅依赖 Mock API）

- [x] Vite + Vue3 + TS + Element Plus 脚手架（`admin-web/`）

- [x] Layout：侧栏 220px + 顶栏 + `<router-view>`

- [x] Axios 封装：baseURL、拦截器、错误 Toast

- [x] 登录页占位（不调真实 API）

- [x] 环境文件 `.env.development`

- [x] 上传联调页（presign → MinIO）



## 小程序（可并行，MP-1）

- [x] uni-app 初始化 + 微信 AppID 配置说明（`miniapp/README.md`）

- [x] TabBar 五栏空页面：首页/专题/咨询/知识库/我的

- [x] `common/request.ts` 封装 + 环境切换

- [x] 全局样式与导航栏规范



## 官网壳（可并行，WEB-1，P4）

- [x] Nuxt 3 + TypeScript 脚手架 `jiangsu-tcm-web/`

- [x] 首页占位 + `composables/useWebApi.ts`（Mock）

- [x] `.env`：`NUXT_PUBLIC_API_BASE`

- [x] Docker/Nginx 将 `/` 反代至官网 dev 端口说明（`jiangsu-tcm-web/README.md`）



## 联调检查点（W0 末）

- [x] BE health 200；AD/MP/WEB 能请求 BE（enums / health）

- [x] 预签名上传端到端：AD 选文件 → BE 签名 → MinIO 成功（`admin-web` 上传联调页）

- [x] README：四端启动命令一页文档（`docs/START.md`）



## Done 定义

- [ ] 合并 develop；parallel-plan W1 各模块可拉分支


