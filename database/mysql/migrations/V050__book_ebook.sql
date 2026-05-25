-- V050–V059 图书与电子书（P6）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `book_category` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(64)     NOT NULL,
  `parent_id`   BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书分类';

CREATE TABLE IF NOT EXISTS `book` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id`     BIGINT UNSIGNED DEFAULT NULL,
  `title`           VARCHAR(256)    NOT NULL,
  `author`          VARCHAR(128)    DEFAULT NULL,
  `cover_url`       VARCHAR(512)    DEFAULT NULL,
  `summary`         VARCHAR(512)    DEFAULT NULL,
  `file_format`     VARCHAR(16)     NOT NULL DEFAULT 'PDF' COMMENT 'PDF/EPUB',
  `oss_key`         VARCHAR(512)    NOT NULL COMMENT '电子书文件',
  `page_count`      INT UNSIGNED    DEFAULT 0,
  `exam_paper_id`   BIGINT UNSIGNED DEFAULT NULL,
  `audit_status`    VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `audit_remark`    VARCHAR(255)    DEFAULT NULL,
  `web_visible`     TINYINT(1)      NOT NULL DEFAULT 0,
  `published_at`    DATETIME        DEFAULT NULL,
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_book_category` (`category_id`),
  KEY `idx_book_audit` (`audit_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书';

CREATE TABLE IF NOT EXISTS `book_chapter` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `book_id`     BIGINT UNSIGNED NOT NULL,
  `parent_id`   BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `title`       VARCHAR(256)    NOT NULL,
  `page_start`  INT UNSIGNED    DEFAULT NULL,
  `page_end`    INT UNSIGNED    DEFAULT NULL,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_chapter_book` (`book_id`, `parent_id`, `sort_no`),
  CONSTRAINT `fk_chapter_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书章节';

CREATE TABLE IF NOT EXISTS `book_bookmark` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`     BIGINT UNSIGNED NOT NULL,
  `book_id`     BIGINT UNSIGNED NOT NULL,
  `chapter_id`  BIGINT UNSIGNED DEFAULT NULL,
  `page_no`     INT UNSIGNED    DEFAULT NULL,
  `note`        VARCHAR(512)    DEFAULT NULL,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_bookmark_user_book` (`user_id`, `book_id`),
  CONSTRAINT `fk_bookmark_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bookmark_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书书签';
