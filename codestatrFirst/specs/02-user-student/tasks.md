# Tasks — 02 用户与学员

## 认领
| 角色 | 姓名 | 分支 | 状态 |
|---|---|---|---|
| BE | | feature/02-be | 待开始 |
| AD | | feature/02-admin | 待开始 |
| MP | | feature/02-mp | 待开始 |

## Backend
- [ ] Flyway V020–V025
- [ ] 微信 login（code2Session）+ 用户 upsert
- [ ] 学员认证 + 短信验证码（Mock 实现可切换）
- [ ] 用户/学员 CRUD API
- [ ] EasyExcel 导入导出 + 错误行报告
- [ ] 权限：`account:user:*`, `account:student:*`

## Admin FE（Mock 列表数据可先行）
- [ ] 用户管理列表/编辑 图2.1–2.2
- [ ] 学员管理 + 工具栏导入导出 图2.3–2.4
- [ ] 导入进度 Dialog + 错误下载

## 小程序
- [ ] 微信授权登录页 图1.1
- [ ] 学员认证表单 图2.2
- [ ] 登录态全局存储与过期处理

## 联调
- [ ] 小程序登录 → 管理端可见新用户
- [ ] 导入 100 条学员 < 30s
