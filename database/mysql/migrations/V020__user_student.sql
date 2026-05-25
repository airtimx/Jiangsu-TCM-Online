-- V020–V029 用户与学员（P3）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `app_user` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `openid`        VARCHAR(64)     NOT NULL COMMENT '微信 openid',
  `unionid`       VARCHAR(64)     DEFAULT NULL,
  `nickname`      VARCHAR(64)     DEFAULT NULL,
  `avatar_url`    VARCHAR(512)    DEFAULT NULL,
  `phone`         VARCHAR(20)     DEFAULT NULL,
  `user_type`     VARCHAR(16)     NOT NULL DEFAULT 'VISITOR' COMMENT 'VISITOR/CERTIFIED',
  `status`        TINYINT         NOT NULL DEFAULT 1 COMMENT '1正常 0禁用',
  `last_login_at` DATETIME        DEFAULT NULL,
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_app_user_openid` (`openid`),
  KEY `idx_app_user_phone` (`phone`),
  KEY `idx_app_user_type` (`user_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='小程序用户';

CREATE TABLE IF NOT EXISTS `student` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL COMMENT '关联 app_user',
  `real_name`     VARCHAR(64)     NOT NULL,
  `id_card`       VARCHAR(32)     DEFAULT NULL COMMENT '身份证号',
  `gender`        TINYINT         DEFAULT NULL COMMENT '0女 1男',
  `region`        VARCHAR(64)     DEFAULT NULL COMMENT '地区（统计维度）',
  `org_name`      VARCHAR(128)    DEFAULT NULL COMMENT '所在单位',
  `cert_status`   VARCHAR(16)     NOT NULL DEFAULT 'UNVERIFIED' COMMENT 'UNVERIFIED/PENDING/CERTIFIED/REJECTED',
  `cert_time`     DATETIME        DEFAULT NULL,
  `reject_reason` VARCHAR(255)    DEFAULT NULL,
  `remark`        VARCHAR(255)    DEFAULT NULL,
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_user` (`user_id`),
  KEY `idx_student_region` (`region`),
  KEY `idx_student_cert` (`cert_status`),
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='认证学员';

CREATE TABLE IF NOT EXISTS `student_import_batch` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `file_name`     VARCHAR(255)    NOT NULL,
  `total_count`   INT UNSIGNED    NOT NULL DEFAULT 0,
  `success_count` INT UNSIGNED    NOT NULL DEFAULT 0,
  `fail_count`    INT UNSIGNED    NOT NULL DEFAULT 0,
  `error_file_url` VARCHAR(512)   DEFAULT NULL COMMENT '失败明细文件 OSS 地址',
  `status`        VARCHAR(16)     NOT NULL DEFAULT 'PROCESSING' COMMENT 'PROCESSING/DONE/FAILED',
  `created_by`    BIGINT UNSIGNED DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `finished_at`   DATETIME        DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_import_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学员导入批次';
