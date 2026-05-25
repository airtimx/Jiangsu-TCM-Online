# Design — 03 首页与资讯

## 表

| 表 | 说明 |
|---|---|
| `home_category` | 首页分类 |
| `home_block` | 区块 JSON 配置 |
| `home_banner` | 轮播 |
| `article` | 资讯 |
| `article_category` | 资讯分类 |
| `user_collection` | 收藏（resource_type=ARTICLE） |
| `browse_log` | 浏览记录 |

## API

**Admin**
- CRUD `/api/admin/v1/home/*`
- CRUD `/api/admin/v1/articles` + `/submit-audit` + `/audit`

**App stable**
- `GET /api/app/v1/home` 聚合
- `GET /api/app/v1/articles?category&keyword&page`
- `GET /api/app/v1/articles/{id}`
- `POST/DELETE /api/app/v1/articles/{id}/collect`

## 并行

- AD 首页配置页与 BE 表结构并行
- MP 首页 UI 用 Mock `/home` JSON

## Admin 页面

- `/home/categories`, `/home/content` 图4.1–4.2
- `/content/articles` 图7.1–7.2
