package com.jiangsu.tcm.module.user.service;

import com.jiangsu.tcm.module.user.dto.AppUserProfileVo;
import com.jiangsu.tcm.module.user.dto.StudentCertifyRequest;

public interface AppUserProfileService {

    AppUserProfileVo getProfile(Long userId);

    AppUserProfileVo certify(Long userId, StudentCertifyRequest request);
}
