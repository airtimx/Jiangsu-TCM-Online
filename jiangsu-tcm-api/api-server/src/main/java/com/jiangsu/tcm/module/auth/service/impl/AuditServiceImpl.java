package com.jiangsu.tcm.module.auth.service.impl;

import com.jiangsu.tcm.common.audit.AuditService;
import com.jiangsu.tcm.common.constant.AuditStatus;
import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AuditServiceImpl implements AuditService {

    @Override
    public void transition(
            String resourceType, Long resourceId, AuditStatus from, AuditStatus to, Long operatorId) {
        if (from == null || to == null) {
            throw BizException.of(ErrorCode.AUDIT_STATUS_INVALID, "审核状态不能为空");
        }
        if (!isAllowedTransition(from, to)) {
            throw BizException.of(
                    ErrorCode.AUDIT_STATUS_INVALID,
                    String.format("不允许从 %s 变更为 %s", from, to));
        }
        log.info(
                "audit transition resourceType={} resourceId={} from={} to={} operatorId={}",
                resourceType,
                resourceId,
                from,
                to,
                operatorId);
    }

    private boolean isAllowedTransition(AuditStatus from, AuditStatus to) {
        if (from == to) {
            return true;
        }
        return switch (from) {
            case DRAFT -> to == AuditStatus.PENDING;
            case PENDING -> to == AuditStatus.APPROVED || to == AuditStatus.REJECTED;
            case APPROVED -> to == AuditStatus.PUBLISHED;
            case REJECTED -> to == AuditStatus.DRAFT;
            case PUBLISHED -> false;
        };
    }
}
