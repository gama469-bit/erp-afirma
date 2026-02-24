#!/bin/bash
# 🚀 Script Automatizado: Configurar GitHub Actions + GCP Cloud Run
# 
# Uso: ./setup-github-actions-gcp.sh
# Requisitos: gcloud CLI instalado y autenticado

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 GitHub Actions + GCP Cloud Run Setup${NC}"
echo "=========================================="

# 1️⃣ Verificar gcloud
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI no está instalado${NC}"
    echo "   Instala desde: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

echo -e "${GREEN}✅ gcloud CLI encontrado${NC}"

# 2️⃣ Obtener Project ID
echo ""
echo -e "${YELLOW}📋 Configuración${NC}"
read -p "Ingresa tu GCP Project ID: " PROJECT_ID
read -p "Ingresa tu GitHub usuario/repo (ej: fredy/erp-afirma): " GITHUB_REPO
read -p "Ingresa tu DB password (actual): " DB_PASSWORD

export PROJECT_ID
export GITHUB_REPO
export SA_NAME="github-actions-sa"
export SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo ""
echo -e "${BLUE}📊 Resumen:${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  GitHub Repo: $GITHUB_REPO"
echo "  Service Account: $SA_EMAIL"

# 3️⃣ Habilitar APIs
echo ""
echo -e "${YELLOW}🔧 Habilitando APIs...${NC}"
gcloud services enable \
  cloudbuild.googleapis.com \
  run.googleapis.com \
  sqladmin.googleapis.com \
  secretmanager.googleapis.com \
  containerregistry.googleapis.com \
  iam.googleapis.com \
  --project=$PROJECT_ID

echo -e "${GREEN}✅ APIs habilitadas${NC}"

# 4️⃣ Crear Service Account
echo ""
echo -e "${YELLOW}🔐 Creando Service Account...${NC}"

gcloud iam service-accounts create $SA_NAME \
  --display-name="GitHub Actions Service Account" \
  --project=$PROJECT_ID \
  2>/dev/null || echo "⚠️ Service Account ya existe"

echo -e "${GREEN}✅ Service Account: $SA_EMAIL${NC}"

# 5️⃣ Otorgar permisos
echo ""
echo -e "${YELLOW}👥 Otorgando permisos...${NC}"

for role in \
  "roles/run.admin" \
  "roles/storage.admin" \
  "roles/secretmanager.secretAccessor" \
  "roles/cloudsql.client" \
  "roles/cloudbuild.builds.editor"
do
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="$role" \
    --quiet \
    --project=$PROJECT_ID 2>/dev/null || true
done

echo -e "${GREEN}✅ Permisos otorgados${NC}"

# 6️⃣ Crear Workload Identity
echo ""
echo -e "${YELLOW}🔑 Configurando Workload Identity Federation...${NC}"

gcloud iam workload-identity-pools create "github-pool" \
  --project=$PROJECT_ID \
  --location=global \
  --display-name="GitHub Actions" \
  2>/dev/null || echo "⚠️ Pool ya existe"

gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --project=$PROJECT_ID \
  --location=global \
  --workload-identity-pool="github-pool" \
  --display-name="GitHub" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  2>/dev/null || echo "⚠️ Provider ya existe"

WIP=$(gcloud iam workload-identity-pools describe "github-pool" \
  --project=$PROJECT_ID \
  --location=global \
  --format='value(name)')

gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL \
  --project=$PROJECT_ID \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WIP}/attribute.repository/${GITHUB_REPO}" \
  --quiet 2>/dev/null || echo "⚠️ IAM binding ya existe"

echo -e "${GREEN}✅ Workload Identity configurado${NC}"

# 7️⃣ Crear Secret
echo ""
echo -e "${YELLOW}🔓 Creando secret de BD...${NC}"

echo -n "$DB_PASSWORD" | gcloud secrets create db-password \
  --data-file=- \
  --project=$PROJECT_ID \
  2>/dev/null || \
echo -n "$DB_PASSWORD" | gcloud secrets versions add db-password \
  --data-file=- \
  --project=$PROJECT_ID

gcloud secrets add-iam-policy-binding db-password \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/secretmanager.secretAccessor" \
  --project=$PROJECT_ID \
  --quiet 2>/dev/null || true

echo -e "${GREEN}✅ Secret creado${NC}"

# 8️⃣ Mostrar resumen
echo ""
echo -e "${GREEN}=========================================="
echo "✅ CONFIGURACIÓN COMPLETADA"
echo "==========================================${NC}"
echo ""
echo "📋 Ahora agrega estos SECRETS en GitHub:"
echo "   Settings → Secrets and variables → Actions"
echo ""
echo -e "${YELLOW}Secret 1: GCP_PROJECT_ID${NC}"
echo "  Valor: $PROJECT_ID"
echo ""
echo -e "${YELLOW}Secret 2: WI_PROVIDER${NC}"
echo "  Valor: $WIP"
echo ""
echo -e "${YELLOW}Secret 3: WI_SERVICE_ACCOUNT${NC}"
echo "  Valor: $SA_EMAIL"
echo ""
echo -e "${BLUE}🚀 Una vez agregados los secrets:${NC}"
echo "  1. git push origin main"
echo "  2. Ve a GitHub Actions"
echo "  3. Observa el deployment automático"
echo ""
echo -e "${BLUE}📚 Más info:${NC}"
echo "  Ver: GITHUB-ACTIONS-GCP-DEPLOY.md"
