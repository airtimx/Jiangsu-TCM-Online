package com.jiangsu.tcm.module.user.support;

import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.module.user.security.AppUserPrincipal;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public final class AppContext {

    private AppContext() {
    }

    public static AppUserPrincipal requirePrincipal() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof AppUserPrincipal principal)) {
            throw BizException.of(ErrorCode.UNAUTHORIZED, "未登录");
        }
        return principal;
    }

    public static Long requireUserId() {
        return requirePrincipal().getUserId();
    }
}
