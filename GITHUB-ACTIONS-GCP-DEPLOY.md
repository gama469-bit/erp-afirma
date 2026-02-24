# 🚀 Deploy con GitHub Actions → GCP Cloud Run

## 📋 Requisitos Previos

- Cuenta de GCP con proyecto creado
- Cloud SQL PostgreSQL instanciado (`erp-afirma-db`)
- Repository en GitHub
- `gcloud` CLI instalado localmente

---

## 🔑 Paso 1: Crear Service Account en GCP (5 minutos)

### 1.1 Habilitar APIs
```bash
gcloud services enable \
  cloudbuild.googleapis.com \
  run.googleapis.com \
  sqladmin.googleapis.com \
  secretmanager.googleapis.com \
  containerregistry.googleapis.com \
  iam.googleapis.com
```

### 1.2 Crear Service Account
```bash
export PROJECT_ID="tu-project-id"
export SA_NAME="github-actions-sa"

gcloud iam service-accounts create $SA_NAME \
  --display-name="GitHub Actions Service Account"

SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
echo "Service Account: $SA_EMAIL"
```

### 1.3 Otorgar Permisos
```bash
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/secretmanager.secretAccessor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/cloudsql.client"
```

### 1.4 Crear Workload Identity (SIN JSON key)
```bash
# Crear Workload Identity Pool
gcloud iam workload-identity-pools create "github-pool" \
  --project=$PROJECT_ID \
  --location=global \
  --display-name="GitHub Actions"

# Crear OIDC Provider
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --project=$PROJECT_ID \
  --location=global \
  --workload-identity-pool="github-pool" \
  --display-name="GitHub" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Obtener el WIP name
WIP=$(gcloud iam workload-identity-pools describe "github-pool" \
  --project=$PROJECT_ID \
  --location=global \
  --format='value(name)')

echo "WIP_PROVIDER=$WIP"

# Configurar binding (reemplazar TU_USUARIO/tu-repo)
gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL \
  --project=$PROJECT_ID \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WIP}/attribute.repository/TU_USUARIO/tu-repo"
```

### 1.5 Crear Secret para DB Password
```bash
echo -n "tu_password_postgresql" | \
  gcloud secrets create db-password --data-file=-

# Dar acceso al Service Account
gcloud secrets add-iam-policy-binding db-password \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/secretmanager.secretAccessor"
```

---

## 🐙 Paso 2: Agregar Secrets en GitHub (3 minutos)

Ve a tu repositorio → **Settings** → **Secrets and variables** → **Actions**

Agrega estos 3 secrets:

| Nombre | Valor | Ejemplo |
|--------|-------|---------|
| `GCP_PROJECT_ID` | Tu Project ID | `my-erp-afirma-12345` |
| `WI_PROVIDER` | URL del Workload Identity Provider | `projects/12345/locations/global/workloadIdentityPools/github-pool/providers/github-provider` |
| `WI_SERVICE_ACCOUNT` | Email del Service Account | `github-actions-sa@my-erp-afirma-12345.iam.gserviceaccount.com` |

---

## ✅ Paso 3: Verificar Configuración

En tu repositorio, el archivo `.github/workflows/deploy.yml` **ya está actualizado** con:

✅ Tests automáticos  
✅ Build Docker  
✅ Push a Container Registry  
✅ Deploy a Cloud Run  
✅ Soporte para `main` y `staging`

---

## 🎬 Paso 4: Hacer Primer Deploy

### Opción A: Deploy Manual (Recomendado para probar)
```bash
# En tu máquina local
git checkout main
git pull

# Hacer un cambio pequeño (cualquiera)
echo "# Deploy test" >> README.md
git add README.md
git commit -m "test: GitHub Actions deployment"
git push origin main
```

### Opción B: Disparar workflow manualmente
En GitHub:
1. Ve a **Actions**
2. Click en **Deploy to GCP Cloud Run**
3. Click en **Run workflow**
4. Selecciona **main** branch
5. Click **Run workflow**

---

## 📊 Monitoreo

