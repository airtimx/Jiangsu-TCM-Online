package com.jiangsu.tcm.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "tcm.sms")
public class SmsProperties {

    private String mode = "mock";
    private String mockCode = "123456";
}
