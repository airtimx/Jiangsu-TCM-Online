package com.jiangsu.tcm;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

class BcryptHashGeneratorTest {

    @Test
    void printAdminPasswordHash() {
        String hash = new BCryptPasswordEncoder().encode("admin123456");
        System.out.println("BCrypt(admin123456)=" + hash);
    }
}
