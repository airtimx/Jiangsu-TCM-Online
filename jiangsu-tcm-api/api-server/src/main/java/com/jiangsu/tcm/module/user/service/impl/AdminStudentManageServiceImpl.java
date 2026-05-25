package com.jiangsu.tcm.module.user.service.impl;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.read.listener.ReadListener;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.jiangsu.tcm.common.constant.CertStatus;
import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.module.user.dto.AdminStudentSaveRequest;
import com.jiangsu.tcm.module.user.dto.AdminStudentVo;
import com.jiangsu.tcm.module.user.dto.StudentExcelRow;
import com.jiangsu.tcm.module.user.dto.StudentImportResultVo;
import com.jiangsu.tcm.module.user.entity.AppUser;
import com.jiangsu.tcm.module.user.entity.Student;
import com.jiangsu.tcm.module.user.entity.StudentImportBatch;
import com.jiangsu.tcm.module.user.mapper.AppUserMapper;
import com.jiangsu.tcm.module.user.mapper.StudentImportBatchMapper;
import com.jiangsu.tcm.module.user.mapper.StudentMapper;
import com.jiangsu.tcm.module.user.service.AdminStudentManageService;
import com.jiangsu.tcm.module.user.support.ImportErrorFileStore;
import jakarta.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class AdminStudentManageServiceImpl implements AdminStudentManageService {

    private final StudentMapper studentMapper;
    private final AppUserMapper appUserMapper;
    private final StudentImportBatchMapper importBatchMapper;
    private final ImportErrorFileStore importErrorFileStore;

    @Override
    public PageResult<AdminStudentVo> page(String keyword, String certStatus, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.min(Math.max(pageSize, 1), 100);
        LambdaQueryWrapper<Student> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(Student::getRealName, keyword)
                    .or()
                    .like(Student::getRegion, keyword)
                    .or()
                    .like(Student::getOrgName, keyword));
        }
        if (StringUtils.hasText(certStatus)) {
            wrapper.eq(Student::getCertStatus, certStatus);
        }
        wrapper.orderByDesc(Student::getId);
        Page<Student> result = studentMapper.selectPage(new Page<>(safePage, safeSize), wrapper);
        List<AdminStudentVo> list = result.getRecords().stream().map(this::toVo).toList();
        return PageResult.of(list, result.getTotal(), safePage, safeSize);
    }

    @Override
    public AdminStudentVo getById(Long id) {
        return toVo(requireStudent(id));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(AdminStudentSaveRequest request) {
        Long userId = resolveUserId(request);
        Long exists = studentMapper.selectCount(new LambdaQueryWrapper<Student>().eq(Student::getUserId, userId));
        if (exists != null && exists > 0) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "该用户已绑定学员");
        }
        Student student = buildStudent(request, userId);
        studentMapper.insert(student);
        syncUserCertified(userId);
        return student.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Long id, AdminStudentSaveRequest request) {
        Student student = requireStudent(id);
        student.setRealName(request.getRealName());
        student.setIdCard(request.getIdCard());
        student.setGender(request.getGender());
        student.setRegion(request.getRegion());
        student.setOrgName(request.getOrgName());
        if (StringUtils.hasText(request.getCertStatus())) {
            student.setCertStatus(request.getCertStatus());
            if (CertStatus.CERTIFIED.name().equals(request.getCertStatus())) {
                student.setCertTime(LocalDateTime.now());
            }
        }
        student.setRemark(request.getRemark());
        studentMapper.updateById(student);
        if (StringUtils.hasText(request.getPhone())) {
            AppUser user = appUserMapper.selectById(student.getUserId());
            if (user != null) {
                user.setPhone(request.getPhone());
                appUserMapper.updateById(user);
            }
        }
        syncUserCertified(student.getUserId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        Student student = requireStudent(id);
        studentMapper.deleteById(id);
        AppUser user = appUserMapper.selectById(student.getUserId());
        if (user != null) {
            user.setUserType("VISITOR");
            appUserMapper.updateById(user);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public StudentImportResultVo importExcel(MultipartFile file, Long operatorId) {
        if (file == null || file.isEmpty()) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "请上传 Excel 文件");
        }
        StudentImportBatch batch = new StudentImportBatch();
        batch.setFileName(file.getOriginalFilename());
        batch.setStatus("PROCESSING");
        batch.setCreatedBy(operatorId);
        importBatchMapper.insert(batch);

        List<StudentExcelRow> rows = new ArrayList<>();
        List<StudentExcelRow> errorRows = new ArrayList<>();
        try {
            EasyExcel.read(file.getInputStream(), StudentExcelRow.class, new ReadListener<StudentExcelRow>() {
                @Override
                public void invoke(StudentExcelRow data, AnalysisContext context) {
                    rows.add(data);
                }

                @Override
                public void doAfterAllAnalysed(AnalysisContext context) {
                }
            }).sheet().doRead();
        } catch (IOException ex) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "Excel 解析失败");
        }

        int success = 0;
        for (StudentExcelRow row : rows) {
            try {
                validateImportRow(row);
                importOneRow(row);
                success++;
            } catch (Exception ex) {
                row.setErrorMessage(ex.getMessage());
                errorRows.add(row);
            }
        }

        batch.setTotalCount(rows.size());
        batch.setSuccessCount(success);
        batch.setFailCount(errorRows.size());
        batch.setStatus("DONE");
        batch.setFinishedAt(LocalDateTime.now());
        String errorPath = null;
        if (!errorRows.isEmpty()) {
            byte[] bytes = writeErrorExcel(errorRows);
            importErrorFileStore.put(batch.getId(), bytes);
            errorPath = "/api/admin/v1/students/import/" + batch.getId() + "/errors";
            batch.setErrorFileKey(errorPath);
        }
        importBatchMapper.updateById(batch);

        return StudentImportResultVo.builder()
                .batchId(batch.getId())
                .totalCount(rows.size())
                .successCount(success)
                .failCount(errorRows.size())
                .errorDownloadPath(errorPath)
                .build();
    }

    @Override
    public void exportExcel(String keyword, String certStatus, HttpServletResponse response) {
        PageResult<AdminStudentVo> page = page(keyword, certStatus, 1, 10000);
        List<StudentExcelRow> rows = page.getList().stream().map(vo -> {
            StudentExcelRow row = new StudentExcelRow();
            row.setRealName(vo.getRealName());
            row.setPhone(vo.getPhone());
            row.setIdCard(vo.getIdCard());
            row.setRegion(vo.getRegion());
            row.setOrgName(vo.getOrgName());
            row.setCertStatus(vo.getCertStatus());
            return row;
        }).toList();
        writeExcelResponse(response, "students.xlsx", rows);
    }

    @Override
    public void downloadImportErrors(Long batchId, HttpServletResponse response) {
        byte[] bytes = importErrorFileStore.get(batchId);
        if (bytes == null) {
            throw BizException.of(ErrorCode.NOT_FOUND, "错误报告不存在或已过期");
        }
        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=" + URLEncoder.encode("import-errors-" + batchId + ".xlsx", StandardCharsets.UTF_8));
            response.getOutputStream().write(bytes);
            response.getOutputStream().flush();
        } catch (IOException ex) {
            throw BizException.of(ErrorCode.SYSTEM_ERROR, "下载失败");
        }
    }

    private void importOneRow(StudentExcelRow row) {
        String openid = "import_" + row.getPhone();
        AppUser user = appUserMapper.selectOne(new LambdaQueryWrapper<AppUser>().eq(AppUser::getOpenid, openid));
        if (user == null) {
            user = new AppUser();
            user.setOpenid(openid);
            user.setNickname(row.getRealName());
            user.setPhone(row.getPhone());
            user.setUserType("CERTIFIED");
            user.setStatus(1);
            appUserMapper.insert(user);
        } else {
            user.setPhone(row.getPhone());
            user.setNickname(row.getRealName());
            user.setUserType("CERTIFIED");
            appUserMapper.updateById(user);
        }
        Student student = studentMapper.selectOne(new LambdaQueryWrapper<Student>().eq(Student::getUserId, user.getId()));
        if (student == null) {
            student = new Student();
            student.setUserId(user.getId());
        }
        student.setRealName(row.getRealName());
        student.setIdCard(row.getIdCard());
        student.setRegion(row.getRegion());
        student.setOrgName(row.getOrgName());
        student.setCertStatus(StringUtils.hasText(row.getCertStatus()) ? row.getCertStatus() : CertStatus.CERTIFIED.name());
        student.setCertTime(LocalDateTime.now());
        if (student.getId() == null) {
            studentMapper.insert(student);
        } else {
            studentMapper.updateById(student);
        }
    }

    private void validateImportRow(StudentExcelRow row) {
        if (!StringUtils.hasText(row.getRealName())) {
            throw new IllegalArgumentException("姓名不能为空");
        }
        if (!StringUtils.hasText(row.getPhone())) {
            throw new IllegalArgumentException("手机号不能为空");
        }
    }

    private Long resolveUserId(AdminStudentSaveRequest request) {
        if (request.getUserId() != null) {
            AppUser user = appUserMapper.selectById(request.getUserId());
            if (user == null) {
                throw BizException.of(ErrorCode.NOT_FOUND, "用户不存在");
            }
            return user.getId();
        }
        if (!StringUtils.hasText(request.getPhone())) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "请指定 userId 或 phone");
        }
        String openid = "admin_" + UUID.randomUUID();
        AppUser user = new AppUser();
        user.setOpenid(openid);
        user.setPhone(request.getPhone());
        user.setNickname(request.getRealName());
        user.setUserType("VISITOR");
        user.setStatus(1);
        appUserMapper.insert(user);
        return user.getId();
    }

    private Student buildStudent(AdminStudentSaveRequest request, Long userId) {
        Student student = new Student();
        student.setUserId(userId);
        student.setRealName(request.getRealName());
        student.setIdCard(request.getIdCard());
        student.setGender(request.getGender());
        student.setRegion(request.getRegion());
        student.setOrgName(request.getOrgName());
        student.setCertStatus(StringUtils.hasText(request.getCertStatus())
                ? request.getCertStatus()
                : CertStatus.CERTIFIED.name());
        student.setCertTime(LocalDateTime.now());
        student.setRemark(request.getRemark());
        return student;
    }

    private void syncUserCertified(Long userId) {
        Student student = studentMapper.selectOne(new LambdaQueryWrapper<Student>().eq(Student::getUserId, userId));
        AppUser user = appUserMapper.selectById(userId);
        if (user == null || student == null) {
            return;
        }
        if (CertStatus.CERTIFIED.name().equals(student.getCertStatus())) {
            user.setUserType("CERTIFIED");
        } else {
            user.setUserType("VISITOR");
        }
        appUserMapper.updateById(user);
    }

    private Student requireStudent(Long id) {
        Student student = studentMapper.selectById(id);
        if (student == null) {
            throw BizException.of(ErrorCode.NOT_FOUND, "学员不存在");
        }
        return student;
    }

    private AdminStudentVo toVo(Student student) {
        AdminStudentVo vo = new AdminStudentVo();
        vo.setId(student.getId());
        vo.setUserId(student.getUserId());
        vo.setRealName(student.getRealName());
        vo.setIdCard(student.getIdCard());
        vo.setGender(student.getGender());
        vo.setRegion(student.getRegion());
        vo.setOrgName(student.getOrgName());
        vo.setCertStatus(student.getCertStatus());
        vo.setCertTime(student.getCertTime());
        vo.setRemark(student.getRemark());
        vo.setCreatedAt(student.getCreatedAt());
        AppUser user = appUserMapper.selectById(student.getUserId());
        if (user != null) {
            vo.setPhone(user.getPhone());
        }
        return vo;
    }

    private byte[] writeErrorExcel(List<StudentExcelRow> errorRows) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        EasyExcel.write(out, StudentExcelRow.class).sheet("errors").doWrite(errorRows);
        return out.toByteArray();
    }

    private void writeExcelResponse(HttpServletResponse response, String filename, List<StudentExcelRow> rows) {
        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=" + URLEncoder.encode(filename, StandardCharsets.UTF_8));
            EasyExcel.write(response.getOutputStream(), StudentExcelRow.class).sheet("students").doWrite(rows);
            response.getOutputStream().flush();
        } catch (IOException ex) {
            throw BizException.of(ErrorCode.SYSTEM_ERROR, "导出失败");
        }
    }
}
