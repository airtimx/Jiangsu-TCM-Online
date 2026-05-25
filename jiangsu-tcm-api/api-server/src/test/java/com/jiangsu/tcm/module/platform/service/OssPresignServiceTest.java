package com.jiangsu.tcm.module.platform.service;

import static org.junit.jupiter.api.Assertions.assertTrue;

import com.jiangsu.tcm.config.OssProperties;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class OssPresignServiceTest {

    private OssPresignService ossPresignService;

    @BeforeEach
    void setUp() {
        OssProperties properties = new OssProperties();
        properties.setEnv("dev");
        ossPresignService = new OssPresignService(properties);
    }

    @Test
    void buildOssKeyShouldFollowConvention() {
        String key = ossPresignService.buildOssKey("course", "pdf");
        assertTrue(key.startsWith("/dev/course/"));
        assertTrue(key.endsWith(".pdf"));
    }
}
