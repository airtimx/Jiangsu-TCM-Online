package com.jiangsu.tcm.module.user.controller;

import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.auth.support.AuthContext;
import com.jiangsu.tcm.module.user.dto.AdminStudentSaveRequest;
import com.jiangsu.tcm.module.user.dto.AdminStudentVo;
import com.jiangsu.tcm.module.user.dto.StudentImportResultVo;
import com.jiangsu.tcm.module.user.service.AdminStudentManageService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
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
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "管理端学员", description = "模块 02 stable")
@RestController
@RequestMapping("/api/admin/v1/students")
@RequiredArgsConstructor
public class AdminStudentController {

    private final AdminStudentManageService adminStudentManageService;

    @PreAuthorize("hasAuthority('account:student:list')")
    @GetMapping
    public Result<PageResult<AdminStudentVo>> page(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String certStatus,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int pageSize) {
        return Result.ok(adminStudentManageService.page(keyword, certStatus, page, pageSize));
    }

    @PreAuthorize("hasAuthority('account:student:export')")
    @GetMapping("/export")
    public void exportExcel(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String certStatus,
            HttpServletResponse response) {
        adminStudentManageService.exportExcel(keyword, certStatus, response);
    }

    @PreAuthorize("hasAuthority('account:student:import')")
    @PostMapping("/import")
    public Result<StudentImportResultVo> importExcel(@RequestParam("file") MultipartFile file) {
        return Result.ok(adminStudentManageService.importExcel(file, AuthContext.requireAdminId()));
    }

    @PreAuthorize("hasAuthority('account:student:import')")
    @GetMapping("/import/{batchId}/errors")
    public void downloadErrors(@PathVariable Long batchId, HttpServletResponse response) {
        adminStudentManageService.downloadImportErrors(batchId, response);
    }

    @PreAuthorize("hasAuthority('account:student:list')")
    @GetMapping("/{id}")
    public Result<AdminStudentVo> get(@PathVariable Long id) {
        return Result.ok(adminStudentManageService.getById(id));
    }

    @PreAuthorize("hasAuthority('account:student:create')")
    @PostMapping
    public Result<Long> create(@Valid @RequestBody AdminStudentSaveRequest request) {
        return Result.ok(adminStudentManageService.create(request));
    }

    @PreAuthorize("hasAuthority('account:student:edit')")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody AdminStudentSaveRequest request) {
        adminStudentManageService.update(id, request);
        return Result.ok(null);
    }

    @PreAuthorize("hasAuthority('account:student:delete')")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        adminStudentManageService.delete(id);
        return Result.ok(null);
    }
}
