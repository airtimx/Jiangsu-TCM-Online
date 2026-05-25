package com.jiangsu.tcm.common.web;

import com.jiangsu.tcm.common.result.Result;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

/**
 * 为 {@link Result} 响应体注入 traceId。
 */
@RestControllerAdvice
public class ResultTraceIdAdvice implements ResponseBodyAdvice<Result<?>> {

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return Result.class.isAssignableFrom(returnType.getParameterType());
    }

    @Override
    public Result<?> beforeBodyWrite(
            Result<?> body,
            MethodParameter returnType,
            MediaType selectedContentType,
            Class<? extends HttpMessageConverter<?>> selectedConverterType,
            ServerHttpRequest request,
            ServerHttpResponse response) {
        if (body == null) {
            return null;
        }
        if (request instanceof ServletServerHttpRequest servletRequest) {
            Object traceId = servletRequest.getServletRequest().getAttribute(TraceIdFilter.TRACE_ID_KEY);
            if (traceId != null) {
                body.setTraceId(traceId.toString());
            }
        }
        return body;
    }
}
