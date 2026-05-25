-- 模块 02 账号管理权限（挂到 super_admin 等角色）
-- 使用 INSERT IGNORE，避免迁移失败后重试时主键冲突

INSERT IGNORE INTO `sys_permission` (`id`, `code`, `name`, `module`, `parent_id`, `sort_no`) VALUES
(20, 'account', '账号管理', 'account', NULL, 20),
(21, 'account:user', '用户管理', 'account', 20, 1),
(22, 'account:user:list', '用户列表', 'account', 21, 1),
(23, 'account:user:edit', '编辑用户', 'account', 21, 2),
(24, 'account:student', '学员管理', 'account', 20, 2),
(25, 'account:student:list', '学员列表', 'account', 24, 1),
(26, 'account:student:create', '创建学员', 'account', 24, 2),
(27, 'account:student:edit', '编辑学员', 'account', 24, 3),
(28, 'account:student:delete', '删除学员', 'account', 24, 4),
(29, 'account:student:import', '导入学员', 'account', 24, 5),
(30, 'account:student:export', '导出学员', 'account', 24, 6);

INSERT IGNORE INTO `sys_role_permission` (`role_id`, `permission_id`)
SELECT 1, `id` FROM `sys_permission` WHERE `id` BETWEEN 20 AND 30;
