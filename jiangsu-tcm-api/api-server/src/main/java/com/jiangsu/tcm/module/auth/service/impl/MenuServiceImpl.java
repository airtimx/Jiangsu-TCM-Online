package com.jiangsu.tcm.module.auth.service.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jiangsu.tcm.module.auth.dto.MenuVo;
import com.jiangsu.tcm.module.auth.service.MenuService;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Slf4j
@Service
@RequiredArgsConstructor
public class MenuServiceImpl implements MenuService {

    private final ObjectMapper objectMapper;

    @Override
    public List<MenuVo> listMenusForPermissions(Set<String> permissionCodes, boolean superAdmin) {
        List<MenuVo> all = loadBaseMenus();
        List<MenuVo> filtered = new ArrayList<>();
        for (MenuVo menu : all) {
            MenuVo copy = filterMenu(menu, permissionCodes, superAdmin);
            if (copy != null) {
                filtered.add(copy);
            }
        }
        return filtered;
    }

    private MenuVo filterMenu(MenuVo menu, Set<String> permissions, boolean superAdmin) {
        if (menu.getChildren() != null && !menu.getChildren().isEmpty()) {
            List<MenuVo> children = new ArrayList<>();
            for (MenuVo child : menu.getChildren()) {
                MenuVo kept = filterMenu(child, permissions, superAdmin);
                if (kept != null) {
                    children.add(kept);
                }
            }
            if (children.isEmpty()) {
                return null;
            }
            MenuVo parent = copyShallow(menu);
            parent.setChildren(children);
            return parent;
        }
        if (canAccess(menu.getPermission(), permissions, superAdmin)) {
            return copyShallow(menu);
        }
        return null;
    }

    private boolean canAccess(String required, Set<String> permissions, boolean superAdmin) {
        if (superAdmin) {
            return true;
        }
        if (!StringUtils.hasText(required)) {
            return true;
        }
        if (permissions.contains(required)) {
            return true;
        }
        return permissions.stream().anyMatch(code -> code.startsWith(required + ":"));
    }

    private MenuVo copyShallow(MenuVo source) {
        MenuVo target = new MenuVo();
        target.setPath(source.getPath());
        target.setTitle(source.getTitle());
        target.setIcon(source.getIcon());
        target.setPermission(source.getPermission());
        return target;
    }

    private List<MenuVo> loadBaseMenus() {
        ClassPathResource resource = new ClassPathResource("auth/menus/base-menus.json");
        try (InputStream in = resource.getInputStream()) {
            return objectMapper.readValue(in, new TypeReference<List<MenuVo>>() {});
        } catch (IOException ex) {
            log.error("load menu config failed", ex);
            return List.of();
        }
    }
}
