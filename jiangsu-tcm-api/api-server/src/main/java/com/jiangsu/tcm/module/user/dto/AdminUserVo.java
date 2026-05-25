package com.jiangsu.tcm.module.user.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class AdminUserVo {

    private Long id;
    private String openid;
    private String nickname;
    private String phone;
    private String userType;
    private Integer status;
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
}
