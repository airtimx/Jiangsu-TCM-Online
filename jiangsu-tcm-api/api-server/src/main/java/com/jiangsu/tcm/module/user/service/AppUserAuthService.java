package com.jiangsu.tcm.module.user.service;

import com.jiangsu.tcm.module.user.security.AppUserPrincipal;

public interface AppUserAuthService {

    AppUserPrincipal loadPrincipal(Long userId);
}
