# 错误修改报告 — 本地开发环境联调（2026-05-25 ~ 2026-05-26）

| 项 | 内容 |
|---|---|
| **报告日期** | 2026-05-26 |
| **执行人** | 蒋玉泽（P1） |
| **环境** | Windows · JDK 21 · MySQL 8.4 · IDEA + Vite/Nuxt dev |
| **影响范围** | 模块 00 工程基座 · 模块 01 认证 RBAC · 模块 02 用户学员 |
| **关联文档** | [docs/START.md](../../docs/START.md) · [cache/tcm-online-platform.json](../cache/tcm-online-platform.json) |

---

## 一、摘要

本次联调共记录 **14 类问题**，其中 **阻塞启动/登录** 的高风险项 6 个，均已给出代码或脚本修复方案。问题高度集中在：

1. **数据库初始化路径混用**（Flyway 迁移 vs `schema_full.sql` / Navicat 全库导出）
2. **Flyway 历史表与本地迁移文件不一致**（误删 SQL、checksum 变更、失败记录未清理）
3. **种子数据非幂等**导致重试失败

**当前推荐初始化方式**：仅使用 Flyway（`db/migration/V001*.sql`），不要导入 `database/mysql/tcm_online.sql` 覆盖开发库。

---

## 二、问题清单总览

| # | 现象 | 错误码/关键字 | 风险 | 状态 |
|---|------|---------------|------|------|
| 1 | MySQL `tcm` 用户无法连接 | 1045 | 高 | 已文档化 |
| 2 | 端口 8080 占用 | Address already in use | 中 | 已改 8081 |
| 3 | 官网 Health CORS 失败 | CORS | 中 | 已修复 |
| 4 | 前端仍请求 8080 | ERR_CONNECTION_REFUSED | 中 | 已文档化 |
| 5 | Nuxt 503 / 无响应 | HTTP 503 | 中 | 已修复 |
| 6 | Nuxt HMR 24678 占用 | EPERM / port in use | 中 | 已修复 |
| 7 | 登录后无「账号管理」菜单 | 权限未加载 | 低 | 需重登 |
| 8 | Flyway 种子主键冲突 | 1062 | 高 | 已改 INSERT IGNORE |
| 9 | `sys_permission` 缺 `parent_id` | 1054 | 高 | 已补列逻辑 |
| 10 | 管理端登录「账号或密码错误」 | code 10002 | 高 | 已提供重置脚本 |
| 11 | 误删 Flyway 迁移 SQL | not resolved locally | 高 | 已从 git 恢复 |
| 12 | Flyway checksum 不匹配 | checksum mismatch | 高 | repair 脚本 |
| 13 | Flyway 失败迁移未清理 | failed migration | 高 | repair 脚本 |
| 14 | 漏跑 00101002 但高版本已执行 | not applied / outOfOrder | 高 | out-of-order + repair |

---

## 三、详细问题与修改

### 问题 1：MySQL `Access denied for user 'tcm'`（1045）

**现象**：后端或 Flyway 无法连接数据库。

**根因**：本机未创建 `tcm/tcm123456` 用户，或与 `application.yml` 默认配置不一致。

**修改**：
- 默认连接改为 `tcm/tcm123456`（方案 B）
- 提供 `database/mysql/init_tcm_user_navicat.sql`

**验证**：`mysql -u tcm -ptcm123456 tcm_online` 可连接。

---

### 问题 2：端口 8080 被占用

**现象**：`Web server failed to start. Port 8080 was already in use`。

**修改**：`application.yml` 默认端口改为 **8081**；四端 `.env` 与 `docs/START.md` 同步。

---

### 问题 3：官网 Health CORS 失败

**现象**：`jiangsu-tcm-web` 跨域访问 `/actuator/health` 被拦截。

**修改**：`application.yml` 增加 `management.endpoints.web.cors` 配置。

---

### 问题 4：前端仍请求 8080

**根因**：Vite/Nuxt dev 未重启，缓存旧 API 地址。

**修改**：文档说明需重启 dev；`.env` 指向 8081 或留空走代理。

---

### 问题 5：Nuxt 503 / 页面无响应

**修改**：`nuxt.config.ts` 设置 `devServer.host: '127.0.0.1'`；提供 `jiangsu-tcm-web/scripts/dev-reset.ps1`。

---

### 问题 6：Nuxt HMR 24678 占用

**修改**：HMR 改端口 + `dev:reset` 清理 `.nuxt` 与僵尸进程。

---

### 问题 7：管理端登录后无「账号管理」菜单

**根因**：`V00102002` 权限 (id 20–30) 未执行或 token 未刷新。

**修改**：确认 `base-menus.json` 含账号管理路由；**退出重新登录**。

---

### 问题 8：Flyway 种子主键冲突（1062）

