@echo off
REM Script de despliegue para Windows VPS
REM Usar: deploy-windows.bat

echo 🚀 Iniciando despliegue en Windows VPS...

REM Detener servicios existentes
echo 📛 Deteniendo servicios existentes...
pm2 stop ecosystem.config.js 2>nul

REM Actualizar código desde GitHub
echo 📥 Actualizando código desde GitHub...
git pull origin main

REM Instalar/actualizar dependencias
echo 📦 Instalando dependencias...
npm ci --production

REM Ejecutar migraciones
echo 🗄️ Ejecutando migraciones de base de datos...
npm run migrate

REM Iniciar con PM2
echo 🔄 Iniciando aplicación con PM2...
npm run pm2:start

REM Verificar estado
echo ✅ Verificando estado del servicio...
pm2 status

echo 🎉 Despliegue completado!
echo 📍 Aplicación disponible en el puerto configurado
pause