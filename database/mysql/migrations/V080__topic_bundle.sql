-- V080–V089 专题整合（P4）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `topic` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`           VARCHAR(256)    NOT NULL,
  `cover_url`       VARCHAR(512)    DEFAULT NULL,
  `summary`         VARCHAR(512)    DEFAULT NULL,
  `requirement`     TEXT            COMMENT '学习要求说明',
  `exam_threshold`  DECIMAL(5,2)    NOT NULL DEFAULT 80.00 COMMENT '完成比例门槛（%）方可考试',
  `exam_paper_id`   BIGINT UNSIGNED DEFAULT NULL,
  `audit_status`    VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `audit_remark`    VARCHAR(255)    DEFAULT NULL,
  `web_visible`     TINYINT(1)      NOT NULL DEFAULT 0,
  `published_at`    DATETIME        DEFAULT NULL,
  `start_at`        DATETIME        DEFAULT NULL,
  `end_at`          DATETIME        DEFAULT NULL,
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_topic_audit` (`audit_status`),
  KEY `idx_topic_web` (`web_visible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='专题';

CREATE TABLE IF NOT EXISTS `topic_resource` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `topic_id`      BIGINT UNSIGNED NOT NULL,
  `resource_type` VARCHAR(32)     NOT NULL COMMENT 'ARTICLE/BOOK/COURSE/PODCAST/EXAM_PAPER',
  `resource_id`   BIGINT UNSIGNED NOT NULL,
  `sort_no`       INT             NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_topic_resource` (`topic_id`, `resource_type`, `resource_id`),
  KEY `idx_topic_res_type` (`topic_id`, `resource_type`),
  CONSTRAINT `fk_topic_res_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='专题资源绑定';

CREATE TABLE IF NOT EXISTS `topic_student` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `topic_id`    BIGINT UNSIGNED NOT NULL,
  `student_id`  BIGINT UNSIGNED NOT NULL,
  `assigned_at` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_topic_student` (`topic_id`, `student_id`),
  CONSTRAINT `fk_ts_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ts_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='专题指定学员';
