package com.jiangsu.tcm.module.user.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class StudentImportResultVo {

    private Long batchId;
    private int totalCount;
    private int successCount;
    private int failCount;
    private String errorDownloadPath;
}
