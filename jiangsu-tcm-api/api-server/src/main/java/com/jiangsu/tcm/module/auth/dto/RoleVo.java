package com.jiangsu.tcm.module.auth.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class RoleVo {

    private Long id;
    private String code;
    private String name;
    private String description;
    private Integer status;
    private Integer sortNo;
    private LocalDateTime createdAt;
}
