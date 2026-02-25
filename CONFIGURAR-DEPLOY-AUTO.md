# 🚀 Configurar Deployment Automático a GCP

## ✅ ¿Qué hace el deployment automático?

Cada vez que hagas `git push` a la rama `main`:
1. GitHub Actions construirá automáticamente la imagen Docker
2. La subirá a Google Container Registry
3. Desplegará la nueva versión a Cloud Run
4. Verificará que el deployment sea exitoso

**Tiempo estimado de configuración: 10 minutos**

---

## 📋 Paso 1: Crear Service Account en GCP (3 minutos)

Abre PowerShell y ejecuta estos comandos:

```powershell
# Definir variables
$PROJECT_ID = "erp-afirma-solutions"
$SA_NAME = "github-actions-deploy"

# Crear Service Account
& "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" iam service-accounts create $SA_NAME --display-name="GitHub Actions Deployment" --project=$PROJECT_ID

# Email del Service Account
$SA_EMAIL = "$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"
Write-Host "Service Account creado: $SA_EMAIL" -ForegroundColor Green
```

---

## 🔑 Paso 2: Otorgar Permisos (2 minutos)

```powershell
# Permisos para Cloud Run
& "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/run.admin"

# Permisos para Storage (Container Registry)
& "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/storage.admin"

# Permisos para Service Account User
& "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/iam.serviceAccountUser"

Write-Host "✅ Permisos otorgados" -ForegroundColor Green
```

---

## 🔐 Paso 3: Crear y Descargar Key JSON (1 minuto)

```powershell
# Crear directorio temporal
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\Desktop\gcp-keys"

# Crear key
& "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" iam service-accounts keys create "$env:USERPROFILE\Desktop\gcp-keys\github-actions-key.json" --iam-account=$SA_EMAIL --project=$PROJECT_ID

Write-Host "✅ Key creada en: $env:USERPROFILE\Desktop\gcp-keys\github-actions-key.json" -ForegroundColor Green
Write-Host "⚠️ IMPORTANTE: Esta key da acceso completo. No la compartas." -ForegroundColor Yellow
```

---

## 📁 Paso 4: Configurar Secret en GitHub (3 minutos)

### 4.1 Abrir el archivo JSON

```powershell
notepad "$env:USERPROFILE\Desktop\gcp-keys\github-actions-key.json"
```

**Copia TODO el contenido del archivo** (desde `{` hasta `}`)

### 4.2 Ir a GitHub

1. Abre: https://github.com/gama469-bit/erp-afirma/settings/secrets/actions
2. Click en **"New repository secret"**
3. Name: `GCP_SA_KEY`
4. Secret: **Pega todo el JSON que copiaste**
5. Click **"Add secret"**

✅ **¡Listo!** El secret está configurado.

---

## 🧪 Paso 5: Probar el Deployment Automático (2 minutos)

### Opción A: Hacer un cambio mínimo

```powershell
# Hacer un cambio pequeño en README
Add-Content -Path "README.md" -Value "`n<!-- Deploy test $(Get-Date) -->"

# Commit y push
git add README.md
git commit -m "test: trigger automatic deployment"
git push origin main
```

### Opción B: Trigger manual desde GitHub

1. Ve a: https://github.com/gama469-bit/erp-afirma/actions
2. Click en **"Deploy to GCP Cloud Run"**
3. Click en **"Run workflow"**
4. Selecciona branch **"main"**
5. Click **"Run workflow"**

---

## 📊Verificar que funciona

1. Ve a: https://github.com/gama469-bit/erp-afirma/actions
2. Deberías ver un workflow ejecutándose (círculo amarillo 🟡)
3. Espera 3-5 minutos
4. Si todo sale bien, verás un check verde ✅
5. Tu aplicación estará actualizada en: https://erp-afirma-434266349334.us-central1.run.app

---

## 🔒 Paso 6: Eliminar la Key Local (IMPORTANTE)

Una vez que el deployment funcione, **ELIMINA** el archivo JSON de tu escritorio:

```powershell
Remove-Item "$env:USERPROFILE\Desktop\gcp-keys\github-actions-key.json"
Write-Host "✅ Key eliminada por seguridad" -ForegroundColor Green
```

---

## ❓ Troubleshooting

### Error: "Permission denied"
- Verifica que otorgaste los 3 roles (run.admin, storage.admin, iam.serviceAccountUser)
- Espera 1-2 minutos para que los permisos se propaguen

### Error: "Invalid credentials"
- Verifica que copiaste TODO el JSON (desde `{` hasta `}`)
- No debe tener espacios extras al inicio o final

### Error: "Image not found"
- El workflow está construyendo la imagen correctamente
- Verifica los logs en GitHub Actions

### Deployment exitoso pero app no funciona
- Verifica que las variables de entorno estén correctas en el workflow
- Revisa los logs en Cloud Run: https://console.cloud.google.com/run

---

## 🎉 ¡Todo listo!

Ahora cada vez que hagas push a `main`:
- ✅ Se desplegará automáticamente a producción
- ✅ Recibirás notificación si falla
- ✅ Podrás ver logs detallados en GitHub Actions

**Próximos pasos opcionales:**
- Configurar notificaciones de Slack/Discord para deployments
- Agregar tests automatizados antes del deploy
- Configurar ambiente de staging

---

**Fecha:** 25 de Febrero, 2026  
**Estado:** ✅ Configuración simplificada con Service Account Key
