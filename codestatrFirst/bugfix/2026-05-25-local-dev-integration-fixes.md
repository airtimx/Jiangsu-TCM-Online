# Bugfix — 本地开发环境联调问题汇总

| 项 | 内容 |
|---|---|
| **日期** | 2026-05-25 |
| **环境** | Windows · JDK 17 · MySQL 本机 · IDEA + Vite/Nuxt dev |
| **影响波次** | W0 工程基座 · W1 模块 01/02 联调 |
| **关联文档** | [docs/START.md](../../docs/START.md) · [cache/tcm-online-platform.json](../cache/tcm-online-platform.json) |

---

## 问题 1：MySQL `Access denied for user 'tcm'`

### Problem
后端启动或 Flyway 迁移报错：`Access denied for user 'tcm'@'localhost' (1045)`。

### Impact
- 模块 00/01/02 后端无法启动
- 风险：**高**（阻塞全部 API）

### Root Cause
- 应用默认使用 `tcm/tcm123456` 连接 `tcm_online`
- 本机 MySQL 未执行 Navicat/脚本创建 `tcm` 用户，或密码不一致
- 曾存在 `application-local.yml` 含 root 密码，与方案 B 混用导致误配

### Fix
1. 在 Navicat 用 **root** 执行 [database/mysql/init_tcm_user_navicat.sql](../../database/mysql/init_tcm_user_navicat.sql)
2. 确认 [application.yml](../../jiangsu-tcm-api/api-server/src/main/resources/application.yml) 默认账号为 `tcm/tcm123456`
3. IDEA **Active profiles 留空**（不要填 `local`）
4. 或使用 [scripts/run-api-tcm.ps1](../../jiangsu-tcm-api/scripts/run-api-tcm.ps1) 启动

### Validation
- [ ] `mysql -u tcm -ptcm123456 tcm_online` 可连接
- [ ] API 启动无 Flyway 1045 错误
- [ ] `http://127.0.0.1:8081/actuator/health` 返回 UP

---

## 问题 2：端口 8080 被占用

### Problem
IDEA 启动报错：`Web server failed to start. Port 8080 was already in use`。

### Impact
- 无法启动第二个后端实例
- 风险：**中**

### Root Cause
- 8080 上已有 Java 进程（IDEA 与命令行各起一个，或 Cursor 后台 `spring-boot:run` 未退出）

### Fix
1. 默认端口已改为 **8081**（`application.yml` 中 `server.port`）
2. 释放占用：`netstat -ano | findstr :8080` → `taskkill /PID <pid> /F`
3. 四端 `.env` / 文档已同步为 8081

### Validation
- [ ] 仅保留一个 API 进程
- [ ] `http://127.0.0.1:8081/actuator/health` 正常

---

## 问题 3：官网 Health「不可用」（CORS）

### Problem
`jiangsu-tcm-web` 首页 Health 显示不可用；浏览器控制台跨域失败。

### Impact
- 官网联调误判后端宕机
- 风险：**中**

### Root Cause
- `/actuator/health` 由 Spring Actuator 提供，**不走** `WebMvc` 的 CORS 配置
- 浏览器从 `localhost:3000` 跨域访问 `127.0.0.1:8081` 被拦截

### Fix
在 [application.yml](../../jiangsu-tcm-api/api-server/src/main/resources/application.yml) 增加：

```yaml
management:
  endpoints:
    web:
      cors:
        allowed-origin-patterns: "http://localhost:*,http://127.0.0.1:*"
        allowed-methods: GET,OPTIONS
        allowed-headers: "*"
```

（后续官网 dev 改为 Vite 代理同源请求，见问题 5。）

### Validation
- [ ] 浏览器 Network 中 health 请求不再报 CORS 错误
- [ ] 首页显示 Health：UP

---

## 问题 4：前端仍请求 8080（`ERR_CONNECTION_REFUSED`）

### Problem
控制台仍出现 `127.0.0.1:8080/actuator/health` 连接被拒绝。

### Impact
- 管理端/官网无法联调
- 风险：**中**

### Root Cause
- 后端已改 8081，但 **Nuxt/Vite dev 未重启**，运行时仍缓存旧 `NUXT_PUBLIC_API_BASE=8080`

