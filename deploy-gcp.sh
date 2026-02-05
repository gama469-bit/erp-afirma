#!/bin/bash
# Script de despliegue para Google Cloud Platform
# Requisitos: gcloud CLI instalado y autenticado

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración (EDITAR ESTOS VALORES)
PROJECT_ID="erp-afirma-solutions"
REGION="us-central1" 
DB_INSTANCE_NAME="erp-afirma-db"
SERVICE_NAME="erp-afirma"
DB_PASSWORD="Sistemas1"echo -e "${BLUE}🚀 Desplegando ERP Afirma en Google Cloud${NC}"
echo "======================================"

# Verificar que gcloud esté instalado
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI no está instalado${NC}"
    echo "Instala desde: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Configurar proyecto
echo -e "${YELLOW}📋 Configurando proyecto...${NC}"
gcloud config set project $PROJECT_ID
gcloud config set run/region $REGION

# Habilitar APIs necesarias
echo -e "${YELLOW}🔧 Habilitando APIs necesarias...${NC}"
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable secretmanager.googleapis.com

# Crear instancia de Cloud SQL (PostgreSQL)
echo -e "${YELLOW}🗄️ Creando instancia de PostgreSQL...${NC}"
gcloud sql instances create $DB_INSTANCE_NAME \
    --database-version=POSTGRES_15 \
    --tier=db-f1-micro \
    --region=$REGION \
    --authorized-networks=0.0.0.0/0 \
    --backup \
    --enable-bin-log || echo "Instancia ya existe"

# Crear base de datos
echo -e "${YELLOW}📊 Creando base de datos...${NC}"
gcloud sql databases create BD_afirma \
    --instance=$DB_INSTANCE_NAME || echo "Base de datos ya existe"

# Establecer password para usuario postgres
echo -e "${YELLOW}🔑 Configurando password de BD...${NC}"
gcloud sql users set-password postgres \
    --instance=$DB_INSTANCE_NAME \
    --password=$DB_PASSWORD

# Crear secret para password de BD
echo -e "${YELLOW}🔐 Creando secret para password...${NC}"
echo -n "$DB_PASSWORD" | gcloud secrets create db-password --data-file=- || \
echo -n "$DB_PASSWORD" | gcloud secrets versions add db-password --data-file=-

# Construir imagen Docker
echo -e "${YELLOW}🐳 Construyendo imagen Docker...${NC}"
gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME \
    --dockerfile=Dockerfile.cloudrun

# Desplegar en Cloud Run
echo -e "${YELLOW}🚀 Desplegando en Cloud Run...${NC}"

# Actualizar archivo de configuración con valores reales
sed -i "s/TU_PROJECT_ID/$PROJECT_ID/g" cloudrun-service.yaml
sed -i "s/REGION/$REGION/g" cloudrun-service.yaml
sed -i "s/INSTANCE_NAME/$DB_INSTANCE_NAME/g" cloudrun-service.yaml

# Aplicar configuración
gcloud run services replace cloudrun-service.yaml

# Permitir tráfico no autenticado
gcloud run services add-iam-policy-binding $SERVICE_NAME \
    --member="allUsers" \
    --role="roles/run.invoker"

# Obtener URL del servicio
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --format="value(status.url)")

echo -e "${GREEN}✅ Despliegue completado!${NC}"
echo ""
echo -e "${BLUE}📍 Tu aplicación está disponible en:${NC}"
echo -e "${GREEN}🌐 $SERVICE_URL${NC}"
echo ""
echo -e "${YELLOW}📋 Próximos pasos:${NC}"
echo "1. Ejecutar migraciones: gcloud run jobs execute migrate-job"
echo "2. Configurar dominio personalizado (opcional)"
echo "3. Configurar monitoreo y alertas"
echo ""
echo -e "${BLUE}🔧 Comandos útiles:${NC}"
echo "Ver logs: gcloud run services logs tail $SERVICE_NAME"
echo "Escalar: gcloud run services update $SERVICE_NAME --max-instances=20"
echo "Ver métricas: gcloud monitoring dashboards list"