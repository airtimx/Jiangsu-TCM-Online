-- V060–V069 播客与音频（P7）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `podcast` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`           VARCHAR(256)    NOT NULL,
  `cover_url`       VARCHAR(512)    DEFAULT NULL,
  `summary`         VARCHAR(512)    DEFAULT NULL,
  `host_name`       VARCHAR(64)     DEFAULT NULL,
  `audit_status`    VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `audit_remark`    VARCHAR(255)    DEFAULT NULL,
  `web_visible`     TINYINT(1)      NOT NULL DEFAULT 0,
  `published_at`    DATETIME        DEFAULT NULL,
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_podcast_audit` (`audit_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='播客';

CREATE TABLE IF NOT EXISTS `podcast_episode` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `podcast_id`    BIGINT UNSIGNED NOT NULL,
  `title`         VARCHAR(256)    NOT NULL,
  `duration_sec`  INT UNSIGNED    NOT NULL DEFAULT 0,
  `audio_key`     VARCHAR(512)    NOT NULL,
  `sort_no`       INT             NOT NULL DEFAULT 0,
  `audit_status`  VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_episode_podcast` (`podcast_id`, `sort_no`),
  CONSTRAINT `fk_episode_podcast` FOREIGN KEY (`podcast_id`) REFERENCES `podcast` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='播客单集';
