package com.jiangsu.tcm.module.user.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AppUserProfileVo {

    private Long id;
    private String openid;
    private String nickname;
    private String avatarUrl;
    private String phone;
    private String userType;
    private StudentBriefVo student;
}
