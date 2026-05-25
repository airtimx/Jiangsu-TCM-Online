-- V030–V039 首页与资讯（P4）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `home_category` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(64)     NOT NULL,
  `icon_url`    VARCHAR(512)    DEFAULT NULL,
  `visible`     TINYINT(1)      NOT NULL DEFAULT 1,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='首页分类';

CREATE TABLE IF NOT EXISTS `home_banner` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(128)    DEFAULT NULL,
  `image_url`   VARCHAR(512)    NOT NULL,
  `link_type`   VARCHAR(16)     DEFAULT 'NONE' COMMENT 'NONE/ARTICLE/TOPIC/URL',
  `link_value`  VARCHAR(512)    DEFAULT NULL,
  `visible`     TINYINT(1)      NOT NULL DEFAULT 1,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `start_at`    DATETIME        DEFAULT NULL,
  `end_at`      DATETIME        DEFAULT NULL,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_banner_visible` (`visible`, `sort_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='首页轮播';

CREATE TABLE IF NOT EXISTS `home_block` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `block_key`   VARCHAR(64)     NOT NULL COMMENT '区块标识',
  `title`       VARCHAR(128)    DEFAULT NULL,
  `config_json` JSON            NOT NULL COMMENT '区块展示配置',
  `visible`     TINYINT(1)      NOT NULL DEFAULT 1,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_home_block_key` (`block_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='首页区块配置';

CREATE TABLE IF NOT EXISTS `article_category` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(64)     NOT NULL,
  `parent_id`   BIGINT UNSIGNED DEFAULT 0,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `visible`     TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_article_cat_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯分类';

CREATE TABLE IF NOT EXISTS `article` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id`     BIGINT UNSIGNED DEFAULT NULL,
  `title`           VARCHAR(256)    NOT NULL,
  `summary`         VARCHAR(512)    DEFAULT NULL,
  `content_html`    MEDIUMTEXT      COMMENT '富文本正文',
  `cover_url`       VARCHAR(512)    DEFAULT NULL,
  `author`          VARCHAR(64)     DEFAULT NULL,
  `view_count`      INT UNSIGNED    NOT NULL DEFAULT 0,
  `collect_count`   INT UNSIGNED    NOT NULL DEFAULT 0,
  `audit_status`    VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `audit_remark`    VARCHAR(255)    DEFAULT NULL,
  `web_visible`     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '官网是否展示',
  `published_at`    DATETIME        DEFAULT NULL,
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  `created_by`      BIGINT UNSIGNED DEFAULT NULL,
  `updated_by`      BIGINT UNSIGNED DEFAULT NULL,
  `created_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_article_category` (`category_id`),
  KEY `idx_article_audit` (`audit_status`, `published_at`),
  KEY `idx_article_web` (`web_visible`, `audit_status`),
  FULLTEXT KEY `ft_article_title` (`title`, `summary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯';

CREATE TABLE IF NOT EXISTS `user_collection` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `resource_type` VARCHAR(32)     NOT NULL COMMENT 'ARTICLE/COURSE/BOOK等',
  `resource_id`   BIGINT UNSIGNED NOT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_collect` (`user_id`, `resource_type`, `resource_id`),
  KEY `idx_collect_resource` (`resource_type`, `resource_id`),
  CONSTRAINT `fk_collect_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户收藏';

CREATE TABLE IF NOT EXISTS `browse_log` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `resource_type` VARCHAR(32)     NOT NULL,
  `resource_id`   BIGINT UNSIGNED NOT NULL,
  `title`         VARCHAR(256)    DEFAULT NULL COMMENT '冗余标题便于列表展示',
  `browsed_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_browse_user_time` (`user_id`, `browsed_at`),
  CONSTRAINT `fk_browse_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='浏览记录';
