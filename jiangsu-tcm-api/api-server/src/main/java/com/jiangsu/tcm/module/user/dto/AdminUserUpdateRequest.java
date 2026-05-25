package com.jiangsu.tcm.module.user.dto;

import lombok.Data;

@Data
public class AdminUserUpdateRequest {

    private String nickname;
    private String phone;
    private Integer status;
}
