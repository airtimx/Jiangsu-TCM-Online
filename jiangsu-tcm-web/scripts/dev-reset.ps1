# 结束占用 3000 / HMR 端口的 Nuxt 进程，并清理 .nuxt 缓存后重新 dev
$ErrorActionPreference = 'SilentlyContinue'
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

foreach ($port in @(3000, 24678, 24679)) {
    netstat -ano | findstr ":$port " | findstr "LISTENING" | ForEach-Object {
        if ($_ -match '\s+(\d+)\s*$') {
            $pid = [int]$Matches[1]
            if ($pid -gt 0) {
                Write-Host "Stopping PID $pid (port $port)..."
                Stop-Process -Id $pid -Force
            }
        }
    }
}

Start-Sleep -Seconds 2
if (Test-Path '.nuxt') {
    Remove-Item -Recurse -Force '.nuxt'
    Write-Host 'Removed .nuxt'
}
Write-Host 'Run: npm run dev'
