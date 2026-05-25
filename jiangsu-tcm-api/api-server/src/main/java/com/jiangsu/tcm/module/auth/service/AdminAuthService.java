package com.jiangsu.tcm.module.auth.service;

import com.jiangsu.tcm.module.auth.security.AdminPrincipal;

public interface AdminAuthService {

    AdminPrincipal loadPrincipal(Long adminId);
}
