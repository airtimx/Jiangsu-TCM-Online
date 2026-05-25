# Spec — 14 数据统计（data-analytics）

| 项 | 内容 |
|---|---|
| 波次 | W4 |
| 前置 | 02, 07, 09, 08 |
| Flyway | V140–V149 |
| 端 | BE + Admin |

## Scope

- 学时统计、学员统计、地区学员、成绩统计
- 筛选、图表数据、Excel 导出
- 只读聚合，不改业务表

## Acceptance Criteria

- [ ] 四类报表与手册图12.1–12.4 维度一致
- [ ] 导出 1 万行 < 60s
- [ ] analyst 角色只读
