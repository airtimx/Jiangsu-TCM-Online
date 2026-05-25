package com.jiangsu.tcm.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAPI 3 文档（info.version 1.0.0，规范 §4.3）。
 */
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI openApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("江苏中医在线 API")
                        .version("1.0.0")
                        .description("一期 REST API，路径版本 v1"));
    }
}
