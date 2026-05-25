# Spec — 01 认证与 RBAC（auth-rbac）

| 项 | 内容 |
|---|---|
| 波次 | W1 |
| 前置 | 00 |
| 阻塞 | 全部管理端模块、02 部分 |
| Flyway | V010–V019 |
| 端 | BE + Admin |

## Background

管理端需账号密码登录、JWT 鉴权、角色权限与动态菜单；为 15 个后台模块提供统一 `@PreAuthorize` 能力。

## Scope

**In scope**
- 管理员登录/登出、记住账号（Cookie 存账号名）
- JWT 签发与刷新
- 角色、权限、管理员 CRUD
- 菜单树按权限过滤
- 审计日志（登录、权限变更）
- 通用审核状态枚举 `AuditStatus`

**Out of scope**
- 微信登录（02）
- 业务 CMS 权限细项（各模块注册 permission 码）

## Acceptance Criteria

- [ ] 登录成功返回 token + 菜单树
- [ ] 无权限接口返回 403
- [ ] 角色可配置权限树并即时生效
- [ ] 记住账号下次预填（不含明文密码）
- [ ] OpenAPI 标记 `stable`：login、menus、roles
