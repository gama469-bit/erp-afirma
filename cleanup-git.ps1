#!/usr/bin/env pwsh
# Script de limpieza rápida de archivos sensibles del repositorio Git

Write-Host "`n🧹 LIMPIEZA DE ARCHIVOS SENSIBLES DEL REPOSITORIO`n" -ForegroundColor Cyan

# Verificar si estamos en un repositorio git
if (-not (Test-Path .git)) {
    Write-Host "❌ Error: No estás en un repositorio Git" -ForegroundColor Red
    exit 1
}

# Verificar estado actual
Write-Host "📊 Verificando estado actual...`n" -ForegroundColor Yellow

$trackedSensitive = @(
    "create-admin-user.js",
    "CREDENCIALES.md",
    "check-tables.js",
    "check-users.js",
    "create-rh-user.js",
    "change-admin-password.js",
    "grant-permissions.sql",
    "recreate-projects.sql",
    "create-job-openings.sql"
)

$filesToRemove = @()

foreach ($file in $trackedSensitive) {
    if (Test-Path $file) {
        $isTracked = git ls-files $file 2>&1
        if ($isTracked) {
            $filesToRemove += $file
            Write-Host "  ⚠️  $file - Siendo rastreado por Git" -ForegroundColor Yellow
        }
    }
}

if ($filesToRemove.Count -eq 0) {
    Write-Host "✅ No hay archivos sensibles siendo rastreados.`n" -ForegroundColor Green
    exit 0
}

Write-Host "`n📋 Se encontraron $($filesToRemove.Count) archivo(s) a remover del tracking.`n" -ForegroundColor Yellow

# Preguntar confirmación
$response = Read-Host "¿Deseas removerlos del tracking de Git? (S/N)"

if ($response -ne "S" -and $response -ne "s") {
    Write-Host "`n❌ Operación cancelada.`n" -ForegroundColor Red
    exit 0
}

Write-Host "`n🔄 Removiendo archivos del tracking...`n" -ForegroundColor Cyan

foreach ($file in $filesToRemove) {
    try {
        git rm --cached $file 2>&1 | Out-Null
        Write-Host "  ✅ Removido: $file" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠️  No se pudo remover: $file" -ForegroundColor Yellow
    }
}

Write-Host "`n📝 Haciendo commit de los cambios...`n" -ForegroundColor Cyan

git add .gitignore 2>&1 | Out-Null
git commit -m "Remove sensitive files from tracking and update gitignore" 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Commit realizado exitosamente!`n" -ForegroundColor Green
    
    Write-Host "📊 Estado actual del repositorio:`n" -ForegroundColor Cyan
    git status --short
    
    Write-Host "`n💡 SIGUIENTE PASO:" -ForegroundColor Yellow
    Write-Host "  - Verifica que todo esté correcto" -ForegroundColor White
    Write-Host "  - Si estás listo, ejecuta: git push" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Red
    Write-Host "  Si las credenciales YA fueron subidas antes:" -ForegroundColor Yellow
    Write-Host "  1. Cambia TODAS las contraseñas AHORA" -ForegroundColor White
    Write-Host "  2. Lee SEGURIDAD-GIT.md para limpiar el historial" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "⚠️  No se pudo hacer commit (puede que no haya cambios)`n" -ForegroundColor Yellow
}
