package com.jiangsu.tcm;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 江苏中医在线 API 启动类（模块 00 工程基座）。
 */
@SpringBootApplication
@MapperScan("com.jiangsu.tcm.module.**.mapper")
public class JiangsuTcmOnlineApplication {

    public static void main(String[] args) {
        SpringApplication.run(JiangsuTcmOnlineApplication.class, args);
    }
}
