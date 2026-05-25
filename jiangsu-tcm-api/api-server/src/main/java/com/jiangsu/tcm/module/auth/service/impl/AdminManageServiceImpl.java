package com.jiangsu.tcm.module.auth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.module.auth.dto.AdminSaveRequest;
import com.jiangsu.tcm.module.auth.dto.AdminVo;
import com.jiangsu.tcm.module.auth.entity.SysAdmin;
import com.jiangsu.tcm.module.auth.mapper.SysAdminMapper;
import com.jiangsu.tcm.module.auth.mapper.SysAdminRoleMapper;
import com.jiangsu.tcm.module.auth.service.AdminManageService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class AdminManageServiceImpl implements AdminManageService {

    private final SysAdminMapper sysAdminMapper;
    private final SysAdminRoleMapper sysAdminRoleMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public PageResult<AdminVo> page(String keyword, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.min(Math.max(pageSize, 1), 100);
        LambdaQueryWrapper<SysAdmin> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(SysAdmin::getUsername, keyword).or().like(SysAdmin::getRealName, keyword));
        }
        wrapper.orderByDesc(SysAdmin::getId);
        Page<SysAdmin> result = sysAdminMapper.selectPage(new Page<>(safePage, safeSize), wrapper);
        List<AdminVo> list = result.getRecords().stream().map(this::toVo).toList();
        return PageResult.of(list, result.getTotal(), safePage, safeSize);
    }

    @Override
    public AdminVo getById(Long id) {
        SysAdmin admin = requireAdmin(id);
        return toVo(admin);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(AdminSaveRequest request) {
        if (!StringUtils.hasText(request.getPassword())) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "创建管理员必须设置密码");
        }
        Long exists = sysAdminMapper.selectCount(
                new LambdaQueryWrapper<SysAdmin>().eq(SysAdmin::getUsername, request.getUsername()));
        if (exists != null && exists > 0) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "账号已存在");
        }
        SysAdmin admin = new SysAdmin();
        fillAdmin(admin, request);
        admin.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        sysAdminMapper.insert(admin);
        bindRoles(admin.getId(), request.getRoleIds());
        return admin.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Long id, AdminSaveRequest request) {
        SysAdmin admin = requireAdmin(id);
        if (!admin.getUsername().equals(request.getUsername())) {
            Long exists = sysAdminMapper.selectCount(
                    new LambdaQueryWrapper<SysAdmin>().eq(SysAdmin::getUsername, request.getUsername()));
            if (exists != null && exists > 0) {
                throw BizException.of(ErrorCode.PARAM_INVALID, "账号已存在");
            }
        }
        fillAdmin(admin, request);
        if (StringUtils.hasText(request.getPassword())) {
            admin.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        }
        sysAdminMapper.updateById(admin);
        sysAdminRoleMapper.deleteByAdminId(id);
        bindRoles(id, request.getRoleIds());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        requireAdmin(id);
        sysAdminRoleMapper.deleteByAdminId(id);
        sysAdminMapper.deleteById(id);
    }

    private void bindRoles(Long adminId, List<Long> roleIds) {
        for (Long roleId : roleIds) {
            sysAdminRoleMapper.insert(adminId, roleId);
        }
    }

    private void fillAdmin(SysAdmin admin, AdminSaveRequest request) {
        admin.setUsername(request.getUsername());
        admin.setRealName(request.getRealName());
        admin.setPhone(request.getPhone());
        admin.setEmail(request.getEmail());
        admin.setStatus(request.getStatus() == null ? 1 : request.getStatus());
    }

    private SysAdmin requireAdmin(Long id) {
        SysAdmin admin = sysAdminMapper.selectById(id);
        if (admin == null) {
            throw BizException.of(ErrorCode.NOT_FOUND, "管理员不存在");
        }
        return admin;
    }

    private AdminVo toVo(SysAdmin admin) {
        AdminVo vo = new AdminVo();
        vo.setId(admin.getId());
        vo.setUsername(admin.getUsername());
        vo.setRealName(admin.getRealName());
        vo.setPhone(admin.getPhone());
        vo.setEmail(admin.getEmail());
        vo.setStatus(admin.getStatus());
        vo.setRoleCodes(sysAdminRoleMapper.selectRoleCodesByAdminId(admin.getId()));
        vo.setLastLoginAt(admin.getLastLoginAt());
        vo.setCreatedAt(admin.getCreatedAt());
        return vo;
    }
}
