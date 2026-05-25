package com.jiangsu.tcm.module.auth.service;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

import com.jiangsu.tcm.common.constant.AuditStatus;
import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.module.auth.service.impl.AuditServiceImpl;
import org.junit.jupiter.api.Test;

class AuditServiceImplTest {

    private final AuditServiceImpl auditService = new AuditServiceImpl();

    @Test
    void shouldAllowDraftToPending() {
        assertDoesNotThrow(() -> auditService.transition("course", 1L, AuditStatus.DRAFT, AuditStatus.PENDING, 1L));
    }

    @Test
    void shouldRejectPublishedTransition() {
        assertThrows(
                BizException.class,
                () -> auditService.transition("course", 1L, AuditStatus.PUBLISHED, AuditStatus.DRAFT, 1L));
    }
}
