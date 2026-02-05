# SCRIPT DE LIMPIEZA - EJECUTAR COMO ADMINISTRADOR
# Guardar como cleanup-admin.ps1 y ejecutar con permisos de administrador

Write-Host "INICIANDO LIMPIEZA COMPLETA DEL SISTEMA" -ForegroundColor Cyan
Write-Host "==========================================="

Write-Host ""
Write-Host "PASO 1: Deteniendo procesos HTTPD..." -ForegroundColor Yellow
try {
    taskkill /F /IM httpd.exe
    Write-Host "OK - Procesos httpd.exe terminados" -ForegroundColor Green
} catch {
    Write-Host "INFO - No hay procesos httpd.exe corriendo" -ForegroundColor Blue
}

Write-Host ""
Write-Host "PASO 2: Eliminando servicios PEMHTTPD..." -ForegroundColor Yellow
try {
    sc stop "PEMHTTPD-x64"
    sc delete "PEMHTTPD-x64"
    Write-Host "OK - Servicio PEMHTTPD-x64 eliminado" -ForegroundColor Green
} catch {
    Write-Host "INFO - Servicio PEMHTTPD-x64 ya no existe" -ForegroundColor Blue
}

Write-Host ""
Write-Host "PASO 3: Eliminando directorios..." -ForegroundColor Yellow
if (Test-Path "C:\apache24") {
    Remove-Item "C:\apache24" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "OK - Directorio Apache24 eliminado" -ForegroundColor Green
} else {
    Write-Host "INFO - Directorio Apache24 no existe" -ForegroundColor Blue
}

Write-Host ""
Write-Host "PASO 4: Verificacion final..." -ForegroundColor Yellow
$httpdProcesses = Get-Process | Where-Object {$_.ProcessName -eq "httpd"} -ErrorAction SilentlyContinue
if ($httpdProcesses) {
    Write-Host "ADVERTENCIA - Aun hay procesos httpd corriendo:" -ForegroundColor Yellow
    $httpdProcesses | Select-Object ProcessName, Id | Format-Table
} else {
    Write-Host "OK - No hay procesos httpd corriendo" -ForegroundColor Green
}

$ports = netstat -ano | findstr ":80"
if ($ports) {
    Write-Host "ADVERTENCIA - Puertos 80/8080 aun en uso:" -ForegroundColor Yellow
    $ports
} else {
    Write-Host "OK - Puertos 80/8080 completamente libres" -ForegroundColor Green
}

Write-Host ""
Write-Host "LIMPIEZA COMPLETADA" -ForegroundColor Green
Write-Host "Ahora puedes usar los puertos 80 y 8080 sin conflictos"
Write-Host ""
Write-Host "Para migrar tu frontend al puerto 8080:"
Write-Host "cd c:\Desarrollo\employee-management-app\src"
Write-Host "npx http-server -p 8080 --cors"