# 江苏中医在线 — 子模块索引与并行开发指南

## 核心文档

| 文档 | 说明 |
|---|---|
| [代码编写规范 V2.0](../../../江苏中医在线项目 - 代码编写规范文档.md) | 全栈编码标准、版本号统一、阿里巴巴 P3C（**开发前必读**） |
| [parallel-plan.md](./parallel-plan.md) | 并行波次与 Flyway 区间 |
| [team-assignment.md](./team-assignment.md) | 七人分工与认领 |
| [design.md](./design.md) | 技术架构总览 |

## 文档结构

```
codestatrFirst/specs/
├── tcm-online-platform/          # 总览（spec / design / ui-prototypes / parallel-plan）
├── 00-platform-foundation/       # 工程基座
├── 01-auth-rbac/                 # 认证与权限
├── 02-user-student/              # 用户与学员
├── 03-home-info/                 # 首页与资讯
├── 04-course-video/              # 课程与视频
├── 05-book-ebook/                # 图书与电子书
├── 06-podcast-audio/             # 播客与音频
├── 07-learning-tracker/          # 学习追踪（共享服务）
├── 08-topic-bundle/              # 专题整合
├── 09-question-exam/             # 题库与测评
├── 10-expert-qa/                 # 专家答疑
├── 11-knowledge-base/            # 知识库
├── 12-feedback/                  # 反馈管理
├── 13-live-streaming/            # 直播
├── 14-data-analytics/            # 数据统计
├── 15-admin-dashboard/           # 工作桌面
├── 16-official-web/              # 官网展示
└── 17-user-center/               # 小程序个人中心
```

每个子模块含 **spec.md（范围）**、**design.md（接口/表）**、**tasks.md（可并行任务包）**。

---

## 18 个子模块一览

| ID | 模块 | 管理端 | 小程序 | 官网 | 建议人力 |
|---|---|:---:|:---:|:---:|---|
| 00 | 工程基座 | ● | ● | ● | 3（BE+AD+MP+WEB 壳） |
| 01 | 认证 RBAC | ● | ○ | 2（BE+AD） |
| 02 | 用户学员 | ● | ● | 2（BE+MP） |
| 03 | 首页资讯 | ● | ● | ● | 3 |
| 04 | 课程视频 | ● | ● | ○ | 3 |
| 05 | 图书电子书 | ● | ● | ○ | 3 |
| 06 | 播客音频 | ● | ● | ○ | 2 |
| 07 | 学习追踪 | — | ● | — | 1（BE 主） |
| 08 | 专题整合 | ● | ● | ● | 2 |
| 09 | 题库测评 | ● | ● | — | 3 |
| 10 | 专家答疑 | ● | ● | — | 2 |
| 11 | 知识库 | ● | ● | — | 2 |
| 12 | 反馈 | ● | ● | — | 1 |
| 13 | 直播 | ● | ● | ○ | 2 |
| 14 | 数据统计 | ● | — | — | 2 |
| 15 | 工作桌面 | ● | — | — | 1 |
| 16 | 官网展示 | — | — | ● | 2（BE+WEB，P4） |
| 17 | 个人中心 | — | ● | — | 1 |

---

## 并行波次（多人协作）

详见 [parallel-plan.md](./parallel-plan.md)。

| 波次 | 周期 | 可并行模块 | 人数上限 |
|---|---|---|---|
| W0 | 1 周 | 00 | 3 人分端 |
| W1 | 2 周 | 01 → 02 | 4 人 |
| W2 | 3 周 | 03, 04, 05, 06, 07, 09 | **7 人** |
| W3 | 3 周 | 08, 10, 11, 12, 13, 16, 17 | **7 人** |
| W4 | 2 周 | 14, 15, 16 收尾 + 联调 | 4 人 |
| W5 | 2 周 | 全量 E2E、压测、上线 | 全员 |

---

## 分支策略

```
main
 └── develop
      ├── feature/00-platform-be
      ├── feature/00-platform-admin
      ├── feature/00-platform-mp
      ├── feature/03-home-info-be
      ├── feature/03-home-info-admin
      └── feature/03-home-info-mp
```

- 模块内：`feature/<模块ID>-<be|admin|mp>`
- 联调：`develop` 每周合并；冲突域：公共 DTO、路由前缀、Flyway 版本号
- **Flyway 版本**：由 BE 负责人统一分配区间（见 parallel-plan.md）

---

## 联调顺序（硬依赖）

```
00 → 01 → 02
         ↓
    ┌────┴────┬────────┬────────┐
    03       04       05       06
    │        └────┬───┴───┬────┘
    │             07      09
    └──────► 08 ◄─┘       │
              │           │
         10 11 12 13  17 ◄┘
              │
         14 15 16
```

---

## 公共契约

| 契约 | 位置 | 维护者 |
|---|---|---|
| 统一响应体 / 错误码 | 00-platform | BE-00 |
| OpenAPI 聚合 | `api-server/docs/openapi.yaml` | 各模块 PR 追加 |
| 审核状态枚举 | 01-auth-rbac + 各 CMS 模块 | BE-01 |
| 媒体上传签名 | 00-platform OSS 模块 | BE-00 |
| 权限码命名 | 01-auth-rbac | BE-01 |

---

## 七人分工

详见 **[team-assignment.md](./team-assignment.md)**（P1–P7 模块归属、分周排期、协作接口）。

| 人员 | 主责模块 |
|---|---|
| **P1** | 00, 01, 07, 14（平台/学时/统计 BE） |
| **P2** | Admin 框架, 01 登录权限页, 15, 14 图表 |
| **P3** | 小程序壳, 02, 17 |
| **P4** | 03, 08, 16 |
| **P5** | 04, 13 |
| **P6** | 05, 11 |
| **P7** | 06, 09, 10, 12 |

## 快速认领

在 [team-assignment.md](./team-assignment.md) 填写姓名，并在对应模块 `tasks.md` 同步 Owner。
