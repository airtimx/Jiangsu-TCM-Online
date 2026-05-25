# 方案 B：使用 Navicat 创建的 tcm 用户启动（默认 tcm/tcm123456）
Set-Location $PSScriptRoot\..
$env:SPRING_PROFILES_ACTIVE = ""
.\mvnw.cmd -pl api-server spring-boot:run
