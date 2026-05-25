package com.jiangsu.tcm.module.auth.security;

import java.util.Collection;
import java.util.Set;
import java.util.stream.Collectors;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@Getter
public class AdminPrincipal implements UserDetails {

    private final Long adminId;
    private final String username;
    private final String realName;
    private final Set<String> roleCodes;
    private final Set<String> permissionCodes;
    private final boolean enabled;

    public AdminPrincipal(
            Long adminId,
            String username,
            String realName,
            Set<String> roleCodes,
            Set<String> permissionCodes,
            boolean enabled) {
        this.adminId = adminId;
        this.username = username;
        this.realName = realName;
        this.roleCodes = roleCodes;
        this.permissionCodes = permissionCodes;
        this.enabled = enabled;
    }

    public boolean isSuperAdmin() {
        return roleCodes.contains("super_admin");
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return permissionCodes.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toSet());
    }

    @Override
    public String getPassword() {
        return "";
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return enabled;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }
}
