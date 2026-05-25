package com.jiangsu.tcm.module.platform.dto;

import java.util.Map;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PresignResponse {

    private String uploadUrl;
    private String ossKey;
    private String method;
    private Map<String, String> headers;
    private int expireSeconds;
}
