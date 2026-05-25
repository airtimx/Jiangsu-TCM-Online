/*
 Navicat Premium Dump SQL

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80408 (8.4.8)
 Source Host           : localhost:3306
 Source Schema         : tcm_online

 Target Server Type    : MySQL
 Target Server Version : 80408 (8.4.8)
 File Encoding         : 65001

 Date: 26/05/2026 00:04:39
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for app_user
-- ----------------------------
DROP TABLE IF EXISTS `app_user`;
CREATE TABLE `app_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '微信 openid',
  `unionid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VISITOR' COMMENT 'VISITOR/CERTIFIED',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1正常 0禁用',
  `last_login_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_app_user_openid`(`openid` ASC) USING BTREE,
  INDEX `idx_app_user_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_app_user_type`(`user_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '小程序用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_user
-- ----------------------------

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '富文本正文',
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `author` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `view_count` int UNSIGNED NOT NULL DEFAULT 0,
  `collect_count` int UNSIGNED NOT NULL DEFAULT 0,
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `web_visible` tinyint(1) NOT NULL DEFAULT 0 COMMENT '官网是否展示',
  `published_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_article_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_article_audit`(`audit_status` ASC, `published_at` ASC) USING BTREE,
  INDEX `idx_article_web`(`web_visible` ASC, `audit_status` ASC) USING BTREE,
  FULLTEXT INDEX `ft_article_title`(`title`, `summary`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资讯' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article
-- ----------------------------

-- ----------------------------
-- Table structure for article_category
-- ----------------------------
DROP TABLE IF EXISTS `article_category`;
CREATE TABLE `article_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NULL DEFAULT 0,
  `sort_no` int NOT NULL DEFAULT 0,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_article_cat_parent`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资讯分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_category
-- ----------------------------

-- ----------------------------
-- Table structure for audit_log
-- ----------------------------
DROP TABLE IF EXISTS `audit_log`;
CREATE TABLE `audit_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `operator_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ADMIN/APP/SYSTEM',
  `operator_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '操作人 ID',
  `operator_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `action` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '动作：AUDIT_APPROVE/DELETE/EXPORT等',
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源类型',
  `resource_id` bigint UNSIGNED NULL DEFAULT NULL,
  `before_data` json NULL,
  `after_data` json NULL,
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_audit_resource`(`resource_type` ASC, `resource_id` ASC) USING BTREE,
  INDEX `idx_audit_operator`(`operator_type` ASC, `operator_id` ASC) USING BTREE,
  INDEX `idx_audit_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作审计日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of audit_log
-- ----------------------------

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `author` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `file_format` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PDF' COMMENT 'PDF/EPUB',
  `oss_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '电子书文件',
  `page_count` int UNSIGNED NULL DEFAULT 0,
  `exam_paper_id` bigint UNSIGNED NULL DEFAULT NULL,
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `web_visible` tinyint(1) NOT NULL DEFAULT 0,
  `published_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_book_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_book_audit`(`audit_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------

-- ----------------------------
-- Table structure for book_bookmark
-- ----------------------------
DROP TABLE IF EXISTS `book_bookmark`;
CREATE TABLE `book_bookmark`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `book_id` bigint UNSIGNED NOT NULL,
  `chapter_id` bigint UNSIGNED NULL DEFAULT NULL,
  `page_no` int UNSIGNED NULL DEFAULT NULL,
  `note` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_bookmark_user_book`(`user_id` ASC, `book_id` ASC) USING BTREE,
  INDEX `fk_bookmark_book`(`book_id` ASC) USING BTREE,
  CONSTRAINT `fk_bookmark_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_bookmark_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书书签' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_bookmark
-- ----------------------------

-- ----------------------------
-- Table structure for book_category
-- ----------------------------
DROP TABLE IF EXISTS `book_category`;
CREATE TABLE `book_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `sort_no` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_category
-- ----------------------------

-- ----------------------------
-- Table structure for book_chapter
-- ----------------------------
DROP TABLE IF EXISTS `book_chapter`;
CREATE TABLE `book_chapter`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `book_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `page_start` int UNSIGNED NULL DEFAULT NULL,
  `page_end` int UNSIGNED NULL DEFAULT NULL,
  `sort_no` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter_book`(`book_id` ASC, `parent_id` ASC, `sort_no` ASC) USING BTREE,
  CONSTRAINT `fk_chapter_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书章节' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_chapter
-- ----------------------------

-- ----------------------------
-- Table structure for browse_log
-- ----------------------------
DROP TABLE IF EXISTS `browse_log`;
CREATE TABLE `browse_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `resource_id` bigint UNSIGNED NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '冗余标题便于列表展示',
  `browsed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_browse_user_time`(`user_id` ASC, `browsed_at` ASC) USING BTREE,
  CONSTRAINT `fk_browse_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '浏览记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of browse_log
-- ----------------------------

-- ----------------------------
-- Table structure for campaign
-- ----------------------------
DROP TABLE IF EXISTS `campaign`;
CREATE TABLE `campaign`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `campaign_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'VOTE/SURVEY',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `start_at` datetime NULL DEFAULT NULL,
  `end_at` datetime NULL DEFAULT NULL,
  `config_json` json NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '活动（二期）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of campaign
-- ----------------------------

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `exam_paper_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联考卷（09）',
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `web_visible` tinyint(1) NOT NULL DEFAULT 0,
  `published_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course_audit`(`audit_status` ASC) USING BTREE,
  INDEX `idx_course_exam`(`exam_paper_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '课程' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------

-- ----------------------------
-- Table structure for course_video
-- ----------------------------
DROP TABLE IF EXISTS `course_video`;
CREATE TABLE `course_video`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id` bigint UNSIGNED NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration_sec` int UNSIGNED NOT NULL DEFAULT 0,
  `oss_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `media_asset_id` bigint UNSIGNED NULL DEFAULT NULL,
  `sort_no` int NOT NULL DEFAULT 0,
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_video_course`(`course_id` ASC, `sort_no` ASC) USING BTREE,
  CONSTRAINT `fk_video_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '课程视频' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_video
-- ----------------------------

-- ----------------------------
-- Table structure for credit_log
-- ----------------------------
DROP TABLE IF EXISTS `credit_log`;
CREATE TABLE `credit_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `topic_id` bigint UNSIGNED NULL DEFAULT NULL,
  `credit_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'LEARNING/EXAM/BONUS',
  `credit_value` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `ref_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `ref_id` bigint UNSIGNED NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_credit_user`(`user_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `fk_credit_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学分/积分流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of credit_log
-- ----------------------------

-- ----------------------------
-- Table structure for exam_answer
-- ----------------------------
DROP TABLE IF EXISTS `exam_answer`;
CREATE TABLE `exam_answer`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `record_id` bigint UNSIGNED NOT NULL,
  `question_id` bigint UNSIGNED NOT NULL,
  `user_answer` json NOT NULL,
  `correct` tinyint(1) NOT NULL DEFAULT 0,
  `score` decimal(6, 2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_exam_answer`(`record_id` ASC, `question_id` ASC) USING BTREE,
  INDEX `fk_answer_question`(`question_id` ASC) USING BTREE,
  CONSTRAINT `fk_answer_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_answer_record` FOREIGN KEY (`record_id`) REFERENCES `exam_record` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '答题明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_answer
-- ----------------------------

-- ----------------------------
-- Table structure for exam_paper
-- ----------------------------
DROP TABLE IF EXISTS `exam_paper`;
CREATE TABLE `exam_paper`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bank_id` bigint UNSIGNED NULL DEFAULT NULL,
  `paper_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'FIXED' COMMENT 'FIXED/RANDOM',
  `random_count` int UNSIGNED NULL DEFAULT NULL COMMENT '随机抽题数量',
  `total_score` decimal(8, 2) NOT NULL DEFAULT 100.00,
  `pass_score` decimal(8, 2) NOT NULL DEFAULT 60.00,
  `duration_min` int UNSIGNED NULL DEFAULT 60 COMMENT '考试时长（分钟）',
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_paper_bank`(`bank_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '考卷' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_paper
-- ----------------------------

-- ----------------------------
-- Table structure for exam_paper_question
-- ----------------------------
DROP TABLE IF EXISTS `exam_paper_question`;
CREATE TABLE `exam_paper_question`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `paper_id` bigint UNSIGNED NOT NULL,
  `question_id` bigint UNSIGNED NOT NULL,
  `sort_no` int NOT NULL DEFAULT 0,
  `score` decimal(6, 2) NOT NULL DEFAULT 1.00,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_paper_question`(`paper_id` ASC, `question_id` ASC) USING BTREE,
  INDEX `fk_epq_question`(`question_id` ASC) USING BTREE,
  CONSTRAINT `fk_epq_paper` FOREIGN KEY (`paper_id`) REFERENCES `exam_paper` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_epq_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '考卷-题目' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_paper_question
-- ----------------------------

-- ----------------------------
-- Table structure for exam_record
-- ----------------------------
DROP TABLE IF EXISTS `exam_record`;
CREATE TABLE `exam_record`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `student_id` bigint UNSIGNED NULL DEFAULT NULL,
  `paper_id` bigint UNSIGNED NOT NULL,
  `topic_id` bigint UNSIGNED NULL DEFAULT NULL,
  `total_score` decimal(8, 2) NOT NULL DEFAULT 0.00,
  `user_score` decimal(8, 2) NOT NULL DEFAULT 0.00,
  `passed` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SUBMITTED' COMMENT 'IN_PROGRESS/SUBMITTED',
  `started_at` datetime NOT NULL,
  `submitted_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_exam_record_user`(`user_id` ASC, `submitted_at` ASC) USING BTREE,
  INDEX `idx_exam_record_topic`(`topic_id` ASC) USING BTREE,
  INDEX `idx_exam_record_paper`(`paper_id` ASC) USING BTREE,
  CONSTRAINT `fk_record_paper` FOREIGN KEY (`paper_id`) REFERENCES `exam_paper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '考试记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_record
-- ----------------------------

-- ----------------------------
-- Table structure for expert
-- ----------------------------
DROP TABLE IF EXISTS `expert`;
CREATE TABLE `expert`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `admin_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联管理员（专家登录）',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '职称',
  `avatar_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `intro` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `specialty` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '擅长领域',
  `resume_json` json NULL COMMENT '履历时间轴',
  `sort_no` int NOT NULL DEFAULT 0,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_expert_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_expert_admin`(`admin_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专家' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of expert
-- ----------------------------

-- ----------------------------
-- Table structure for expert_category
-- ----------------------------
DROP TABLE IF EXISTS `expert_category`;
CREATE TABLE `expert_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_no` int NOT NULL DEFAULT 0,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专家分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of expert_category
-- ----------------------------

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `images_json` json NULL COMMENT '图片 URL 数组',
  `contact` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_feedback_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_feedback_created`(`created_at` ASC) USING BTREE,
  CONSTRAINT `fk_feedback_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户反馈' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feedback
-- ----------------------------

-- ----------------------------
-- Table structure for flyway_schema_history
-- ----------------------------
DROP TABLE IF EXISTS `flyway_schema_history`;
CREATE TABLE `flyway_schema_history`  (
  `installed_rank` int NOT NULL,
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `script` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` int NULL DEFAULT NULL,
  `installed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`) USING BTREE,
  INDEX `flyway_schema_history_s_idx`(`success` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of flyway_schema_history
-- ----------------------------
INSERT INTO `flyway_schema_history` VALUES (1, '1', '<< Flyway Baseline >>', 'BASELINE', '<< Flyway Baseline >>', NULL, 'root', '2026-05-25 21:59:26', 0, 1);
INSERT INTO `flyway_schema_history` VALUES (2, '00100001', 'baseline platform', 'SQL', 'V00100001__baseline_platform.sql', -1503439688, 'root', '2026-05-25 21:59:27', 297, 1);
INSERT INTO `flyway_schema_history` VALUES (3, '00100002', 'seed sys config', 'SQL', 'V00100002__seed_sys_config.sql', 501643442, 'root', '2026-05-25 21:59:27', 3, 1);
INSERT INTO `flyway_schema_history` VALUES (4, '00101001', 'auth rbac tables', 'SQL', 'V00101001__auth_rbac_tables.sql', -1463618375, 'tcm', '2026-05-25 23:43:40', 25, 1);
INSERT INTO `flyway_schema_history` VALUES (5, '00101002', 'seed auth rbac', 'SQL', 'V00101002__seed_auth_rbac.sql', 22446508, 'tcm', '2026-05-26 00:03:08', 15, 1);
INSERT INTO `flyway_schema_history` VALUES (6, '00102001', 'user student tables', 'SQL', 'V00102001__user_student_tables.sql', -2147081950, 'tcm', '2026-05-26 00:03:08', 27, 1);
INSERT INTO `flyway_schema_history` VALUES (7, '00102002', 'seed user student permissions', 'SQL', 'V00102002__seed_user_student_permissions.sql', -2128741657, 'tcm', '2026-05-26 00:03:08', 4, 1);

-- ----------------------------
-- Table structure for home_banner
-- ----------------------------
DROP TABLE IF EXISTS `home_banner`;
CREATE TABLE `home_banner`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `link_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'NONE' COMMENT 'NONE/ARTICLE/TOPIC/URL',
  `link_value` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `sort_no` int NOT NULL DEFAULT 0,
  `start_at` datetime NULL DEFAULT NULL,
  `end_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_banner_visible`(`visible` ASC, `sort_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '首页轮播' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_banner
-- ----------------------------

-- ----------------------------
-- Table structure for home_block
-- ----------------------------
DROP TABLE IF EXISTS `home_block`;
CREATE TABLE `home_block`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `block_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '区块标识',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `config_json` json NOT NULL COMMENT '区块展示配置',
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `sort_no` int NOT NULL DEFAULT 0,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_home_block_key`(`block_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '首页区块配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_block
-- ----------------------------

-- ----------------------------
-- Table structure for home_category
-- ----------------------------
DROP TABLE IF EXISTS `home_category`;
CREATE TABLE `home_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `sort_no` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '首页分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_category
-- ----------------------------

-- ----------------------------
-- Table structure for kb_book
-- ----------------------------
DROP TABLE IF EXISTS `kb_book`;
CREATE TABLE `kb_book`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `author` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `file_format` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PDF',
  `oss_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slice_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/PROCESSING/DONE/FAILED',
  `question_bank_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '可选章节练习题库',
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_kb_book_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_kb_book_slice`(`slice_status` ASC) USING BTREE,
  FULLTEXT INDEX `ft_kb_book_title`(`title`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识库书籍' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_book
-- ----------------------------

-- ----------------------------
-- Table structure for kb_bookmark
-- ----------------------------
DROP TABLE IF EXISTS `kb_bookmark`;
CREATE TABLE `kb_bookmark`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `book_id` bigint UNSIGNED NOT NULL,
  `chapter_id` bigint UNSIGNED NULL DEFAULT NULL,
  `page_no` int UNSIGNED NULL DEFAULT NULL,
  `note` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_kb_bookmark_user`(`user_id` ASC, `book_id` ASC) USING BTREE,
  INDEX `fk_kb_bm_book`(`book_id` ASC) USING BTREE,
  CONSTRAINT `fk_kb_bm_book` FOREIGN KEY (`book_id`) REFERENCES `kb_book` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_kb_bm_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识库书签' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_bookmark
-- ----------------------------

-- ----------------------------
-- Table structure for kb_category
-- ----------------------------
DROP TABLE IF EXISTS `kb_category`;
CREATE TABLE `kb_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '中医基础理论/中药学等',
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `sort_no` int NOT NULL DEFAULT 0,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识库分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_category
-- ----------------------------
INSERT INTO `kb_category` VALUES (1, '中医基础理论', 0, 1, 1, '2026-05-25 21:55:49');
INSERT INTO `kb_category` VALUES (2, '中医诊断学', 0, 2, 1, '2026-05-25 21:55:49');
INSERT INTO `kb_category` VALUES (3, '中药学', 0, 3, 1, '2026-05-25 21:55:49');
INSERT INTO `kb_category` VALUES (4, '方剂学', 0, 4, 1, '2026-05-25 21:55:49');
INSERT INTO `kb_category` VALUES (5, '中医内科学', 0, 5, 1, '2026-05-25 21:55:49');
INSERT INTO `kb_category` VALUES (6, '中医外科学', 0, 6, 1, '2026-05-25 21:55:49');
INSERT INTO `kb_category` VALUES (7, '四大经典', 0, 7, 1, '2026-05-25 21:55:49');
INSERT INTO `kb_category` VALUES (8, '中医基础理论', 0, 1, 1, '2026-05-25 21:55:51');
INSERT INTO `kb_category` VALUES (9, '中医诊断学', 0, 2, 1, '2026-05-25 21:55:51');
INSERT INTO `kb_category` VALUES (10, '中药学', 0, 3, 1, '2026-05-25 21:55:51');
INSERT INTO `kb_category` VALUES (11, '方剂学', 0, 4, 1, '2026-05-25 21:55:51');
INSERT INTO `kb_category` VALUES (12, '中医内科学', 0, 5, 1, '2026-05-25 21:55:51');
INSERT INTO `kb_category` VALUES (13, '中医外科学', 0, 6, 1, '2026-05-25 21:55:51');
INSERT INTO `kb_category` VALUES (14, '四大经典', 0, 7, 1, '2026-05-25 21:55:51');

-- ----------------------------
-- Table structure for kb_chapter
-- ----------------------------
DROP TABLE IF EXISTS `kb_chapter`;
CREATE TABLE `kb_chapter`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `book_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '切片正文',
  `page_start` int UNSIGNED NULL DEFAULT NULL,
  `page_end` int UNSIGNED NULL DEFAULT NULL,
  `sort_no` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_kb_chapter_book`(`book_id` ASC, `parent_id` ASC, `sort_no` ASC) USING BTREE,
  FULLTEXT INDEX `ft_kb_chapter_content`(`title`, `content_text`),
  CONSTRAINT `fk_kb_chapter_book` FOREIGN KEY (`book_id`) REFERENCES `kb_book` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识库章节' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_chapter
-- ----------------------------

-- ----------------------------
-- Table structure for learning_duration
-- ----------------------------
DROP TABLE IF EXISTS `learning_duration`;
CREATE TABLE `learning_duration`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `stat_date` date NOT NULL,
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `seconds` int UNSIGNED NOT NULL DEFAULT 0,
  `report_count` int UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_duration_day`(`user_id` ASC, `stat_date` ASC, `resource_type` ASC) USING BTREE,
  INDEX `idx_duration_date`(`stat_date` ASC) USING BTREE,
  CONSTRAINT `fk_duration_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习时长（按日）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_duration
-- ----------------------------

-- ----------------------------
-- Table structure for learning_progress
-- ----------------------------
DROP TABLE IF EXISTS `learning_progress`;
CREATE TABLE `learning_progress`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'COURSE_VIDEO/BOOK_CHAPTER/PODCAST_EPISODE',
  `resource_id` bigint UNSIGNED NOT NULL,
  `position` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '播放位置或页码',
  `progress_pct` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '进度百分比',
  `completed` tinyint(1) NOT NULL DEFAULT 0,
  `last_report_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_learning_progress`(`user_id` ASC, `resource_type` ASC, `resource_id` ASC) USING BTREE,
  INDEX `idx_progress_resource`(`resource_type` ASC, `resource_id` ASC) USING BTREE,
  CONSTRAINT `fk_progress_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习进度' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_progress
-- ----------------------------

-- ----------------------------
-- Table structure for live_session
-- ----------------------------
DROP TABLE IF EXISTS `live_session`;
CREATE TABLE `live_session`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `topic_id` bigint UNSIGNED NULL DEFAULT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NULL DEFAULT NULL,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SCHEDULED' COMMENT 'SCHEDULED/LIVE/ENDED',
  `third_party_room_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `playback_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回放地址',
  `provider` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'TENCENT' COMMENT '直播服务商',
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `web_visible` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_live_topic`(`topic_id` ASC) USING BTREE,
  INDEX `idx_live_start`(`start_time` ASC) USING BTREE,
  INDEX `idx_live_audit`(`audit_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '直播场次' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of live_session
-- ----------------------------

-- ----------------------------
-- Table structure for media_asset
-- ----------------------------
DROP TABLE IF EXISTS `media_asset`;
CREATE TABLE `media_asset`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `module` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务模块：course/book/article等',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文件名',
  `oss_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'OSS 对象键',
  `mime_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'MIME',
  `file_size` bigint UNSIGNED NULL DEFAULT 0 COMMENT '字节数',
  `duration_sec` int UNSIGNED NULL DEFAULT NULL COMMENT '音视频时长（秒）',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE/DELETED',
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_media_oss_key`(`oss_key` ASC) USING BTREE,
  INDEX `idx_media_module`(`module` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '媒体资源' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of media_asset
-- ----------------------------

-- ----------------------------
-- Table structure for podcast
-- ----------------------------
DROP TABLE IF EXISTS `podcast`;
CREATE TABLE `podcast`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `host_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `web_visible` tinyint(1) NOT NULL DEFAULT 0,
  `published_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_podcast_audit`(`audit_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '播客' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of podcast
-- ----------------------------

-- ----------------------------
-- Table structure for podcast_episode
-- ----------------------------
DROP TABLE IF EXISTS `podcast_episode`;
CREATE TABLE `podcast_episode`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `podcast_id` bigint UNSIGNED NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration_sec` int UNSIGNED NOT NULL DEFAULT 0,
  `audio_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_no` int NOT NULL DEFAULT 0,
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_episode_podcast`(`podcast_id` ASC, `sort_no` ASC) USING BTREE,
  CONSTRAINT `fk_episode_podcast` FOREIGN KEY (`podcast_id`) REFERENCES `podcast` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '播客单集' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of podcast_episode
-- ----------------------------

-- ----------------------------
-- Table structure for qa_reply
-- ----------------------------
DROP TABLE IF EXISTS `qa_reply`;
CREATE TABLE `qa_reply`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `thread_id` bigint UNSIGNED NOT NULL,
  `replier_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'EXPERT/ADMIN',
  `replier_id` bigint UNSIGNED NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_reply_thread`(`thread_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `fk_reply_thread` FOREIGN KEY (`thread_id`) REFERENCES `qa_thread` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '答疑回复' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qa_reply
-- ----------------------------

-- ----------------------------
-- Table structure for qa_thread
-- ----------------------------
DROP TABLE IF EXISTS `qa_thread`;
CREATE TABLE `qa_thread`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `expert_id` bigint UNSIGNED NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN' COMMENT 'OPEN/ANSWERED/CLOSED',
  `public_visible` tinyint(1) NOT NULL DEFAULT 1 COMMENT '公开展示',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_qa_expert`(`expert_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_qa_student`(`student_id` ASC) USING BTREE,
  INDEX `fk_qa_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_qa_expert` FOREIGN KEY (`expert_id`) REFERENCES `expert` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_qa_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_qa_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '答疑主题' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qa_thread
-- ----------------------------

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `bank_id` bigint UNSIGNED NOT NULL,
  `question_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'SINGLE/MULTIPLE/FILL',
  `stem` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题干',
  `options_json` json NULL COMMENT '选项 [{key,label}]',
  `answer_json` json NOT NULL COMMENT '答案',
  `analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '解析',
  `score` decimal(6, 2) NOT NULL DEFAULT 1.00,
  `difficulty` tinyint NULL DEFAULT 1 COMMENT '1-5',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_question_bank`(`bank_id` ASC) USING BTREE,
  CONSTRAINT `fk_question_bank` FOREIGN KEY (`bank_id`) REFERENCES `question_bank` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '题目' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question
-- ----------------------------

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `category` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '题库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question_bank
-- ----------------------------

-- ----------------------------
-- Table structure for site_config
-- ----------------------------
DROP TABLE IF EXISTS `site_config`;
CREATE TABLE `site_config`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'site_name/icp/miniapp_qr等',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_site_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '官网站点配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of site_config
-- ----------------------------
INSERT INTO `site_config` VALUES (1, 'site_name', '\"江苏中医在线\"', '站点名称', '2026-05-25 21:55:49');
INSERT INTO `site_config` VALUES (2, 'site_subtitle', '\"江苏中医知识服务云平台\"', '副标题', '2026-05-25 21:55:49');
INSERT INTO `site_config` VALUES (3, 'icp_no', '\"苏ICP备xxxx号\"', '备案号', '2026-05-25 21:55:49');
INSERT INTO `site_config` VALUES (4, 'miniapp_name', '\"江苏中医在线\"', '小程序名称', '2026-05-25 21:55:49');
INSERT INTO `site_config` VALUES (5, 'customer_phone', '\"400-000-0000\"', '客服电话', '2026-05-25 21:55:49');

-- ----------------------------
-- Table structure for site_nav
-- ----------------------------
DROP TABLE IF EXISTS `site_nav`;
CREATE TABLE `site_nav`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `label` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `sort_no` int NOT NULL DEFAULT 0,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `nav_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HEADER' COMMENT 'HEADER/FOOTER',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_site_nav_type`(`nav_type` ASC, `visible` ASC, `sort_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '官网导航' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of site_nav
-- ----------------------------
INSERT INTO `site_nav` VALUES (1, '首页', '/', 0, 1, 1, 'HEADER', '2026-05-25 21:55:49');
INSERT INTO `site_nav` VALUES (2, '资讯', '/articles', 0, 2, 1, 'HEADER', '2026-05-25 21:55:49');
INSERT INTO `site_nav` VALUES (3, '专题', '/topics', 0, 3, 1, 'HEADER', '2026-05-25 21:55:49');
INSERT INTO `site_nav` VALUES (4, '课程', '/courses', 0, 4, 1, 'HEADER', '2026-05-25 21:55:49');
INSERT INTO `site_nav` VALUES (5, '图书', '/books', 0, 5, 1, 'HEADER', '2026-05-25 21:55:49');
INSERT INTO `site_nav` VALUES (6, '直播', '/live', 0, 6, 1, 'HEADER', '2026-05-25 21:55:49');
INSERT INTO `site_nav` VALUES (7, '关于', '/about', 0, 7, 1, 'HEADER', '2026-05-25 21:55:49');
INSERT INTO `site_nav` VALUES (8, '首页', '/', 0, 1, 1, 'HEADER', '2026-05-25 21:55:51');
INSERT INTO `site_nav` VALUES (9, '资讯', '/articles', 0, 2, 1, 'HEADER', '2026-05-25 21:55:51');
INSERT INTO `site_nav` VALUES (10, '专题', '/topics', 0, 3, 1, 'HEADER', '2026-05-25 21:55:51');
INSERT INTO `site_nav` VALUES (11, '课程', '/courses', 0, 4, 1, 'HEADER', '2026-05-25 21:55:51');
INSERT INTO `site_nav` VALUES (12, '图书', '/books', 0, 5, 1, 'HEADER', '2026-05-25 21:55:51');
INSERT INTO `site_nav` VALUES (13, '直播', '/live', 0, 6, 1, 'HEADER', '2026-05-25 21:55:51');
INSERT INTO `site_nav` VALUES (14, '关于', '/about', 0, 7, 1, 'HEADER', '2026-05-25 21:55:51');

-- ----------------------------
-- Table structure for statistics_snapshot
-- ----------------------------
DROP TABLE IF EXISTS `statistics_snapshot`;
CREATE TABLE `statistics_snapshot`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `snapshot_date` date NOT NULL,
  `metric_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'LEARNING_HOURS/STUDENT_COUNT/REGION/SCORE',
  `dimension_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '如 region=南京市',
  `dimension_val` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `metric_value` decimal(16, 4) NOT NULL DEFAULT 0.0000,
  `extra_json` json NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_snapshot_metric`(`snapshot_date` ASC, `metric_type` ASC, `dimension_key` ASC, `dimension_val` ASC) USING BTREE,
  INDEX `idx_snapshot_type_date`(`metric_type` ASC, `snapshot_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '统计预聚合快照' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of statistics_snapshot
-- ----------------------------

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL COMMENT '关联 app_user',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_card` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号',
  `gender` tinyint NULL DEFAULT NULL COMMENT '0女 1男',
  `region` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地区（统计维度）',
  `org_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所在单位',
  `cert_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNVERIFIED' COMMENT 'UNVERIFIED/PENDING/CERTIFIED/REJECTED',
  `cert_time` datetime NULL DEFAULT NULL,
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_student_region`(`region` ASC) USING BTREE,
  INDEX `idx_student_cert`(`cert_status` ASC) USING BTREE,
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '认证学员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------

-- ----------------------------
-- Table structure for student_import_batch
-- ----------------------------
DROP TABLE IF EXISTS `student_import_batch`;
CREATE TABLE `student_import_batch`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_count` int UNSIGNED NOT NULL DEFAULT 0,
  `success_count` int UNSIGNED NOT NULL DEFAULT 0,
  `fail_count` int UNSIGNED NOT NULL DEFAULT 0,
  `error_file_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '失败明细文件 OSS 地址',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PROCESSING' COMMENT 'PROCESSING/DONE/FAILED',
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `finished_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_import_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学员导入批次' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_import_batch
-- ----------------------------

-- ----------------------------
-- Table structure for sys_admin
-- ----------------------------
DROP TABLE IF EXISTS `sys_admin`;
CREATE TABLE `sys_admin`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录账号',
  `password_hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'bcrypt 哈希',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1启用 0禁用',
  `login_fail_count` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `locked_until` datetime NULL DEFAULT NULL,
  `last_login_at` datetime NULL DEFAULT NULL,
  `last_login_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sys_admin_username`(`username` ASC) USING BTREE,
  INDEX `idx_sys_admin_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_admin
-- ----------------------------
INSERT INTO `sys_admin` VALUES (1, 'admin', '$2b$10$ww.8o3lcU7L1kUvRaaTr7.z9kYQrjTb/ZzynGGduSSQ6A9ZR1iqsO', '系统管理员', NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, 0, '2026-05-25 21:55:49', '2026-05-25 21:55:49');

-- ----------------------------
-- Table structure for sys_admin_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_admin_role`;
CREATE TABLE `sys_admin_role`  (
  `admin_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`admin_id`, `role_id`) USING BTREE,
  INDEX `idx_sar_role`(`role_id` ASC) USING BTREE,
  CONSTRAINT `fk_sar_admin` FOREIGN KEY (`admin_id`) REFERENCES `sys_admin` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sar_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员-角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_admin_role
-- ----------------------------
INSERT INTO `sys_admin_role` VALUES (1, 1);

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置值（JSON 或文本）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sys_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, 'platform.version', '1.0.0-SNAPSHOT', '工程基座版本', '2026-05-25 21:59:27', '2026-05-25 21:59:27');

-- ----------------------------
-- Table structure for sys_login_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_id` bigint UNSIGNED NULL DEFAULT NULL,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_login_log_admin`(`admin_id` ASC) USING BTREE,
  INDEX `idx_login_log_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理端登录日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_login_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'course:video:audit',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '权限树父节点',
  `sort_no` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sys_permission_code`(`code` ASC) USING BTREE,
  INDEX `idx_sys_permission_parent`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '权限' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (1, 'system:admin:view', '查看管理员', 'system', NULL, 10, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (2, 'system:admin:edit', '编辑管理员', 'system', NULL, 11, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (3, 'system:role:view', '查看角色', 'system', NULL, 20, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (4, 'system:role:edit', '编辑角色', 'system', NULL, 21, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (5, 'article:view', '查看资讯', 'article', NULL, 30, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (6, 'article:create', '创建资讯', 'article', NULL, 31, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (7, 'article:audit', '审核资讯', 'article', NULL, 32, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (8, 'course:view', '查看课程', 'course', NULL, 40, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (9, 'course:create', '创建课程', 'course', NULL, 41, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (10, 'course:audit', '审核课程', 'course', NULL, 42, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (11, 'book:view', '查看图书', 'book', NULL, 50, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (12, 'book:create', '创建图书', 'book', NULL, 51, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (13, 'topic:view', '查看专题', 'topic', NULL, 60, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (14, 'topic:create', '创建专题', 'topic', NULL, 61, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (15, 'exam:view', '查看题库', 'exam', NULL, 70, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (16, 'exam:create', '维护题库', 'exam', NULL, 71, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (17, 'stats:view', '查看统计', 'stats', NULL, 80, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (18, 'stats:export', '导出统计', 'stats', NULL, 81, '2026-05-25 21:55:49');
INSERT INTO `sys_permission` VALUES (20, 'account', '账号管理', 'account', NULL, 20, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (21, 'account:user', '用户管理', 'account', 20, 1, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (22, 'account:user:list', '用户列表', 'account', 21, 1, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (23, 'account:user:edit', '编辑用户', 'account', 21, 2, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (24, 'account:student', '学员管理', 'account', 20, 2, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (25, 'account:student:list', '学员列表', 'account', 24, 1, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (26, 'account:student:create', '创建学员', 'account', 24, 2, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (27, 'account:student:edit', '编辑学员', 'account', 24, 3, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (28, 'account:student:delete', '删除学员', 'account', 24, 4, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (29, 'account:student:import', '导入学员', 'account', 24, 5, '2026-05-25 23:57:18');
INSERT INTO `sys_permission` VALUES (30, 'account:student:export', '导出学员', 'account', 24, 6, '2026-05-25 23:57:18');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'super_admin/content_editor等',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `sort_no` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sys_role_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, 'super_admin', '超级管理员', '全部模块', 1, 1, '2026-05-25 21:55:49', '2026-05-25 21:55:49');
INSERT INTO `sys_role` VALUES (2, 'content_editor', '内容编辑', '内容 CRUD，无审核通过', 1, 2, '2026-05-25 21:55:49', '2026-05-25 21:55:49');
INSERT INTO `sys_role` VALUES (3, 'auditor', '审核员', '审核通过/驳回', 1, 3, '2026-05-25 21:55:49', '2026-05-25 21:55:49');
INSERT INTO `sys_role` VALUES (4, 'student_admin', '学员管理员', '学员/用户/导入导出', 1, 4, '2026-05-25 21:55:49', '2026-05-25 21:55:49');
INSERT INTO `sys_role` VALUES (5, 'analyst', '数据分析员', '只读统计', 1, 5, '2026-05-25 21:55:49', '2026-05-25 21:55:49');
INSERT INTO `sys_role` VALUES (6, 'expert', '专家', '答疑回复', 1, 6, '2026-05-25 21:55:49', '2026-05-25 21:55:49');

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
  `role_id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`) USING BTREE,
  INDEX `idx_srp_permission`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `fk_srp_perm` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_srp_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色-权限' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
INSERT INTO `sys_role_permission` VALUES (1, 1);
INSERT INTO `sys_role_permission` VALUES (1, 2);
INSERT INTO `sys_role_permission` VALUES (1, 3);
INSERT INTO `sys_role_permission` VALUES (1, 4);
INSERT INTO `sys_role_permission` VALUES (1, 5);
INSERT INTO `sys_role_permission` VALUES (1, 6);
INSERT INTO `sys_role_permission` VALUES (1, 7);
INSERT INTO `sys_role_permission` VALUES (1, 8);
INSERT INTO `sys_role_permission` VALUES (1, 9);
INSERT INTO `sys_role_permission` VALUES (1, 10);
INSERT INTO `sys_role_permission` VALUES (1, 11);
INSERT INTO `sys_role_permission` VALUES (1, 12);
INSERT INTO `sys_role_permission` VALUES (1, 13);
INSERT INTO `sys_role_permission` VALUES (1, 14);
INSERT INTO `sys_role_permission` VALUES (1, 15);
INSERT INTO `sys_role_permission` VALUES (1, 16);
INSERT INTO `sys_role_permission` VALUES (1, 17);
INSERT INTO `sys_role_permission` VALUES (1, 18);
INSERT INTO `sys_role_permission` VALUES (1, 20);
INSERT INTO `sys_role_permission` VALUES (1, 21);
INSERT INTO `sys_role_permission` VALUES (1, 22);
INSERT INTO `sys_role_permission` VALUES (1, 23);
INSERT INTO `sys_role_permission` VALUES (1, 24);
INSERT INTO `sys_role_permission` VALUES (1, 25);
INSERT INTO `sys_role_permission` VALUES (1, 26);
INSERT INTO `sys_role_permission` VALUES (1, 27);
INSERT INTO `sys_role_permission` VALUES (1, 28);
INSERT INTO `sys_role_permission` VALUES (1, 29);
INSERT INTO `sys_role_permission` VALUES (1, 30);

-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `requirement` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '学习要求说明',
  `exam_threshold` decimal(5, 2) NOT NULL DEFAULT 80.00 COMMENT '完成比例门槛（%）方可考试',
  `exam_paper_id` bigint UNSIGNED NULL DEFAULT NULL,
  `audit_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `web_visible` tinyint(1) NOT NULL DEFAULT 0,
  `published_at` datetime NULL DEFAULT NULL,
  `start_at` datetime NULL DEFAULT NULL,
  `end_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_topic_audit`(`audit_status` ASC) USING BTREE,
  INDEX `idx_topic_web`(`web_visible` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专题' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic
-- ----------------------------

-- ----------------------------
-- Table structure for topic_resource
-- ----------------------------
DROP TABLE IF EXISTS `topic_resource`;
CREATE TABLE `topic_resource`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `topic_id` bigint UNSIGNED NOT NULL,
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ARTICLE/BOOK/COURSE/PODCAST/EXAM_PAPER',
  `resource_id` bigint UNSIGNED NOT NULL,
  `sort_no` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_topic_resource`(`topic_id` ASC, `resource_type` ASC, `resource_id` ASC) USING BTREE,
  INDEX `idx_topic_res_type`(`topic_id` ASC, `resource_type` ASC) USING BTREE,
  CONSTRAINT `fk_topic_res_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专题资源绑定' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic_resource
-- ----------------------------

-- ----------------------------
-- Table structure for topic_student
-- ----------------------------
DROP TABLE IF EXISTS `topic_student`;
CREATE TABLE `topic_student`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `topic_id` bigint UNSIGNED NOT NULL,
  `student_id` bigint UNSIGNED NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_topic_student`(`topic_id` ASC, `student_id` ASC) USING BTREE,
  INDEX `fk_ts_student`(`student_id` ASC) USING BTREE,
  CONSTRAINT `fk_ts_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_ts_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专题指定学员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic_student
-- ----------------------------

-- ----------------------------
-- Table structure for user_collection
-- ----------------------------
DROP TABLE IF EXISTS `user_collection`;
CREATE TABLE `user_collection`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ARTICLE/COURSE/BOOK等',
  `resource_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_collect`(`user_id` ASC, `resource_type` ASC, `resource_id` ASC) USING BTREE,
  INDEX `idx_collect_resource`(`resource_type` ASC, `resource_id` ASC) USING BTREE,
  CONSTRAINT `fk_collect_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户收藏' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_collection
-- ----------------------------

-- ----------------------------
-- Table structure for web_seo
-- ----------------------------
DROP TABLE IF EXISTS `web_seo`;
CREATE TABLE `web_seo`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '页面路径',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `og_image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_web_seo_path`(`path` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '官网 SEO' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of web_seo
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
