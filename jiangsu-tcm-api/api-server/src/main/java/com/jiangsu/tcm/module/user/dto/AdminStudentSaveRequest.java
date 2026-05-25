package com.jiangsu.tcm.module.user.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AdminStudentSaveRequest {

    private Long userId;

    @NotBlank(message = "姓名不能为空")
    private String realName;

    private String phone;
    private String idCard;
    private Integer gender;
    private String region;
    private String orgName;
    private String certStatus;
    private String remark;
}
