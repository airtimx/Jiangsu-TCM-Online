# Tasks — 江苏中医在线平台（总览）

> 子模块详细任务见 `codestatrFirst/specs/<模块ID>/tasks.md`  
> **七人分工**见 [team-assignment.md](./team-assignment.md)  
> 并行计划见 [parallel-plan.md](./parallel-plan.md) | 索引见 [README.md](./README.md)

## 七人分工速查

| 人员 | 负责模块 |
|---|---|
| P1 | 00, 01, 07, 14 |
| P2 | Admin 框架, 01 页, 15, 14 图表 |
| P3 | 00-MP, 02, 17 |
| P4 | 03, 08, 16 |
| P5 | 04, 13 |
| P6 | 05, 11 |
| P7 | 06, 09, 10, 12 |

---

## 子模块任务地图

| ID | 模块 | 波次 | 文档 | 并行度 |
|---|---|---|---|---|
| 00 | 工程基座 | W0 | [tasks](../00-platform-foundation/tasks.md) | BE+AD+MP |
| 01 | 认证 RBAC | W1 | [tasks](../01-auth-rbac/tasks.md) | BE+AD |
| 02 | 用户学员 | W1 | [tasks](../02-user-student/tasks.md) | BE+AD+MP |
| 03 | 首页资讯 | W2 | [tasks](../03-home-info/tasks.md) | BE+AD+MP+WEB |
| 04 | 课程视频 | W2 | [tasks](../04-course-video/tasks.md) | BE+AD+MP |
| 05 | 图书电子书 | W2 | [tasks](../05-book-ebook/tasks.md) | BE+AD+MP |
| 06 | 播客音频 | W2 | [tasks](../06-podcast-audio/tasks.md) | BE+MP |
| 07 | 学习追踪 | W2 | [tasks](../07-learning-tracker/tasks.md) | BE |
| 08 | 专题整合 | W3 | [tasks](../08-topic-bundle/tasks.md) | BE+AD+MP |
| 09 | 题库测评 | W2–3 | [tasks](../09-question-exam/tasks.md) | BE+AD+MP |
| 10 | 专家答疑 | W3 | [tasks](../10-expert-qa/tasks.md) | BE+AD+MP |
| 11 | 知识库 | W3 | [tasks](../11-knowledge-base/tasks.md) | BE+MP |
| 12 | 反馈 | W3 | [tasks](../12-feedback/tasks.md) | BE+AD |
| 13 | 直播 | W3 | [tasks](../13-live-streaming/tasks.md) | BE+AD+MP |
| 14 | 数据统计 | W4 | [tasks](../14-data-analytics/tasks.md) | BE+AD |
| 15 | 工作桌面 | W4 | [tasks](../15-admin-dashboard/tasks.md) | BE+AD |
| 16 | 官网展示 | W3–4 | [tasks](../16-official-web/tasks.md) | BE+WEB |
| 17 | 个人中心 | W3 | [tasks](../17-user-center/tasks.md) | BE+MP |

---

## 波次里程碑

### W0 — 工程基座 ✓ 文档就绪
- [ ] 00 全部 tasks 完成 → develop 可拉 W1 分支

### W1 — 认证与用户
- [ ] 01 + 02 联调通过

### W2 — 最大并行（目标 7 人）
- [ ] 03 / 04 / 05 / 06 / 07 / 09 各模块 Done
- [ ] OpenAPI stable 接口清单发布

### W3 — 聚合与运营（目标 7 人）
- [ ] 08 / 10 / 11 / 12 / 13 / 16 / 17 完成
- [ ] 核心路径：登录→专题→学习→考试 打通

### W4 — 统计与桌面
- [ ] 14 / 15 / 16 收尾 完成
- [ ] 管理端 15 模块可演示

### W5 — 上线
- [ ] E2E + 压测 + 安全 + 生产部署
- [ ] 对照 [spec.md](./spec.md) 验收标准

---

## 跨模块协作项

- [ ] Flyway 版本区间遵守 parallel-plan
- [ ] 各 CMS 模块实现 `CountProvider`（供 15）
- [ ] 04/05/06 MP 集成 `reportProgress()`（供 07）
- [ ] 08 资源选择器对接 03–06/09 API
- [ ] 每周五 develop 联调窗口

---

## Done

- [x] 总览 spec / design / ui-prototypes
- [x] 18 子模块 spec / design / tasks（含 16-official-web）
- [x] parallel-plan / README

## In Progress

- [ ] 团队认领各模块 tasks.md 顶部 Owner 表
