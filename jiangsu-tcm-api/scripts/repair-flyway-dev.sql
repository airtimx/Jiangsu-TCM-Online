-- Flyway 开发环境修复（Navicat 对 tcm_online 整文件执行一次）
-- 解决：Flyway 历史异常、schema_full/tcm_online.sql 旧权限码（view vs list）、admin 密码
-- 执行后 IDEA Rebuild，重启 API，管理端退出重新登录

USE `tcm_online`;

SELECT installed_rank, version, description, success, checksum
FROM flyway_schema_history
ORDER BY installed_rank;

DELETE FROM flyway_schema_history WHERE success = 0;

-- 清理旧版权限（tcm_online.sql 为 system:admin:view，Flyway 为 system:admin:list）
DELETE FROM sys_role_permission WHERE permission_id BETWEEN 1 AND 30;
DELETE FROM sys_permission WHERE id BETWEEN 1 AND 30;

-- 重跑种子迁移
DELETE FROM flyway_schema_history WHERE version IN ('00101002', '00102002');

-- 补 parent_id（schema_full 旧库）
SET @col_exists = (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'sys_permission'
      AND COLUMN_NAME = 'parent_id'
);
SET @ddl = IF(
    @col_exists = 0,
    'ALTER TABLE `sys_permission` ADD COLUMN `parent_id` BIGINT UNSIGNED DEFAULT NULL COMMENT ''权限树父节点'' AFTER `module`, ADD KEY `idx_sys_permission_parent` (`parent_id`)',
    'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 重置 admin 密码为 admin123456
UPDATE `sys_admin`
SET `password_hash` = '$2a$10$MrP2XHDtE3bCU.4AsWBAtuwx/H9jkXkfAA/A..ozqkb3UvAEcumFK',
    `status` = 1,
    `deleted` = 0
WHERE `username` = 'admin';

SELECT installed_rank, version, description, success
FROM flyway_schema_history
ORDER BY installed_rank;
