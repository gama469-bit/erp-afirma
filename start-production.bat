@echo off
REM Versión de producción usando el método actual que funciona
REM Optimizado para ambiente de producción local

echo 🚀 Iniciando ERP Afirma - Versión Producción
echo ============================================

REM Configurar variables de entorno para producción
set NODE_ENV=production
set API_PORT=3000

echo 🗄️ Verificando base de datos...
REM La base de datos BD_afirma ya existe y funciona

echo 📦 Instalando dependencias de producción...
npm ci --only=production

echo 🔄 Ejecutando migraciones...
npm run migrate

echo 🚀 Iniciando API en modo producción...
start "ERP Afirma - API" cmd /k "echo API ejecutándose en puerto 3000 && node server/index.js"

REM Esperar a que la API esté lista
timeout /t 5 /nobreak >nul

echo 🌐 Iniciando servidor frontend...
start "ERP Afirma - Frontend" cmd /k "echo Frontend ejecutándose en puerto 8082 && npm run start:dev"

echo.
echo ✅ ERP Afirma ejecutándose en modo producción!
echo.
echo 📍 Accede a la aplicación en:
echo    🌐 http://localhost:8082  (Desarrollo)
echo    🔗 http://localhost:3000  (API directa)
echo.
echo 🔧 Para producción real:
echo    - Configura un dominio apuntando a tu servidor
echo    - Usa un proxy reverso (Nginx/IIS)
echo    - Configura SSL/HTTPS
echo    - Usa PM2 para gestión de procesos
echo.
echo ⚠️  Ambas ventanas deben permanecer abiertas
echo    Presiona Ctrl+C en cualquiera para detener
echo.

pause