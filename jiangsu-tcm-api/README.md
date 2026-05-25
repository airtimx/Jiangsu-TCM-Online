# jiangsu-tcm-api — 江苏中医在线后端

**前后端分离**：本目录仅包含 Java 后端，不含任何前端工程。

```
jiangsu-tcm-api/
├── pom.xml
├── tcm-common/
├── api-server/
├── docker-compose.yml
└── docs/openapi/
```

前端工程位于仓库根目录：`../admin-web`、`../miniapp`、`../jiangsu-tcm-web`。

## 启动

```powershell
docker compose up -d
.\mvnw.cmd -pl api-server spring-boot:run
```

默认端口 **8081**。前端通过 `http://127.0.0.1:8081` 调用 API（见仓库根 `docs/START.md`）。

### 模块 01 管理端登录（Flyway 预置）

| 项 | 值 |
|---|---|
| 账号 | `admin` |
| 密码 | `admin123456` |
| 登录 API | `POST /api/admin/v1/auth/login` |

## 数据库连接失败（Access denied for user 'tcm'）

**原因**：本机 3306 上的 MySQL 没有 `tcm` 用户（常见于未用 Docker、或用的是本地安装的 MySQL）。

**解决（任选其一）**

### 方式 A：创建应用账号（推荐）

在 `jiangsu-tcm-api` 目录执行（将 `root` 密码换成你的）：

```powershell
mysql -u root -p < scripts\init-local-mysql.sql
```

然后重新启动 API（默认 `tcm` / `tcm123456`）。

### 方式 B：使用 Docker MySQL

安装并启动 Docker Desktop 后：

```powershell
docker compose up -d
```

确保本机 **3306 未被其他 MySQL 占用**；若占用，可改 `docker-compose.yml` 端口映射为 `3307:3306`，并设置：

```powershell
$env:MYSQL_URL="jdbc:mysql://127.0.0.1:3307/tcm_online?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true"
```

### 方式 C：临时用 root

已生成本地配置 `api-server/application-local.yml`（**已 gitignore，勿提交**）。

```powershell
cd jiangsu-tcm-api
.\mvnw.cmd -pl api-server spring-boot:run "-Dspring-boot.run.profiles=local"
```

或在 IDEA：**Active profiles** 填 `local`。

### 方式 D：root 创建 tcm 用户后仍用默认账号

```powershell
powershell -ExecutionPolicy Bypass -File scripts\init-mysql.ps1
.\mvnw.cmd -pl api-server spring-boot:run
```

### 已有 Docker 数据卷但密码不对

```powershell
docker compose down -v
docker compose up -d
```

会清空 MySQL 数据卷并按 `docker-compose.yml` 重新初始化用户。
