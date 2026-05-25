# 模块 00 — 四端本地启动（前后端分离）

各端**独立目录、独立端口**，通过环境变量指向 API。

## 0. 后端依赖（仅 api 工程）

**Docker 方式**（需 Docker Desktop）：

```powershell
cd jiangsu-tcm-api
docker compose up -d
```

**本机 MySQL 方式**（无 Docker）：用 root 执行一次：

```powershell
cd jiangsu-tcm-api
mysql -u root -p < scripts\init-local-mysql.sql
```

若报错 `Access denied for user 'tcm'`，见 `jiangsu-tcm-api/README.md` 故障排查。

| 服务 | 端口 |
|------|------|
| MySQL | 3306 |
| Redis | 6379 |
| MinIO | 9000 / 9001 |

---

## 1. 后端 API — `jiangsu-tcm-api/`（:8081）

```powershell
cd jiangsu-tcm-api
.\mvnw.cmd -pl api-server spring-boot:run
```

| 地址 | 说明 |
|------|------|
| http://127.0.0.1:8081/actuator/health | 健康检查 |
| http://127.0.0.1:8081/docs | OpenAPI |
| http://127.0.0.1:8081/api/common/v1/enums | 公共枚举 |

---

## 2. 管理端 — `admin-web/`（:5173）

```powershell
cd admin-web
npm install
npm run dev
```

- 环境变量：`.env.development` → `VITE_API_BASE_URL=http://127.0.0.1:8081`
- **不使用 Vite 代理**，直连后端（前后端分离）

---

## 3. 小程序 — `miniapp/`

HBuilderX 打开仓库根目录下 `miniapp/`。

- `src/common/config.ts` → `API_BASE = http://127.0.0.1:8081`
- 微信开发者工具：关闭「校验合法域名」

---

## 4. 网页端 — `jiangsu-tcm-web/`（:3000）

```powershell
cd jiangsu-tcm-web
npm install
npm run dev
```

- `.env` → `NUXT_PUBLIC_API_BASE=http://127.0.0.1:8081`

---

## 联调检查

- [ ] API `health` = UP
- [ ] Admin 首页「检测 API」成功（跨域 + enums）
- [ ] Admin「上传联调」presign → MinIO
- [ ] 官网首页显示 API 正常
- [ ] 小程序首页「检测 API」成功
