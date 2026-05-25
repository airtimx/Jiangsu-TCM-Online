# Spec — 05 图书与电子书（book-ebook）

| 项 | 内容 |
|---|---|
| 波次 | W2 |
| 前置 | 01, 00(OSS) |
| Flyway | V050–V059 |
| 端 | BE + Admin + 小程序 |

## Scope

- 图书分类、图书 CRUD、审核
- 章节树、PDF/EPUB 上传
- 章节级考卷关联（exam_paper_id）
- 小程序：章节阅读、书签（与 11 知识库阅读器复用组件）

## Acceptance Criteria

- [ ] PDF 在线阅读（分页或滚动）
- [ ] 章节树三级以内流畅
- [ ] 书签增删查
