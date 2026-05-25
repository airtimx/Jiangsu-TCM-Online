package com.jiangsu.tcm.common.audit;

import com.jiangsu.tcm.common.constant.AuditStatus;

/**
 * CMS 审核状态流转（模块 01 骨架，各业务模块复用）。
 */
public interface AuditService {

    /**
     * 校验并执行审核状态变更。
     *
     * @param resourceType 资源类型
     * @param resourceId   资源 ID
     * @param from         当前状态
     * @param to           目标状态
     * @param operatorId   操作人 ID
     */
    void transition(String resourceType, Long resourceId, AuditStatus from, AuditStatus to, Long operatorId);
}
