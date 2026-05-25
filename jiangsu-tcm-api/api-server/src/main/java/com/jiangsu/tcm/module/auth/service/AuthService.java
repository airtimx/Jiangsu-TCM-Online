package com.jiangsu.tcm.module.auth.service;

import com.jiangsu.tcm.module.auth.dto.AdminProfileVo;
import com.jiangsu.tcm.module.auth.dto.LoginRequest;
import com.jiangsu.tcm.module.auth.dto.LoginResponse;
import com.jiangsu.tcm.module.auth.dto.RefreshTokenRequest;
import jakarta.servlet.http.HttpServletRequest;

public interface AuthService {

    LoginResponse login(LoginRequest request, HttpServletRequest httpRequest);

    LoginResponse refresh(RefreshTokenRequest request);

    AdminProfileVo me(Long adminId);

    void logout(Long adminId, HttpServletRequest httpRequest);
}
