# 🚀 Quick Start: GitHub Actions → GCP Cloud Run

## ⚡ 3 Formas de Hacerlo

### 🤖 Opción 1: Automática (RECOMENDADO - 5 minutos)

Si tienes `gcloud` CLI instalado:

```bash
chmod +x setup-github-actions-gcp.sh
./setup-github-actions-gcp.sh
```

El script hace TODO automáticamente:
- ✅ APIs habilitadas
- ✅ Service Account creado
- ✅ Permisos otorgados
- ✅ Workload Identity configurado
- ✅ Secrets creados

Luego solo agrega los secrets en GitHub

---

### 📖 Opción 2: Manual (10 minutos)

Sigue paso a paso: [GITHUB-ACTIONS-GCP-DEPLOY.md](./GITHUB-ACTIONS-GCP-DEPLOY.md)

---

### 🎯 Opción 3: Copy-Paste Rápido (7 minutos)

```bash
# Variables
export PROJECT_ID="TU_PROJECT_ID"
export GITHUB_REPO="tu-usuario/tu-repo"
export DB_PASSWORD="tu_password_postgresql"
export SA_NAME="github-actions-sa"

# 1️⃣ APIs
gcloud services enable cloudbuild.googleapis.com run.googleapis.com sqladmin.googleapis.com secretmanager.googleapis.com containerregistry.googleapis.com iam.googleapis.com --project=$PROJECT_ID

# 2️⃣ Service Account
gcloud iam service-accounts create $SA_NAME --display-name="GitHub Actions" --project=$PROJECT_ID 2>/dev/null || true
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

# 3️⃣ Permisos
for role in roles/run.admin roles/storage.admin roles/secretmanager.secretAccessor roles/cloudsql.client; do
  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="$role" --quiet --project=$PROJECT_ID 2>/dev/null || true
done

# 4️⃣ Workload Identity
gcloud iam workload-identity-pools create github-pool --project=$PROJECT_ID --location=global --display-name="GitHub" 2>/dev/null || true
gcloud iam workload-identity-pools providers create-oidc github-provider --project=$PROJECT_ID --location=global --workload-identity-pool=github-pool --display-name="GitHub" --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" --issuer-uri="https://token.actions.githubusercontent.com" 2>/dev/null || true

WIP=$(gcloud iam workload-identity-pools describe github-pool --project=$PROJECT_ID --location=global --format='value(name)')

gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL --project=$PROJECT_ID --role="roles/iam.workloadIdentityUser" --member="principalSet://iam.googleapis.com/${WIP}/attribute.repository/${GITHUB_REPO}" --quiet 2>/dev/null || true

# 5️⃣ Secret
echo -n "$DB_PASSWORD" | gcloud secrets create db-password --data-file=- --project=$PROJECT_ID 2>/dev/null || echo -n "$DB_PASSWORD" | gcloud secrets versions add db-password --data-file=- --project=$PROJECT_ID

gcloud secrets add-iam-policy-binding db-password --member="serviceAccount:$SA_EMAIL" --role="roles/secretmanager.secretAccessor" --project=$PROJECT_ID --quiet 2>/dev/null || true

# 6️⃣ Mostrar valores para GitHub Secrets
echo ""
echo "Agrega estos SECRETS en GitHub:"
echo "GCP_PROJECT_ID: $PROJECT_ID"
echo "WI_PROVIDER: $WIP"
echo "WI_SERVICE_ACCOUNT: $SA_EMAIL"
```

---

## 📝 Luego en GitHub

1. Ve a **Settings** → **Secrets and variables** → **Actions**
2. Click en **New repository secret** (3 veces)
3. Agrega:
   - `GCP_PROJECT_ID` = tu-project-id
   - `WI_PROVIDER` = proyecto/locations/...
   - `WI_SERVICE_ACCOUNT` = github-actions-sa@...

---

## 🎬 Hacer Primer Deploy

```bash
# Opción A: Manual
git checkout main
echo "test" >> README.md
git add .
git commit -m "test: github actions"
git push origin main

# Opción B: GitHub UI
# Actions → Deploy to GCP Cloud Run → Run workflow
```

Espera ~10-15 minutos → ¡Deployed! 🎉

---

## 🔍 Monitoreo

```bash
# Ver logs
gcloud run services logs read erp-afirma --limit=50

# Ver URL
gcloud run services describe erp-afirma --region=us-central1 --format='value(status.url)'

# Probar
curl https://erp-afirma.run.app/api/health
```

---

## ❌ Si Falla

### Error: "Permission denied"
```bash
# Verificar permisos
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:*github-actions-sa*"
```

### Error: "Workload Identity not found"
Re-ejecuta los pasos de Workload Identity

### Error: "Cloud SQL connection"
Verifica que Cloud SQL tiene IP pública:
```bash
gcloud sql instances describe erp-afirma-db \
  --format='value(ipAddresses[0].ipAddress)'
```

---

## 📈 Flujo de Trabajo

```
feature branch
    ↓ (git push)
Tests en GitHub Actions
    ↓ (si pasan)
Build Docker
    ↓
Push a Container Registry
    ↓
Deploy a Cloud Run
    ↓
Health Checks
    ↓
✅ LIVE!
```

---

## ✨ Branches Automáticos

| Push a | Destino | Auto-Deploy |
|--------|---------|------------|
| `main` | erp-afirma (prod) | ✅ Sí |
| `staging` | erp-afirma-staging | ✅ Sí |
| `feature/*` | - | ❌ No |

---

## 🎯 Próximo Paso

**Elige UNA opción y ejecuta ahora:**

### Si tienes gcloud instalado (RECOMENDADO):
```bash
./setup-github-actions-gcp.sh
```

### Si no tienes gcloud:
Lee [GITHUB-ACTIONS-GCP-DEPLOY.md](./GITHUB-ACTIONS-GCP-DEPLOY.md) y sigue manualmente

---

**¡Despliegues automáticos en minutos! 🚀**
