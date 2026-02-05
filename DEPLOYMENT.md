# 🚀 Guía de Despliegue a Producción

## Índice
1. [Preparación del Repositorio GitHub](#github)
2. [Despliegue en Heroku](#heroku)
3. [Despliegue en VPS propio](#vps)
4. [Despliegue con Docker](#docker)
5. [Configuración de Dominio](#dominio)

## 📂 Preparación del Repositorio GitHub {#github}

### Paso 1: Inicializar repositorio Git

```bash
# Inicializar Git (si no está ya)
git init

# Agregar todos los archivos
git add .

# Hacer commit inicial
git commit -m "Initial commit: ERP Afirma system"

# Crear repositorio en GitHub (desde la web)
# Luego conectar:
git remote add origin https://github.com/tu-usuario/erp-afirma.git
git branch -M main
git push -u origin main
```

### Paso 2: Configurar variables de entorno

```bash
# Copiar archivo de ejemplo
cp .env.example .env

# Editar .env con valores de producción
# IMPORTANTE: No subir .env a GitHub (ya está en .gitignore)
```

---

## 🌐 Despliegue en Heroku {#heroku}

### Prerequisitos
- Cuenta en Heroku
- Heroku CLI instalado

```bash
# Instalar Heroku CLI
npm install -g heroku

# Login en Heroku
heroku login

# Crear aplicación
heroku create tu-erp-afirma

# Agregar addon de PostgreSQL
heroku addons:create heroku-postgresql:mini

# Configurar variables de entorno
heroku config:set NODE_ENV=production
heroku config:set DB_SSL=true

# Desplegar
git push heroku main

# Ejecutar migraciones
heroku run npm run migrate

# Abrir aplicación
heroku open
```

### Deploy automático desde GitHub
1. Ve a Heroku Dashboard
2. Conecta tu repositorio GitHub
3. Habilita "Automatic deploys" desde la rama `main`

---

## 🖥️ Despliegue en VPS propio {#vps}

### Prerequisitos en el servidor
```bash
# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar PM2
sudo npm install -g pm2

# Instalar PostgreSQL
sudo apt update
sudo apt install postgresql postgresql-contrib

# Configurar PostgreSQL
sudo -u postgres createuser --interactive
sudo -u postgres createdb BD_afirma
```

### Despliegue
```bash
# Clonar repositorio
git clone https://github.com/tu-usuario/erp-afirma.git
cd erp-afirma

# Instalar dependencias
npm ci --production

# Configurar variables de entorno
cp .env.example .env
nano .env  # Editar con valores correctos

# Ejecutar migraciones
npm run migrate

# Iniciar con PM2
npm run pm2:start

# Configurar PM2 para autostart
pm2 startup
pm2 save
```

### Nginx como proxy reverso
```nginx
server {
    listen 80;
    server_name tu-dominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

---

## 🐳 Despliegue con Docker {#docker}

### Desarrollo local con Docker
```bash
# Construir imagen
npm run docker:build

# Ejecutar con docker-compose
npm run docker:run

# La aplicación estará disponible en http://localhost:3000
```

### Producción con Docker
```bash
# Construir para producción
docker build -t erp-afirma:prod .

# Ejecutar con variables de entorno
docker run -d \
  --name erp-afirma \
  -p 3000:3000 \
  -e NODE_ENV=production \
  -e DB_HOST=tu-db-host \
  -e DB_PASSWORD=tu-password \
  erp-afirma:prod
```

---

## 🌍 Configuración de Dominio {#dominio}

### Configurar DNS
```
A record: @ -> IP_DE_TU_SERVIDOR
CNAME: www -> tu-dominio.com
```

### SSL con Let's Encrypt
```bash
# Instalar Certbot
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot

# Obtener certificado
sudo certbot --nginx -d tu-dominio.com -d www.tu-dominio.com

# Renovación automática
sudo crontab -e
# Agregar: 0 12 * * * /usr/bin/certbot renew --quiet
```

---

## 📋 Checklist Final

- [ ] Código subido a GitHub
- [ ] Variables de entorno configuradas
- [ ] Base de datos creada y migrada
- [ ] SSL configurado (HTTPS)
- [ ] Dominio configurado
- [ ] Monitoreo configurado (PM2/logs)
- [ ] Backup de base de datos programado
- [ ] Firewall configurado (solo puertos necesarios)

---

## 🔧 Comandos útiles

```bash
# Ver logs en tiempo real
pm2 logs

# Reiniciar aplicación
pm2 restart erp-afirma

# Ver estado de servicios
pm2 status

# Backup de base de datos
pg_dump BD_afirma > backup_$(date +%Y%m%d).sql

# Restaurar backup
psql BD_afirma < backup_20231120.sql
```

## 🆘 Troubleshooting

### Error de conexión a BD
- Verificar variables de entorno
- Comprobar que PostgreSQL esté corriendo
- Revisar configuración de firewall

### Error 502 Bad Gateway
- Verificar que la aplicación esté corriendo (pm2 status)
- Revisar logs (pm2 logs)
- Comprobar configuración de Nginx

### Aplicación lenta
- Revisar uso de memoria (pm2 monit)
- Optimizar consultas de base de datos
- Considerar usar cluster mode en PM2