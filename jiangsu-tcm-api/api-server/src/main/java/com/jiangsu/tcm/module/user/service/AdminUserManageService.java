package com.jiangsu.tcm.module.user.service;

import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.module.user.dto.AdminUserUpdateRequest;
import com.jiangsu.tcm.module.user.dto.AdminUserVo;

public interface AdminUserManageService {

    PageResult<AdminUserVo> page(String keyword, int page, int pageSize);

    AdminUserVo getById(Long id);

    void update(Long id, AdminUserUpdateRequest request);
}
