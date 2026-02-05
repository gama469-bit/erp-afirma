# SCRIPT PARA DETENER SERVIDOR EDB - EJECUTAR COMO ADMINISTRADOR
# Detiene el servidor EDB PEM que interfiere con el puerto 8080

Write-Host "DETENIENDO SERVIDOR EDB EN PUERTO 8080" -ForegroundColor Cyan
Write-Host "======================================="

Write-Host ""
Write-Host "PASO 1: Buscando servicio EDB PEM HTTPD..." -ForegroundColor Yellow
$edbService = Get-Service | Where-Object {$_.Name -like "*pem*httpd*"} -ErrorAction SilentlyContinue
if ($edbService) {
    Write-Host "Encontrado servicio: $($edbService.Name) - Estado: $($edbService.Status)"
    if ($edbService.Status -eq "Running") {
        Write-Host "Deteniendo servicio EDB PEMHTTPD..."
        Stop-Service -Name $edbService.Name -Force
        Write-Host "OK - Servicio EDB detenido" -ForegroundColor Green
    } else {
        Write-Host "INFO - Servicio ya detenido" -ForegroundColor Blue
    }
} else {
    Write-Host "INFO - No se encontro servicio EDB PEMHTTPD" -ForegroundColor Blue
}

Write-Host ""
Write-Host "PASO 2: Buscando procesos Apache EDB..." -ForegroundColor Yellow
$edbProcesses = Get-Process | Where-Object {
    $_.Path -like "*edb*" -or 
    $_.Path -like "*pem*" -or
    ($_.ProcessName -eq "httpd" -and $_.Path -like "*Program Files*")
} -ErrorAction SilentlyContinue

if ($edbProcesses) {
    Write-Host "Procesos EDB encontrados:"
    $edbProcesses | Select-Object ProcessName, Id, Path | Format-Table
    Write-Host "Deteniendo procesos EDB..."
    $edbProcesses | Stop-Process -Force
    Write-Host "OK - Procesos EDB detenidos" -ForegroundColor Green
} else {
    Write-Host "INFO - No hay procesos EDB corriendo" -ForegroundColor Blue
}

Write-Host ""
Write-Host "PASO 3: Verificacion final..." -ForegroundColor Yellow
$port8080 = netstat -ano | findstr ":8080" | findstr "LISTENING"
if ($port8080) {
    Write-Host "ADVERTENCIA - Puerto 8080 aun ocupado:" -ForegroundColor Yellow
    $port8080
} else {
    Write-Host "OK - Puerto 8080 liberado" -ForegroundColor Green
}

Write-Host ""
Write-Host "LIMPIEZA EDB COMPLETADA" -ForegroundColor Green
Write-Host "Ahora el puerto 8080 deberia estar libre para tu aplicacion"