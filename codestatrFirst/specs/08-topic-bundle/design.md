# Design — 08 专题整合

## 表

`topic`, `topic_resource`（topic_id, resource_type, resource_id, sort_no）, `topic_student`

## resource_type 枚举

`ARTICLE` | `BOOK` | `COURSE` | `PODCAST` | `EXAM_PAPER`

## API

- Admin: CRUD `/api/admin/v1/topics`, bind resources, assign students
- App: `GET /api/app/v1/topics`, `GET /api/app/v1/topics/{id}` 含资源树与进度

## 并行策略

| 角色 | 可开工时机 |
|---|---|
| BE | 03–06 的 resource_id 用 seed 数据 |
| AD | 专题编辑 UI 用 Mock 资源选择器 |
| MP | 详情页 Tab 用 Mock JSON |

## 依赖契约

- 调 07：`GET .../learning/topic/{id}/summary`
- 调 09：`exam_paper_id` 存在即可

## Admin：图9.1–9.2
