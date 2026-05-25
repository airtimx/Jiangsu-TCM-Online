package com.jiangsu.tcm.module.user.controller;

import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.user.dto.AppUserProfileVo;
import com.jiangsu.tcm.module.user.dto.StudentCertifyRequest;
import com.jiangsu.tcm.module.user.service.AppUserProfileService;
import com.jiangsu.tcm.module.user.support.AppContext;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "小程序用户", description = "模块 02 stable")
@RestController
@RequestMapping("/api/app/v1")
@RequiredArgsConstructor
public class AppUserController {

    private final AppUserProfileService appUserProfileService;

    @Operation(summary = "用户资料")
    @GetMapping("/user/profile")
    public Result<AppUserProfileVo> profile() {
        return Result.ok(appUserProfileService.getProfile(AppContext.requireUserId()));
    }

    @Operation(summary = "学员认证")
    @PostMapping("/student/certify")
    public Result<AppUserProfileVo> certify(@Valid @RequestBody StudentCertifyRequest request) {
        return Result.ok(appUserProfileService.certify(AppContext.requireUserId(), request));
    }
}