**现象**：
```
V00101002__seed_auth_rbac.sql failed
Duplicate entry '1' for key 'sys_role.PRIMARY'
```

**根因**：迁移中断后数据已写入，`flyway_schema_history` 未记成功；重启再次 `INSERT` 冲突。

**代码修改**：

| 文件 | 修改 |
|------|------|
| `V00101002__seed_auth_rbac.sql` | `INSERT` → `INSERT IGNORE` |
| `V00102002__seed_user_student_permissions.sql` | 同上 |

---

### 问题 9：`sys_permission` 缺少 `parent_id`（1054）

**现象**：执行种子 SQL 报 `Unknown column 'parent_id' in 'field list'`。

**根因**：
- 库由 `schema_full.sql` 或 Navicat 导出初始化，旧表无 `parent_id`
- `V00101001` 使用 `CREATE TABLE IF NOT EXISTS`，不会改已有表结构

**代码修改**：

| 文件 | 修改 |
|------|------|
| `V00101002__seed_auth_rbac.sql` | 开头增加条件 `ALTER TABLE` 补 `parent_id` |
| `database/mysql/schema_full.sql` | `sys_permission` 增加 `parent_id` 列 |

---

### 问题 10：管理端登录「账号或密码错误」

**现象**：`POST /api/admin/v1/auth/login` 返回 `code: 10002`；控制台 `Error: 账号或密码错误`。

**根因**：导入 `database/mysql/tcm_online.sql` 后，`admin` 密码哈希与 Flyway 种子 `admin123456` 不一致；`INSERT IGNORE` 不会覆盖已有密码。

**修改**：

| 文件 | 说明 |
|------|------|
| `scripts/reset-admin-password-dev.sql` | Navicat 一键重置 admin 密码 |
| `V00101002__seed_auth_rbac.sql` | `sys_admin` 改为 `ON DUPLICATE KEY UPDATE` 同步密码 |

**默认账号**：`admin` / `admin123456`

---

### 问题 11：误删 Flyway 迁移 SQL

**现象**：
```
Detected applied migration not resolved locally: 00100001 / 00100002 / 00101001
```

**根因**：`db/migration/` 下 6 个 `V001*.sql` 被误删，仅剩 `V00101002`；曾误将 Navicat 导出 `tcm_online.sql` 放入 migration 目录。

**修改**：
- 从 git 恢复全部 6 个迁移文件
- 删除误放的 `db/migration/tcm_online.sql`（Navicat 全库 dump 不属于 Flyway）

**重要**：`db/migration/V001*.sql` 为应用启动必需，**禁止删除**。

---

### 问题 12：Flyway checksum 不匹配

**现象**：
```
Migration checksum mismatch for migration version 00101002
-> Applied to database : 22446508
-> Resolved locally    : 1846961866
```

**根因**：修复种子脚本后文件内容变更，与 `flyway_schema_history.checksum` 不一致。

**修改**：`repair-flyway-dev.sql` 删除 `00101002`（及后续版本）历史记录，启动时按新脚本重跑。

---

### 问题 13：Flyway 失败迁移记录未清理

**现象**：
```
Detected failed migration to version 00101002
Please remove any half-completed changes then run repair
```

**修改**：
```sql
DELETE FROM flyway_schema_history WHERE success = 0;
```

---

### 问题 14：漏跑 00101002，高版本已在历史中

**现象**：
```
Detected resolved migration not applied to database: 00101002
To allow executing this migration, set -outOfOrder=true
```

**根因**：repair 只删了 `00101002` 记录，但 `00102001`/`00102002` 仍在历史中，Flyway 默认禁止乱序补跑。

**修改**：

| 文件 | 修改 |
|------|------|
| `application.yml` | `spring.flyway.out-of-order: true`（开发环境） |
| `repair-flyway-dev.sql` | 同时删除 `00101002`、`00102001`、`00102002` 历史 |

---

### 问题 15：Navicat 只执行 SQL 片段导致语法错误

**现象**：`[SQL] Finished with error`，从 `(27, 'account:student:edit'...` 开始执行。

**根因**：未选中完整 `INSERT INTO ... VALUES`，缺少语句头部。

**规范**：迁移/种子 SQL 必须**整文件执行**，不要只选中 VALUES 中间几行。

---

## 四、代码与脚本变更索引

### 4.1 Flyway 迁移（`api-server/src/main/resources/db/migration/`）

| 文件 | 最终状态 |
|------|----------|
| `V00100001__baseline_platform.sql` | 基座表（已恢复） |
| `V00100002__seed_sys_config.sql` | 系统配置种子（已恢复） |
| `V00101001__auth_rbac_tables.sql` | RBAC 表（已恢复） |
| `V00101002__seed_auth_rbac.sql` | INSERT IGNORE + parent_id 补列 + admin ON DUPLICATE KEY UPDATE |
| `V00102001__user_student_tables.sql` | 用户学员表（已恢复） |
| `V00102002__seed_user_student_permissions.sql` | INSERT IGNORE 账号权限种子 |

