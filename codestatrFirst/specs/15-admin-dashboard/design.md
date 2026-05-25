# Design — 15 工作桌面

## API

`GET /api/admin/v1/dashboard` 返回：

```json
{
  "notices": [],
  "widgets": [
    { "key": "pending_audit", "count": 12, "link": "/content/articles?status=PENDING" }
  ],
  "shortcuts": []
}
```

## 各模块需提供

在各自 BE 实现 `CountProvider` 接口注册 Spring Bean，避免 15 模块反向依赖所有 Service。

## Admin：图1.2

## 并行

AD 可与 14 同一人；BE 聚合 0.5 周（各模块补 count 接口可并行 PR）
