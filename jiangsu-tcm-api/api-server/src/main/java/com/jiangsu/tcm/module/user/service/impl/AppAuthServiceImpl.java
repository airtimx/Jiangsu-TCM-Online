package com.jiangsu.tcm.module.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.jiangsu.tcm.config.JwtProperties;
import com.jiangsu.tcm.module.auth.security.JwtTokenProvider;
import com.jiangsu.tcm.module.user.dto.AppUserProfileVo;
import com.jiangsu.tcm.module.user.dto.WxLoginRequest;
import com.jiangsu.tcm.module.user.dto.WxLoginResponse;
import com.jiangsu.tcm.module.user.entity.AppUser;
import com.jiangsu.tcm.module.user.mapper.AppUserMapper;
import com.jiangsu.tcm.module.user.service.AppAuthService;
import com.jiangsu.tcm.module.user.service.AppUserProfileService;
import com.jiangsu.tcm.module.user.service.WxSessionService;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AppAuthServiceImpl implements AppAuthService {

    private final WxSessionService wxSessionService;
    private final AppUserMapper appUserMapper;
    private final JwtTokenProvider jwtTokenProvider;
    private final JwtProperties jwtProperties;
    private final AppUserProfileService appUserProfileService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public WxLoginResponse wxLogin(WxLoginRequest request) {
        WxSessionService.WxSession session = wxSessionService.resolve(request.getCode());
        AppUser user = appUserMapper.selectOne(
                new LambdaQueryWrapper<AppUser>().eq(AppUser::getOpenid, session.openid()));
        if (user == null) {
            user = new AppUser();
            user.setOpenid(session.openid());
            user.setUnionid(session.unionid());
            user.setNickname("微信用户");
            user.setUserType("VISITOR");
            user.setStatus(1);
            appUserMapper.insert(user);
        }
        user.setLastLoginAt(LocalDateTime.now());
        appUserMapper.updateById(user);
        AppUserProfileVo profile = appUserProfileService.getProfile(user.getId());
        String token = jwtTokenProvider.createAppAccessToken(user.getId(), user.getOpenid());
        return WxLoginResponse.builder()
                .accessToken(token)
                .expiresIn(jwtProperties.getAccessTokenMinutes() * 60L)
                .user(profile)
                .build();
    }
}
