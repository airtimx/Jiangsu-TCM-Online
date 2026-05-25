package com.jiangsu.tcm.common.exception;

import lombok.Getter;

/**
 * 业务异常，禁止用于流程控制（规范 §3.5）。
 */
@Getter
public class BizException extends RuntimeException {

    private final int code;

    public BizException(int code, String message) {
        super(message);
        this.code = code;
    }

    public static BizException of(int code, String message) {
        return new BizException(code, message);
    }
}
