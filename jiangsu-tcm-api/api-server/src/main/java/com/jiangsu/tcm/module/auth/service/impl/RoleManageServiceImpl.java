package com.jiangsu.tcm.module.auth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.module.auth.dto.PermissionTreeVo;
import com.jiangsu.tcm.module.auth.dto.RoleSaveRequest;
import com.jiangsu.tcm.module.auth.dto.RoleVo;
import com.jiangsu.tcm.module.auth.entity.SysPermission;
import com.jiangsu.tcm.module.auth.entity.SysRole;
import com.jiangsu.tcm.module.auth.mapper.SysPermissionMapper;
import com.jiangsu.tcm.module.auth.mapper.SysRoleMapper;
import com.jiangsu.tcm.module.auth.mapper.SysRolePermissionMapper;
import com.jiangsu.tcm.module.auth.service.RoleManageService;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class RoleManageServiceImpl implements RoleManageService {

    private final SysRoleMapper sysRoleMapper;
    private final SysPermissionMapper sysPermissionMapper;
    private final SysRolePermissionMapper sysRolePermissionMapper;
    private final JdbcTemplate jdbcTemplate;

    @Override
    public PageResult<RoleVo> page(String keyword, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.min(Math.max(pageSize, 1), 100);
        LambdaQueryWrapper<SysRole> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(SysRole::getCode, keyword).or().like(SysRole::getName, keyword));
        }
        wrapper.orderByAsc(SysRole::getSortNo).orderByAsc(SysRole::getId);
        Page<SysRole> result = sysRoleMapper.selectPage(new Page<>(safePage, safeSize), wrapper);
        List<RoleVo> list = result.getRecords().stream().map(this::toVo).toList();
        return PageResult.of(list, result.getTotal(), safePage, safeSize);
    }

    @Override
    public List<RoleVo> listAll() {
        return sysRoleMapper.selectList(new LambdaQueryWrapper<SysRole>()
                        .eq(SysRole::getStatus, 1)
                        .orderByAsc(SysRole::getSortNo))
                .stream()
                .map(this::toVo)
                .toList();
    }

    @Override
    public RoleVo getById(Long id) {
        return toVo(requireRole(id));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(RoleSaveRequest request) {
        ensureCodeUnique(request.getCode(), null);
        SysRole role = new SysRole();
        fillRole(role, request);
        sysRoleMapper.insert(role);
        return role.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Long id, RoleSaveRequest request) {
        SysRole role = requireRole(id);
        ensureCodeUnique(request.getCode(), id);
        fillRole(role, request);
        sysRoleMapper.updateById(role);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        SysRole role = requireRole(id);
        if ("super_admin".equals(role.getCode())) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "不能删除 super_admin 角色");
        }
        sysRolePermissionMapper.deleteByRoleId(id);
        sysRoleMapper.deleteById(id);
    }

    @Override
    public List<Long> getPermissionIds(Long roleId) {
        requireRole(roleId);
        return jdbcTemplate.queryForList(
                        "SELECT permission_id FROM sys_role_permission WHERE role_id = ? ORDER BY permission_id",
                        Long.class,
                        roleId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePermissions(Long roleId, List<Long> permissionIds) {
        requireRole(roleId);
        sysRolePermissionMapper.deleteByRoleId(roleId);
        if (permissionIds == null) {
            return;
        }
        for (Long permissionId : permissionIds) {
            SysPermission permission = sysPermissionMapper.selectById(permissionId);
            if (permission == null) {
                throw BizException.of(ErrorCode.NOT_FOUND, "权限不存在: " + permissionId);
            }
            sysRolePermissionMapper.insert(roleId, permissionId);
        }
    }

    @Override
    public List<PermissionTreeVo> permissionTree() {
        List<SysPermission> all = sysPermissionMapper.selectList(
                new LambdaQueryWrapper<SysPermission>().orderByAsc(SysPermission::getSortNo));
        Map<Long, PermissionTreeVo> index = new HashMap<>();
        List<PermissionTreeVo> roots = new ArrayList<>();
        for (SysPermission permission : all) {
            PermissionTreeVo node = new PermissionTreeVo();
            node.setId(permission.getId());
            node.setCode(permission.getCode());
            node.setName(permission.getName());
            node.setModule(permission.getModule());
            node.setParentId(permission.getParentId());
            index.put(permission.getId(), node);
        }
        for (SysPermission permission : all) {
            PermissionTreeVo node = index.get(permission.getId());
            if (permission.getParentId() == null) {
                roots.add(node);
            } else {
                PermissionTreeVo parent = index.get(permission.getParentId());
                if (parent != null) {
                    parent.getChildren().add(node);
                } else {
                    roots.add(node);
                }
            }
        }
        return roots;
    }

    private void ensureCodeUnique(String code, Long excludeId) {
        LambdaQueryWrapper<SysRole> wrapper = new LambdaQueryWrapper<SysRole>().eq(SysRole::getCode, code);
        if (excludeId != null) {
            wrapper.ne(SysRole::getId, excludeId);
        }
        Long count = sysRoleMapper.selectCount(wrapper);
        if (count != null && count > 0) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "角色编码已存在");
        }
    }

    private SysRole requireRole(Long id) {
        SysRole role = sysRoleMapper.selectById(id);
        if (role == null) {
            throw BizException.of(ErrorCode.NOT_FOUND, "角色不存在");
        }
        return role;
    }

    private void fillRole(SysRole role, RoleSaveRequest request) {
        role.setCode(request.getCode());
        role.setName(request.getName());
        role.setDescription(request.getDescription());
        role.setStatus(request.getStatus() == null ? 1 : request.getStatus());
        role.setSortNo(request.getSortNo() == null ? 0 : request.getSortNo());
    }

    private RoleVo toVo(SysRole role) {
        RoleVo vo = new RoleVo();
        vo.setId(role.getId());
        vo.setCode(role.getCode());
        vo.setName(role.getName());
        vo.setDescription(role.getDescription());
        vo.setStatus(role.getStatus());
        vo.setSortNo(role.getSortNo());
        vo.setCreatedAt(role.getCreatedAt());
        return vo;
    }
}
