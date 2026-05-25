# 错误修复报告 — 2026-05-26（本地联调）

| 项 | 内容 |
|---|---|
| **报告日期** | 2026-05-26 |
| **执行人** | 蒋玉泽（P1） |
| **环境** | Windows · JDK 21 · MySQL 8.4 · IDEA · admin-web :5173 · API :8081 |
| **关联** | [2026-05-25 联调汇总](./2026-05-25-local-dev-integration-fixes.md) |

---

## 一、今日摘要

今日联调以 **Flyway + 数据库权限数据不一致** 为主线，导致 API 无法启动、管理端登录失败、管理员/角色列表报「系统繁忙」。截至报告编写时，**代码与脚本修复已完成**；本机需按「第五节一键恢复」执行 SQL 并重新登录验收。

| 类别 | 今日新增/强化问题数 | 阻塞级 |
|------|---------------------|--------|
| Flyway 迁移 | 6 | 是 |
| 数据库结构/种子 | 3 | 是 |
| 管理端权限/接口 | 2 | 是 |
| 管理端前端 404 | 1 | 否（噪音） |

**核心结论**：开发库不要用 `database/mysql/tcm_online.sql` 全库导入；只走 Flyway（`db/migration/V001*.sql`），勿删除迁移文件。

---

## 二、今日问题清单

| # | 现象 | 根因概要 | 修复状态 |
|---|------|----------|----------|
| 1 | API 启动失败 `Duplicate entry '1' for sys_role` | 种子非幂等 + 迁移中断重试 | 已改 `INSERT IGNORE` |
| 2 | 执行种子 SQL `1054 Unknown column 'parent_id'` | `schema_full`/`tcm_online.sql` 旧表结构 | 种子内自动 `ALTER` + repair 脚本 |
| 3 | 管理端登录「账号或密码错误」 | 导入库 admin 密码哈希非 `admin123456` | `reset-admin-password` + `ON DUPLICATE KEY UPDATE` |
| 4 | Flyway `applied migration not resolved locally` | **误删** `V00100001` 等 5 个迁移文件 | 已从 git 恢复 6 个 SQL |
| 5 | Flyway `checksum mismatch` 00101002 | 修改种子后历史 checksum 过期 | `repair-flyway-dev.sql` 删历史重跑 |
| 6 | Flyway `failed migration` 00101002 | 失败记录未清理 | `DELETE success=0` |
| 7 | Flyway `resolved migration not applied: 00101002` | 只删 01002 历史但 020xx 仍在 | `out-of-order: true` + 删 01002~02002 历史 |
| 8 | 管理员/角色页「系统繁忙」`code 50000` | 权限码 `view` ≠ 后端要求 `list`；鉴权异常未处理 | 清权限重跑种子 + `GlobalExceptionHandler` |
| 9 | 浏览器 Network `404 Not Found` | `favicon.ico`、侧栏父路径 `/system` 无路由 | 前端路由重定向 + 菜单 index 修正 |

---

## 三、详细说明与修改

### 3.1 Flyway 种子主键冲突（1062）

**日志**：
```
V00101002__seed_auth_rbac.sql failed
Duplicate entry '1' for key 'sys_role.PRIMARY'
```

**根因**：`V00101002` 执行失败后数据已写入，`flyway_schema_history` 未成功；重启再次 `INSERT` 冲突。

**修改**：
- `V00101002__seed_auth_rbac.sql`、`V00102002__seed_user_student_permissions.sql` → `INSERT IGNORE`
- `sys_admin` 使用 `ON DUPLICATE KEY UPDATE` 同步开发环境密码

---

### 3.2 缺少 `parent_id` 列（1054）

**日志**：`Unknown column 'parent_id' in 'field list'`

**根因**：库由 `tcm_online.sql` / `schema_full.sql` 初始化，`sys_permission` 无 `parent_id`；`CREATE TABLE IF NOT EXISTS` 不会改旧表。

