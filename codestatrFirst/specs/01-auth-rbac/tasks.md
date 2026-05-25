# Tasks — 01 认证 RBAC

## 认领
| 角色 | 姓名 | 分支 | 状态 |
|---|---|---|---|
| BE | | feature/01-be | 待开始 |
| AD | | feature/01-admin | 待开始 |

## Backend（BE-1，依赖 00）
- [ ] Flyway V010–V015 表结构 + 预置 super_admin
- [ ] JWT 签发/校验过滤器 + 刷新策略
- [ ] 登录/登出/me API + 登录日志
- [ ] 角色权限 CRUD + 权限树查询
- [ ] 菜单注册机制（JSON 片段合并）
- [ ] `AuditStatus` + `AuditService` 骨架
- [ ] 单元测试：登录、403、权限变更

## Admin FE（AD-1，可与 BE 并行，Mock token）
- [ ] 登录页：账号/密码/记住账号 图1.1
- [ ] Token 存储 + 路由守卫
- [ ] 动态侧栏菜单渲染
- [ ] 管理员列表/编辑 Dialog 图3.1–3.3
- [ ] 角色列表 + 权限树勾选 图3.2
- [ ] 403 页与登出

## 联调检查点
- [ ] 真实登录 → 侧栏按角色显示
- [ ] 无 `course:audit` 权限时课程审核按钮隐藏

## Done
- [ ] OpenAPI stable 发布；02/03 可开始对接 JWT
