package com.jiangsu.tcm.module.user.service.impl;

import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.module.user.entity.AppUser;
import com.jiangsu.tcm.module.user.mapper.AppUserMapper;
import com.jiangsu.tcm.module.user.security.AppUserPrincipal;
import com.jiangsu.tcm.module.user.service.AppUserAuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AppUserAuthServiceImpl implements AppUserAuthService {

    private final AppUserMapper appUserMapper;

    @Override
    public AppUserPrincipal loadPrincipal(Long userId) {
        AppUser user = appUserMapper.selectById(userId);
        if (user == null || user.getStatus() == null || user.getStatus() != 1) {
            throw BizException.of(ErrorCode.UNAUTHORIZED, "用户不存在或已禁用");
        }
        return new AppUserPrincipal(user.getId(), user.getOpenid(), user.getNickname(), true);
    }
}
