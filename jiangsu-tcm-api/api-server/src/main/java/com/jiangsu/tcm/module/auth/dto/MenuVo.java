package com.jiangsu.tcm.module.auth.dto;

import java.util.List;
import lombok.Data;

@Data
public class MenuVo {

    private String path;
    private String title;
    private String icon;
    private String permission;
    private List<MenuVo> children;
}
