package com.jiangsu.tcm.module.user.controller;

import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.user.dto.AdminUserUpdateRequest;
import com.jiangsu.tcm.module.user.dto.AdminUserVo;
import com.jiangsu.tcm.module.user.service.AdminUserManageService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "管理端用户")
@RestController
@RequestMapping("/api/admin/v1/users")
@RequiredArgsConstructor
public class AdminUserController {

    private final AdminUserManageService adminUserManageService;

    @PreAuthorize("hasAuthority('account:user:list')")
    @GetMapping
    public Result<PageResult<AdminUserVo>> page(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int pageSize) {
        return Result.ok(adminUserManageService.page(keyword, page, pageSize));
    }

    @PreAuthorize("hasAuthority('account:user:list')")
    @GetMapping("/{id}")
    public Result<AdminUserVo> get(@PathVariable Long id) {
        return Result.ok(adminUserManageService.getById(id));
    }

    @PreAuthorize("hasAuthority('account:user:edit')")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody AdminUserUpdateRequest request) {
        adminUserManageService.update(id, request);
        return Result.ok(null);
    }
}
