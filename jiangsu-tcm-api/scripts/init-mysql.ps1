# 使用 root 初始化 tcm 用户（可选，初始化后应用仍可用 tcm/tcm123456）
# 用法：在 jiangsu-tcm-api 目录，修改下方密码后执行
#   powershell -ExecutionPolicy Bypass -File scripts\init-mysql.ps1

param(
    [string]$RootUser = "root",
    [string]$RootPassword = "jyz20010930@A",
    [string]$MysqlExe = ""
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sqlFile = Join-Path $scriptDir "init-local-mysql.sql"

if (-not $MysqlExe) {
    $candidates = @(
        "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql.exe"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { $MysqlExe = $c; break }
    }
}

if (-not $MysqlExe -or -not (Test-Path $MysqlExe)) {
    $cmd = Get-Command mysql -ErrorAction SilentlyContinue
    if ($cmd) { $MysqlExe = $cmd.Source }
}

if (-not $MysqlExe) {
    Write-Error "未找到 mysql.exe，请安装 MySQL 或将 bin 加入 PATH，或 -MysqlExe 指定路径"
    exit 1
}

Write-Host "使用: $MysqlExe"
& $MysqlExe -u $RootUser "-p$RootPassword" -e "source $($sqlFile -replace '\\','/')"
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: 已创建 tcm_online 与 tcm 用户 (tcm/tcm123456)"
} else {
    Write-Error "初始化失败，请检查 root 密码与 MySQL 服务是否启动"
    exit $LASTEXITCODE
}
