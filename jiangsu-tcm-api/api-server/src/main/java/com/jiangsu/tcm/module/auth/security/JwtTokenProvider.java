package com.jiangsu.tcm.module.auth.security;

import com.jiangsu.tcm.config.JwtProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;
import javax.crypto.SecretKey;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class JwtTokenProvider {

    public static final String CLAIM_ADMIN_ID = "adminId";
    public static final String CLAIM_USER_ID = "userId";
    public static final String CLAIM_TOKEN_TYPE = "type";
    public static final String TYPE_ACCESS = "access";
    public static final String TYPE_REFRESH = "refresh";
    public static final String TYPE_APP_ACCESS = "app_access";

    private final JwtProperties jwtProperties;

    public String createAccessToken(Long adminId, String username) {
        return buildAdminToken(adminId, username, TYPE_ACCESS, jwtProperties.getAccessTokenMinutes() * 60L);
    }

    public String createRefreshToken(Long adminId, String username) {
        return buildAdminToken(adminId, username, TYPE_REFRESH, jwtProperties.getRefreshTokenDays() * 24L * 3600L);
    }

    public String createAppAccessToken(Long userId, String openid) {
        Instant now = Instant.now();
        long expireSeconds = jwtProperties.getAccessTokenMinutes() * 60L;
        return Jwts.builder()
                .subject(openid)
                .claim(CLAIM_USER_ID, userId)
                .claim(CLAIM_TOKEN_TYPE, TYPE_APP_ACCESS)
                .issuedAt(Date.from(now))
                .expiration(Date.from(now.plusSeconds(expireSeconds)))
                .signWith(secretKey())
                .compact();
    }

    public Claims parseClaims(String token) {
        return Jwts.parser()
                .verifyWith(secretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public boolean isAccessToken(Claims claims) {
        return TYPE_ACCESS.equals(claims.get(CLAIM_TOKEN_TYPE, String.class));
    }

    public boolean isRefreshToken(Claims claims) {
        return TYPE_REFRESH.equals(claims.get(CLAIM_TOKEN_TYPE, String.class));
    }

    public boolean isAppAccessToken(Claims claims) {
        return TYPE_APP_ACCESS.equals(claims.get(CLAIM_TOKEN_TYPE, String.class));
    }

    public Long getAdminId(Claims claims) {
        return claims.get(CLAIM_ADMIN_ID, Long.class);
    }

    public Long getUserId(Claims claims) {
        return claims.get(CLAIM_USER_ID, Long.class);
    }

    private String buildAdminToken(Long adminId, String username, String type, long expireSeconds) {
        Instant now = Instant.now();
        return Jwts.builder()
                .subject(username)
                .claim(CLAIM_ADMIN_ID, adminId)
                .claim(CLAIM_TOKEN_TYPE, type)
                .issuedAt(Date.from(now))
                .expiration(Date.from(now.plusSeconds(expireSeconds)))
                .signWith(secretKey())
                .compact();
    }

    public void validateToken(String token) {
        try {
            parseClaims(token);
        } catch (JwtException | IllegalArgumentException ex) {
            throw new JwtException("无效的令牌", ex);
        }
    }

    private SecretKey secretKey() {
        byte[] keyBytes = jwtProperties.getSecret().getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            throw new IllegalStateException("JWT secret 长度至少 32 字节");
        }
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
