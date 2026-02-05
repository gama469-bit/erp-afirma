@echo off
REM Despliegue local de ERP Afirma para producción
REM Este script configura la aplicación en modo producción sin Docker

echo 🚀 Configurando ERP Afirma para Producción Local
echo ================================================

REM Verificar que PostgreSQL esté corriendo
echo 🗄️ Verificando PostgreSQL...
psql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PostgreSQL no está instalado o no está en PATH
    echo    Instala PostgreSQL desde: https://www.postgresql.org/download/windows/
    pause
    exit /b 1
) else (
    echo ✅ PostgreSQL está disponible
)

REM Verificar/crear base de datos
echo 🔧 Configurando base de datos...
psql -U postgres -c "CREATE DATABASE \"BD_afirma\";" 2>nul
if %errorlevel% equ 0 (
    echo ✅ Base de datos BD_afirma creada
) else (
    echo ℹ️  Base de datos BD_afirma ya existe
)

REM Configurar variables de entorno para producción
echo 🌐 Configurando variables de entorno...
set NODE_ENV=production
set DB_HOST=localhost
set DB_PORT=5432
set DB_NAME=BD_afirma
set DB_USER=postgres
set DB_PASSWORD=Sistemas1
set API_PORT=3000

REM Instalar/actualizar dependencias
echo 📦 Instalando dependencias de producción...
npm ci --production

REM Ejecutar migraciones
echo 🔄 Ejecutando migraciones de base de datos...
npm run migrate

if %errorlevel% neq 0 (
    echo ❌ Error ejecutando migraciones
    pause
    exit /b 1
)

REM Instalar PM2 si no está instalado
echo 🔧 Verificando PM2...
pm2 --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Instalando PM2...
    npm install -g pm2
) else (
    echo ✅ PM2 ya está instalado
)

REM Detener procesos anteriores
echo 🛑 Deteniendo procesos anteriores...
pm2 stop ecosystem.config.js 2>nul
pm2 delete ecosystem.config.js 2>nul

REM Iniciar aplicación con PM2
echo 🚀 Iniciando aplicación en modo producción...
pm2 start ecosystem.config.js --env production

if %errorlevel% neq 0 (
    echo ❌ Error iniciando con PM2
    echo 🔄 Intentando inicio directo...
    start "ERP Afirma API" node server/index.js
    timeout /t 3 /nobreak >nul
)

REM Mostrar estado
echo.
echo 📊 Estado de la aplicación:
pm2 status

echo.
echo 🎉 ERP Afirma configurado para producción!
echo.
echo 📍 Aplicación disponible en:
echo    🌐 http://localhost:3000
echo.
echo 📋 Comandos útiles:
echo    Ver estado:     pm2 status
echo    Ver logs:       pm2 logs
echo    Reiniciar:      pm2 restart ecosystem.config.js
echo    Detener:        pm2 stop ecosystem.config.js
echo.
echo 🔧 Para acceso externo, configura:
echo    - Firewall: Puerto 3000
echo    - Router: Port forwarding 3000
echo    - DNS: A record apuntando a tu IP pública
echo.

pause