# 江苏中医在线 — MySQL 数据库脚本

依据 `codestatrFirst/specs/tcm-online-platform/design.md` 及各模块 `design.md` 生成，对齐团队 Flyway 版本分段（见 `team-assignment.md` §5）。

## 环境要求

- MySQL **8.0+**（推荐；兼容 5.7，需自行去掉 `CHECK` 约束）
- 字符集：`utf8mb4` / `utf8mb4_unicode_ci`
- 引擎：InnoDB

## 快速导入（全量）

```bash
mysql -u root -p < database/mysql/00_create_database.sql
mysql -u root -p tcm_online < database/mysql/schema_full.sql
mysql -u root -p tcm_online < database/mysql/seed/seed_init.sql
```

## 按模块迁移（并行开发）

按版本号顺序执行 `migrations/` 下脚本，与 Owner 分工一致：

| 版本段 | Owner | 脚本 |
|--------|-------|------|
| V000–V009 | P1 | `V000__platform.sql` |
| V010–V019 | P1 | `V010__auth_rbac.sql` |
| V020–V029 | P3 | `V020__user_student.sql` |
| V030–V039 | P4 | `V030__home_info.sql` |
| V040–V049 | P5 | `V040__course_video.sql` |
| V050–V059 | P6 | `V050__book_ebook.sql` |
| V060–V069 | P7 | `V060__podcast_audio.sql` |
| V070–V079 | P1 | `V070__learning_tracker.sql` |
| V080–V089 | P4 | `V080__topic_bundle.sql` |
| V090–V099 | P7 | `V090__question_exam.sql` |
| V100–V109 | P7 | `V100__expert_qa.sql` |
| V110–V119 | P6 | `V110__knowledge_base.sql` |
| V120–V124 | P7 | `V120__feedback.sql` |
| V130–V139 | P5 | `V130__live_streaming.sql` |
| V140–V149 | P1 | `V140__data_analytics.sql` |
| V150–V159 | P4 | `V150__official_web.sql` |

## 通用约定

- 主键：`BIGINT UNSIGNED AUTO_INCREMENT`
- 软删：`deleted TINYINT(1) DEFAULT 0`
- 审核流：`audit_status`：`DRAFT` / `PENDING` / `APPROVED` / `REJECTED` / `PUBLISHED`
- 官网可见：`web_visible TINYINT(1) DEFAULT 0`（审核通过且对 Web 开放时为 1）
- 时间戳：`created_at` / `updated_at`

## 相关文档

- 平台设计：`codestatrFirst/specs/tcm-online-platform/design.md`
- 分工与 Flyway：`codestatrFirst/specs/tcm-online-platform/team-assignment.md`
