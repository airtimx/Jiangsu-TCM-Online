package com.jiangsu.tcm.module.user.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class StudentCertifyRequest {

    @NotBlank(message = "姓名不能为空")
    private String realName;

    @NotBlank(message = "手机号不能为空")
    private String phone;

    @NotBlank(message = "验证码不能为空")
    private String smsCode;

    private String idCard;
    private String region;
    private String orgName;
}
