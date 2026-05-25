package com.jiangsu.tcm.module.auth.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import java.util.List;
import lombok.Data;

@Data
public class AdminSaveRequest {

    @NotBlank(message = "账号不能为空")
    private String username;

    private String password;

    private String realName;
    private String phone;
    private String email;
    private Integer status = 1;

    @NotEmpty(message = "至少分配一个角色")
    private List<Long> roleIds;
}
