-- =============================================================================
-- 江苏中医在线 — 全量表结构（由 migrations 合并生成）
-- 导入前请先执行 00_create_database.sql
-- =============================================================================

USE `tcm_online`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- >>> V000__platform.sql
-- V000–V009 工程基座（P1）
-- 媒体资源、系统配置、操作审计

USE `tcm_online`;

-- ---------------------------------------------------------------------------
-- 媒体资源（OSS 登记）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `media_asset` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `module`        VARCHAR(32)     NOT NULL COMMENT '业务模块：course/book/article等',
  `file_name`     VARCHAR(255)    NOT NULL COMMENT '原始文件名',
  `oss_key`       VARCHAR(512)    NOT NULL COMMENT 'OSS 对象键',
  `mime_type`     VARCHAR(128)    DEFAULT NULL COMMENT 'MIME',
  `file_size`     BIGINT UNSIGNED DEFAULT 0 COMMENT '字节数',
  `duration_sec`  INT UNSIGNED    DEFAULT NULL COMMENT '音视频时长（秒）',
  `status`        VARCHAR(16)     NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE/DELETED',
  `created_by`    BIGINT UNSIGNED DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_media_oss_key` (`oss_key`),
  KEY `idx_media_module` (`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='媒体资源';

-- ---------------------------------------------------------------------------
-- 系统配置
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sys_config` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_key`  VARCHAR(64)     NOT NULL COMMENT '配置键',
  `config_value` TEXT           COMMENT '配置值（JSON 或文本）',
  `remark`      VARCHAR(255)    DEFAULT NULL,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置';

-- ---------------------------------------------------------------------------
-- 操作审计（审核、删除、导出等）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `audit_log` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `operator_type` VARCHAR(16)     NOT NULL COMMENT 'ADMIN/APP/SYSTEM',
  `operator_id`   BIGINT UNSIGNED DEFAULT NULL COMMENT '操作人 ID',
  `operator_name` VARCHAR(64)     DEFAULT NULL,
  `action`        VARCHAR(64)     NOT NULL COMMENT '动作：AUDIT_APPROVE/DELETE/EXPORT等',
  `resource_type` VARCHAR(32)     DEFAULT NULL COMMENT '资源类型',
  `resource_id`   BIGINT UNSIGNED DEFAULT NULL,
  `before_data`   JSON            DEFAULT NULL,
  `after_data`    JSON            DEFAULT NULL,
  `ip`            VARCHAR(64)     DEFAULT NULL,
  `user_agent`    VARCHAR(512)    DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_resource` (`resource_type`, `resource_id`),
  KEY `idx_audit_operator` (`operator_type`, `operator_id`),
  KEY `idx_audit_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作审计日志';


