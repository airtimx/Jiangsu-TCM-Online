package com.jiangsu.tcm.module.auth.service;

import com.jiangsu.tcm.module.auth.dto.MenuVo;
import java.util.List;
import java.util.Set;

public interface MenuService {

    List<MenuVo> listMenusForPermissions(Set<String> permissionCodes, boolean superAdmin);
}
