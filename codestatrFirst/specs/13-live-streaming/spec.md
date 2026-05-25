# Spec — 13 直播（live-streaming）

| 项 | 内容 |
|---|---|
| 波次 | W3 |
| 前置 | 01, 08(可选) |
| Flyway | V130–V139 |
| 端 | BE + Admin + 小程序 |

## Scope

- 直播 CRUD、审核
- 第三方 LiveProvider 对接
- 小程序观看页
- 回放地址回填

## Acceptance Criteria

- [ ] 创建直播返回第三方 roomId
- [ ] 开播前/中/后状态正确
- [ ] 回调更新回放 URL
