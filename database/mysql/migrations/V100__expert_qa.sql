-- V100–V109 专家答疑（P7）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `expert_category` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(64)     NOT NULL,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `visible`     TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='专家分类';

CREATE TABLE IF NOT EXISTS `expert` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id`   BIGINT UNSIGNED DEFAULT NULL,
  `admin_id`      BIGINT UNSIGNED DEFAULT NULL COMMENT '关联管理员（专家登录）',
  `name`          VARCHAR(64)     NOT NULL,
  `title`         VARCHAR(64)     DEFAULT NULL COMMENT '职称',
  `avatar_url`    VARCHAR(512)    DEFAULT NULL,
  `intro`         VARCHAR(512)    DEFAULT NULL,
  `specialty`     VARCHAR(255)    DEFAULT NULL COMMENT '擅长领域',
  `resume_json`   JSON            DEFAULT NULL COMMENT '履历时间轴',
  `sort_no`       INT             NOT NULL DEFAULT 0,
  `visible`       TINYINT(1)      NOT NULL DEFAULT 1,
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_expert_category` (`category_id`),
  KEY `idx_expert_admin` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='专家';

CREATE TABLE IF NOT EXISTS `qa_thread` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id`    BIGINT UNSIGNED NOT NULL,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `expert_id`     BIGINT UNSIGNED NOT NULL,
  `title`         VARCHAR(256)    DEFAULT NULL,
  `content`       TEXT            NOT NULL,
  `status`        VARCHAR(16)     NOT NULL DEFAULT 'OPEN' COMMENT 'OPEN/ANSWERED/CLOSED',
  `public_visible` TINYINT(1)     NOT NULL DEFAULT 1 COMMENT '公开展示',
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_qa_expert` (`expert_id`, `status`),
  KEY `idx_qa_student` (`student_id`),
  CONSTRAINT `fk_qa_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
  CONSTRAINT `fk_qa_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`),
  CONSTRAINT `fk_qa_expert` FOREIGN KEY (`expert_id`) REFERENCES `expert` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答疑主题';

CREATE TABLE IF NOT EXISTS `qa_reply` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `thread_id`     BIGINT UNSIGNED NOT NULL,
  `replier_type`  VARCHAR(16)     NOT NULL COMMENT 'EXPERT/ADMIN',
  `replier_id`    BIGINT UNSIGNED NOT NULL,
  `content`       TEXT            NOT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_reply_thread` (`thread_id`, `created_at`),
  CONSTRAINT `fk_reply_thread` FOREIGN KEY (`thread_id`) REFERENCES `qa_thread` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答疑回复';
