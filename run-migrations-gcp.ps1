# Script para ejecutar migraciones en Cloud SQL desde local
Write-Host "Ejecutando migraciones en Cloud SQL" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Configuración
$PROJECT_ID = "erp-afirma-solutions"
$INSTANCE_NAME = "erp-afirma-db"
$DB_NAME = "BD_afirma"
$DB_USER = "postgres"
$DB_PASSWORD = "Sistemas1"

# Variables de entorno para la conexión
$env:DB_HOST = "34.27.67.249"
$env:DB_PORT = "5432"
$env:DB_NAME = $DB_NAME
$env:DB_USER = $DB_USER
$env:DB_PASSWORD = $DB_PASSWORD
$env:NODE_ENV = "production"

Write-Host "Configuracion:" -ForegroundColor Yellow
Write-Host "  Proyecto: $PROJECT_ID"
Write-Host "  Instancia: $INSTANCE_NAME"
Write-Host "  Base de datos: $DB_NAME"
Write-Host "  Host: $env:DB_HOST"
Write-Host ""

# Verificar que Node.js esté disponible
Write-Host "Verificando Node.js..." -ForegroundColor Yellow
node --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "Node.js no encontrado" -ForegroundColor Red
    exit 1
}
Write-Host "Node.js disponible" -ForegroundColor Green
Write-Host ""

# Ejecutar migraciones
Write-Host "Ejecutando migraciones..." -ForegroundColor Cyan
Write-Host ""

node server/migrate.js

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Migraciones completadas exitosamente!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Verifica tu aplicacion en:" -ForegroundColor Cyan
    Write-Host "https://erp-afirma-ndaeiqg4mq-uc.a.run.app" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "Error al ejecutar migraciones" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifica:" -ForegroundColor Yellow
    Write-Host "  1. La IP de Cloud SQL permite conexiones desde tu IP" -ForegroundColor Gray
    Write-Host "  2. La contraseña es correcta" -ForegroundColor Gray
    Write-Host "  3. El firewall permite conexiones al puerto 5432" -ForegroundColor Gray
}

Write-Host ""
pause
