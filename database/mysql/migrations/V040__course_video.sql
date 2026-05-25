-- V040–V049 课程与视频（P5）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `course` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`           VARCHAR(256)    NOT NULL,
  `summary`         VARCHAR(512)    DEFAULT NULL,
  `cover_url`       VARCHAR(512)    DEFAULT NULL,
  `description`     TEXT            DEFAULT NULL,
  `exam_paper_id`   BIGINT UNSIGNED DEFAULT NULL COMMENT '关联考卷（09）',
  `audit_status`    VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `audit_remark`    VARCHAR(255)    DEFAULT NULL,
  `web_visible`     TINYINT(1)      NOT NULL DEFAULT 0,
  `published_at`    DATETIME        DEFAULT NULL,
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  `created_by`      BIGINT UNSIGNED DEFAULT NULL,
  `created_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_audit` (`audit_status`),
  KEY `idx_course_exam` (`exam_paper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程';

CREATE TABLE IF NOT EXISTS `course_video` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id`     BIGINT UNSIGNED NOT NULL,
  `title`         VARCHAR(256)    NOT NULL,
  `duration_sec`  INT UNSIGNED    NOT NULL DEFAULT 0,
  `oss_key`       VARCHAR(512)    NOT NULL,
  `media_asset_id` BIGINT UNSIGNED DEFAULT NULL,
  `sort_no`       INT             NOT NULL DEFAULT 0,
  `audit_status`  VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_video_course` (`course_id`, `sort_no`),
  CONSTRAINT `fk_video_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程视频';
