# Spec — 03 首页与资讯（home-info）

| 项 | 内容 |
|---|---|
| 波次 | W2 |
| 前置 | 01, 02（收藏需 user） |
| Flyway | V030–V039 |
| 端 | BE + Admin + 小程序 + 官网读 |

## Background

驱动小程序首页展示与资讯全链路：分类、Banner、资讯 CRUD、审核、搜索、收藏分享。

## Scope

**In scope**
- 首页分类、Banner、区块配置
- 资讯 CRUD、富文本、审核流
- 小程序：首页聚合、列表、详情、收藏、分享、搜索

**Out of scope**
- 专题（08）
- 官网 Nuxt 页面与 `/api/web/v1` BFF（由 **16-official-web** 实现；本模块提供数据源与 `web_visible` 字段）
- ES 全文检索（二期，一期 MySQL FULLTEXT）

## Acceptance Criteria

- [ ] 管理端配置首页后小程序 5 分钟内可见（或清缓存后）
- [ ] 资讯审核通过后才在 app 展示
- [ ] 收藏/取消收藏幂等
- [ ] 分享 `onShareAppMessage` 带标题与路径
