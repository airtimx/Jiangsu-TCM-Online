package com.jiangsu.tcm.module.user.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class AdminStudentVo {

    private Long id;
    private Long userId;
    private String realName;
    private String phone;
    private String idCard;
    private Integer gender;
    private String region;
    private String orgName;
    private String certStatus;
    private LocalDateTime certTime;
    private String remark;
    private LocalDateTime createdAt;
}
