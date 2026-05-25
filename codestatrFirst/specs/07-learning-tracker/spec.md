# Spec — 07 学习追踪（learning-tracker）

| 项 | 内容 |
|---|---|
| 波次 | W2 |
| 前置 | 00, 02（student_id） |
| Flyway | V070–V079 |
| 端 | BE 为主；MP 上报 |

## Background

跨 04/05/06 的统一学时与进度服务，供 08 门槛校验、14 统计、17 个人中心使用。

## Scope

- 进度上报：VIDEO/AUDIO/BOOK
- 心跳合并、日聚合 `learning_duration`
- 查询：用户在某 resource 的进度、专题完成度

**Out of scope**
- 统计大屏（14）

## Acceptance Criteria

- [ ] 视频观看 ≥90% 记完成
- [ ] 幂等上报不重复计学时
- [ ] 专题完成度 API 供 08/09 使用
