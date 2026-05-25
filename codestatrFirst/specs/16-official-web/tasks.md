# Tasks — 16 官网展示

## 认领

| 角色 | 姓名 | 分支 | 状态 |
|---|---|---|---|
| BE | | `feature/16-official-web-be` | 待开始 |
| WEB | | `feature/16-official-web-nuxt` | 待开始 |

---

## W0 — 工程占位（与 00 协同）

- [ ] `official-web/` Nuxt 3 空项目可 `pnpm dev`
- [ ] Docker Compose / Nginx 增加 `official-web` 路由示例
- [ ] 环境变量 `NUXT_PUBLIC_API_BASE` 文档

## Backend（P4，依赖 03 OpenAPI stable）

- [ ] Flyway V150 `site_config` / `site_nav`
- [ ] 03/08 表增加 `web_visible` 默认值与迁移说明
- [ ] `WebHomeController` `GET /api/web/v1/home`
- [ ] `WebArticleController` 列表 + 详情（复用 03 Service，只读）
- [ ] `WebTopicController` 列表 + 详情摘要
- [ ] `WebContentController` 课程/图书/播客/直播卡片
- [ ] `WebSiteController` 导航配置
- [ ] `MiniappSchemeController` scheme 生成（调微信 open API 或静态映射）
- [ ] 限流过滤器 + 集成测试（公开接口无 token）
- [ ] OpenAPI `web-v1` 片段标记 `stable`

## 官网前端（P4）

- [ ] Layout：Header / Footer / 备案号
- [ ] 首页：Banner + 资讯区块 + 专题入口 + 小程序 CTA
- [ ] 资讯列表/详情（富文本组件 XSS 安全）
- [ ] 专题列表/详情（资源清单只读，无播放器）
- [ ] 课程/图书/播客/直播列表页（卡片 + 跳转小程序）
- [ ] `MiniappCta` 组件（二维码 + 文案）
- [ ] SEO：`useSeoMeta`、sitemap.xml、robots.txt
- [ ] 响应式断点（≥1280 三栏，<768 单栏）

## 联调（W3 末 / W4）

- [ ] 03 发布资讯后 Web 5 分钟内可见
- [ ] 08 专题绑定资源后 Web 详情清单正确
- [ ] 无 Web 端学习/考试入口（验收项）
- [ ] 与 P2 确认 Nginx 生产路由与 Admin 不同域

## 建议排期

- **W2 末**：WEB 壳 + 静态首页（Mock API）
- **W3**：与 08 并行，BE 接 03 stable 后切真实数据
- **W4**：SEO、压测、与 W5 全量 E2E 一并验收
