package com.jiangsu.tcm.module.auth.service;

import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.module.auth.dto.AdminSaveRequest;
import com.jiangsu.tcm.module.auth.dto.AdminVo;

public interface AdminManageService {

    PageResult<AdminVo> page(String keyword, int page, int pageSize);

    AdminVo getById(Long id);

    Long create(AdminSaveRequest request);

    void update(Long id, AdminSaveRequest request);

    void delete(Long id);
}
