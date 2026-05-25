package com.jiangsu.tcm.module.auth.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;
import lombok.Data;

@Data
@TableName("sys_login_log")
public class SysLoginLog {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long adminId;
    private String username;
    private Integer success;
    private String ip;
    private String userAgent;
    private String message;
    private LocalDateTime createdAt;
}
