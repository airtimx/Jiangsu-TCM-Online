package com.jiangsu.tcm;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import com.jiangsu.tcm.common.result.Result;
import org.junit.jupiter.api.Test;

/**
 * 冒烟测试（不启动 Spring 容器，避免本机 JDK/DB 差异）。
 */
class JiangsuTcmOnlineApplicationTests {

    @Test
    void resultContractShouldLoad() {
        Result<String> result = Result.ok("ok");
        assertNotNull(result);
    }
}
