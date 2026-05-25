package com.jiangsu.tcm.module.auth.service.impl;

import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.module.auth.entity.SysAdmin;
import com.jiangsu.tcm.module.auth.mapper.SysAdminMapper;
import com.jiangsu.tcm.module.auth.mapper.SysAdminRoleMapper;
import com.jiangsu.tcm.module.auth.mapper.SysPermissionMapper;
import com.jiangsu.tcm.module.auth.security.AdminPrincipal;
import com.jiangsu.tcm.module.auth.service.AdminAuthService;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminAuthServiceImpl implements AdminAuthService {

    private final SysAdminMapper sysAdminMapper;
    private final SysAdminRoleMapper sysAdminRoleMapper;
    private final SysPermissionMapper sysPermissionMapper;

    @Override
    public AdminPrincipal loadPrincipal(Long adminId) {
        SysAdmin admin = sysAdminMapper.selectById(adminId);
        if (admin == null || admin.getStatus() == null || admin.getStatus() != 1) {
            throw BizException.of(ErrorCode.UNAUTHORIZED, "账号不存在或已禁用");
        }
        List<String> roleCodes = sysAdminRoleMapper.selectRoleCodesByAdminId(adminId);
        Set<String> permissions = resolvePermissions(adminId, roleCodes);
        return new AdminPrincipal(
                admin.getId(),
                admin.getUsername(),
                admin.getRealName(),
                new HashSet<>(roleCodes),
                permissions,
                true);
    }

    private Set<String> resolvePermissions(Long adminId, List<String> roleCodes) {
        if (roleCodes.contains("super_admin") || sysPermissionMapper.countSuperAdminRole(adminId) > 0) {
            return new HashSet<>(sysPermissionMapper.selectList(null).stream()
                    .map(p -> p.getCode())
                    .toList());
        }
        return new HashSet<>(sysPermissionMapper.selectCodesByAdminId(adminId));
    }
}