### Ver logs del deployment
En GitHub → **Actions** → **Deploy to GCP Cloud Run**

Click en el último run y expande los jobs

### Ver logs de Cloud Run
```bash
gcloud run services logs read erp-afirma --limit=50
```

### Ver URL del servicio
```bash
gcloud run services describe erp-afirma --region=us-central1 \
  --format='value(status.url)'
```

### Probar la API
```bash
curl https://erp-afirma.run.app/api/health
# Response: {"status":"ok"}
```

---

## 🔀 Branches y Ambientes

| Branch | Destino | Automático |
|--------|---------|-----------|
| `main` | erp-afirma (prod) | ✅ Sí |
| `staging` | erp-afirma-staging | ✅ Sí |
| `feature/*` | Sin deploy | ❌ No |

**Workflow:**
```
feature branch → PR a staging
        ↓
    Test automático
        ↓
    Merge a staging
        ↓
    Deploy automático a staging
        ↓
    Testing manual
        ↓
    PR a main
        ↓
    Deploy automático a production
```

---

## 🚨 Troubleshooting

### Error: "Permission denied"
```
Error: User does not have permission 'run.services.update'
```
**Solución:** Verificar que el Service Account tiene rol `roles/run.admin`
```bash
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:*github-actions-sa*"
```

### Error: "Docker image cannot be pulled"
```
Error: Unable to pull Docker image
```
**Solución:** Verificar que la imagen se subió a Container Registry
```bash
gcloud container images list --repository=gcr.io/$PROJECT_ID
```

### Error: "Cloud SQL connection timeout"
```
Error: timeout connecting to database
```
**Solución:** Verificar que Cloud SQL tiene IP pública y acceso configurado

### Workflow tarda mucho (>15 min)
Normal en primer deploy (descarga de dependencias). Próximos deploys serán más rápidos.

---

## 🔐 Seguridad

✅ No hay credenciales en el código  
✅ Usa Workload Identity Federation (no JSON keys)  
✅ Secretos en Google Secret Manager  
✅ Service Account con permisos mínimos  

---

## 📈 Próximos Pasos Opcionales

### 1. Configurar Rollback Automático
```yaml
# Agregar al deploy.yml si un health check falla
- name: Rollback on failure
  if: failure()
  run: |
    gcloud run services update-traffic erp-afirma \
      --to-revisions PREVIOUS=100
```

### 2. Agregar Notificaciones en Slack
Agregar secret `SLACK_WEBHOOK_URL` y:
```yaml
- name: Notify Slack
  if: always()
  run: |
    curl -X POST ${{ secrets.SLACK_WEBHOOK_URL }} \
      -d '{"text":"Deployment completed"}'
```

### 3. Automatizar Migraciones
```yaml
- name: Run migrations
  run: |
    # Crear job en Cloud Run para ejecutar migraciones
    gcloud run jobs create migrate-${{ github.sha }} \
      --image gcr.io/$PROJECT_ID/erp-afirma:${{ github.sha }} \
      --command npm \
      --args run,migrate
```

---

## 📞 Verificación Final

Ejecuta esto para confirmar que todo está configurado:

```bash
# 1. Verificar GCP
gcloud run services list --region=us-central1

# 2. Verificar Cloud SQL
gcloud sql instances describe erp-afirma-db

# 3. Verificar secrets
gcloud secrets list

# 4. Verificar Container Registry
gcloud container images list --repository=gcr.io/$PROJECT_ID

# 5. Verificar GitHub Secrets
# (Ve a GitHub Settings → Secrets)
```

---

## ✨ ¡Listo!

Tu proyecto ahora tiene desplegues automáticos. 

Cada vez que hagas `git push origin main`, automáticamente:
1. ✅ Tests ejecutan
2. ✅ Docker image se construye
3. ✅ Se sube a Container Registry
4. ✅ Se deploya a Cloud Run
5. ✅ Health checks validan

**Tiempo total:** ~10-15 minutos

---

**Más información:** Ver `FIX-FOREIGN-KEY-CONSTRAINT.md` para resolver problemas de BD
