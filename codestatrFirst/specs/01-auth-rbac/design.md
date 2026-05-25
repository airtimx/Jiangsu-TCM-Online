# Design — 01 认证 RBAC

## 表结构（Flyway V010–V019）

| 表 | 说明 |
|---|---|
| `sys_admin` | 管理员账号 |
| `sys_role` | 角色 |
| `sys_permission` | 权限码 |
| `sys_role_permission` | 角色-权限 |
| `sys_admin_role` | 管理员-角色 |
| `sys_login_log` | 登录日志 |

## API（stable）

| 方法 | 路径 | 权限 |
|---|---|---|
| POST | `/api/admin/v1/auth/login` | 公开 |
| POST | `/api/admin/v1/auth/logout` | 登录 |
| GET | `/api/admin/v1/auth/me` | 登录 |
| GET | `/api/admin/v1/menus` | 登录 |
| CRUD | `/api/admin/v1/admins` | `system:admin:*` |
| CRUD | `/api/admin/v1/roles` | `system:role:*` |
| GET/PUT | `/api/admin/v1/roles/{id}/permissions` | `system:role:edit` |

## 权限码规范

```
{module}:{resource}:{action}
例：course:video:audit
```

## 预置角色

`super_admin` | `content_editor` | `auditor` | `student_admin` | `analyst`

## 公共组件

- `AuditStatus` 枚举：DRAFT/PENDING/APPROVED/REJECTED/PUBLISHED
- `AuditService` 接口供 CMS 模块复用

## Admin 页面

- `/login` 图1.1
- `/system/admins` 图3.1
- `/system/roles` 图3.2–3.3
