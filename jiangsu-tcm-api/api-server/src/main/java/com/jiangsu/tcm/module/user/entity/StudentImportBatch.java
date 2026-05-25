package com.jiangsu.tcm.module.user.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;
import lombok.Data;

@Data
@TableName("student_import_batch")
public class StudentImportBatch {

    @TableId(type = IdType.AUTO)
    private Long id;
    private String fileName;
    private Integer totalCount;
    private Integer successCount;
    private Integer failCount;
    private String errorFileKey;
    private String status;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime finishedAt;
}
