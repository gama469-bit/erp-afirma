# 🌐 Guía de Despliegue en Google Cloud Platform

## 📋 Índice
1. [Prerequisitos](#prerequisitos)
2. [Configuración inicial](#configuracion)
3. [Despliegue automático](#automatico)
4. [Despliegue manual](#manual)
5. [Configuración de dominio](#dominio)
6. [Monitoreo y mantenimiento](#monitoreo)

---

## 🔧 Prerequisitos {#prerequisitos}

### 1. Cuenta de Google Cloud
- Crear cuenta en: https://cloud.google.com/
- Habilitar facturación (necesaria para Cloud SQL)
- Obtener $300 de créditos gratuitos (nuevas cuentas)

### 2. Instalar Google Cloud CLI

**Windows:**
```powershell
# Descargar e instalar desde:
# https://cloud.google.com/sdk/docs/install

# O usar PowerShell:
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")
& $env:Temp\GoogleCloudSDKInstaller.exe
```

**Linux/Mac:**
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

### 3. Autenticación
```bash
# Inicializar y autenticar
gcloud init

# Seleccionar o crear proyecto
gcloud projects create tu-erp-afirma --name="ERP Afirma"
gcloud config set project tu-erp-afirma
```

---

## ⚙️ Configuración inicial {#configuracion}

### 1. Editar archivos de configuración

**deploy-gcp.bat** (Windows) o **deploy-gcp.sh** (Linux):
```bash
# Cambiar estas variables por tus valores:
PROJECT_ID="tu-project-id"           # ID único de tu proyecto
REGION="us-central1"                 # Región más cercana
DB_INSTANCE_NAME="erp-afirma-db"     # Nombre de tu BD
SERVICE_NAME="erp-afirma"            # Nombre del servicio
DB_PASSWORD="tu_password_seguro"     # Password fuerte
```

### 2. Configurar facturación
```bash
# Listar cuentas de facturación
gcloud billing accounts list

# Vincular proyecto a facturación
gcloud billing projects link tu-project-id \
    --billing-account=XXXXXX-XXXXXX-XXXXXX
```

---

## 🚀 Despliegue automático {#automatico}

### Opción A: Windows
```powershell
# Ejecutar script de despliegue
.\deploy-gcp.bat
```

### Opción B: Linux/Mac
```bash
# Hacer ejecutable y correr
chmod +x deploy-gcp.sh
./deploy-gcp.sh
```

### ¿Qué hace el script automático?
1. ✅ Habilita APIs necesarias
2. ✅ Crea instancia de PostgreSQL
3. ✅ Configura base de datos y usuario
4. ✅ Construye imagen Docker
5. ✅ Despliega en Cloud Run
6. ✅ Configura acceso público
7. ✅ Te da la URL final

---

## 🔨 Despliegue manual {#manual}

### Paso 1: Habilitar APIs
```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable secretmanager.googleapis.com
```

### Paso 2: Crear base de datos
```bash
# Crear instancia PostgreSQL
gcloud sql instances create erp-afirma-db \
    --database-version=POSTGRES_15 \
    --tier=db-f1-micro \
    --region=us-central1 \
    --backup

# Crear base de datos
gcloud sql databases create BD_afirma \
    --instance=erp-afirma-db

# Configurar password
gcloud sql users set-password postgres \
    --instance=erp-afirma-db \
    --password=TU_PASSWORD_SEGURO
```

### Paso 3: Crear secrets
```bash
# Crear secret para password de BD
echo -n "TU_PASSWORD_SEGURO" | gcloud secrets create db-password --data-file=-
```

### Paso 4: Construir y desplegar
```bash
# Construir imagen
gcloud builds submit --tag gcr.io/tu-project-id/erp-afirma \
    --dockerfile=Dockerfile.cloudrun

# Desplegar en Cloud Run
gcloud run deploy erp-afirma \
    --image gcr.io/tu-project-id/erp-afirma \
    --platform managed \
    --region=us-central1 \
    --allow-unauthenticated \
    --set-env-vars NODE_ENV=production,DB_HOST=/cloudsql/tu-project-id:us-central1:erp-afirma-db,DB_NAME=BD_afirma,DB_USER=postgres \
    --set-secrets DB_PASSWORD=db-password:latest \
    --add-cloudsql-instances tu-project-id:us-central1:erp-afirma-db \
    --memory=512Mi \
    --cpu=1 \
    --max-instances=10
```

### Paso 5: Ejecutar migraciones
```bash
# Opción A: Cloud Shell
gcloud cloud-shell ssh --command="
  cd /tmp && 
  git clone https://github.com/tu-usuario/erp-afirma.git && 
  cd erp-afirma && 
  npm install && 
  DB_HOST=/cloudsql/tu-project-id:us-central1:erp-afirma-db DB_NAME=BD_afirma DB_USER=postgres DB_PASSWORD=TU_PASSWORD npm run migrate
"

# Opción B: Cloud Run Job (recomendado)
gcloud run jobs create migrate-job \
    --image gcr.io/tu-project-id/erp-afirma \
    --command=npm \
    --args=run,migrate \
    --set-env-vars NODE_ENV=production,DB_HOST=/cloudsql/tu-project-id:us-central1:erp-afirma-db,DB_NAME=BD_afirma,DB_USER=postgres \
    --set-secrets DB_PASSWORD=db-password:latest \
    --add-cloudsql-instances tu-project-id:us-central1:erp-afirma-db

gcloud run jobs execute migrate-job
```

---

## 🌍 Configuración de dominio {#dominio}

### 1. Dominio personalizado
```bash
# Mapear dominio
gcloud run domain-mappings create \
    --service=erp-afirma \
    --domain=tu-dominio.com

# Verificar configuración DNS requerida
gcloud run domain-mappings describe \
    --domain=tu-dominio.com
```

### 2. Configurar DNS
```
# En tu proveedor de DNS, agregar:
CNAME: www.tu-dominio.com -> ghs.googlehosted.com
A: tu-dominio.com -> [IP que Google Cloud te proporcione]
```

### 3. SSL automático
Google Cloud maneja SSL automáticamente para dominios verificados.

---

## 📊 Monitoreo y mantenimiento {#monitoreo}

### Ver logs
```bash
# Logs en tiempo real
gcloud run services logs tail erp-afirma

# Logs por período
gcloud run services logs read erp-afirma \
    --since="2024-01-01" \
    --until="2024-01-31"
```

### Escalar aplicación
```bash
# Aumentar instancias máximas
gcloud run services update erp-afirma \
    --max-instances=50

# Configurar CPU y memoria
gcloud run services update erp-afirma \
    --cpu=2 \
    --memory=1Gi
```

### Monitoreo y alertas
```bash
# Crear política de alerta para errores
gcloud alpha monitoring policies create \
    --policy-from-file=monitoring-policy.yaml
```

### Backup de base de datos
```bash
# Backup manual
gcloud sql export sql erp-afirma-db \
    gs://tu-bucket/backup-$(date +%Y%m%d).sql \
    --database=BD_afirma

# Backup automático (ya configurado en la instancia)
gcloud sql instances patch erp-afirma-db \
    --backup-start-time=03:00
```

---

## 💰 Costos estimados

**Para aplicación pequeña/mediana:**
- **Cloud Run**: ~$5-15/mes (depende del tráfico)
- **Cloud SQL (db-f1-micro)**: ~$7/mes
- **Storage**: ~$1-3/mes
- **Network**: ~$1-5/mes

**Total estimado: $15-30/mes**

---

## 🔧 Comandos útiles

```bash
# Estado del servicio
gcloud run services list

# Detalles del servicio
gcloud run services describe erp-afirma

# Revisar configuración
gcloud config list

# Ver facturación
gcloud billing accounts list
gcloud billing budgets list

# Limpiar recursos (CUIDADO)
gcloud run services delete erp-afirma
gcloud sql instances delete erp-afirma-db
```

---

## 🆘 Troubleshooting

### Error de conexión a BD
```bash
# Verificar que Cloud SQL esté corriendo
gcloud sql instances describe erp-afirma-db

# Verificar conectividad
gcloud sql connect erp-afirma-db --user=postgres
```

### Error de memoria
```bash
# Aumentar memoria
gcloud run services update erp-afirma --memory=1Gi
```

### Error de timeout
```bash
# Aumentar timeout
gcloud run services update erp-afirma --timeout=300
```

### Logs de error
```bash
# Ver logs de errores específicos
gcloud run services logs read erp-afirma --filter="severity>=ERROR"
```

---

## 📚 Recursos adicionales

- **Documentación oficial**: https://cloud.google.com/run/docs
- **Calculadora de costos**: https://cloud.google.com/products/calculator
- **Mejores prácticas**: https://cloud.google.com/run/docs/best-practices
- **Monitoreo**: https://cloud.google.com/monitoring/docs