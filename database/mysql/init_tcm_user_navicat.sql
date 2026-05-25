-- Navicat 执行：创建应用账号 tcm（与 application.yml 默认一致）
-- 用法：Navicat → 连接 root → 新建查询 → 粘贴全部 → 运行

CREATE DATABASE IF NOT EXISTS `tcm_online`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

-- 若用户已存在但密码不对，先改密码：
-- ALTER USER 'tcm'@'localhost' IDENTIFIED BY 'tcm123456';

CREATE USER IF NOT EXISTS 'tcm'@'localhost' IDENTIFIED BY 'tcm123456';
CREATE USER IF NOT EXISTS 'tcm'@'127.0.0.1' IDENTIFIED BY 'tcm123456';

GRANT ALL PRIVILEGES ON `tcm_online`.* TO 'tcm'@'localhost';
GRANT ALL PRIVILEGES ON `tcm_online`.* TO 'tcm'@'127.0.0.1';

FLUSH PRIVILEGES;

-- 验证（可选）：
-- SELECT user, host FROM mysql.user WHERE user = 'tcm';
