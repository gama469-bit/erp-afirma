# SCRIPT PARA INICIAR APLICACION ERP AFIRMA
# Guarda este archivo como start-app.ps1 y ejecuta con PowerShell

Write-Host "INICIANDO APLICACION ERP AFIRMA" -ForegroundColor Green
Write-Host "================================"

# Verificar directorios
Write-Host ""
Write-Host "Verificando estructura de archivos..." -ForegroundColor Yellow
if (!(Test-Path ".\src")) {
    Write-Host "ERROR: Directorio src no encontrado" -ForegroundColor Red
    exit 1
}

if (!(Test-Path ".\server\api.js")) {
    Write-Host "ERROR: Archivo api.js no encontrado" -ForegroundColor Red
    exit 1
}

Write-Host "OK: Archivos encontrados" -ForegroundColor Green

# Detener procesos previos
Write-Host ""
Write-Host "Deteniendo procesos previos..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -eq "node" -or $_.ProcessName -eq "http-server"} | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process | Where-Object {$_.ProcessName -eq "live-server"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep 3

# Limpiar caché de npm
Write-Host ""
Write-Host "Limpiando caché..." -ForegroundColor Yellow
npm cache clean --force 2>$null

# Iniciar API en background
Write-Host ""
Write-Host "Iniciando API en puerto 3000..." -ForegroundColor Yellow
$currentDir = (Get-Location).Path
Start-Process powershell -ArgumentList "-Command", "cd '$currentDir\server'; node api.js; pause" -WindowStyle Normal
Start-Sleep 5

# Verificar API
try {
    $apiTest = Invoke-RestMethod "http://127.0.0.1:3000/api/employees-v2" -TimeoutSec 5
    Write-Host "OK: API funcionando - $($apiTest.Count) empleados" -ForegroundColor Green
} catch {
    Write-Host "ERROR: API no responde" -ForegroundColor Red
    Write-Host "Inicia manualmente: cd server; node api.js" -ForegroundColor Yellow
}

# Iniciar Frontend
Write-Host ""
Write-Host "Iniciando Frontend en puerto 8082..." -ForegroundColor Yellow
Write-Host "Ejecutando: npm start (live-server)"
Write-Host "NOTA: Deja esta ventana abierta para mantener el servidor corriendo" -ForegroundColor Cyan
Write-Host ""
Write-Host "La aplicación estará disponible en:" -ForegroundColor Green
Write-Host "  http://127.0.0.1:8082" -ForegroundColor White
Write-Host "  API disponible en: http://127.0.0.1:3000" -ForegroundColor White
Write-Host ""
npm start