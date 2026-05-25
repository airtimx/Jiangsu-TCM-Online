package com.jiangsu.tcm.module.auth.dto;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Data;

@Data
public class AdminVo {

    private Long id;
    private String username;
    private String realName;
    private String phone;
    private String email;
    private Integer status;
    private List<String> roleCodes;
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
}
