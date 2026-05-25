package com.jiangsu.tcm.module.auth.dto;

import java.util.List;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AdminProfileVo {

    private Long id;
    private String username;
    private String realName;
    private List<String> roles;
    private List<String> permissions;
}
