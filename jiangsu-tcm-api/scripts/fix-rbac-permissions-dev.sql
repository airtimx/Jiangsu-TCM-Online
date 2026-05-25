-- 仅修复 RBAC 权限码（tcm_online.sql 旧码 view vs Flyway 新码 list）
-- 执行后重启 API，管理端退出重新登录

USE `tcm_online`;

DELETE FROM sys_role_permission WHERE permission_id BETWEEN 1 AND 30;
DELETE FROM sys_permission WHERE id BETWEEN 1 AND 30;
DELETE FROM flyway_schema_history WHERE version IN ('00101002', '00102002');

-- 重启 API 后 Flyway 会重跑 V00101002、V00102002
