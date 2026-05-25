package com.jiangsu.tcm.common.web;

import com.jiangsu.tcm.common.exception.BizException;
import com.jiangsu.tcm.common.exception.ErrorCode;
import com.jiangsu.tcm.common.result.Result;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authorization.AuthorizationDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理，对外不返回堆栈（规范 §3.5）。
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BizException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<Void> handleBizException(BizException ex, HttpServletRequest request) {
        log.warn("biz error code={} message={}", ex.getCode(), ex.getMessage());
        return withTraceId(Result.fail(ex.getCode(), ex.getMessage()), request);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<Void> handleValidation(MethodArgumentNotValidException ex, HttpServletRequest request) {
        FieldError fieldError = ex.getBindingResult().getFieldError();
        String message = fieldError != null ? fieldError.getDefaultMessage() : "参数校验失败";
        return withTraceId(Result.fail(ErrorCode.PARAM_INVALID, message), request);
    }

    @ExceptionHandler({AccessDeniedException.class, AuthorizationDeniedException.class})
    @ResponseStatus(HttpStatus.OK)
    public Result<Void> handleAccessDenied(Exception ex, HttpServletRequest request) {
        log.warn("access denied: {}", ex.getMessage());
        return withTraceId(Result.fail(ErrorCode.FORBIDDEN, "无访问权限"), request);
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<Void> handleException(Exception ex, HttpServletRequest request) {
        log.error("system error", ex);
        return withTraceId(Result.fail(ErrorCode.SYSTEM_ERROR, "系统繁忙，请稍后重试"), request);
    }

    private static Result<Void> withTraceId(Result<Void> result, HttpServletRequest request) {
        Object traceId = request.getAttribute(TraceIdFilter.TRACE_ID_KEY);
        if (traceId != null) {
            result.setTraceId(traceId.toString());
        }
        return result;
    }
}
