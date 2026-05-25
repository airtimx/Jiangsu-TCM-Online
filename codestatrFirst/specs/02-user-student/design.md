# Design — 02 用户与学员

## 表

| 表 | 说明 |
|---|---|
| `app_user` | openid, nickname, phone, avatar |
| `student` | user_id, real_name, id_card, region, org, cert_status |
| `student_import_batch` | 导入批次与错误文件 |

## API

**小程序 stable**
- `POST /api/app/v1/auth/wx-login` body: `{ code }`
- `POST /api/app/v1/student/certify`
- `GET /api/app/v1/user/profile`

**管理端**
- `GET/PUT /api/admin/v1/users`
- `GET/POST/PUT/DELETE /api/admin/v1/students`
- `POST /api/admin/v1/students/import`
- `GET /api/admin/v1/students/export`

## 认证状态

`UNVERIFIED` → `PENDING` → `CERTIFIED` / `REJECTED`

## 并行说明

- MP 可用 Mock openid 开发认证 UI
- BE 导入导出与 MP 登录可不同人并行

## Admin 页面

- `/account/users` 图2.1–2.2
- `/account/students` 图2.3–2.4
