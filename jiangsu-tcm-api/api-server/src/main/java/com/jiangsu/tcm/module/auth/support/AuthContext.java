package com.jiangsu.tcm.module.auth.support;

import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.module.auth.security.AdminPrincipal;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public final class AuthContext {

    private AuthContext() {
    }

    public static AdminPrincipal requirePrincipal() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof AdminPrincipal principal)) {
            throw BizException.of(ErrorCode.UNAUTHORIZED, "未登录");
        }
        return principal;
    }

    public static Long requireAdminId() {
        return requirePrincipal().getAdminId();
    }
}
