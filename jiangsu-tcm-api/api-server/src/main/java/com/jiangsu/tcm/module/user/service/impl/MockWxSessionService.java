package com.jiangsu.tcm.module.user.service.impl;

import com.jiangsu.tcm.config.WxProperties;
import com.jiangsu.tcm.module.user.service.WxSessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class MockWxSessionService implements WxSessionService {

    private final WxProperties wxProperties;

    @Override
    public WxSession resolve(String code) {
        if (!"mock".equalsIgnoreCase(wxProperties.getMode())) {
            throw new UnsupportedOperationException("仅实现 mock 微信登录，生产请接入 code2Session");
        }
        String openid = "mock_" + (StringUtils.hasText(code) ? code : "guest");
        return new WxSession(openid, null);
    }
}
