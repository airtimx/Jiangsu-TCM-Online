package com.jiangsu.tcm.module.user.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

@Data
public class StudentExcelRow {

    @ExcelProperty("姓名")
    private String realName;

    @ExcelProperty("手机号")
    private String phone;

    @ExcelProperty("身份证号")
    private String idCard;

    @ExcelProperty("地区")
    private String region;

    @ExcelProperty("所在单位")
    private String orgName;

    @ExcelProperty("认证状态")
    private String certStatus;

    @ExcelProperty("错误原因")
    private String errorMessage;
}
