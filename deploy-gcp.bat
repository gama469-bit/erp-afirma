@echo off
REM Script de despliegue para Google Cloud Platform (Windows)
REM Requisitos: gcloud CLI instalado y autenticado

echo 🚀 Desplegando ERP Afirma en Google Cloud
echo ======================================

REM Configuración (EDITAR ESTOS VALORES)
set PROJECT_ID=erp-afirma-solutions
set REGION=us-central1
set DB_INSTANCE_NAME=erp-afirma-db
set SERVICE_NAME=erp-afirma
set DB_PASSWORD=Sistemas1

REM Verificar que gcloud esté instalado
gcloud --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ gcloud CLI no está instalado
    echo Instala desde: https://cloud.google.com/sdk/docs/install
    pause
    exit /b 1
)

echo ✅ gcloud CLI encontrado

REM Configurar proyecto
echo 📋 Configurando proyecto...
gcloud config set project %PROJECT_ID%
gcloud config set run/region %REGION%

REM Habilitar APIs necesarias
echo 🔧 Habilitando APIs necesarias...
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable secretmanager.googleapis.com

REM Crear instancia de Cloud SQL
echo 🗄️ Creando instancia de PostgreSQL...
gcloud sql instances create %DB_INSTANCE_NAME% ^
    --database-version=POSTGRES_15 ^
    --tier=db-f1-micro ^
    --region=%REGION% ^
    --authorized-networks=0.0.0.0/0 ^
    --backup ^
    --enable-bin-log

if %errorlevel% neq 0 (
    echo ℹ️ La instancia probablemente ya existe, continuando...
)

REM Crear base de datos
echo 📊 Creando base de datos...
gcloud sql databases create BD_afirma --instance=%DB_INSTANCE_NAME%

REM Establecer password
echo 🔑 Configurando password de BD...
gcloud sql users set-password postgres ^
    --instance=%DB_INSTANCE_NAME% ^
    --password=%DB_PASSWORD%

REM Crear secret
echo 🔐 Creando secret para password...
echo %DB_PASSWORD%| gcloud secrets create db-password --data-file=-

REM Construir imagen Docker
echo 🐳 Construyendo imagen Docker...
gcloud builds submit --config cloudbuild.yaml .

REM Desplegar en Cloud Run
echo 🚀 Desplegando en Cloud Run...
gcloud run deploy %SERVICE_NAME% ^
    --image gcr.io/%PROJECT_ID%/%SERVICE_NAME% ^
    --platform managed ^
    --region=%REGION% ^
    --allow-unauthenticated ^
    --set-env-vars NODE_ENV=production,DB_HOST=/cloudsql/%PROJECT_ID%:%REGION%:%DB_INSTANCE_NAME%,DB_NAME=BD_afirma,DB_USER=postgres ^
    --set-secrets DB_PASSWORD=db-password:latest ^
    --set-cloudsql-instances %PROJECT_ID%:%REGION%:%DB_INSTANCE_NAME% ^
    --memory=512Mi ^
    --cpu=1 ^
    --max-instances=10

if %errorlevel% neq 0 (
    echo ❌ Error en el despliegue
    pause
    exit /b 1
)

REM Ejecutar migraciones
echo 🗄️ Ejecutando migraciones de base de datos...
gcloud run jobs execute erp-afirma-migrate --region=%REGION%

REM Obtener URL del servicio
echo 📍 Obteniendo URL del servicio...
for /f "tokens=*" %%i in ('gcloud run services describe %SERVICE_NAME% --format="value(status.url)"') do set SERVICE_URL=%%i

echo.
echo ✅ Despliegue completado!
echo.
echo 📍 Tu aplicación está disponible en:
echo 🌐 %SERVICE_URL%
echo.
echo 📋 Próximos pasos:
echo 1. Ejecutar migraciones manualmente desde Cloud Shell
echo 2. Configurar dominio personalizado (opcional)
echo 3. Configurar monitoreo y alertas
echo.
echo 🔧 Comandos útiles:
echo Ver logs: gcloud run services logs tail %SERVICE_NAME%
echo Escalar: gcloud run services update %SERVICE_NAME% --max-instances=20
echo.

pause