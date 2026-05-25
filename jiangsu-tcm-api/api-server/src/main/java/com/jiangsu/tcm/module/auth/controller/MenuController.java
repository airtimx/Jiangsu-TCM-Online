package com.jiangsu.tcm.module.auth.controller;

import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.auth.dto.MenuVo;
import com.jiangsu.tcm.module.auth.security.AdminPrincipal;
import com.jiangsu.tcm.module.auth.service.MenuService;
import com.jiangsu.tcm.module.auth.support.AuthContext;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "管理端菜单", description = "模块 01 stable")
@RestController
@RequestMapping("/api/admin/v1/menus")
@RequiredArgsConstructor
public class MenuController {

    private final MenuService menuService;

    @Operation(summary = "当前用户菜单树")
    @GetMapping
    public Result<List<MenuVo>> menus() {
        AdminPrincipal principal = AuthContext.requirePrincipal();
        return Result.ok(menuService.listMenusForPermissions(principal.getPermissionCodes(), principal.isSuperAdmin()));
    }
}
