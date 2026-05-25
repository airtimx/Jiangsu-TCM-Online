package com.jiangsu.tcm.module.auth.service;

import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.module.auth.dto.PermissionTreeVo;
import com.jiangsu.tcm.module.auth.dto.RoleSaveRequest;
import com.jiangsu.tcm.module.auth.dto.RoleVo;
import java.util.List;

public interface RoleManageService {

    PageResult<RoleVo> page(String keyword, int page, int pageSize);

    List<RoleVo> listAll();

    RoleVo getById(Long id);

    Long create(RoleSaveRequest request);

    void update(Long id, RoleSaveRequest request);

    void delete(Long id);

    List<Long> getPermissionIds(Long roleId);

    void updatePermissions(Long roleId, List<Long> permissionIds);

    List<PermissionTreeVo> permissionTree();
}
