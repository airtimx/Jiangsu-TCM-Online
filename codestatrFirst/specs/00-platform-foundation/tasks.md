# Tasks — 00 工程基座

## 认领
| 角色 | 姓名 | 分支 | 状态 |
|---|---|---|---|
| BE | | feature/00-platform-be | 待开始 |
| AD | | feature/00-platform-admin | 待开始 |
| MP | | feature/00-platform-mp | 待开始 |
| WEB | | feature/00-platform-web | 待开始 |

## Backend（可并行，BE-1）
- [ ] 初始化 Spring Boot 3 + Java 17 多模块 Maven
- [ ] 实现 `Result` / `GlobalExceptionHandler` / `traceId` 过滤器
- [ ] Flyway V000 基线 + V001 `sys_config` 占位表
- [ ] Docker Compose：MySQL 8、Redis 7、MinIO
- [ ] OSS 预签名上传 API + 集成测试
- [ ] OpenAPI 3 配置 + `/docs` 静态页
- [ ] GitHub Actions / GitLab CI：mvn test

## Admin FE（可并行，AD-1，仅依赖 Mock API）
- [ ] Vite + Vue3 + TS + Element Plus 脚手架
- [ ] Layout：侧栏 220px + 顶栏 + `<router-view>`
- [ ] Axios 封装：baseURL、拦截器、错误 Toast
- [ ] 登录页占位（不调真实 API）
- [ ] 环境文件 `.env.development`

## 小程序（可并行，MP-1）
- [ ] uni-app 初始化 + 微信 AppID 配置说明
- [ ] TabBar 五栏空页面：首页/专题/咨询/知识库/我的
- [ ] `request.uts/ts` 封装 + 环境切换
- [ ] 全局样式与导航栏规范

## 官网壳（可并行，WEB-1，P4）
- [ ] Nuxt 3 + TypeScript 脚手架 `official-web/`
- [ ] 首页占位 + `composables/useWebApi.ts`（Mock）
- [ ] `.env`：`NUXT_PUBLIC_API_BASE`
- [ ] Docker/Nginx 将 `/` 反代至官网 dev 端口说明

## 联调检查点（W0 末）
- [ ] BE health 200；AD/MP/WEB 能请求 BE 根路径
- [ ] 预签名上传端到端：AD 选文件 → BE 签名 → MinIO 成功
- [ ] README：四端启动命令一页文档

## Done 定义
- [ ] 合并 develop；parallel-plan W1 各模块可拉分支
