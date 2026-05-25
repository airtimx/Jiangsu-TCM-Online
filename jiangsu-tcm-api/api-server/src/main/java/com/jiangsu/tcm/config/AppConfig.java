package com.jiangsu.tcm.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties({OssProperties.class, JwtProperties.class, WxProperties.class, SmsProperties.class})
public class AppConfig {
}
