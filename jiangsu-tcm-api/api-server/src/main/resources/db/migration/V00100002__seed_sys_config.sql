-- 系统配置占位（W0）

INSERT INTO `sys_config` (`config_key`, `config_value`, `remark`)
VALUES ('platform.version', '1.0.0-SNAPSHOT', '工程基座版本')
ON DUPLICATE KEY UPDATE `config_value` = VALUES(`config_value`);
