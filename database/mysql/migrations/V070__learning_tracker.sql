-- V070–V079 学习追踪（P1）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `learning_progress` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `resource_type` VARCHAR(32)     NOT NULL COMMENT 'COURSE_VIDEO/BOOK_CHAPTER/PODCAST_EPISODE',
  `resource_id`   BIGINT UNSIGNED NOT NULL,
  `position`      INT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '播放位置或页码',
  `progress_pct`  DECIMAL(5,2)    NOT NULL DEFAULT 0.00 COMMENT '进度百分比',
  `completed`     TINYINT(1)      NOT NULL DEFAULT 0,
  `last_report_at` DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_learning_progress` (`user_id`, `resource_type`, `resource_id`),
  KEY `idx_progress_resource` (`resource_type`, `resource_id`),
  CONSTRAINT `fk_progress_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学习进度';

CREATE TABLE IF NOT EXISTS `learning_duration` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `stat_date`     DATE            NOT NULL,
  `resource_type` VARCHAR(32)     NOT NULL,
  `seconds`       INT UNSIGNED    NOT NULL DEFAULT 0,
  `report_count`  INT UNSIGNED    NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_duration_day` (`user_id`, `stat_date`, `resource_type`),
  KEY `idx_duration_date` (`stat_date`),
  CONSTRAINT `fk_duration_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学习时长（按日）';

CREATE TABLE IF NOT EXISTS `credit_log` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `topic_id`      BIGINT UNSIGNED DEFAULT NULL,
  `credit_type`   VARCHAR(32)     NOT NULL COMMENT 'LEARNING/EXAM/BONUS',
  `credit_value`  DECIMAL(10,2)   NOT NULL DEFAULT 0,
  `ref_type`      VARCHAR(32)     DEFAULT NULL,
  `ref_id`        BIGINT UNSIGNED DEFAULT NULL,
  `remark`        VARCHAR(255)    DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_credit_user` (`user_id`, `created_at`),
  CONSTRAINT `fk_credit_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学分/积分流水';
