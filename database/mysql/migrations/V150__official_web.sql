-- V150–V159 官网展示（P4）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `site_config` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_key`  VARCHAR(64)     NOT NULL COMMENT 'site_name/icp/miniapp_qr等',
  `config_value` TEXT           NOT NULL,
  `remark`      VARCHAR(255)    DEFAULT NULL,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_site_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='官网站点配置';

CREATE TABLE IF NOT EXISTS `site_nav` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `label`       VARCHAR(64)     NOT NULL,
  `path`        VARCHAR(128)    NOT NULL,
  `parent_id`   BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `visible`     TINYINT(1)      NOT NULL DEFAULT 1,
  `nav_type`    VARCHAR(16)     NOT NULL DEFAULT 'HEADER' COMMENT 'HEADER/FOOTER',
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_site_nav_type` (`nav_type`, `visible`, `sort_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='官网导航';

CREATE TABLE IF NOT EXISTS `web_seo` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `path`        VARCHAR(128)    NOT NULL COMMENT '页面路径',
  `title`       VARCHAR(128)    DEFAULT NULL,
  `description` VARCHAR(512)    DEFAULT NULL,
  `og_image`    VARCHAR(512)    DEFAULT NULL,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_web_seo_path` (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='官网 SEO';

-- 二期预留（投票/问卷）
CREATE TABLE IF NOT EXISTS `campaign` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(256)    NOT NULL,
  `campaign_type` VARCHAR(16)   NOT NULL COMMENT 'VOTE/SURVEY',
  `status`      VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `start_at`    DATETIME        DEFAULT NULL,
  `end_at`      DATETIME        DEFAULT NULL,
  `config_json` JSON            DEFAULT NULL,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动（二期）';
