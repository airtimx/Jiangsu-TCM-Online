package com.jiangsu.tcm.module.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.common.result.PageResult;
import com.jiangsu.tcm.module.user.dto.AdminUserUpdateRequest;
import com.jiangsu.tcm.module.user.dto.AdminUserVo;
import com.jiangsu.tcm.module.user.entity.AppUser;
import com.jiangsu.tcm.module.user.mapper.AppUserMapper;
import com.jiangsu.tcm.module.user.service.AdminUserManageService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class AdminUserManageServiceImpl implements AdminUserManageService {

    private final AppUserMapper appUserMapper;

    @Override
    public PageResult<AdminUserVo> page(String keyword, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.min(Math.max(pageSize, 1), 100);
        LambdaQueryWrapper<AppUser> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(AppUser::getNickname, keyword)
                    .or()
                    .like(AppUser::getPhone, keyword)
                    .or()
                    .like(AppUser::getOpenid, keyword));
        }
        wrapper.orderByDesc(AppUser::getId);
        Page<AppUser> result = appUserMapper.selectPage(new Page<>(safePage, safeSize), wrapper);
        List<AdminUserVo> list = result.getRecords().stream().map(this::toVo).toList();
        return PageResult.of(list, result.getTotal(), safePage, safeSize);
    }

    @Override
    public AdminUserVo getById(Long id) {
        return toVo(requireUser(id));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Long id, AdminUserUpdateRequest request) {
        AppUser user = requireUser(id);
        if (request.getNickname() != null) {
            user.setNickname(request.getNickname());
        }
        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
        }
        if (request.getStatus() != null) {
            user.setStatus(request.getStatus());
        }
        appUserMapper.updateById(user);
    }

    private AppUser requireUser(Long id) {
        AppUser user = appUserMapper.selectById(id);
        if (user == null) {
            throw BizException.of(ErrorCode.NOT_FOUND, "用户不存在");
        }
        return user;
    }

    private AdminUserVo toVo(AppUser user) {
        AdminUserVo vo = new AdminUserVo();
        vo.setId(user.getId());
        vo.setOpenid(user.getOpenid());
        vo.setNickname(user.getNickname());
        vo.setPhone(user.getPhone());
        vo.setUserType(user.getUserType());
        vo.setStatus(user.getStatus());
        vo.setLastLoginAt(user.getLastLoginAt());
        vo.setCreatedAt(user.getCreatedAt());
        return vo;
    }
}