### Fix
1. 确认 `.env` 为 8081 或留空走代理（见问题 5）
2. **Ctrl+C** 停掉 dev，重新 `npm run dev`
3. 浏览器硬刷新或无痕窗口

### Validation
- [ ] Network 请求指向 8081 或 localhost:3000（代理）
- [ ] 无 8080 请求

---

## 问题 5：Nuxt 503 / 页面无响应

### Problem
访问 `http://localhost:3000/` 返回 **503** 或长时间加载。

### Impact
- 官网无法访问
- 风险：**中**

### Root Cause
- 3000 端口上 **Nuxt 进程卡死**（能连上但不响应）
- 或多个 `npm run dev` 实例争抢端口/HMR

### Fix
1. [nuxt.config.ts](../../jiangsu-tcm-web/nuxt.config.ts) 设置 `devServer.host: '127.0.0.1'`
2. 开发默认 `NUXT_PUBLIC_API_BASE` 留空，Vite 代理到 8081
3. 使用 [scripts/dev-reset.ps1](../../jiangsu-tcm-web/scripts/dev-reset.ps1) 或 `npm run dev:reset` 清理后重启
4. **同一时间只运行一个** `npm run dev`

### Validation
- [ ] 终端出现 `Local: http://127.0.0.1:3000/`
- [ ] 首页 HTTP 200

---

## 问题 6：Nuxt HMR 端口 24678 占用 / EPERM 删 `.nuxt`

### Problem
```
WebSocket server error: Port 24678 is already in use
Cannot restart nuxt: EPERM: operation not permitted, rmdir '.nuxt/dev'
```

### Impact
- Nuxt 无法热更新或重启
- 风险：**中**

### Root Cause
- 重复启动 Nuxt，旧进程占用 HMR WebSocket 端口
- 旧进程仍锁定 `.nuxt/dev` 目录

### Fix
1. `nuxt.config.ts` 中 HMR 改端口并 `strictPort: false`
2. 执行 `npm run dev:reset`（结束 3000/24678 进程并删除 `.nuxt`）
3. 再 `npm run dev`

### Validation
- [ ] 无 24678 占用报错
- [ ] 修改代码后 HMR 正常

---

## 问题 7：管理端登录后看不到「账号管理」菜单

### Problem
模块 02 完成后，侧栏无用户/学员管理入口。

### Impact
- 无法验证 02 功能
- 风险：**低**

### Root Cause
- 菜单来自登录时后端返回的权限树；**02 权限 Flyway 在已有库上需重启 API 并重新登录**
- 或仍使用旧 token / 未执行 `V00102002` 种子

### Fix
1. 重启 API，确认 Flyway 执行 `V00102001`、`V00102002`
2. 管理端 **退出重新登录**（admin / admin123456）
3. 确认 [base-menus.json](../../jiangsu-tcm-api/api-server/src/main/resources/auth/menus/base-menus.json) 含 `/account/users`、`/account/students`

### Validation
- [ ] 侧栏出现「账号管理 → 用户管理 / 学员管理」
- [ ] `/account/users`、`/account/students` 可访问

---

## 预防清单（联调前）

| 检查项 | 命令/地址 |
|--------|-----------|
| MySQL `tcm` 可连 | Navicat 或 `mysql -u tcm -p` |
| API 单实例 | `netstat -ano \| findstr :8081` |
| Health | http://127.0.0.1:8081/actuator/health |
| 管理端 env | `admin-web/.env.development` → 8081 |
| 官网 dev | 只开一个 `npm run dev`，必要时 `dev:reset` |
| 小程序 API | `Jiangsu-tcm-uniapp/common/request.uts` → 8081 |

---

## 变更文件索引

| 文件 | 变更说明 |
|------|----------|
| `jiangsu-tcm-api/.../application.yml` | 端口 8081、Actuator CORS、JWT/WX/SMS 配置 |
| `jiangsu-tcm-web/nuxt.config.ts` | devServer、Vite 代理、HMR |
| `jiangsu-tcm-web/scripts/dev-reset.ps1` | Nuxt 进程与缓存清理 |
| `admin-web/.env.development` | API 8081 |
| `docs/START.md` | 四端启动与联调地址 |
| `codestatrFirst/cache/tcm-online-platform.json` | 工程与进度缓存 |

---

**记录人**：AI Workspace / P1 联调  
**状态**：已修复项可在本机按 Validation 复验；未勾选项需执行人确认
