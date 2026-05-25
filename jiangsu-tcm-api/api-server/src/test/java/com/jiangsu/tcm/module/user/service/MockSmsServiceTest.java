package com.jiangsu.tcm.module.user.service;

import static org.junit.jupiter.api.Assertions.assertTrue;

import com.jiangsu.tcm.config.SmsProperties;
import com.jiangsu.tcm.module.user.service.impl.MockSmsService;
import org.junit.jupiter.api.Test;

class MockSmsServiceTest {

    @Test
    void shouldVerifyMockCode() {
        SmsService smsService = new MockSmsService(new SmsProperties());
        smsService.sendCode("13800000000");
        assertTrue(smsService.verifyCode("13800000000", "123456"));
    }
}
