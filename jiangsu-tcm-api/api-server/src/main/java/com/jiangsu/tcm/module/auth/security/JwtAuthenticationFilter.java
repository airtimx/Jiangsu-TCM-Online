package com.jiangsu.tcm.module.auth.security;

import com.jiangsu.tcm.module.auth.service.AdminAuthService;
import com.jiangsu.tcm.module.user.security.AppUserPrincipal;
import com.jiangsu.tcm.module.user.service.AppUserAuthService;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final AdminAuthService adminAuthService;
    private final AppUserAuthService appUserAuthService;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String token = resolveToken(request);
        if (StringUtils.hasText(token) && SecurityContextHolder.getContext().getAuthentication() == null) {
            Claims claims = jwtTokenProvider.parseClaims(token);
            UsernamePasswordAuthenticationToken authentication = null;
            if (jwtTokenProvider.isAppAccessToken(claims)) {
                Long userId = jwtTokenProvider.getUserId(claims);
                AppUserPrincipal principal = appUserAuthService.loadPrincipal(userId);
                authentication = new UsernamePasswordAuthenticationToken(principal, null, principal.getAuthorities());
            } else if (jwtTokenProvider.isAccessToken(claims)) {
                Long adminId = jwtTokenProvider.getAdminId(claims);
                AdminPrincipal principal = adminAuthService.loadPrincipal(adminId);
                authentication = new UsernamePasswordAuthenticationToken(principal, null, principal.getAuthorities());
            }
            if (authentication != null) {
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }
        filterChain.doFilter(request, response);
    }

    private String resolveToken(HttpServletRequest request) {
        String bearer = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (StringUtils.hasText(bearer) && bearer.startsWith("Bearer ")) {
            return bearer.substring(7);
        }
        return null;
    }
}
