# Design — 00 工程基座

## 仓库结构

```
tcm-online/
├── api-server/          # Spring Boot 3
├── admin-web/           # Vue3 + Vite + Element Plus
├── miniapp/             # uni-app
├── official-web/        # Nuxt 3（16-official-web）
├── docker-compose.yml
└── docs/openapi/
```

## 统一响应

```json
{ "code": 0, "message": "ok", "data": {}, "traceId": "uuid" }
```

错误码段：0 成功；1xxxx 客户端；2xxxx 业务；5xxxx 系统。

## 核心 API（stable）

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/actuator/health` | 健康检查 |
| POST | `/api/common/v1/upload/presign` | OSS 预签名 |
| GET | `/api/common/v1/enums` | 公共枚举（审核状态等占位） |

## 配置

| 环境变量 | 用途 |
|---|---|
| `MYSQL_URL` | 数据库 |
| `REDIS_URL` | 缓存 |
| `OSS_ENDPOINT/BUCKET/KEY` | 对象存储 |
| `JWT_SECRET` | 占位，01 模块启用 |

## OSS 路径规范

```
/{env}/{module}/{yyyyMM}/{uuid}.{ext}
```

## 对外契约

- 包 `com.tcm.common`：Result、BizException、PageResult
- 各模块 BE 仅依赖 common，不得跨模块直接调 Service
