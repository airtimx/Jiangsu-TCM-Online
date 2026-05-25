package com.jiangsu.tcm.module.auth.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SysAdminRoleMapper {

    @Select("SELECT role_id FROM sys_admin_role WHERE admin_id = #{adminId}")
    List<Long> selectRoleIdsByAdminId(@Param("adminId") Long adminId);

    @Select("""
            SELECT r.code FROM sys_role r
            INNER JOIN sys_admin_role ar ON ar.role_id = r.id
            WHERE ar.admin_id = #{adminId}
            """)
    List<String> selectRoleCodesByAdminId(@Param("adminId") Long adminId);

    @Delete("DELETE FROM sys_admin_role WHERE admin_id = #{adminId}")
    int deleteByAdminId(@Param("adminId") Long adminId);

    @Insert("INSERT INTO sys_admin_role (admin_id, role_id) VALUES (#{adminId}, #{roleId})")
    int insert(@Param("adminId") Long adminId, @Param("roleId") Long roleId);
}
