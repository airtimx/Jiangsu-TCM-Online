-- V000–V009 工程基座（P1）
-- 媒体资源、系统配置、操作审计

USE `tcm_online`;

-- ---------------------------------------------------------------------------
-- 媒体资源（OSS 登记）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `media_asset` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `module`        VARCHAR(32)     NOT NULL COMMENT '业务模块：course/book/article等',
  `file_name`     VARCHAR(255)    NOT NULL COMMENT '原始文件名',
  `oss_key`       VARCHAR(512)    NOT NULL COMMENT 'OSS 对象键',
  `mime_type`     VARCHAR(128)    DEFAULT NULL COMMENT 'MIME',
  `file_size`     BIGINT UNSIGNED DEFAULT 0 COMMENT '字节数',
  `duration_sec`  INT UNSIGNED    DEFAULT NULL COMMENT '音视频时长（秒）',
  `status`        VARCHAR(16)     NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE/DELETED',
  `created_by`    BIGINT UNSIGNED DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_media_oss_key` (`oss_key`),
  KEY `idx_media_module` (`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='媒体资源';

-- ---------------------------------------------------------------------------
-- 系统配置
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sys_config` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_key`  VARCHAR(64)     NOT NULL COMMENT '配置键',
  `config_value` TEXT           COMMENT '配置值（JSON 或文本）',
  `remark`      VARCHAR(255)    DEFAULT NULL,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置';

-- ---------------------------------------------------------------------------
-- 操作审计（审核、删除、导出等）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `audit_log` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `operator_type` VARCHAR(16)     NOT NULL COMMENT 'ADMIN/APP/SYSTEM',
  `operator_id`   BIGINT UNSIGNED DEFAULT NULL COMMENT '操作人 ID',
  `operator_name` VARCHAR(64)     DEFAULT NULL,
  `action`        VARCHAR(64)     NOT NULL COMMENT '动作：AUDIT_APPROVE/DELETE/EXPORT等',
  `resource_type` VARCHAR(32)     DEFAULT NULL COMMENT '资源类型',
  `resource_id`   BIGINT UNSIGNED DEFAULT NULL,
  `before_data`   JSON            DEFAULT NULL,
  `after_data`    JSON            DEFAULT NULL,
  `ip`            VARCHAR(64)     DEFAULT NULL,
  `user_agent`    VARCHAR(512)    DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_resource` (`resource_type`, `resource_id`),
  KEY `idx_audit_operator` (`operator_type`, `operator_id`),
  KEY `idx_audit_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作审计日志';
