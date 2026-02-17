# Script para iniciar ERP Afirma en modo desarrollo local
Write-Host "🚀 Iniciando ERP Afirma en modo desarrollo local..." -ForegroundColor Green
Write-Host ""

# Configurar variables de entorno para desarrollo local
$env:NODE_ENV = "development"
$env:DB_HOST = "localhost"
$env:DB_PORT = "5432"
$env:DB_NAME = "BD_afirma"
$env:DB_USER = "postgres"
$env:DB_PASSWORD = "Sistemas1"
$env:PORT = "3000"
$env:FRONTEND_PORT = "8082"
$env:API_PORT = "3000"

Write-Host "📋 Variables de entorno configuradas:" -ForegroundColor Yellow
Write-Host "NODE_ENV: $env:NODE_ENV" -ForegroundColor Cyan
Write-Host "DB_HOST: $env:DB_HOST" -ForegroundColor Cyan
Write-Host "PORT: $env:PORT" -ForegroundColor Cyan
Write-Host ""

Write-Host "🌐 Iniciando servidor..." -ForegroundColor Green
Write-Host "Accede a: http://localhost:3000" -ForegroundColor Magenta
Write-Host ""

# Iniciar servidor (usando api.js que tiene autenticación real)
node server/api.js