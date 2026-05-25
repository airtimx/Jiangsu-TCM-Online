# 并行开发计划 — 江苏中医在线

## 1. 目标

- 支持 **7+ 人同时开发** 而不互相阻塞
- 模块间通过 **API 契约 + Mock** 解耦
- 每周一次 **develop 联调窗口**（周五）

---

## 2. 角色定义

| 代号 | 角色 | 职责 |
|---|---|---|
| BE | 后端 | API、表结构、Flyway、单测 |
| AD | 管理端前端 | Vue 页面、权限菜单 |
| MP | 小程序前端 | 页面、微信 API |
| QA | 测试 | 用例、联调、回归 |

---

## 3. 波次与人员分配

### W0（第 1 周）— 工程基座 `00-platform-foundation`

| 人员 | 分支 | 交付物 |
|---|---|---|
| BE-1 | feature/00-platform-be | Spring Boot 骨架、统一响应、Flyway V000、OSS 上传、Docker Compose |
| AD-1 | feature/00-platform-admin | Vue3 布局、路由空壳、Axios 封装、登录页占位 |
| MP-1 | feature/00-platform-mp | uni-app TabBar 空壳、request 封装、环境配置 |
| WEB-1 | feature/00-platform-web | Nuxt 3 官网空壳、`NUXT_PUBLIC_API_BASE`、Nginx 路由占位 |

**出口标准**：本地 `docker compose up` 三端 + 官网壳可启动；`/health` 200；Mock 登录可调通。

---

### W1（第 2–3 周）— 认证 + 用户

| 人员 | 模块 | 分支 | 依赖 |
|---|---|---|---|
| BE-1 | 01-auth-rbac | feature/01-be | 00 |
| AD-1 | 01-auth-rbac | feature/01-admin | 00-ad 布局 |
| BE-2 | 02-user-student | feature/02-be | 01 JWT 契约（可先 Mock） |
| MP-1 | 02-user-student | feature/02-mp | 00-mp + 01 wx-login 契约 |

**并行规则**：BE-2 在 01 的 OpenAPI 草案发布后即可开工；微信登录可用 Mock openid。

---

### W2（第 4–6 周）— 内容与学习（最大并行度）

| 人员 | 模块 | 可开工条件 |
|---|---|---|
| BE-1 + AD-1 | 03-home-info | 01 完成 |
| BE-2 + AD-2 | 04-course-video | 01 + OSS |
| BE-3 + AD-3 | 05-book-ebook | 01 + OSS |
| BE-4 + MP-2 | 06-podcast-audio | 01 + OSS |
| BE-5 | 07-learning-tracker | 00；消费端 04/05/06 可用 Mock resourceId |
| BE-6 + AD-4 + MP-3 | 09-question-exam | 01；与 08 解耦（试卷独立 ID） |

**7 人并行**：P1(07) + P2(Review) + P3(02/17) + P4(03) + P5(04) + P6(05) + P7(06+09)。

**Flyway 版本区间**

| 模块 | 版本号段 |
|---|---|
| 00 | V000–V009 |
| 01 | V010–V019 |
| 02 | V020–V029 |
| 03 | V030–V039 |
| 04 | V040–V049 |
| 05 | V050–V059 |
| 06 | V060–V069 |
| 07 | V070–V079 |
| 09 | V090–V099 |
| 16 | V150–V159 |

---

### W3（第 7–9 周）— 聚合与运营

| 人员 | 模块 | 依赖 |
|---|---|---|
| BE-1 + AD-1 + MP-1 | 08-topic-bundle | 03/04/05/06 至少 API 可用 |
| BE-2 + AD-2 + MP-2 | 10-expert-qa | 02 学员 |
| BE-3 + MP-3 | 11-knowledge-base | 05 书籍解析可复用 |
| BE-4 + AD-3 | 12-feedback | 02 |
| BE-5 + AD-4 + MP-4 | 13-live-streaming | 01；08 可选 |
| MP-5 | 17-user-center | 02/07/09/10 聚合 API |
| WEB-1 + BE-1 | 16-official-web | 03 资讯 API stable；08 专题可 Mock |

**7 人并行**：P4 负责 08+16（BE+WEB）；其余模块 Admin + MP 可同模块不同页面并行。

---

### W4（第 10–11 周）— 统计与桌面

| 人员 | 模块 | 依赖 |
|---|---|---|
| BE-1 + AD-1 | 14-data-analytics | 07/09/02 有数据 |
| BE-2 + AD-2 | 15-admin-dashboard | 01 + 各模块待办计数 API |
| WEB-1 | 16-official-web | SEO、sitemap、小程序 CTA 验收 |

可与 QA 开始 **核心路径 E2E**（登录→专题→学习→考试；官网浏览→小程序跳转）。

---

### W5（第 12–13 周）— 全量联调上线

- 全模块回归
- 压测：首页 500 QPS、考试提交 100 QPS
- 安全：OWASP Top10 checklist
- 生产部署与手册更新

---

## 4. Mock 与契约解耦

各模块在 `design.md` 中声明 **对外 API**；未就绪时提供：

```
/api/mock/v1/<module>/...
```

或在 Postman Collection `codestatrFirst/cache/postman/` 维护示例（可选）。

**消费方规则**：只依赖 OpenAPI 中已标记 `stable` 的接口；`draft` 接口可变更。

---

## 5. 冲突热点与规避

| 热点 | 规避 |
|---|---|
| Flyway 版本冲突 | 上表区间；合并前 rebase develop |
| 公共枚举/DTO | 放 `common-core` 包，00 模块维护 |
| 管理端菜单 | 01 提供菜单注册 JSON，各模块 PR 追加 menu 片段 |
| OSS 路径规范 | `/{env}/{module}/{yyyyMM}/{uuid}.ext` |
| 审核流 | 复用 `AuditService`（01 提供），各 CMS 只实现回调 |

---

## 6. 周会检查清单

- [ ] 各 feature 分支是否 rebase develop
- [ ] OpenAPI 是否更新
- [ ] Flyway 是否冲突
- [ ] 模块 tasks.md 中 In Progress 是否同步
- [ ] 阻塞项是否需 Mock 放行

---

## 7. 模块联调矩阵

|  | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 14 |
|---|---|---|---|---|---|---|---|---|
| **08-topic** | ✓ | ✓ | ✓ | ✓ | ○ | — | ✓ | ○ |
| **14-stats** | ○ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| **17-user** | ✓ | ○ | ○ | ○ | ✓ | ○ | ✓ | ○ |

✓ = 强依赖；○ = 弱依赖 / 可 Mock

---

## 8. 认领模板

复制到模块 `tasks.md` 顶部：

```markdown
## 认领
| 角色 | 姓名 | 分支 | 状态 |
|---|---|---|---|
| BE | | feature/XX-be | 待开始 |
| AD | | feature/XX-admin | 待开始 |
| MP | | feature/XX-mp | 待开始 |
```
