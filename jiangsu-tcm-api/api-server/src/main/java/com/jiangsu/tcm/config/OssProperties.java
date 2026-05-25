package com.jiangsu.tcm.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 对象存储配置（MinIO / 阿里云 OSS S3 兼容）。
 */
@Data
@ConfigurationProperties(prefix = "tcm.oss")
public class OssProperties {

    private String endpoint = "http://127.0.0.1:9000";
    private String bucket = "tcm-online";
    private String accessKey = "minioadmin";
    private String secretKey = "minioadmin";
    private String env = "dev";
    private int presignExpireSeconds = 3600;
}