**修改**：
- `V00101002` 开头条件 `ALTER TABLE` 补列
- `database/mysql/schema_full.sql` 与 Flyway 对齐
- `repair-flyway-dev.sql` 含补列逻辑

---

### 3.3 管理端登录失败（10002）

**现象**：`POST /auth/login` 返回「账号或密码错误」。

**根因**：`tcm_online.sql` 中 admin 的 bcrypt 与 Flyway 种子 `admin123456` 不一致；`INSERT IGNORE` 不覆盖已有密码。

**修改**：
- 脚本 [reset-admin-password-dev.sql](../../jiangsu-tcm-api/scripts/reset-admin-password-dev.sql)
- 默认账号：`admin` / `admin123456`

---

### 3.4 误删 Flyway 迁移文件

**日志**：
```
Detected applied migration not resolved locally: 00100001, 00100002, 00101001
```

**根因**：`db/migration/` 仅剩 `V00101002`；曾误放 Navicat 全库 dump `tcm_online.sql`（已删除）。

**修改**：`git checkout` 恢复 6 个 `V001*.sql`。

**规范**：禁止删除 `db/migration/V001*.sql`。

---

### 3.5 Flyway 校验：checksum / failed / 乱序

| 错误信息 | 处理 |
|----------|------|
| `checksum mismatch for 00101002` | 删除该版本 `flyway_schema_history` 记录后重跑 |
| `Detected failed migration to version 00101002` | `DELETE FROM flyway_schema_history WHERE success = 0` |
| `resolved migration not applied: 00101002` | `application.yml` 增加 `flyway.out-of-order: true`；repair 同时删 `00101002`、`00102002` 历史 |

---

### 3.6 管理员/角色列表「系统繁忙」（50000）

**现象**：`AdminListView` / `RoleListView` mounted 报错；API 返回 `code: 50000`。

**根因（双重）**：

1. **数据**：`tcm_online.sql` 权限为 `system:admin:view`、`system:role:view`；Controller 要求 `system:admin:list`、`system:role:list`。
2. **代码**：`@PreAuthorize` 拒绝时抛 `AuthorizationDeniedException`，落入 `GlobalExceptionHandler` 通用 `Exception`，误报 50000。

**修改**：

| 文件 | 变更 |
|------|------|
| `GlobalExceptionHandler.java` | 捕获 `AccessDeniedException` / `AuthorizationDeniedException` → `10003 无访问权限` |
| `fix-rbac-permissions-dev.sql` | 删除 id 1–30 旧权限，重跑 01002/02002 种子 |
| `repair-flyway-dev.sql` | 合并权限清理 + Flyway + 密码重置 |
| `MybatisPlusConfig.java` | 移除重复 `@MapperScan`（消除启动 WARN） |

**验收**：修复并重新登录后，`GET /api/admin/v1/admins`、`/roles` 应返回 `code: 0`。

---

### 3.7 管理端浏览器 404

**现象**：控制台 `Failed to load resource: 404`。

**常见 URL**：
- `http://127.0.0.1:5173/favicon.ico` — 无图标文件
- `/system`、`/account` — 侧栏父菜单无对应路由

**修改**（admin-web）：

| 文件 | 变更 |
|------|------|
| `index.html` | `<link rel="icon" href="data:," />` 抑制 favicon 请求 |
| `router/index.ts` | `/account` → `/account/users`，`/system` → `/system/admins` |
| `AdminLayout.vue` | 子菜单 `index` 改为 `group:/system`，不参与路由 |

---

## 四、今日变更文件索引

### 4.1 后端（jiangsu-tcm-api）

