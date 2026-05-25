# Design — 14 数据统计

## 数据源

| 报表 | 主表 |
|---|---|
| 学时 | `learning_duration` |
| 学员 | `student` + `app_user` |
| 地区 | `student.region` 聚合 |
| 成绩 | `exam_record` |

## API

- `GET /api/admin/v1/stats/learning-hours`
- `GET /api/admin/v1/stats/students`
- `GET /api/admin/v1/stats/regions`
- `GET /api/admin/v1/stats/scores`
- `GET /api/admin/v1/stats/*/export`

## 性能

- 热数据 `statistics_snapshot` 日表预聚合
- 导出异步 Job + 下载链接

## 并行

W4 两人：BE 聚合 SQL + AD ECharts；不阻塞 W3 业务开发

## Admin：图12.1–12.4
