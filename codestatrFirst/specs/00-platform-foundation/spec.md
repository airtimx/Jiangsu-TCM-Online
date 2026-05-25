# Spec — 00 工程基座（platform-foundation）

| 项 | 内容 |
|---|---|
| 波次 | W0（第 1 周） |
| 前置依赖 | 无 |
| 阻塞 | 全部模块 |
| Flyway | V000–V009 |
| 端 | BE + Admin + 小程序 + 官网壳 |

## Background

统一四端工程结构、公共契约与本地运行环境，避免后续 18 个模块在分支合并时反复冲突。

## Scope

**In scope**
- Monorepo / 多仓库目录约定
- Spring Boot 3 骨架、健康检查、统一响应体、全局异常
- Flyway 初始化、Docker Compose（MySQL/Redis/MinIO）
- OSS 上传签名接口
- Vue3 管理端 Layout + 路由 + Axios
- uni-app 小程序 TabBar 壳 + request 封装
- Nuxt 3 官网空壳 + `NUXT_PUBLIC_API_BASE`（业务页由 16 模块）
- CI：lint + 单元测试模板
- OpenAPI 聚合入口

**Out of scope**
- 业务表与业务 API
- 真实登录鉴权（由 01 模块）

## Acceptance Criteria

- [ ] `docker compose up` 后 API `/actuator/health` 返回 UP
- [ ] 四端（含官网壳）本地均可启动，环境变量文档齐全
- [ ] 统一响应 `{ code, message, data, traceId }` 被集成测试覆盖
- [ ] OSS 预签名上传 Demo 可用
- [ ] Flyway V000 基线迁移可重复执行
- [ ] develop 分支保护 + PR 模板就绪
