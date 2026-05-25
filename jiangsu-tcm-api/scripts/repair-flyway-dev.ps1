# Flyway repair for dev database tcm_online
# Usage: powershell -ExecutionPolicy Bypass -File scripts\repair-flyway-dev.ps1

param(
    [string]$MysqlUser = "tcm",
    [string]$MysqlPassword = "tcm123456",
    [string]$Database = "tcm_online",
    [string]$MysqlExe = ""
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sqlFile = Join-Path $scriptDir "repair-flyway-dev.sql"

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

if (-not $MysqlExe) {
    $cmd = Get-Command mysql -ErrorAction SilentlyContinue
    if ($cmd) { $MysqlExe = $cmd.Source }
}

if (-not $MysqlExe) {
    Write-Host "mysql.exe not found. Run repair-flyway-dev.sql in Navicat instead."
    exit 1
}

Write-Host "Using: $MysqlExe"
& $MysqlExe -u $MysqlUser "-p$MysqlPassword" -h 127.0.0.1 $Database -e "source $($sqlFile -replace '\\','/')"
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: flyway_schema_history repaired. Rebuild and restart API."
} else {
    Write-Error "Repair failed. Check MySQL service and user $MysqlUser"
    exit $LASTEXITCODE
}
