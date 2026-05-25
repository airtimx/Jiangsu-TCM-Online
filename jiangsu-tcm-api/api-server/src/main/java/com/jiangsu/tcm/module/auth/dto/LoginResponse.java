package com.jiangsu.tcm.module.auth.dto;

import java.util.List;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class LoginResponse {

    private String accessToken;
    private String refreshToken;
    private long expiresIn;
    private AdminProfileVo admin;
    private List<MenuVo> menus;
}
