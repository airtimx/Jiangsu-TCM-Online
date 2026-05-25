package com.jiangsu.tcm.module.auth.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.jiangsu.tcm.module.auth.entity.SysPermission;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SysPermissionMapper extends BaseMapper<SysPermission> {

    @Select("""
            SELECT DISTINCT p.code
            FROM sys_permission p
            INNER JOIN sys_role_permission rp ON p.id = rp.permission_id
            INNER JOIN sys_admin_role ar ON ar.role_id = rp.role_id
            WHERE ar.admin_id = #{adminId}
            ORDER BY p.code
            """)
    List<String> selectCodesByAdminId(@Param("adminId") Long adminId);

    @Select("""
            SELECT COUNT(1)
            FROM sys_admin_role ar
            INNER JOIN sys_role r ON ar.role_id = r.id
            WHERE ar.admin_id = #{adminId} AND r.code = 'super_admin'
            """)
    int countSuperAdminRole(@Param("adminId") Long adminId);
}
