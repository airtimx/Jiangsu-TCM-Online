package com.jiangsu.tcm.common.result;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

import org.junit.jupiter.api.Test;

class ResultTest {

    @Test
    void okShouldUseSuccessCode() {
        Result<String> result = Result.ok("data");
        assertEquals(0, result.getCode());
        assertEquals("ok", result.getMessage());
        assertEquals("data", result.getData());
    }

    @Test
    void failShouldKeepBusinessCode() {
        Result<Void> result = Result.fail(10001, "参数错误");
        assertEquals(10001, result.getCode());
        assertNull(result.getData());
    }
}
