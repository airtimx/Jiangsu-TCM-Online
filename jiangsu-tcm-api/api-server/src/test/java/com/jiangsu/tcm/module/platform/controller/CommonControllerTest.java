package com.jiangsu.tcm.module.platform.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jiangsu.tcm.common.web.GlobalExceptionHandler;
import com.jiangsu.tcm.common.web.ResultTraceIdAdvice;
import com.jiangsu.tcm.common.web.TraceIdFilter;
import com.jiangsu.tcm.module.platform.dto.PresignRequest;
import com.jiangsu.tcm.module.platform.dto.PresignResponse;
import com.jiangsu.tcm.module.platform.service.OssPresignService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

@ExtendWith(MockitoExtension.class)
class CommonControllerTest {

    private MockMvc mockMvc;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private OssPresignService ossPresignService;

    @BeforeEach
    void setUp() {
        ossPresignService = mock(OssPresignService.class);
        CommonController controller = new CommonController(ossPresignService);
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler(), new ResultTraceIdAdvice())
                .setMessageConverters(new MappingJackson2HttpMessageConverter())
                .addFilters(new TraceIdFilter())
                .build();
    }

    @Test
    void enumsShouldReturnUnifiedResult() throws Exception {
        mockMvc.perform(get("/api/common/v1/enums"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.message").value("ok"))
                .andExpect(jsonPath("$.traceId").isNotEmpty())
                .andExpect(jsonPath("$.data.auditStatus").isArray());
    }

    @Test
    void presignShouldReturnUnifiedResult() throws Exception {
        when(ossPresignService.createPresignedUpload(any())).thenReturn(
                PresignResponse.builder()
                        .uploadUrl("http://127.0.0.1:9000/tcm-online/test")
                        .ossKey("/dev/course/202605/uuid.pdf")
                        .method("PUT")
                        .expireSeconds(3600)
                        .build());

        PresignRequest request = new PresignRequest();
        request.setModule("course");
        request.setFileName("demo.pdf");
        request.setContentType("application/pdf");

        mockMvc.perform(post("/api/common/v1/upload/presign")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.data.ossKey").value("/dev/course/202605/uuid.pdf"))
                .andExpect(jsonPath("$.traceId").isNotEmpty());
    }
}
