package com.jiangsu.tcm.module.auth.controller;

import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.auth.dto.AdminProfileVo;
import com.jiangsu.tcm.module.auth.dto.LoginRequest;
import com.jiangsu.tcm.module.auth.dto.LoginResponse;
import com.jiangsu.tcm.module.auth.dto.RefreshTokenRequest;
import com.jiangsu.tcm.module.auth.service.AuthService;
import com.jiangsu.tcm.module.auth.support.AuthContext;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "管理端认证", description = "模块 01 stable")
@RestController
@RequestMapping("/api/admin/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @Operation(summary = "登录")
    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request, HttpServletRequest httpRequest) {
        return Result.ok(authService.login(request, httpRequest));
    }

    @Operation(summary = "刷新令牌")
    @PostMapping("/refresh")
    public Result<LoginResponse> refresh(@Valid @RequestBody RefreshTokenRequest request) {
        return Result.ok(authService.refresh(request));
    }

    @Operation(summary = "当前用户")
    @GetMapping("/me")
    public Result<AdminProfileVo> me() {
        return Result.ok(authService.me(AuthContext.requireAdminId()));
    }

    @Operation(summary = "登出")
    @PostMapping("/logout")
    public Result<Void> logout(HttpServletRequest httpRequest) {
        authService.logout(AuthContext.requireAdminId(), httpRequest);
        return Result.ok(null);
    }
}
