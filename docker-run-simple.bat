@echo off
REM Script para ejecutar ERP Afirma con Docker de forma simple
REM Este script crea y ejecuta la aplicación sin Docker Compose

echo 🐳 Iniciando ERP Afirma con Docker...
echo.

echo 📦 Construyendo imagen de la aplicación...
docker build -t erp-afirma .

if %errorlevel% neq 0 (
    echo ❌ Error construyendo la imagen
    pause
    exit /b 1
)

echo.
echo 🗄️ Iniciando base de datos PostgreSQL...
docker run -d ^
  --name erp-postgres ^
  -e POSTGRES_DB=BD_afirma ^
  -e POSTGRES_USER=postgres ^
  -e POSTGRES_PASSWORD=password123 ^
  -p 5432:5432 ^
  postgres:15

echo.
echo ⏳ Esperando a que PostgreSQL esté listo...
timeout /t 10 /nobreak >nul

echo.
echo 🚀 Iniciando aplicación ERP Afirma...
docker run -d ^
  --name erp-afirma-app ^
  --link erp-postgres:db ^
  -e NODE_ENV=production ^
  -e DB_HOST=db ^
  -e DB_PORT=5432 ^
  -e DB_NAME=BD_afirma ^
  -e DB_USER=postgres ^
  -e DB_PASSWORD=password123 ^
  -p 3000:3000 ^
  erp-afirma

if %errorlevel% neq 0 (
    echo ❌ Error iniciando la aplicación
    pause
    exit /b 1
)

echo.
echo 🎉 ERP Afirma ejecutándose exitosamente!
echo.
echo 📍 Aplicación disponible en: http://localhost:3000
echo.
echo 📋 Comandos útiles:
echo    Ver logs:     docker logs erp-afirma-app -f
echo    Detener todo: docker stop erp-afirma-app erp-postgres
echo    Limpiar:      docker rm erp-afirma-app erp-postgres
echo.

pause