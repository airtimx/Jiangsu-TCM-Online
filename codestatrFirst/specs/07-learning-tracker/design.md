# Design — 07 学习追踪

## 表

| 表 | 说明 |
|---|---|
| `learning_progress` | user_id, resource_type, resource_id, progress_pct, completed |
| `learning_duration` | user_id, date, seconds, resource_type |

## API（stable）

- `POST /api/app/v1/learning/progress` body: `{ type, resourceId, position, duration }`
- `GET /api/app/v1/learning/progress?resourceType&resourceId`
- `GET /api/app/v1/learning/topic/{topicId}/summary` 专题汇总

## 并行

**独立 BE 模块**，04/05/06 前端仅调用 HTTP，无需等待彼此代码合并。

Mock：resourceId 可用 UUID 占位测试。

## 定时任务

每日 02:00 聚合 duration → 供 14 读取
