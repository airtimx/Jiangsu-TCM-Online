package com.jiangsu.tcm.module.auth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.config.JwtProperties;
import com.jiangsu.tcm.module.auth.dto.AdminProfileVo;
import com.jiangsu.tcm.module.auth.dto.LoginRequest;
import com.jiangsu.tcm.module.auth.dto.LoginResponse;
import com.jiangsu.tcm.module.auth.dto.RefreshTokenRequest;
import com.jiangsu.tcm.module.auth.entity.SysAdmin;
import com.jiangsu.tcm.module.auth.entity.SysLoginLog;
import com.jiangsu.tcm.module.auth.mapper.SysAdminMapper;
import com.jiangsu.tcm.module.auth.mapper.SysAdminRoleMapper;
import com.jiangsu.tcm.module.auth.mapper.SysLoginLogMapper;
import com.jiangsu.tcm.module.auth.security.AdminPrincipal;
import com.jiangsu.tcm.module.auth.security.JwtTokenProvider;
import com.jiangsu.tcm.module.auth.service.AdminAuthService;
import com.jiangsu.tcm.module.auth.service.AuthService;
import com.jiangsu.tcm.module.auth.service.MenuService;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final SysAdminMapper sysAdminMapper;
    private final SysLoginLogMapper sysLoginLogMapper;
    private final SysAdminRoleMapper sysAdminRoleMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final JwtProperties jwtProperties;
    private final AdminAuthService adminAuthService;
    private final MenuService menuService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public LoginResponse login(LoginRequest request, HttpServletRequest httpRequest) {
        SysAdmin admin = sysAdminMapper.selectOne(
                new LambdaQueryWrapper<SysAdmin>().eq(SysAdmin::getUsername, request.getUsername()));
        if (admin == null || !passwordEncoder.matches(request.getPassword(), admin.getPasswordHash())) {
            saveLoginLog(null, request.getUsername(), false, httpRequest, "账号或密码错误");
            throw BizException.of(ErrorCode.UNAUTHORIZED, "账号或密码错误");
        }
        if (admin.getStatus() != null && admin.getStatus() != 1) {
            saveLoginLog(admin.getId(), admin.getUsername(), false, httpRequest, "账号已禁用");
            throw BizException.of(ErrorCode.UNAUTHORIZED, "账号已禁用");
        }
        admin.setLastLoginAt(LocalDateTime.now());
        admin.setLastLoginIp(httpRequest.getRemoteAddr());
        admin.setLoginFailCount(0);
        sysAdminMapper.updateById(admin);
        saveLoginLog(admin.getId(), admin.getUsername(), true, httpRequest, "登录成功");
        return buildLoginResponse(admin);
    }

    @Override
    public LoginResponse refresh(RefreshTokenRequest request) {
        Claims claims = jwtTokenProvider.parseClaims(request.getRefreshToken());
        if (!jwtTokenProvider.isRefreshToken(claims)) {
            throw BizException.of(ErrorCode.UNAUTHORIZED, "无效的刷新令牌");
        }
        Long adminId = jwtTokenProvider.getAdminId(claims);
        SysAdmin admin = sysAdminMapper.selectById(adminId);
        if (admin == null) {
            throw BizException.of(ErrorCode.UNAUTHORIZED, "账号不存在");
        }
        return buildLoginResponse(admin);
    }

    @Override
    public AdminProfileVo me(Long adminId) {
        AdminPrincipal principal = adminAuthService.loadPrincipal(adminId);
        return AdminProfileVo.builder()
                .id(principal.getAdminId())
                .username(principal.getUsername())
                .realName(principal.getRealName())
                .roles(principal.getRoleCodes().stream().sorted().toList())
                .permissions(principal.getPermissionCodes().stream().sorted().toList())
                .build();
    }

    @Override
    public void logout(Long adminId, HttpServletRequest httpRequest) {
        SysAdmin admin = sysAdminMapper.selectById(adminId);
        if (admin != null) {
            saveLoginLog(adminId, admin.getUsername(), true, httpRequest, "登出");
        }
    }

    private LoginResponse buildLoginResponse(SysAdmin admin) {
        AdminPrincipal principal = adminAuthService.loadPrincipal(admin.getId());
        String accessToken = jwtTokenProvider.createAccessToken(admin.getId(), admin.getUsername());
        String refreshToken = jwtTokenProvider.createRefreshToken(admin.getId(), admin.getUsername());
        AdminProfileVo profile = AdminProfileVo.builder()
                .id(admin.getId())
                .username(admin.getUsername())
                .realName(admin.getRealName())
                .roles(sysAdminRoleMapper.selectRoleCodesByAdminId(admin.getId()))
                .permissions(principal.getPermissionCodes().stream().sorted().toList())
                .build();
        return LoginResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .expiresIn(jwtProperties.getAccessTokenMinutes() * 60L)
                .admin(profile)
                .menus(menuService.listMenusForPermissions(principal.getPermissionCodes(), principal.isSuperAdmin()))
                .build();
    }

    private void saveLoginLog(Long adminId, String username, boolean success, HttpServletRequest request, String message) {
        SysLoginLog log = new SysLoginLog();
        log.setAdminId(adminId);
        log.setUsername(username);
        log.setSuccess(success ? 1 : 0);
        log.setIp(request.getRemoteAddr());
        log.setUserAgent(request.getHeader("User-Agent"));
        log.setMessage(message);
        sysLoginLogMapper.insert(log);
    }
}