-- >>> V010__auth_rbac.sql
-- V010–V019 认证 RBAC（P1）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `sys_admin` (
  `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username`         VARCHAR(64)     NOT NULL COMMENT '登录账号',
  `password_hash`    VARCHAR(128)    NOT NULL COMMENT 'bcrypt 哈希',
  `real_name`        VARCHAR(64)     DEFAULT NULL,
  `phone`            VARCHAR(20)     DEFAULT NULL,
  `email`            VARCHAR(128)    DEFAULT NULL,
  `avatar_url`       VARCHAR(512)    DEFAULT NULL,
  `status`           TINYINT         NOT NULL DEFAULT 1 COMMENT '1启用 0禁用',
  `login_fail_count` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `locked_until`     DATETIME        DEFAULT NULL,
  `last_login_at`    DATETIME        DEFAULT NULL,
  `last_login_ip`    VARCHAR(64)     DEFAULT NULL,
  `deleted`          TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_admin_username` (`username`),
  KEY `idx_sys_admin_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员';

CREATE TABLE IF NOT EXISTS `sys_role` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(64)     NOT NULL COMMENT 'super_admin/content_editor等',
  `name`        VARCHAR(64)     NOT NULL,
  `description` VARCHAR(255)    DEFAULT NULL,
  `status`      TINYINT         NOT NULL DEFAULT 1,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_role_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色';

CREATE TABLE IF NOT EXISTS `sys_permission` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(128)    NOT NULL COMMENT 'course:video:audit',
  `name`        VARCHAR(64)     NOT NULL,
  `module`      VARCHAR(32)     DEFAULT NULL,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_permission_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限';

CREATE TABLE IF NOT EXISTS `sys_role_permission` (
  `role_id`       BIGINT UNSIGNED NOT NULL,
  `permission_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  KEY `idx_srp_permission` (`permission_id`),
  CONSTRAINT `fk_srp_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_srp_perm` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色-权限';

CREATE TABLE IF NOT EXISTS `sys_admin_role` (
  `admin_id` BIGINT UNSIGNED NOT NULL,
  `role_id`  BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`admin_id`, `role_id`),
  KEY `idx_sar_role` (`role_id`),
  CONSTRAINT `fk_sar_admin` FOREIGN KEY (`admin_id`) REFERENCES `sys_admin` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sar_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员-角色';

CREATE TABLE IF NOT EXISTS `sys_login_log` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_id`   BIGINT UNSIGNED DEFAULT NULL,
  `username`   VARCHAR(64)     NOT NULL,
  `success`    TINYINT(1)      NOT NULL DEFAULT 0,
  `ip`         VARCHAR(64)     DEFAULT NULL,
  `user_agent` VARCHAR(512)    DEFAULT NULL,
  `message`    VARCHAR(255)    DEFAULT NULL,
  `created_at` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_login_log_admin` (`admin_id`),
  KEY `idx_login_log_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理端登录日志';


-- >>> V020__user_student.sql
-- V020–V029 用户与学员（P3）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `app_user` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `openid`        VARCHAR(64)     NOT NULL COMMENT '微信 openid',
  `unionid`       VARCHAR(64)     DEFAULT NULL,
  `nickname`      VARCHAR(64)     DEFAULT NULL,
  `avatar_url`    VARCHAR(512)    DEFAULT NULL,
  `phone`         VARCHAR(20)     DEFAULT NULL,
  `user_type`     VARCHAR(16)     NOT NULL DEFAULT 'VISITOR' COMMENT 'VISITOR/CERTIFIED',
  `status`        TINYINT         NOT NULL DEFAULT 1 COMMENT '1正常 0禁用',
  `last_login_at` DATETIME        DEFAULT NULL,
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_app_user_openid` (`openid`),
  KEY `idx_app_user_phone` (`phone`),
  KEY `idx_app_user_type` (`user_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='小程序用户';

CREATE TABLE IF NOT EXISTS `student` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL COMMENT '关联 app_user',
  `real_name`     VARCHAR(64)     NOT NULL,
  `id_card`       VARCHAR(32)     DEFAULT NULL COMMENT '身份证号',
  `gender`        TINYINT         DEFAULT NULL COMMENT '0女 1男',
  `region`        VARCHAR(64)     DEFAULT NULL COMMENT '地区（统计维度）',
  `org_name`      VARCHAR(128)    DEFAULT NULL COMMENT '所在单位',
  `cert_status`   VARCHAR(16)     NOT NULL DEFAULT 'UNVERIFIED' COMMENT 'UNVERIFIED/PENDING/CERTIFIED/REJECTED',
  `cert_time`     DATETIME        DEFAULT NULL,
  `reject_reason` VARCHAR(255)    DEFAULT NULL,
  `remark`        VARCHAR(255)    DEFAULT NULL,
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_user` (`user_id`),
  KEY `idx_student_region` (`region`),
  KEY `idx_student_cert` (`cert_status`),
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='认证学员';

CREATE TABLE IF NOT EXISTS `student_import_batch` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `file_name`     VARCHAR(255)    NOT NULL,
  `total_count`   INT UNSIGNED    NOT NULL DEFAULT 0,
  `success_count` INT UNSIGNED    NOT NULL DEFAULT 0,
  `fail_count`    INT UNSIGNED    NOT NULL DEFAULT 0,
  `error_file_url` VARCHAR(512)   DEFAULT NULL COMMENT '失败明细文件 OSS 地址',
  `status`        VARCHAR(16)     NOT NULL DEFAULT 'PROCESSING' COMMENT 'PROCESSING/DONE/FAILED',
  `created_by`    BIGINT UNSIGNED DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `finished_at`   DATETIME        DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_import_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学员导入批次';


-- >>> V030__home_info.sql
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


-- >>> V040__course_video.sql
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


-- >>> V050__book_ebook.sql
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


-- >>> V060__podcast_audio.sql
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


-- >>> V070__learning_tracker.sql
-- V070–V079 学习追踪（P1）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `learning_progress` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `resource_type` VARCHAR(32)     NOT NULL COMMENT 'COURSE_VIDEO/BOOK_CHAPTER/PODCAST_EPISODE',
  `resource_id`   BIGINT UNSIGNED NOT NULL,
  `position`      INT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '播放位置或页码',
  `progress_pct`  DECIMAL(5,2)    NOT NULL DEFAULT 0.00 COMMENT '进度百分比',
  `completed`     TINYINT(1)      NOT NULL DEFAULT 0,
  `last_report_at` DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_learning_progress` (`user_id`, `resource_type`, `resource_id`),
  KEY `idx_progress_resource` (`resource_type`, `resource_id`),
  CONSTRAINT `fk_progress_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学习进度';

CREATE TABLE IF NOT EXISTS `learning_duration` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `stat_date`     DATE            NOT NULL,
  `resource_type` VARCHAR(32)     NOT NULL,
  `seconds`       INT UNSIGNED    NOT NULL DEFAULT 0,
  `report_count`  INT UNSIGNED    NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_duration_day` (`user_id`, `stat_date`, `resource_type`),
  KEY `idx_duration_date` (`stat_date`),
  CONSTRAINT `fk_duration_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学习时长（按日）';

CREATE TABLE IF NOT EXISTS `credit_log` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `topic_id`      BIGINT UNSIGNED DEFAULT NULL,
  `credit_type`   VARCHAR(32)     NOT NULL COMMENT 'LEARNING/EXAM/BONUS',
  `credit_value`  DECIMAL(10,2)   NOT NULL DEFAULT 0,
  `ref_type`      VARCHAR(32)     DEFAULT NULL,
  `ref_id`        BIGINT UNSIGNED DEFAULT NULL,
  `remark`        VARCHAR(255)    DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_credit_user` (`user_id`, `created_at`),
  CONSTRAINT `fk_credit_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学分/积分流水';


-- >>> V080__topic_bundle.sql
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


-- >>> V090__question_exam.sql
-- V090–V099 题库与测评（P7）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `question_bank` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(128)    NOT NULL,
  `description` VARCHAR(512)    DEFAULT NULL,
  `category`    VARCHAR(64)     DEFAULT NULL,
  `deleted`     TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='题库';

CREATE TABLE IF NOT EXISTS `question` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `bank_id`       BIGINT UNSIGNED NOT NULL,
  `question_type` VARCHAR(16)     NOT NULL COMMENT 'SINGLE/MULTIPLE/FILL',
  `stem`          TEXT            NOT NULL COMMENT '题干',
  `options_json`  JSON            DEFAULT NULL COMMENT '选项 [{key,label}]',
  `answer_json`   JSON            NOT NULL COMMENT '答案',
  `analysis`      TEXT            DEFAULT NULL COMMENT '解析',
  `score`         DECIMAL(6,2)    NOT NULL DEFAULT 1.00,
  `difficulty`    TINYINT         DEFAULT 1 COMMENT '1-5',
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_question_bank` (`bank_id`),
  CONSTRAINT `fk_question_bank` FOREIGN KEY (`bank_id`) REFERENCES `question_bank` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='题目';

CREATE TABLE IF NOT EXISTS `exam_paper` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`         VARCHAR(256)    NOT NULL,
  `bank_id`       BIGINT UNSIGNED DEFAULT NULL,
  `paper_type`    VARCHAR(16)     NOT NULL DEFAULT 'FIXED' COMMENT 'FIXED/RANDOM',
  `random_count`  INT UNSIGNED    DEFAULT NULL COMMENT '随机抽题数量',
  `total_score`   DECIMAL(8,2)    NOT NULL DEFAULT 100.00,
  `pass_score`    DECIMAL(8,2)    NOT NULL DEFAULT 60.00,
  `duration_min`  INT UNSIGNED    DEFAULT 60 COMMENT '考试时长（分钟）',
  `audit_status`  VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_paper_bank` (`bank_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考卷';

CREATE TABLE IF NOT EXISTS `exam_paper_question` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `paper_id`    BIGINT UNSIGNED NOT NULL,
  `question_id` BIGINT UNSIGNED NOT NULL,
  `sort_no`     INT             NOT NULL DEFAULT 0,
  `score`       DECIMAL(6,2)    NOT NULL DEFAULT 1.00,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_paper_question` (`paper_id`, `question_id`),
  CONSTRAINT `fk_epq_paper` FOREIGN KEY (`paper_id`) REFERENCES `exam_paper` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_epq_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考卷-题目';

CREATE TABLE IF NOT EXISTS `exam_record` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `student_id`    BIGINT UNSIGNED DEFAULT NULL,
  `paper_id`      BIGINT UNSIGNED NOT NULL,
  `topic_id`      BIGINT UNSIGNED DEFAULT NULL,
  `total_score`   DECIMAL(8,2)    NOT NULL DEFAULT 0,
  `user_score`    DECIMAL(8,2)    NOT NULL DEFAULT 0,
  `passed`        TINYINT(1)      NOT NULL DEFAULT 0,
  `status`        VARCHAR(16)     NOT NULL DEFAULT 'SUBMITTED' COMMENT 'IN_PROGRESS/SUBMITTED',
  `started_at`    DATETIME        NOT NULL,
  `submitted_at`  DATETIME        DEFAULT NULL,
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_exam_record_user` (`user_id`, `submitted_at`),
  KEY `idx_exam_record_topic` (`topic_id`),
  KEY `idx_exam_record_paper` (`paper_id`),
  CONSTRAINT `fk_record_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`),
  CONSTRAINT `fk_record_paper` FOREIGN KEY (`paper_id`) REFERENCES `exam_paper` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考试记录';

CREATE TABLE IF NOT EXISTS `exam_answer` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `record_id`     BIGINT UNSIGNED NOT NULL,
  `question_id`   BIGINT UNSIGNED NOT NULL,
  `user_answer`   JSON            NOT NULL,
  `correct`       TINYINT(1)      NOT NULL DEFAULT 0,
  `score`         DECIMAL(6,2)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_exam_answer` (`record_id`, `question_id`),
  CONSTRAINT `fk_answer_record` FOREIGN KEY (`record_id`) REFERENCES `exam_record` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_answer_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答题明细';


-- >>> V100__expert_qa.sql
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


-- >>> V110__knowledge_base.sql
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


-- >>> V120__feedback.sql
-- V120–V124 反馈（P7）

USE `tcm_online`;

CREATE TABLE IF NOT EXISTS `feedback` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`     BIGINT UNSIGNED NOT NULL,
  `content`     TEXT            NOT NULL,
  `images_json` JSON            DEFAULT NULL COMMENT '图片 URL 数组',
  `contact`     VARCHAR(64)     DEFAULT NULL,
  `deleted`     TINYINT(1)      NOT NULL DEFAULT 0,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_feedback_user` (`user_id`),
  KEY `idx_feedback_created` (`created_at`),
  CONSTRAINT `fk_feedback_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户反馈';


-- >>> V130__live_streaming.sql
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


-- >>> V140__data_analytics.sql
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


-- >>> V150__official_web.sql
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


SET FOREIGN_KEY_CHECKS = 1;
