package com.jiangsu.tcm.module.user.service.impl;

import com.jiangsu.tcm.config.SmsProperties;
import com.jiangsu.tcm.module.user.service.SmsService;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class MockSmsService implements SmsService {

    private final SmsProperties smsProperties;
    private final Map<String, String> codeStore = new ConcurrentHashMap<>();

    @Override
    public void sendCode(String phone) {
        String code = smsProperties.getMockCode();
        codeStore.put(phone, code);
        log.info("mock sms sent phone={} code={}", phone, code);
    }

    @Override
    public boolean verifyCode(String phone, String code) {
        if (!"mock".equalsIgnoreCase(smsProperties.getMode())) {
            return false;
        }
        return smsProperties.getMockCode().equals(code) || codeStore.getOrDefault(phone, "").equals(code);
    }
}
