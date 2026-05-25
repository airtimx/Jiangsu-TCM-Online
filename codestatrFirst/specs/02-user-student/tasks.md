# Tasks — 02 用户与学员

## 认领
| 角色 | 姓名 | 分支 | 状态 |
|---|---|---|---|
| BE | 蒋玉泽 | feature/02-be | 已完成 |
| AD | 蒋玉泽 | feature/02-admin | 已完成 |
| MP | 蒋玉泽 | feature/02-mp | 已完成 |

## Backend
- [x] Flyway V00102001–V00102002
- [x] 微信 login（code2Session Mock）+ 用户 upsert
- [x] 学员认证 + 短信验证码（Mock 实现可切换）
- [x] 用户/学员 CRUD API
- [x] EasyExcel 导入导出 + 错误行报告
- [x] 权限：`account:user:*`, `account:student:*`

## Admin FE（Mock 列表数据可先行）
- [x] 用户管理列表/编辑 图2.1–2.2
- [x] 学员管理 + 工具栏导入导出 图2.3–2.4
- [x] 导入进度 Dialog + 错误下载

## 小程序
- [x] 微信授权登录页（Mock code）
- [x] 学员认证表单
- [x] 登录态全局存储与过期处理

## 联调
- [ ] 小程序登录 → 管理端可见新用户（需本机 API + MySQL）
- [ ] 导入 100 条学员 < 30s
