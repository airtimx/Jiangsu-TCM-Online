package com.jiangsu.tcm.module.auth.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jiangsu.tcm.common.web.GlobalExceptionHandler;
import com.jiangsu.tcm.common.web.ResultTraceIdAdvice;
import com.jiangsu.tcm.common.web.TraceIdFilter;
import com.jiangsu.tcm.module.auth.dto.AdminProfileVo;
import com.jiangsu.tcm.module.auth.dto.LoginRequest;
import com.jiangsu.tcm.module.auth.dto.LoginResponse;
import com.jiangsu.tcm.module.auth.service.AuthService;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

@ExtendWith(MockitoExtension.class)
class AuthControllerTest {

    private MockMvc mockMvc;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private AuthService authService;

    @BeforeEach
    void setUp() {
        authService = mock(AuthService.class);
        AuthController controller = new AuthController(authService);
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler(), new ResultTraceIdAdvice())
                .setMessageConverters(new MappingJackson2HttpMessageConverter())
                .addFilters(new TraceIdFilter())
                .build();
    }

    @Test
    void loginShouldReturnToken() throws Exception {
        when(authService.login(any(), any()))
                .thenReturn(LoginResponse.builder()
                        .accessToken("access-token")
                        .refreshToken("refresh-token")
                        .expiresIn(7200)
                        .admin(AdminProfileVo.builder()
                                .id(1L)
                                .username("admin")
                                .roles(List.of("super_admin"))
                                .permissions(List.of("system:admin:list"))
                                .build())
                        .menus(List.of())
                        .build());

        LoginRequest request = new LoginRequest();
        request.setUsername("admin");
        request.setPassword("admin123456");

        mockMvc.perform(post("/api/admin/v1/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.data.accessToken").value("access-token"));
    }
}
