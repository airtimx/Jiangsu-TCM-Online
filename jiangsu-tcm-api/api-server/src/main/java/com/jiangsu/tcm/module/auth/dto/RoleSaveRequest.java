package com.jiangsu.tcm.module.auth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RoleSaveRequest {

    @NotBlank(message = "角色编码不能为空")
    private String code;

    @NotBlank(message = "角色名称不能为空")
    private String name;

    private String description;
    private Integer status = 1;
    private Integer sortNo = 0;
}
