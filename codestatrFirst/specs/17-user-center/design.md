# Design — 17 个人中心

## API 聚合（BFF 可选）

`GET /api/app/v1/mine/summary` 返回：

```json
{
  "profile": {},
  "certStatus": "CERTIFIED",
  "stats": { "hours": 120, "topicsDone": 3 },
  "collectionsCount": 10,
  "qaCount": 2
}
```

内部调用 02/03/07/10 只读接口或本地 join

## 页面

- `/pages/mine/index` 图2.1
- 子页：collections, history, manual, stats, my-qa

## 并行

纯 MP 模块，BE 仅需 1 个聚合接口；UI 与 08/10 并行

## 依赖

各子 API stable 后即可联调
