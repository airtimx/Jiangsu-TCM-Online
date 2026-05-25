# Design — 16 官网展示

## 技术栈

| 层 | 选型 |
|---|---|
| 前端 | Nuxt 3 + Vue 3 + TypeScript + Pinia |
| 渲染 | SSG 为主，资讯/专题详情 ISR（revalidate 300s） |
| UI | 自研组件 + Tailwind；主色 `#2E7D6B` |
| 后端 | Spring Boot 3，`/api/web/v1` 控制器包 `com.jiangsu.tcm.web` |
| 部署 | Nginx 反代 `official-web` + `api-server`；静态资源 CDN |

## 仓库目录

```
official-web/
├── nuxt.config.ts
├── pages/
│   ├── index.vue              # 首页
│   ├── articles/
│   ├── topics/
│   ├── courses/
│   ├── books/
│   └── live/
├── components/
│   ├── AppHeader.vue
│   ├── MiniappCta.vue         # 打开小程序
│   └── ContentCard.vue
└── composables/useWebApi.ts
```

## 数据表（Flyway V150–V159）

| 表 | 说明 |
|---|---|
| `site_config` | key-value：站点名、备案号、ICP、客服电话 |
| `site_nav` | 导航项：label, path, sort, visible |
| `web_seo` | 可选：path, title, description, og_image |

> 业务内容表（资讯、专题等）**不重复建表**，通过各模块表 + `web_visible` 字段（03/08 迁移追加）过滤。

## API（`/api/web/v1`，公开读，`stable`）

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/home` | 首页聚合：Banner、推荐资讯、推荐专题 |
| GET | `/articles` | 资讯列表 `?category&page&size` |
| GET | `/articles/{id}` | 资讯详情（富文本 HTML 已消毒） |
| GET | `/topics` | 专题列表 |
| GET | `/topics/{id}` | 专题详情 + 资源清单（只读，无 playUrl） |
| GET | `/courses` | 课程卡片列表 |
| GET | `/courses/{id}` | 课程摘要 |
| GET | `/books` | 图书卡片列表 |
| GET | `/podcasts` | 播客列表 |
| GET | `/live` | 直播预告/回放列表（只读） |
| GET | `/site/nav` | 导航与页脚配置 |
| GET | `/miniapp/scheme` | 生成小程序 path scheme（query: `path`） |

### 响应示例

```json
{
  "code": 0,
  "message": "ok",
  "data": {
    "banners": [],
    "articles": [],
    "topics": []
  },
  "traceId": "uuid"
}
```

### 安全

- 无登录态；`RateLimiter` 100 req/min/IP（可配置）
- 富文本白名单标签与 03 模块一致
- 禁止返回 `playUrl`、考卷答案、学员 PII

## 前端页面路由

| 路径 | 页面 |
|---|---|
| `/` | 首页 |
| `/articles` | 资讯列表 |
| `/articles/[id]` | 资讯详情 |
| `/topics` | 专题列表 |
| `/topics/[id]` | 专题详情 |
| `/courses` | 课程列表 |
| `/books` | 图书列表 |
| `/live` | 直播列表 |
| `/about` | 关于平台（静态 + site_config） |

## 与小程序引导

所有「开始学习」「参加考试」按钮调用 `MiniappCta`：

1. 展示小程序码（静态配置 + 动态 path）
2. 移动端尝试 `wx-open-launch-weapp`（环境允许时）
3. 降级文案：「请使用微信搜索江苏中医在线小程序」

## 性能

- 列表接口分页默认 12 条
- `Cache-Control: public, max-age=300` 对首页/列表
- 详情页 `max-age=60`

## OpenAPI

各接口在 `docs/openapi/web-v1.yaml` 片段登记，合并由 00 模块聚合。
