# Script para configurar deployment automático a GCP
# Uso: .\setup-github-deploy.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SETUP: GitHub Actions → GCP Deploy" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Variables
$PROJECT_ID = "erp-afirma-solutions"
$SA_NAME = "github-actions-deploy"
$SA_EMAIL = "$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"
$GCLOUD = "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd"
$KEY_DIR = "$env:USERPROFILE\Desktop\gcp-keys"
$KEY_FILE = "$KEY_DIR\github-actions-key.json"

# Verificar que gcloud existe
if (!(Test-Path $GCLOUD)) {
    Write-Host "❌ ERROR: gcloud no encontrado en $GCLOUD" -ForegroundColor Red
    exit 1
}

Write-Host "📋 Proyecto: $PROJECT_ID" -ForegroundColor Yellow
Write-Host "🔑 Service Account: $SA_EMAIL" -ForegroundColor Yellow
Write-Host ""

# Paso 1: Crear Service Account
Write-Host "Paso 1/5: Creando Service Account..." -ForegroundColor Cyan
try {
    $result = & $GCLOUD iam service-accounts create $SA_NAME `
        --display-name="GitHub Actions Deployment" `
        --project=$PROJECT_ID 2>&1
    
    if ($LASTEXITCODE -eq 0 -or $result -like "*already exists*") {
        Write-Host "✅ Service Account creado/existente" -ForegroundColor Green
    } else {
        throw $result
    }
} catch {
    Write-Host "⚠️ Service Account posiblemente ya existe (continuando...)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2

# Paso 2: Otorgar permisos
Write-Host ""
Write-Host "Paso 2/5: Otorgando permisos..." -ForegroundColor Cyan

$roles = @(
    "roles/run.admin",
    "roles/storage.admin",
    "roles/iam.serviceAccountUser"
)

foreach ($role in $roles) {
    Write-Host "  → $role" -ForegroundColor Gray
    & $GCLOUD projects add-iam-policy-binding $PROJECT_ID `
        --member="serviceAccount:$SA_EMAIL" `
        --role=$role `
        --quiet > $null 2>&1
}

Write-Host "✅ Permisos otorgados" -ForegroundColor Green
Start-Sleep -Seconds 2

# Paso 3: Crear directorio y key
Write-Host ""
Write-Host "Paso 3/5: Creando key JSON..." -ForegroundColor Cyan

# Crear directorio
if (!(Test-Path $KEY_DIR)) {
    New-Item -ItemType Directory -Force -Path $KEY_DIR > $null
}

# Eliminar key anterior si existe
if (Test-Path $KEY_FILE) {
    Remove-Item $KEY_FILE -Force
}

# Crear nueva key
& $GCLOUD iam service-accounts keys create $KEY_FILE `
    --iam-account=$SA_EMAIL `
    --project=$PROJECT_ID

if (Test-Path $KEY_FILE) {
    Write-Host "✅ Key creada: $KEY_FILE" -ForegroundColor Green
} else {
    Write-Host "❌ ERROR: No se pudo crear la key" -ForegroundColor Red
    exit 1
}

Start-Sleep -Seconds 2

# Paso 4: Mostrar contenido de la key
Write-Host ""
Write-Host "Paso 4/5: Preparando key para GitHub..." -ForegroundColor Cyan

# Leer contenido
$keyContent = Get-Content $KEY_FILE -Raw

# Copiar al clipboard si está disponible
try {
    Set-Clipboard -Value $keyContent
    Write-Host "✅ Key copiada al portapapeles" -ForegroundColor Green
} catch {
    Write-Host "⚠️ No se pudo copiar al portapapeles (hazlo manualmente)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  📋 CONTENIDO DE LA KEY (copiar esto):" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host $keyContent -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# Paso 5: Instrucciones finales
Write-Host "Paso 5/5: Configurar en GitHub" -ForegroundColor Cyan
Write-Host ""
Write-Host "🔗 Abre este link:" -ForegroundColor Green
Write-Host "   https://github.com/fredy-solis/erp-afirma/settings/secrets/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Sigue estos pasos:" -ForegroundColor Yellow
Write-Host "   1. Click en 'New repository secret'" -ForegroundColor White
Write-Host "   2. Name: GCP_SA_KEY" -ForegroundColor White
Write-Host "   3. Secret: Pega el JSON de arriba (ya está en tu portapapeles)" -ForegroundColor White
Write-Host "   4. Click 'Add secret'" -ForegroundColor White
Write-Host ""

# Preguntar si quiere abrir el navegador
$openBrowser = Read-Host "¿Abrir GitHub en el navegador? (Y/n)"
if ($openBrowser -ne "n" -and $openBrowser -ne "N") {
    Start-Process "https://github.com/fredy-solis/erp-afirma/settings/secrets/actions"
}

Write-Host ""
Write-Host "✅ Después de agregar el secret, prueba el deployment:" -ForegroundColor Green
Write-Host "   git add ." -ForegroundColor Cyan
Write-Host "   git commit -m 'feat: enable automatic deployment'" -ForegroundColor Cyan
Write-Host "   git push origin main" -ForegroundColor Cyan
Write-Host ""

# Ofrecer eliminar la key
Write-Host "🔒 IMPORTANTE: ¿Eliminar la key del disco después de configurar? (recomendado)" -ForegroundColor Yellow
$deleteKey = Read-Host "Presiona ENTER después de configurar el secret en GitHub, o 'N' para mantener la key"

if ($deleteKey -ne "n" -and $deleteKey -ne "N") {
    Remove-Item $KEY_FILE -Force
    Write-Host "✅ Key eliminada del disco" -ForegroundColor Green
} else {
    Write-Host "⚠️ Key guardada en: $KEY_FILE" -ForegroundColor Yellow
    Write-Host "   Recuerda eliminarla después: Remove-Item '$KEY_FILE'" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🎉 ¡Configuración completa!" -ForegroundColor Green
Write-Host ""
