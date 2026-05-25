-- V130–V139 直播（P5）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `live_session` (
  `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`               VARCHAR(256)    NOT NULL,
  `cover_url`           VARCHAR(512)    DEFAULT NULL,
  `summary`             VARCHAR(512)    DEFAULT NULL,
  `topic_id`            BIGINT UNSIGNED DEFAULT NULL,
  `start_time`          DATETIME        NOT NULL,
  `end_time`            DATETIME        DEFAULT NULL,
  `status`              VARCHAR(16)     NOT NULL DEFAULT 'SCHEDULED' COMMENT 'SCHEDULED/LIVE/ENDED',
  `third_party_room_id` VARCHAR(128)    DEFAULT NULL,
  `playback_url`        VARCHAR(512)    DEFAULT NULL COMMENT '回放地址',
  `provider`            VARCHAR(32)     DEFAULT 'TENCENT' COMMENT '直播服务商',
  `audit_status`        VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `audit_remark`        VARCHAR(255)    DEFAULT NULL,
  `web_visible`         TINYINT(1)      NOT NULL DEFAULT 0,
  `deleted`             TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_live_topic` (`topic_id`),
  KEY `idx_live_start` (`start_time`),
  KEY `idx_live_audit` (`audit_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='直播场次';
