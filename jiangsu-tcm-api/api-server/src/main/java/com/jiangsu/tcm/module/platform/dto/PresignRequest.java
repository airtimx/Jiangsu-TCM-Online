package com.jiangsu.tcm.module.platform.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class PresignRequest {

    @NotBlank(message = "module 不能为空")
    @Size(max = 32, message = "module 长度不能超过 32")
    @Pattern(regexp = "^[a-z][a-z0-9-]*$", message = "module 须为小写字母开头")
    private String module;

    @NotBlank(message = "fileName 不能为空")
    @Size(max = 255, message = "fileName 长度不能超过 255")
    private String fileName;

    @Size(max = 128, message = "contentType 长度不能超过 128")
    private String contentType;
}
