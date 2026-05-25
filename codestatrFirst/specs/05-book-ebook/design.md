# Design — 05 图书与电子书

## 表

`book_category`, `book`, `book_chapter`（parent_id, title, page_start, page_end, sort_no）

## API

- Admin: `/api/admin/v1/books`, `/books/{id}/chapters`
- App: `GET /api/app/v1/books/{id}`, chapters tree, `GET .../chapters/{cid}/content`
- App: `POST/GET/DELETE /api/app/v1/books/{id}/bookmarks`

## 并行

- BE 章节树 API 与 AD 树形编辑器并行
- MP 阅读器可先加载静态 PDF URL

## 与 11 关系

阅读器组件抽 `packages/reader`；11 知识库复用，不互相阻塞。

## Admin：图6.1–6.3
