package com.jiangsu.tcm.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "tcm.wx")
public class WxProperties {

    /** mock | wechat */
    private String mode = "mock";
    private String appId = "";
    private String appSecret = "";
}