### 4.2 运维脚本（`jiangsu-tcm-api/scripts/`）

| 脚本 | 用途 |
|------|------|
| [repair-flyway-dev.sql](../../jiangsu-tcm-api/scripts/repair-flyway-dev.sql) | **主修复脚本**：清失败记录、删 00101002~00102002 历史、补 parent_id、重置 admin 密码 |
| [repair-flyway-dev.ps1](../../jiangsu-tcm-api/scripts/repair-flyway-dev.ps1) | 命令行执行 repair（需 mysql.exe 在 PATH） |
| [reset-admin-password-dev.sql](../../jiangsu-tcm-api/scripts/reset-admin-password-dev.sql) | 仅重置 admin 密码 |
| [run-api-tcm.ps1](../../jiangsu-tcm-api/scripts/run-api-tcm.ps1) | 使用 tcm 账号启动 API |
| [init-mysql.ps1](../../jiangsu-tcm-api/scripts/init-mysql.ps1) | root 初始化 tcm 用户 |

### 4.3 应用配置

| 文件 | 关键变更 |
|------|----------|
| `application.yml` | 端口 8081 · Actuator CORS · `flyway.out-of-order: true` |
| `database/mysql/schema_full.sql` | `sys_permission.parent_id` 与 Flyway 对齐 |

### 4.4 已删除的临时/误放文件

| 文件 | 原因 |
|------|------|
| `db/migration/tcm_online.sql` | Navicat 全库 dump，不应在 Flyway 目录 |
| `scripts/fix-sys-permission-parent-id.sql` | 逻辑已合并进 `V00101002` 与 `repair-flyway-dev.sql` |
| `scripts/repair-flyway-failed.sql` | 由 `repair-flyway-dev.sql` 替代 |
| `scripts/seed-account-permissions-manual.sql` | 临时手动脚本，已废弃 |

---

## 五、一键恢复流程（开发库）

当 Flyway / 登录 / 种子数据混乱时，按顺序执行：

### 步骤 1：Navicat 执行 repair

整文件执行：[jiangsu-tcm-api/scripts/repair-flyway-dev.sql](../../jiangsu-tcm-api/scripts/repair-flyway-dev.sql)

### 步骤 2：IDEA Rebuild

**Build → Rebuild Project**（确保 `target/classes/db/migration/` 含 6 个 SQL）

### 步骤 3：重启 API

Run `JiangsuTcmOnlineApplication`，确认日志无 Flyway 报错。

### 步骤 4：验证

```sql
-- Flyway 全绿
SELECT version, success FROM flyway_schema_history ORDER BY installed_rank;

-- admin 存在且启用
SELECT username, status, deleted FROM sys_admin WHERE username = 'admin';
```

```
GET  http://127.0.0.1:8081/actuator/health  → UP
POST http://127.0.0.1:8081/api/admin/v1/auth/login
     {"username":"admin","password":"admin123456"}  → code: 0
```

### 步骤 5：管理端重新登录

`http://127.0.0.1:5173` · 账号 `admin` / `admin123456` · 退出后重登以刷新菜单。

### 核选项（可丢本地数据时）

```sql
DROP DATABASE tcm_online;
CREATE DATABASE tcm_online DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- 再执行 init_tcm_user_navicat.sql（如需），然后启动 API 让 Flyway 从头迁移
```

---

## 六、预防规范

| 规范 | 说明 |
|------|------|
| **只用 Flyway 管库表** | 开发库不要用 `tcm_online.sql` 全库导入覆盖 |
| **勿删 `db/migration/V001*.sql`** | 6 个文件缺一不可 |
| **勿改已成功的迁移** | 结构变更应新增更高版本号，如 `V00101003__xxx.sql` |
| **Navicat 整文件执行 SQL** | 不要只选中 VALUES 片段 |
| **repair 后 Rebuild** | 确保 classpath 中 migration 与源码一致 |
| **改权限/菜单后重登** | 旧 JWT 不含新 permission |

---

## 七、验收清单

| 检查项 | 期望 |
|--------|------|
| API 启动 | 无 Flyway Validate/Migrate 异常 |
| `flyway_schema_history` | `00100001` ~ `00102002` 全部 `success=1` |
| Health | `http://127.0.0.1:8081/actuator/health` → UP |
| 管理端登录 | `admin` / `admin123456` 成功 |
| 侧栏菜单 | 系统管理 + 账号管理可见 |
| 四端 API 地址 | 均指向 8081 |

---

**报告状态**：代码与脚本修复已完成；验收项需本机按「第五节一键恢复」执行后勾选确认。

**记录人**：AI Workspace / P1 联调  
**最后更新**：2026-05-26
