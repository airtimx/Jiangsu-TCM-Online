package com.jiangsu.tcm.module.auth.dto;

import java.util.ArrayList;
import java.util.List;
import lombok.Data;

@Data
public class PermissionTreeVo {

    private Long id;
    private String code;
    private String name;
    private String module;
    private Long parentId;
    private List<PermissionTreeVo> children = new ArrayList<>();
}
