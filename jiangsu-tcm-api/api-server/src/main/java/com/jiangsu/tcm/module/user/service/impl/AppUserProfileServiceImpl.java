package com.jiangsu.tcm.module.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.jiangsu.tcm.common.constant.CertStatus;
import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.module.user.dto.AppUserProfileVo;
import com.jiangsu.tcm.module.user.dto.StudentBriefVo;
import com.jiangsu.tcm.module.user.dto.StudentCertifyRequest;
import com.jiangsu.tcm.module.user.entity.AppUser;
import com.jiangsu.tcm.module.user.entity.Student;
import com.jiangsu.tcm.module.user.mapper.AppUserMapper;
import com.jiangsu.tcm.module.user.mapper.StudentMapper;
import com.jiangsu.tcm.module.user.service.AppUserProfileService;
import com.jiangsu.tcm.module.user.service.SmsService;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AppUserProfileServiceImpl implements AppUserProfileService {

    private final AppUserMapper appUserMapper;
    private final StudentMapper studentMapper;
    private final SmsService smsService;

    @Override
    public AppUserProfileVo getProfile(Long userId) {
        AppUser user = requireUser(userId);
        return toProfile(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AppUserProfileVo certify(Long userId, StudentCertifyRequest request) {
        if (!smsService.verifyCode(request.getPhone(), request.getSmsCode())) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "短信验证码错误");
        }
        AppUser user = requireUser(userId);
        user.setPhone(request.getPhone());
        appUserMapper.updateById(user);

        Student student = studentMapper.selectOne(new LambdaQueryWrapper<Student>().eq(Student::getUserId, userId));
        if (student == null) {
            student = new Student();
            student.setUserId(userId);
            student.setCertStatus(CertStatus.UNVERIFIED.name());
        }
        student.setRealName(request.getRealName());
        student.setIdCard(request.getIdCard());
        student.setRegion(request.getRegion());
        student.setOrgName(request.getOrgName());
        student.setCertStatus(CertStatus.CERTIFIED.name());
        student.setCertTime(LocalDateTime.now());
        if (student.getId() == null) {
            studentMapper.insert(student);
        } else {
            studentMapper.updateById(student);
        }
        user.setUserType("CERTIFIED");
        appUserMapper.updateById(user);
        return toProfile(user);
    }

    private AppUser requireUser(Long userId) {
        AppUser user = appUserMapper.selectById(userId);
        if (user == null) {
            throw BizException.of(ErrorCode.NOT_FOUND, "用户不存在");
        }
        return user;
    }

    private AppUserProfileVo toProfile(AppUser user) {
        Student student = studentMapper.selectOne(new LambdaQueryWrapper<Student>().eq(Student::getUserId, user.getId()));
        StudentBriefVo brief = null;
        if (student != null) {
            brief = new StudentBriefVo();
            brief.setId(student.getId());
            brief.setRealName(student.getRealName());
            brief.setCertStatus(student.getCertStatus());
            brief.setRegion(student.getRegion());
            brief.setOrgName(student.getOrgName());
        }
        return AppUserProfileVo.builder()
                .id(user.getId())
                .openid(user.getOpenid())
                .nickname(user.getNickname())
                .avatarUrl(user.getAvatarUrl())
                .phone(user.getPhone())
                .userType(user.getUserType())
                .student(brief)
                .build();
    }
}
