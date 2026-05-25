package com.jiangsu.tcm.common.exception;

/**
 * 统一业务错误码（规范 §4.2）。
 */
public final class ErrorCode {

    public static final int SUCCESS = 0;
    public static final int PARAM_INVALID = 10001;
    public static final int UNAUTHORIZED = 10002;
    public static final int FORBIDDEN = 10003;
    public static final int NOT_FOUND = 20001;
    public static final int AUDIT_STATUS_INVALID = 20002;
    public static final int SYSTEM_ERROR = 50000;

    private ErrorCode() {
    }
}
