-- V140–V149 数据统计（P1）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `statistics_snapshot` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `snapshot_date` DATE            NOT NULL,
  `metric_type`   VARCHAR(32)     NOT NULL COMMENT 'LEARNING_HOURS/STUDENT_COUNT/REGION/SCORE',
  `dimension_key` VARCHAR(64)     DEFAULT NULL COMMENT '如 region=南京市',
  `dimension_val` VARCHAR(128)    DEFAULT NULL,
  `metric_value`  DECIMAL(16,4)   NOT NULL DEFAULT 0,
  `extra_json`    JSON            DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_snapshot_metric` (`snapshot_date`, `metric_type`, `dimension_key`, `dimension_val`),
  KEY `idx_snapshot_type_date` (`metric_type`, `snapshot_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='统计预聚合快照';
