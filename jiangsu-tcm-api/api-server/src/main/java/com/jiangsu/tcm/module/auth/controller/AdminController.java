package com.jiangsu.tcm.module.auth.controller;

import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.auth.dto.AdminSaveRequest;
import com.jiangsu.tcm.module.auth.dto.AdminVo;
import com.jiangsu.tcm.module.auth.service.AdminManageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
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

@Tag(name = "管理员管理")
@RestController
@RequestMapping("/api/admin/v1/admins")
@RequiredArgsConstructor
public class AdminController {

    private final AdminManageService adminManageService;

    @PreAuthorize("hasAuthority('system:admin:list')")
    @GetMapping
    public Result<PageResult<AdminVo>> page(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int pageSize) {
        return Result.ok(adminManageService.page(keyword, page, pageSize));
    }

    @PreAuthorize("hasAuthority('system:admin:list')")
    @GetMapping("/{id}")
    public Result<AdminVo> get(@PathVariable Long id) {
        return Result.ok(adminManageService.getById(id));
    }

    @PreAuthorize("hasAuthority('system:admin:create')")
    @PostMapping
    public Result<Long> create(@Valid @RequestBody AdminSaveRequest request) {
        return Result.ok(adminManageService.create(request));
    }

    @PreAuthorize("hasAuthority('system:admin:edit')")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody AdminSaveRequest request) {
        adminManageService.update(id, request);
        return Result.ok(null);
    }

    @PreAuthorize("hasAuthority('system:admin:delete')")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        adminManageService.delete(id);
        return Result.ok(null);
    }
}
