-- 初始化种子数据（开发/测试环境）
-- 默认管理员密码：Admin@123（bcrypt，上线前务必修改）

USE `tcm_online`;

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- 角色
-- ---------------------------------------------------------------------------
INSERT INTO `sys_role` (`code`, `name`, `description`, `sort_no`) VALUES
  ('super_admin',    '超级管理员', '全部模块', 1),
  ('content_editor', '内容编辑',   '内容 CRUD，无审核通过', 2),
  ('auditor',        '审核员',     '审核通过/驳回', 3),
  ('student_admin',  '学员管理员', '学员/用户/导入导出', 4),
  ('analyst',        '数据分析员', '只读统计', 5),
  ('expert',         '专家',       '答疑回复', 6)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- ---------------------------------------------------------------------------
-- 权限（示例，可按模块扩展）
-- ---------------------------------------------------------------------------
INSERT INTO `sys_permission` (`code`, `name`, `module`, `sort_no`) VALUES
  ('system:admin:view',   '查看管理员', 'system', 10),
  ('system:admin:edit',   '编辑管理员', 'system', 11),
  ('system:role:view',    '查看角色',   'system', 20),
  ('system:role:edit',    '编辑角色',   'system', 21),
  ('article:view',        '查看资讯',   'article', 30),
  ('article:create',      '创建资讯',   'article', 31),
  ('article:audit',       '审核资讯',   'article', 32),
  ('course:view',         '查看课程',   'course', 40),
  ('course:create',       '创建课程',   'course', 41),
  ('course:audit',        '审核课程',   'course', 42),
  ('book:view',           '查看图书',   'book', 50),
  ('book:create',         '创建图书',   'book', 51),
  ('topic:view',          '查看专题',   'topic', 60),
  ('topic:create',        '创建专题',   'topic', 61),
  ('exam:view',           '查看题库',   'exam', 70),
  ('exam:create',         '维护题库',   'exam', 71),
  ('stats:view',          '查看统计',   'stats', 80),
  ('stats:export',        '导出统计',   'stats', 81)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- super_admin 绑定全部权限
INSERT IGNORE INTO `sys_role_permission` (`role_id`, `permission_id`)
SELECT r.id, p.id FROM `sys_role` r CROSS JOIN `sys_permission` p WHERE r.code = 'super_admin';

-- ---------------------------------------------------------------------------
-- 默认管理员 admin / Admin@123（bcrypt rounds=10，生产环境务必修改）
-- ---------------------------------------------------------------------------
INSERT INTO `sys_admin` (`username`, `password_hash`, `real_name`, `status`) VALUES
  ('admin', '$2b$10$ww.8o3lcU7L1kUvRaaTr7.z9kYQrjTb/ZzynGGduSSQ6A9ZR1iqsO', '系统管理员', 1)
ON DUPLICATE KEY UPDATE `real_name` = VALUES(`real_name`);

-- 绑定 super_admin（若 admin 已存在则补绑）
INSERT IGNORE INTO `sys_admin_role` (`admin_id`, `role_id`)
SELECT a.id, r.id FROM `sys_admin` a, `sys_role` r
WHERE a.username = 'admin' AND r.code = 'super_admin';

-- ---------------------------------------------------------------------------
-- 官网站点配置
-- ---------------------------------------------------------------------------
INSERT INTO `site_config` (`config_key`, `config_value`, `remark`) VALUES
  ('site_name', '"江苏中医在线"', '站点名称'),
  ('site_subtitle', '"江苏中医知识服务云平台"', '副标题'),
  ('icp_no', '"苏ICP备xxxx号"', '备案号'),
  ('miniapp_name', '"江苏中医在线"', '小程序名称'),
  ('customer_phone', '"400-000-0000"', '客服电话')
ON DUPLICATE KEY UPDATE `config_value` = VALUES(`config_value`);

INSERT INTO `site_nav` (`label`, `path`, `sort_no`, `nav_type`) VALUES
  ('首页', '/', 1, 'HEADER'),
  ('资讯', '/articles', 2, 'HEADER'),
  ('专题', '/topics', 3, 'HEADER'),
  ('课程', '/courses', 4, 'HEADER'),
  ('图书', '/books', 5, 'HEADER'),
  ('直播', '/live', 6, 'HEADER'),
  ('关于', '/about', 7, 'HEADER')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);

-- 知识库默认分类
INSERT INTO `kb_category` (`name`, `sort_no`) VALUES
  ('中医基础理论', 1),
  ('中医诊断学', 2),
  ('中药学', 3),
  ('方剂学', 4),
  ('中医内科学', 5),
  ('中医外科学', 6),
  ('四大经典', 7);
