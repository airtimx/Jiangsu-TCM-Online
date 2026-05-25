-- 预置角色、权限、超级管理员（默认密码 admin123456，仅开发环境）
-- 使用 INSERT IGNORE / ON DUPLICATE KEY UPDATE，避免迁移失败后重试冲突

-- 兼容 schema_full 等旧表结构：sys_permission 可能缺少 parent_id
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

INSERT IGNORE INTO `sys_role` (`id`, `code`, `name`, `description`, `status`, `sort_no`) VALUES
(1, 'super_admin', '超级管理员', '拥有全部权限', 1, 0),
(2, 'content_editor', '内容编辑', '内容录入与编辑', 1, 10),
(3, 'auditor', '审核员', '内容审核', 1, 20),
(4, 'student_admin', '学员管理员', '学员与学籍', 1, 30),
(5, 'analyst', '数据分析员', '统计与报表', 1, 40);

INSERT IGNORE INTO `sys_permission` (`id`, `code`, `name`, `module`, `parent_id`, `sort_no`) VALUES
(1, 'system', '系统管理', 'system', NULL, 0),
(2, 'system:admin', '管理员', 'system', 1, 1),
(3, 'system:admin:list', '管理员列表', 'system', 2, 1),
(4, 'system:admin:create', '创建管理员', 'system', 2, 2),
(5, 'system:admin:edit', '编辑管理员', 'system', 2, 3),
(6, 'system:admin:delete', '删除管理员', 'system', 2, 4),
(7, 'system:role', '角色', 'system', 1, 2),
(8, 'system:role:list', '角色列表', 'system', 7, 1),
(9, 'system:role:create', '创建角色', 'system', 7, 2),
(10, 'system:role:edit', '编辑角色', 'system', 7, 3),
(11, 'system:role:delete', '删除角色', 'system', 7, 4),
(12, 'system:upload:demo', '上传联调', 'system', 1, 3),
(13, 'course:video:audit', '课程审核', 'course', NULL, 100);

INSERT IGNORE INTO `sys_role_permission` (`role_id`, `permission_id`)
SELECT 1, `id` FROM `sys_permission` WHERE `id` BETWEEN 1 AND 13;

INSERT INTO `sys_admin` (`id`, `username`, `password_hash`, `real_name`, `status`, `deleted`)
VALUES (1, 'admin', '$2a$10$MrP2XHDtE3bCU.4AsWBAtuwx/H9jkXkfAA/A..ozqkb3UvAEcumFK', '超级管理员', 1, 0)
ON DUPLICATE KEY UPDATE
    `password_hash` = VALUES(`password_hash`),
    `real_name` = VALUES(`real_name`),
    `status` = 1,
    `deleted` = 0;

INSERT IGNORE INTO `sys_admin_role` (`admin_id`, `role_id`) VALUES (1, 1);
