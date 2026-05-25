# Design — 11 知识库

## 表

`kb_category`, `kb_book`, `kb_chapter`, `kb_bookmark`

## API

- Admin: upload, trigger slice job, category CRUD
- App: `GET /api/app/v1/kb/categories`, tree, content, search

## 异步

`KbSliceJob` 队列：PDF → 章节文本/页码

## 并行

- BE 切片 Job 与 MP 目录 UI 并行（Mock 目录）
- 阅读器组件与 05 共用 `packages/reader`

## 与 05 边界

| 05 图书 | 11 知识库 |
|---|---|
| 专题学习资源 | 工具书查阅 |
| 配卷考核 | 可选章节练习 |
