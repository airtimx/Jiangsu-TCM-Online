package com.jiangsu.tcm.module.auth.controller;

import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.auth.dto.PermissionTreeVo;
import com.jiangsu.tcm.module.auth.dto.RolePermissionUpdateRequest;
import com.jiangsu.tcm.module.auth.dto.RoleSaveRequest;
import com.jiangsu.tcm.module.auth.dto.RoleVo;
import com.jiangsu.tcm.module.auth.service.RoleManageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "角色权限管理", description = "模块 01 stable")
@RestController
@RequestMapping("/api/admin/v1/roles")
@RequiredArgsConstructor
public class RoleController {

    private final RoleManageService roleManageService;

    @PreAuthorize("hasAuthority('system:role:list')")
    @GetMapping
    public Result<PageResult<RoleVo>> page(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int pageSize) {
        return Result.ok(roleManageService.page(keyword, page, pageSize));
    }

    @PreAuthorize("hasAuthority('system:role:list')")
    @GetMapping("/all")
    public Result<List<RoleVo>> listAll() {
        return Result.ok(roleManageService.listAll());
    }

    @PreAuthorize("hasAuthority('system:role:list')")
    @GetMapping("/{id}")
    public Result<RoleVo> get(@PathVariable Long id) {
        return Result.ok(roleManageService.getById(id));
    }

    @PreAuthorize("hasAuthority('system:role:create')")
    @PostMapping
    public Result<Long> create(@Valid @RequestBody RoleSaveRequest request) {
        return Result.ok(roleManageService.create(request));
    }

    @PreAuthorize("hasAuthority('system:role:edit')")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody RoleSaveRequest request) {
        roleManageService.update(id, request);
        return Result.ok(null);
    }

    @PreAuthorize("hasAuthority('system:role:delete')")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        roleManageService.delete(id);
        return Result.ok(null);
    }

    @PreAuthorize("hasAuthority('system:role:edit')")
    @GetMapping("/{id}/permissions")
    public Result<List<Long>> getPermissions(@PathVariable Long id) {
        return Result.ok(roleManageService.getPermissionIds(id));
    }

    @PreAuthorize("hasAuthority('system:role:edit')")
    @PutMapping("/{id}/permissions")
    public Result<Void> updatePermissions(
            @PathVariable Long id, @RequestBody RolePermissionUpdateRequest request) {
        roleManageService.updatePermissions(id, request.getPermissionIds());
        return Result.ok(null);
    }

    @PreAuthorize("hasAuthority('system:role:list')")
    @GetMapping("/permissions/tree")
    public Result<List<PermissionTreeVo>> permissionTree() {
        return Result.ok(roleManageService.permissionTree());
    }
}
