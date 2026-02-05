# Script para iniciar solo la API del ERP Afirma
Write-Host "🚀 Iniciando API ERP Afirma..." -ForegroundColor Green
Write-Host ""

# Configurar variables de entorno para la API
$env:NODE_ENV = "development"
$env:DB_HOST = "localhost"
$env:DB_PORT = "5432"
$env:DB_NAME = "BD_afirma"
$env:DB_USER = "postgres"
$env:DB_PASSWORD = "Sistemas1"
$env:PORT = "3000"

Write-Host "📋 Variables de entorno API:" -ForegroundColor Yellow
Write-Host "NODE_ENV: $env:NODE_ENV" -ForegroundColor Cyan
Write-Host "PORT: $env:PORT" -ForegroundColor Cyan
Write-Host "DB_HOST: $env:DB_HOST" -ForegroundColor Cyan
Write-Host ""

Write-Host "🌐 API iniciándose..." -ForegroundColor Green
Write-Host "API disponible en: http://localhost:3000" -ForegroundColor Magenta
Write-Host ""

# Iniciar API
cd server
node index.js