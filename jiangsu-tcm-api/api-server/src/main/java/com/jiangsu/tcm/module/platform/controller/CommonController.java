package com.jiangsu.tcm.module.platform.controller;

import com.jiangsu.tcm.common.constant.AuditStatus;
import com.jiangsu.tcm.common.constant.CertStatus;
import com.jiangsu.tcm.common.result.Result;
import com.jiangsu.tcm.module.platform.dto.EnumItemVo;
import com.jiangsu.tcm.module.platform.dto.PresignRequest;
import com.jiangsu.tcm.module.platform.dto.PresignResponse;
import com.jiangsu.tcm.module.platform.service.OssPresignService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 公共 API（模块 00 stable 契约）。
 */
@Tag(name = "公共接口")
@RestController
@RequestMapping("/api/common/v1")
@RequiredArgsConstructor
public class CommonController {

    private final OssPresignService ossPresignService;

    @Operation(summary = "OSS 预签名上传")
    @PostMapping("/upload/presign")
    public Result<PresignResponse> presign(@Valid @RequestBody PresignRequest request) {
        return Result.ok(ossPresignService.createPresignedUpload(request));
    }

    @Operation(summary = "公共枚举")
    @GetMapping("/enums")
    public Result<Map<String, List<EnumItemVo>>> enums() {
        Map<String, List<EnumItemVo>> data = new LinkedHashMap<>();
        data.put(
                "auditStatus",
                Arrays.stream(AuditStatus.values())
                        .map(status -> new EnumItemVo(status.name(), status.name()))
                        .collect(Collectors.toList()));
        data.put(
                "certStatus",
                Arrays.stream(CertStatus.values())
                        .map(status -> new EnumItemVo(status.name(), status.name()))
                        .collect(Collectors.toList()));
        return Result.ok(data);
    }
}
