package com.jiangsu.tcm.module.user.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class WxLoginResponse {

    private String accessToken;
    private long expiresIn;
    private AppUserProfileVo user;
}
