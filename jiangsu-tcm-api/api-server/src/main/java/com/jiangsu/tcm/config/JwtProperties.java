package com.jiangsu.tcm.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "tcm.jwt")
public class JwtProperties {

    private String secret = "jiangsu-tcm-online-dev-jwt-secret-key-32bytes-min";
    private int accessTokenMinutes = 120;
    private int refreshTokenDays = 7;
}
