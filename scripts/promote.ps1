# Script de Promoción PRE a PRODUCCIÓN
# Uso: .\promote.ps1 -Action "validate-pre" | "promote" | "rollback" | "status"

param(
    [ValidateSet("validate-pre", "promote", "rollback", "status", "compare")]
    [string]$Action = "status"
)

# Configuración
$PROJECT = "erp-afirma-solutions"
$REGION = "us-central1"
$SERVICE_PRE = "erp-afirma-pre"
$SERVICE_PROD = "erp-afirma"
$IMAGE = "gcr.io/erp-afirma-solutions/erp-afirma:latest"

# Funciones de utilidad
function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host $Text -ForegroundColor Blue
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host ""
}

function Write-Success {
    param([string]$Text)
    Write-Host "✅ $Text" -ForegroundColor Green
}

function Write-Error {
    param([string]$Text)
    Write-Host "❌ $Text" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Text)
    Write-Host "⚠️ $Text" -ForegroundColor Yellow
}

function Validate-PreHealth {
    Write-Header "Validando PRE-PRODUCCIÓN"
    
    try {
        # Obtener URL
        $PRE_URL = gcloud run services describe $SERVICE_PRE --region=$REGION --format="value(status.url)" 2>$null
        Write-Host "URL PRE: $PRE_URL"
        
        # Verificar health
        $response = Invoke-WebRequest -Uri "$PRE_URL/api/health" -UseBasicParsing -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            Write-Success "API Health: RESPONDE"
        } else {
            Write-Error "API Health: NO RESPONDE"
            return $false
        }
        
        # Verificar logs recientes
        Write-Host ""
        Write-Host "Últimos 10 logs:"
        gcloud run services logs read $SERVICE_PRE --region=$REGION --limit 10 | Select-Object -First 10
        
        # Verificar errores
        $logs = gcloud run services logs read $SERVICE_PRE --region=$REGION --limit 100
        $errorCount = ($logs | Where-Object { $_ -match "Error" } | Measure-Object).Count
        
        if ($errorCount -gt 0) {
            Write-Warning "Se encontraron $errorCount errores en los últimos 100 logs"
            return $false
        } else {
            Write-Success "Sin errores detectados"
        }
        
        return $true
    }
    catch {
        Write-Error "Error validando PRE: $_"
        return $false
    }
}

function Promote-ToProd {
    Write-Header "Promoviendo de PRE a PRODUCCIÓN"
    
    # Validar PRE primero
    if (-not (Validate-PreHealth)) {
        Write-Error "Validación de PRE falló. Abortando promoción."
        return
    }
    
    Write-Host ""
    Write-Warning "Esta acción desplegará cambios a PRODUCCIÓN"
    Write-Host "Servicios afectados: $SERVICE_PROD"
    $confirm = Read-Host "¿Continuar? (s/N)"
    
    if ($confirm -ne "s" -and $confirm -ne "S") {
        Write-Warning "Promoción cancelada"
        return
    }
    
    Write-Header "Desplegando a PRODUCCIÓN"
    
    try {
        gcloud run deploy $SERVICE_PROD `
            --image $IMAGE `
            --region=$REGION `
            --platform=managed `
            --allow-unauthenticated `
            --memory=512Mi `
            --cpu=1 `
            --max-instances=10 `
            --set-env-vars="NODE_ENV=production,DB_NAME=BD_afirma,DB_USER=postgres,DB_PORT=5432" `
            --set-cloudsql-instances="$PROJECT`:$REGION`:erp-afirma-db"
        
        Write-Success "Despliegue a PRODUCCIÓN completado"
        
        Write-Host ""
        Write-Host "Detalles:"
        gcloud run services describe $SERVICE_PROD --region=$REGION --format="value(status.url)"
    }
    catch {
        Write-Error "Error durante el despliegue: $_"
    }
}

function Rollback-Prod {
    Write-Header "ROLLBACK de PRODUCCIÓN"
    
    try {
        # Listar revisiones
        Write-Host "Revisiones disponibles:"
        gcloud run revisions list --service=$SERVICE_PROD --region=$REGION --limit 5 --format="table(NAME,ACTIVE)"
        
        Write-Host ""
        $revision = Read-Host "Ingresa el nombre de la revisión para rollback"
        
        if ([string]::IsNullOrEmpty($revision)) {
            Write-Error "Revisión no especificada"
            return
        }
        
        Write-Warning "Realizando rollback a: $revision"
        $confirm = Read-Host "¿Continuar? (s/N)"
        
        if ($confirm -ne "s" -and $confirm -ne "S") {
            Write-Warning "Rollback cancelado"
            return
        }
        
        gcloud run services update-traffic $SERVICE_PROD `
            --to-revisions=$revision=100 `
            --region=$REGION
        
        Write-Success "Rollback completado"
    }
    catch {
        Write-Error "Error durante rollback: $_"
    }
}

function Get-Status {
    Write-Header "Estado Actual de Servicios"
    
    try {
        Write-Host "PRE-PRODUCCIÓN:" -ForegroundColor Blue
        $PRE_URL = gcloud run services describe $SERVICE_PRE --region=$REGION --format="value(status.url)"
        $PRE_REV = gcloud run services describe $SERVICE_PRE --region=$REGION --format="value(status.latestReadyRevisionName)"
        Write-Host "  URL: $PRE_URL"
        Write-Host "  Revisión: $PRE_REV"
        
        Write-Host ""
        Write-Host "PRODUCCIÓN:" -ForegroundColor Blue
        $PROD_URL = gcloud run services describe $SERVICE_PROD --region=$REGION --format="value(status.url)"
        $PROD_REV = gcloud run services describe $SERVICE_PROD --region=$REGION --format="value(status.latestReadyRevisionName)"
        Write-Host "  URL: $PROD_URL"
        Write-Host "  Revisión: $PROD_REV"
        
        Write-Host ""
        Write-Host "BASE DE DATOS:" -ForegroundColor Blue
        gcloud sql instances describe erp-afirma-db --format="table(state,databaseVersion)"
    }
    catch {
        Write-Error "Error obteniendo estado: $_"
    }
}

function Compare-Environments {
    Write-Header "Comparación de Ambientes"
    
    try {
        Write-Host "PRE-PRODUCCIÓN:" -ForegroundColor Blue
        gcloud run services describe $SERVICE_PRE --region=$REGION --format="yaml" | Select-String -Pattern "env:" -A 20
        
        Write-Host ""
        Write-Host "PRODUCCIÓN:" -ForegroundColor Blue
        gcloud run services describe $SERVICE_PROD --region=$REGION --format="yaml" | Select-String -Pattern "env:" -A 20
    }
    catch {
        Write-Error "Error comparando ambientes: $_"
    }
}

# Ejecutar acción
switch ($Action) {
    "validate-pre" { Validate-PreHealth }
    "promote" { Promote-ToProd }
    "rollback" { Rollback-Prod }
    "status" { Get-Status }
    "compare" { Compare-Environments }
    default { 
        Write-Host "Uso: .\promote.ps1 -Action 'validate-pre' | 'promote' | 'rollback' | 'status' | 'compare'"
        Write-Host ""
        Write-Host "Acciones:"
        Write-Host "  validate-pre  - Validar salud de PRE-PRODUCCIÓN"
        Write-Host "  promote       - Promocionar de PRE a PRODUCCIÓN (después de validar)"
        Write-Host "  rollback      - Revertir PRODUCCIÓN a revisión anterior"
        Write-Host "  status        - Ver estado actual de ambos servicios"
        Write-Host "  compare       - Comparar configuración entre ambientes"
    }
}
