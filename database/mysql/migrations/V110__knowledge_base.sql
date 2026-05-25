-- V110–V119 知识库（P6）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `kb_category` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(64)     NOT NULL COMMENT '中医基础理论/中药学等',
  `parent_id`   BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `visible`     TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识库分类';

CREATE TABLE IF NOT EXISTS `kb_book` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id`     BIGINT UNSIGNED DEFAULT NULL,
  `title`           VARCHAR(256)    NOT NULL,
  `author`          VARCHAR(128)    DEFAULT NULL,
  `cover_url`       VARCHAR(512)    DEFAULT NULL,
  `file_format`     VARCHAR(16)     NOT NULL DEFAULT 'PDF',
  `oss_key`         VARCHAR(512)    NOT NULL,
  `slice_status`    VARCHAR(16)     NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/PROCESSING/DONE/FAILED',
  `question_bank_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '可选章节练习题库',
  `audit_status`    VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_kb_book_category` (`category_id`),
  KEY `idx_kb_book_slice` (`slice_status`),
  FULLTEXT KEY `ft_kb_book_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识库书籍';

CREATE TABLE IF NOT EXISTS `kb_chapter` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `book_id`     BIGINT UNSIGNED NOT NULL,
  `parent_id`   BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `title`       VARCHAR(256)    NOT NULL,
  `content_text` MEDIUMTEXT     DEFAULT NULL COMMENT '切片正文',
  `page_start`  INT UNSIGNED    DEFAULT NULL,
  `page_end`    INT UNSIGNED    DEFAULT NULL,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_kb_chapter_book` (`book_id`, `parent_id`, `sort_no`),
  FULLTEXT KEY `ft_kb_chapter_content` (`title`, `content_text`),
  CONSTRAINT `fk_kb_chapter_book` FOREIGN KEY (`book_id`) REFERENCES `kb_book` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识库章节';

CREATE TABLE IF NOT EXISTS `kb_bookmark` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`     BIGINT UNSIGNED NOT NULL,
  `book_id`     BIGINT UNSIGNED NOT NULL,
  `chapter_id`  BIGINT UNSIGNED DEFAULT NULL,
  `page_no`     INT UNSIGNED    DEFAULT NULL,
  `note`        VARCHAR(512)    DEFAULT NULL,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_kb_bookmark_user` (`user_id`, `book_id`),
  CONSTRAINT `fk_kb_bm_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_kb_bm_book` FOREIGN KEY (`book_id`) REFERENCES `kb_book` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识库书签';
