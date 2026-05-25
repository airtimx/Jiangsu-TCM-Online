-- 模块 01 认证 RBAC（规范 Flyway 段 00110–00119）

CREATE TABLE IF NOT EXISTS `sys_admin` (
  `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username`         VARCHAR(64)     NOT NULL COMMENT '登录账号',
  `password_hash`    VARCHAR(128)    NOT NULL COMMENT 'bcrypt 哈希',
  `real_name`        VARCHAR(64)     DEFAULT NULL,
  `phone`            VARCHAR(20)     DEFAULT NULL,
  `email`            VARCHAR(128)    DEFAULT NULL,
  `avatar_url`       VARCHAR(512)    DEFAULT NULL,
  `status`           TINYINT         NOT NULL DEFAULT 1 COMMENT '1启用 0禁用',
  `login_fail_count` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `locked_until`     DATETIME        DEFAULT NULL,
  `last_login_at`    DATETIME        DEFAULT NULL,
  `last_login_ip`    VARCHAR(64)     DEFAULT NULL,
  `deleted`          TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_admin_username` (`username`),
  KEY `idx_sys_admin_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员';

CREATE TABLE IF NOT EXISTS `sys_role` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(64)     NOT NULL COMMENT 'super_admin/content_editor等',
  `name`        VARCHAR(64)     NOT NULL,
  `description` VARCHAR(255)    DEFAULT NULL,
  `status`      TINYINT         NOT NULL DEFAULT 1,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_role_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色';

CREATE TABLE IF NOT EXISTS `sys_permission` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(128)    NOT NULL COMMENT 'course:video:audit',
  `name`        VARCHAR(64)     NOT NULL,
  `module`      VARCHAR(32)     DEFAULT NULL,
  `parent_id`   BIGINT UNSIGNED DEFAULT NULL COMMENT '权限树父节点',
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_permission_code` (`code`),
  KEY `idx_sys_permission_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限';

CREATE TABLE IF NOT EXISTS `sys_role_permission` (
  `role_id`       BIGINT UNSIGNED NOT NULL,
  `permission_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  KEY `idx_srp_permission` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色-权限';

CREATE TABLE IF NOT EXISTS `sys_admin_role` (
  `admin_id` BIGINT UNSIGNED NOT NULL,
  `role_id`  BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`admin_id`, `role_id`),
  KEY `idx_sar_role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员-角色';

CREATE TABLE IF NOT EXISTS `sys_login_log` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_id`   BIGINT UNSIGNED DEFAULT NULL,
  `username`   VARCHAR(64)     NOT NULL,
  `success`    TINYINT(1)      NOT NULL DEFAULT 0,
  `ip`         VARCHAR(64)     DEFAULT NULL,
  `user_agent` VARCHAR(512)    DEFAULT NULL,
  `message`    VARCHAR(255)    DEFAULT NULL,
  `created_at` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_login_log_admin` (`admin_id`),
  KEY `idx_login_log_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理端登录日志';
