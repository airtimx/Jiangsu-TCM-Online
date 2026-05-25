package com.jiangsu.tcm.module.auth.dto;

import java.util.List;
import lombok.Data;

@Data
public class RolePermissionUpdateRequest {

    private List<Long> permissionIds;
}
