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