| 路径 | 说明 |
|------|------|
| `api-server/.../db/migration/V00101002__seed_auth_rbac.sql` | IGNORE、parent_id、admin 密码 UPSERT |
| `api-server/.../db/migration/V00102002__seed_user_student_permissions.sql` | INSERT IGNORE |
| `api-server/.../application.yml` | `flyway.out-of-order: true` |
| `api-server/.../GlobalExceptionHandler.java` | 权限拒绝 → 10003 |
| `api-server/.../MybatisPlusConfig.java` | 去掉重复 MapperScan |
| `database/mysql/schema_full.sql` | `sys_permission.parent_id` |

### 4.2 运维脚本（scripts/）

| 脚本 | 用途 |
|------|------|
| [repair-flyway-dev.sql](../../jiangsu-tcm-api/scripts/repair-flyway-dev.sql) | **主修复**：Flyway 历史 + 清旧权限 + 补列 + 重置密码 |
| [fix-rbac-permissions-dev.sql](../../jiangsu-tcm-api/scripts/fix-rbac-permissions-dev.sql) | 仅修 RBAC 权限码 |
| [reset-admin-password-dev.sql](../../jiangsu-tcm-api/scripts/reset-admin-password-dev.sql) | 仅重置 admin 密码 |
| [repair-flyway-dev.ps1](../../jiangsu-tcm-api/scripts/repair-flyway-dev.ps1) | 命令行执行 repair（需 mysql.exe） |

### 4.3 管理端（admin-web）

| 路径 | 说明 |
|------|------|
| `index.html` | favicon 占位 |
| `src/router/index.ts` | account/system 重定向 |
| `src/layouts/AdminLayout.vue` | 子菜单 index 不参与路由 |

### 4.4 已删除/废弃

| 文件 | 原因 |
|------|------|
| `db/migration/tcm_online.sql` | Navicat dump 不应在 Flyway 目录 |
| `scripts/fix-sys-permission-parent-id.sql` 等 | 已合并进 repair / 种子 |

---

## 五、一键恢复（本机验收）

```text
1. Navicat → tcm_online → 执行 repair-flyway-dev.sql（整文件）
2. IDEA → Build → Rebuild Project
3. 启动 JiangsuTcmOnlineApplication（端口 8081）
4. admin-web：npm run dev → http://127.0.0.1:5173
5. 退出并重新登录 admin / admin123456
```

**SQL 验证**：

```sql
SELECT version, success FROM flyway_schema_history ORDER BY installed_rank;
SELECT code FROM sys_permission WHERE code LIKE 'system:admin%' OR code LIKE 'system:role%';
-- 应含 system:admin:list、system:role:list（非 view）
```

**接口验证**：

```text
GET  http://127.0.0.1:8081/actuator/health  → UP
POST http://127.0.0.1:8081/api/admin/v1/auth/login  → code: 0
GET  http://127.0.0.1:8081/api/admin/v1/admins?page=1  → code: 0（需带 Token）
```

---

## 六、预防规范

1. **开发库只用 Flyway**，不用 `tcm_online.sql` 全库覆盖。
2. **勿删** `db/migration/V00100001` ~ `V00102002` 共 6 个文件。
3. **勿改**已上线迁移文件内容；结构变更用更高版本号新文件。
4. Navicat 执行 SQL 须**整文件**，不要只选中 VALUES 片段。
5. 修权限/Flyway 后必须**退出重新登录**管理端。
6. 浏览器 404 先看 Network 完整 URL，区分 favicon / 前端路由 / API。

---

## 七、验收清单

| 检查项 | 期望 | 确认 |
|--------|------|------|
| API 启动无 Flyway 报错 | 是 | ☐ |
| flyway 00100001~00102002 全 success=1 | 是 | ☐ |
| 登录 admin/admin123456 | code: 0 | ☐ |
| 管理员列表可加载 | code: 0 | ☐ |
| 角色列表可加载 | code: 0 | ☐ |
| 侧栏有账号管理 | 是 | ☐ |
| 控制台无业务相关 404/500 | 是 | ☐ |

---

**报告状态**：代码与脚本已提交至工作区；验收项需执行人按第五节在本机勾选。

**记录人**：AI Workspace / P1 联调
