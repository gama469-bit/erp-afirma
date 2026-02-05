# DESINSTALACION COMPLETA DE EDB - EJECUTAR COMO ADMINISTRADOR
# Este script elimina completamente EnterpriseDB y libera el puerto 8080

Write-Host "DESINSTALACION COMPLETA DE EDB (EnterpriseDB)" -ForegroundColor Red
Write-Host "=============================================="

Write-Host ""
Write-Host "PASO 1: Deteniendo todos los servicios EDB..." -ForegroundColor Yellow

# Detener servicios EDB
$edbServices = @("PEMHTTPD-x64", "pgagent-pg17", "postgresql-x64-17")
foreach ($service in $edbServices) {
    try {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc -and $svc.Status -eq "Running") {
            Write-Host "Deteniendo servicio: $service"
            Stop-Service -Name $service -Force
            Write-Host "OK - $service detenido" -ForegroundColor Green
        } else {
            Write-Host "INFO - $service ya detenido o no existe" -ForegroundColor Blue
        }
    } catch {
        Write-Host "ADVERTENCIA - No se pudo detener $service" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "PASO 2: Eliminando servicios del registro..." -ForegroundColor Yellow
foreach ($service in $edbServices) {
    try {
        sc delete $service
        Write-Host "OK - Servicio $service eliminado del registro" -ForegroundColor Green
    } catch {
        Write-Host "INFO - Servicio $service ya eliminado" -ForegroundColor Blue
    }
}

Write-Host ""
Write-Host "PASO 3: Deteniendo procesos EDB..." -ForegroundColor Yellow
$edbPaths = @("*edb*", "*pem*", "*postgresql*")
foreach ($path in $edbPaths) {
    $processes = Get-Process | Where-Object {$_.Path -like $path} -ErrorAction SilentlyContinue
    if ($processes) {
        $processes | ForEach-Object {
            Write-Host "Deteniendo proceso: $($_.ProcessName) (PID: $($_.Id))"
            Stop-Process -Id $_.Id -Force
        }
        Write-Host "OK - Procesos EDB detenidos" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "PASO 4: Eliminando directorios EDB..." -ForegroundColor Yellow
$edbDirectories = @(
    "C:\Program Files\edb",
    "C:\Program Files (x86)\edb", 
    "C:\Program Files\PostgreSQL",
    "C:\Program Files (x86)\PostgreSQL"
)

foreach ($dir in $edbDirectories) {
    if (Test-Path $dir) {
        Write-Host "Eliminando directorio: $dir"
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "OK - $dir eliminado" -ForegroundColor Green
    } else {
        Write-Host "INFO - $dir no existe" -ForegroundColor Blue
    }
}

Write-Host ""
Write-Host "PASO 5: Limpiando registro de Windows..." -ForegroundColor Yellow
$registryPaths = @(
    "HKLM:\SOFTWARE\edb",
    "HKLM:\SOFTWARE\PostgreSQL",
    "HKCU:\SOFTWARE\edb",
    "HKCU:\SOFTWARE\PostgreSQL"
)

foreach ($regPath in $registryPaths) {
    try {
        if (Test-Path $regPath) {
            Remove-Item $regPath -Recurse -Force
            Write-Host "OK - Entrada de registro eliminada: $regPath" -ForegroundColor Green
        }
    } catch {
        Write-Host "INFO - No se pudo eliminar: $regPath" -ForegroundColor Blue
    }
}

Write-Host ""
Write-Host "PASO 6: Verificacion final..." -ForegroundColor Yellow
$remainingServices = Get-Service | Where-Object {$_.Name -like "*edb*" -or $_.Name -like "*pem*" -or $_.Name -like "*postgres*"}
if ($remainingServices) {
    Write-Host "ADVERTENCIA - Servicios restantes:" -ForegroundColor Yellow
    $remainingServices | Select-Object Name, Status | Format-Table
} else {
    Write-Host "OK - No quedan servicios EDB" -ForegroundColor Green
}

$port8080Check = netstat -ano | findstr ":8080" | findstr "LISTENING"
if ($port8080Check) {
    Write-Host "ADVERTENCIA - Puerto 8080 aun ocupado" -ForegroundColor Yellow
    $port8080Check
} else {
    Write-Host "OK - Puerto 8080 liberado completamente" -ForegroundColor Green
}

Write-Host ""
Write-Host "DESINSTALACION EDB COMPLETADA" -ForegroundColor Green
Write-Host "Reinicia el sistema para asegurar limpieza completa"
Write-Host "Despues podras usar el puerto 8080 sin conflictos"