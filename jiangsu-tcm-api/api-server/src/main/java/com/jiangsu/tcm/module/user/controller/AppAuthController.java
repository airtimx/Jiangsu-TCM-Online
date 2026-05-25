package com.jiangsu.tcm.module.user.controller;

import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.user.dto.SmsSendRequest;
import com.jiangsu.tcm.module.user.dto.WxLoginRequest;
import com.jiangsu.tcm.module.user.dto.WxLoginResponse;
import com.jiangsu.tcm.module.user.service.AppAuthService;
import com.jiangsu.tcm.module.user.service.SmsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "小程序认证", description = "模块 02 stable")
@RestController
@RequestMapping("/api/app/v1/auth")
@RequiredArgsConstructor
public class AppAuthController {

    private final AppAuthService appAuthService;
    private final SmsService smsService;

    @Operation(summary = "微信登录")
    @PostMapping("/wx-login")
    public Result<WxLoginResponse> wxLogin(@Valid @RequestBody WxLoginRequest request) {
        return Result.ok(appAuthService.wxLogin(request));
    }

    @Operation(summary = "发送短信验证码（Mock）")
    @PostMapping("/sms/send")
    public Result<Void> sendSms(@Valid @RequestBody SmsSendRequest request) {
        smsService.sendCode(request.getPhone());
        return Result.ok(null);
    }
}
