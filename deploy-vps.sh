#!/bin/bash

# Script de despliegue para VPS/Servidor propio
# Usar: ./deploy-vps.sh

echo "🚀 Iniciando despliegue en VPS..."

# Detener servicios existentes
echo "📛 Deteniendo servicios existentes..."
pm2 stop ecosystem.config.js 2>/dev/null || echo "No hay servicios PM2 corriendo"

# Actualizar código desde GitHub
echo "📥 Actualizando código desde GitHub..."
git pull origin main

# Instalar/actualizar dependencias
echo "📦 Instalando dependencias..."
npm ci --production

# Ejecutar migraciones
echo "🗄️ Ejecutando migraciones de base de datos..."
npm run migrate

# Iniciar con PM2
echo "🔄 Iniciando aplicación con PM2..."
npm run pm2:start

# Verificar estado
echo "✅ Verificando estado del servicio..."
pm2 status

echo "🎉 Despliegue completado!"
echo "📍 Aplicación disponible en el puerto configurado"