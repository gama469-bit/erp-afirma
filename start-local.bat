@echo off
echo Iniciando ERP Afirma en modo desarrollo local...
echo.

REM Configurar variables de entorno para desarrollo local
set NODE_ENV=development
set DB_HOST=localhost
set DB_PORT=5432
set DB_NAME=BD_afirma
set DB_USER=postgres
set DB_PASSWORD=postgres
set PORT=3000

echo Variables de entorno configuradas:
echo NODE_ENV=%NODE_ENV%
echo DB_HOST=%DB_HOST%
echo PORT=%PORT%
echo.

echo Iniciando servidor...
node server/index.js

pause