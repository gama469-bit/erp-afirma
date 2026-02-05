# Script para iniciar el frontend del ERP Afirma
Write-Host "🎨 Iniciando Frontend ERP Afirma..." -ForegroundColor Green
Write-Host ""

# Configurar variables de entorno para el frontend
$env:NODE_ENV = "development"
$env:FRONTEND_PORT = "8082"
$env:API_PORT = "3000"

Write-Host "📋 Variables de entorno Frontend:" -ForegroundColor Yellow
Write-Host "FRONTEND_PORT: $env:FRONTEND_PORT" -ForegroundColor Cyan
Write-Host "API_PORT: $env:API_PORT" -ForegroundColor Cyan
Write-Host ""

Write-Host "🌐 Frontend iniciándose..." -ForegroundColor Green
Write-Host "Frontend disponible en: http://localhost:8082" -ForegroundColor Magenta
Write-Host ""

# Iniciar Frontend
cd server
node frontend.js