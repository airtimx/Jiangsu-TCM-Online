package com.jiangsu.tcm.common.result;

import com.jiangsu.tcm.common.exception.ErrorCode;
import lombok.Data;

/**
 * 统一 API 响应体（规范 §4.2）。
 *
 * @param <T> 业务数据类型
 */
@Data
public class Result<T> {

    private int code;
    private String message;
    private T data;
    private String traceId;

    public static <T> Result<T> ok(T data) {
        Result<T> result = new Result<>();
        result.setCode(ErrorCode.SUCCESS);
        result.setMessage("ok");
        result.setData(data);
        return result;
    }

    public static <T> Result<T> ok() {
        return ok(null);
    }

    public static <T> Result<T> fail(int code, String message) {
        Result<T> result = new Result<>();
        result.setCode(code);
        result.setMessage(message);
        return result;
    }
}
