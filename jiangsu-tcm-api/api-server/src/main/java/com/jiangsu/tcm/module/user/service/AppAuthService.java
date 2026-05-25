package com.jiangsu.tcm.module.user.service;

import com.jiangsu.tcm.module.user.dto.WxLoginRequest;
import com.jiangsu.tcm.module.user.dto.WxLoginResponse;

public interface AppAuthService {

    WxLoginResponse wxLogin(WxLoginRequest request);
}
