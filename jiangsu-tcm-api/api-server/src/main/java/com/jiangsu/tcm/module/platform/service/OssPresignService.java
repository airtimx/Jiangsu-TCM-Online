package com.jiangsu.tcm.module.platform.service;

import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.config.OssProperties;
import com.jiangsu.tcm.module.platform.dto.PresignRequest;
import com.jiangsu.tcm.module.platform.dto.PresignResponse;
import java.net.URI;
import java.time.Duration;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;

/**
 * OSS / MinIO 预签名上传（路径规范：/{env}/{module}/{yyyyMM}/{uuid}.{ext}）。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OssPresignService {

    private static final Set<String> ALLOWED_EXTENSIONS =
            Set.of("jpg", "jpeg", "png", "gif", "pdf", "epub", "mp3", "mp4", "m4a", "wav");

    private static final DateTimeFormatter YEAR_MONTH = DateTimeFormatter.ofPattern("yyyyMM");

    private final OssProperties ossProperties;

    public PresignResponse createPresignedUpload(PresignRequest request) {
        String extension = resolveExtension(request.getFileName());
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "不支持的文件类型: " + extension);
        }
        String ossKey = buildOssKey(request.getModule(), extension);
        try (S3Presigner presigner = buildPresigner()) {
            PutObjectRequest objectRequest = PutObjectRequest.builder()
                    .bucket(ossProperties.getBucket())
                    .key(ossKey)
                    .contentType(resolveContentType(request.getContentType(), extension))
                    .build();
            PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
                    .signatureDuration(Duration.ofSeconds(ossProperties.getPresignExpireSeconds()))
                    .putObjectRequest(objectRequest)
                    .build();
            PresignedPutObjectRequest presigned = presigner.presignPutObject(presignRequest);
            log.info("presign ossKey={}", ossKey);
            return PresignResponse.builder()
                    .uploadUrl(presigned.url().toString())
                    .ossKey(ossKey)
                    .method("PUT")
                    .headers(Map.of())
                    .expireSeconds(ossProperties.getPresignExpireSeconds())
                    .build();
        }
    }

    public String buildOssKey(String module, String extension) {
        String yearMonth = YearMonth.now().format(YEAR_MONTH);
        String uuid = UUID.randomUUID().toString().replace("-", "");
        return "/" + ossProperties.getEnv() + "/" + module + "/" + yearMonth + "/" + uuid + "." + extension;
    }

    private S3Presigner buildPresigner() {
        AwsBasicCredentials credentials = AwsBasicCredentials.create(
                ossProperties.getAccessKey(), ossProperties.getSecretKey());
        return S3Presigner.builder()
                .endpointOverride(URI.create(ossProperties.getEndpoint()))
                .region(Region.US_EAST_1)
                .credentialsProvider(StaticCredentialsProvider.create(credentials))
                .serviceConfiguration(
                        S3Configuration.builder().pathStyleAccessEnabled(true).build())
                .build();
    }

    private static String resolveExtension(String fileName) {
        if (!StringUtils.hasText(fileName) || !fileName.contains(".")) {
            throw BizException.of(ErrorCode.PARAM_INVALID, "文件名须包含扩展名");
        }
        return fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
    }

    private static String resolveContentType(String contentType, String extension) {
        if (StringUtils.hasText(contentType)) {
            return contentType;
        }
        return switch (extension) {
            case "jpg", "jpeg" -> "image/jpeg";
            case "png" -> "image/png";
            case "gif" -> "image/gif";
            case "pdf" -> "application/pdf";
            case "epub" -> "application/epub+zip";
            case "mp3" -> "audio/mpeg";
            case "mp4" -> "video/mp4";
            case "m4a" -> "audio/mp4";
            case "wav" -> "audio/wav";
            default -> "application/octet-stream";
        };
    }
}
