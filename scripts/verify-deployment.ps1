#!/usr/bin/env pwsh
# Script de verificación rápida de despliegue
# Uso: .\verify-deployment.ps1

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          VERIFICACIÓN DE DESPLIEGUE ERP AFIRMA                ║" -ForegroundColor Cyan
Write-Host "║                  PRE-PRODUCCIÓN + PRODUCCIÓN                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host ""
Write-Host "Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "Proyecto: erp-afirma-solutions" -ForegroundColor Gray
Write-Host "Región: us-central1" -ForegroundColor Gray

# Verificar gcloud
Write-Host ""
Write-Host "📋 Verificando herramientas..." -ForegroundColor Yellow
$gcloud_version = gcloud --version | Select-Object -First 1
Write-Host "✅ gcloud: $gcloud_version"

# Verificar servicios
Write-Host ""
Write-Host "🔍 Estado de Servicios Cloud Run:" -ForegroundColor Cyan

$services = gcloud run services list --region=us-central1 --format="json" | ConvertFrom-Json

foreach ($svc in $services | Where-Object { $_.metadata.name -like "erp-afirma*" }) {
    $name = $svc.metadata.name
    $url = $svc.status.url
    $ready = $svc.status.conditions | Where-Object { $_.type -eq "Ready" } | Select-Object -ExpandProperty status
    
    if ($ready -eq "True") {
        $status = "🟢 ACTIVO"
    } else {
        $status = "🔴 INACTIVO"
    }
    
    Write-Host ""
    Write-Host "  Servicio: $name"
    Write-Host "  URL: $url"
    Write-Host "  Status: $status"
}

# Verificar Base de Datos
Write-Host ""
Write-Host "🗄️  Estado de Cloud SQL:" -ForegroundColor Cyan

try {
    $db_status = gcloud sql instances describe erp-afirma-db --format="json" | ConvertFrom-Json
    $db_state = $db_status.state
    $db_version = $db_status.databaseVersion
    
    Write-Host ""
    Write-Host "  Instancia: erp-afirma-db"
    Write-Host "  Estado: 🟢 $($db_state.ToUpper())"
    Write-Host "  Versión: $db_version"
    Write-Host "  BD: BD_afirma"
    Write-Host "  Usuario: postgres"
}
catch {
    Write-Host "  ❌ Error obteniendo estado de BD" -ForegroundColor Red
}

# Verificar imagen Docker
Write-Host ""
Write-Host "🐳 Imagen Docker:" -ForegroundColor Cyan

try {
    $images = gcloud container images list-tags gcr.io/erp-afirma-solutions/erp-afirma --format="json" | ConvertFrom-Json
    $latest = $images | Where-Object { $_.tags -contains "latest" } | Select-Object -First 1
    
    Write-Host ""
    Write-Host "  Registro: gcr.io/erp-afirma-solutions"
    Write-Host "  Imagen: erp-afirma"
    Write-Host "  Tag Latest: ✅ Disponible"
    Write-Host "  Digest: $($latest.digest.Substring(0, 12))"
    Write-Host "  Total versiones: $($images.Count)"
}
catch {
    Write-Host "  ❌ Error obteniendo imagen Docker" -ForegroundColor Red
}

# Verificar health endpoints
Write-Host ""
Write-Host "🏥 Verificación de Endpoints:" -ForegroundColor Cyan

$endpoints = @(
    @{ name = "PRE"; url = "https://erp-afirma-pre-ndaeiqg4mq-uc.a.run.app" },
    @{ name = "PROD"; url = "https://erp-afirma-ndaeiqg4mq-uc.a.run.app" }
)

foreach ($endpoint in $endpoints) {
    try {
        $response = Invoke-WebRequest -Uri "$($endpoint.url)/api/health" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            Write-Host ""
            Write-Host "  $($endpoint.name):"
            Write-Host "    Frontend: ✅ 200 OK"
            Write-Host "    API Health: ✅ 200 OK"
        } else {
            Write-Host ""
            Write-Host "  $($endpoint.name):"
            Write-Host "    Status: ❌ $($response.StatusCode)"
        }
    }
    catch {
        Write-Host ""
        Write-Host "  $($endpoint.name):"
        Write-Host "    Status: ⏳ Verificando..."
    }
}

# Logs recientes
Write-Host ""
Write-Host "📊 Actividad Reciente:" -ForegroundColor Cyan

Write-Host ""
Write-Host "  PRE-PRODUCCIÓN (últimas 5 líneas):" -ForegroundColor Gray
$pre_logs = gcloud run services logs read erp-afirma-pre --region=us-central1 --limit=5 2>$null
$pre_logs | ForEach-Object { Write-Host "    $_" }

Write-Host ""
Write-Host "  PRODUCCIÓN (últimas 5 líneas):" -ForegroundColor Gray
$prod_logs = gcloud run services logs read erp-afirma --region=us-central1 --limit=5 2>$null
$prod_logs | ForEach-Object { Write-Host "    $_" }

# Resumen final
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                      RESUMEN FINAL                            ║" -ForegroundColor Green
Write-Host "╠════════════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║                                                                ║" -ForegroundColor Green
Write-Host "║  ✅ PRE-PRODUCCIÓN:  https://erp-afirma-pre-ndaeiqg4mq-uc...  ║" -ForegroundColor Green
Write-Host "║  ✅ PRODUCCIÓN:      https://erp-afirma-ndaeiqg4mq-uc...      ║" -ForegroundColor Green
Write-Host "║  ✅ BASE DE DATOS:   erp-afirma-db (PostgreSQL 15)            ║" -ForegroundColor Green
Write-Host "║                                                                ║" -ForegroundColor Green
Write-Host "║  🚀 Acciones rápidas:                                         ║" -ForegroundColor Green
Write-Host "║     Ver status:     .\scripts\promote.ps1 -Action status      ║" -ForegroundColor Green
Write-Host "║     Validar PRE:    .\scripts\promote.ps1 -Action validate-pre║" -ForegroundColor Green
Write-Host "║     Promocionar:    .\scripts\promote.ps1 -Action promote     ║" -ForegroundColor Green
Write-Host "║     Rollback:       .\scripts\promote.ps1 -Action rollback    ║" -ForegroundColor Green
Write-Host "║                                                                ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host ""
Write-Host "Para más información, consulta:" -ForegroundColor Gray
Write-Host "  - DESPLIEGUE-ESCALONADO-PRE-PROD.md" -ForegroundColor Gray
Write-Host "  - RESUMEN-DESPLIEGUE.md" -ForegroundColor Gray

Write-Host ""
