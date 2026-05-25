package com.jiangsu.tcm.module.user.service;

import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.module.user.dto.AdminStudentSaveRequest;
import com.jiangsu.tcm.module.user.dto.AdminStudentVo;
import com.jiangsu.tcm.module.user.dto.StudentImportResultVo;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;

public interface AdminStudentManageService {

    PageResult<AdminStudentVo> page(String keyword, String certStatus, int page, int pageSize);

    AdminStudentVo getById(Long id);

    Long create(AdminStudentSaveRequest request);

    void update(Long id, AdminStudentSaveRequest request);

    void delete(Long id);

    StudentImportResultVo importExcel(MultipartFile file, Long operatorId);

    void exportExcel(String keyword, String certStatus, HttpServletResponse response);

    void downloadImportErrors(Long batchId, HttpServletResponse response);
}
