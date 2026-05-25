-- 重置管理端 admin 密码为 admin123456（仅开发环境）
-- Navicat 对 tcm_online 整文件执行

USE `tcm_online`;

UPDATE `sys_admin`
SET `password_hash` = '$2a$10$MrP2XHDtE3bCU.4AsWBAtuwx/H9jkXkfAA/A..ozqkb3UvAEcumFK',
    `status` = 1,
    `deleted` = 0,
    `login_fail_count` = 0,
    `locked_until` = NULL
WHERE `username` = 'admin';

SELECT id, username, real_name, status, deleted FROM `sys_admin` WHERE username = 'admin';
