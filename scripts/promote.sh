#!/bin/bash
# Script para gestionar despliegues PRE y PROD en GCP
# Uso: ./promote.sh [validate-pre|promote|rollback]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
PROJECT="erp-afirma-solutions"
REGION="us-central1"
SERVICE_PRE="erp-afirma-pre"
SERVICE_PROD="erp-afirma"
IMAGE="gcr.io/erp-afirma-solutions/erp-afirma:latest"

# Funciones
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

check_pre_health() {
    print_header "Validando PRE-PRODUCCIÓN"
    
    # Obtener URL
    PRE_URL=$(gcloud run services describe $SERVICE_PRE --region=$REGION --format="value(status.url)" 2>/dev/null)
    echo "URL PRE: $PRE_URL"
    
    # Verificar health
    if curl -s "$PRE_URL/api/health" > /dev/null 2>&1; then
        print_success "API Health: RESPONDE"
    else
        print_error "API Health: NO RESPONDE"
        return 1
    fi
    
    # Verificar logs recientes
    echo ""
    echo "Últimos 10 logs:"
    gcloud run services logs read $SERVICE_PRE --region=$REGION --limit 10 | head -10
    
    # Verificar errores
    ERROR_COUNT=$(gcloud run services logs read $SERVICE_PRE --region=$REGION --limit 100 | grep -c "Error" || echo "0")
    if [ $ERROR_COUNT -gt 0 ]; then
        print_warning "Se encontraron $ERROR_COUNT errores en los últimos 100 logs"
        return 1
    else
        print_success "Sin errores detectados"
    fi
    
    return 0
}

promote_to_prod() {
    print_header "Promoviendo de PRE a PRODUCCIÓN"
    
    # Validar PRE primero
    if ! check_pre_health; then
        print_error "Validación de PRE falló. Abortando promoción."
        return 1
    fi
    
    echo ""
    print_warning "Esta acción desplegará cambios a PRODUCCIÓN"
    echo "Servicios afectados: $SERVICE_PROD"
    read -p "¿Continuar? (s/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_warning "Promoción cancelada"
        return 1
    fi
    
    print_header "Desplegando a PRODUCCIÓN"
    
    gcloud run deploy $SERVICE_PROD \
        --image $IMAGE \
        --region=$REGION \
        --platform=managed \
        --allow-unauthenticated \
        --memory=512Mi \
        --cpu=1 \
        --max-instances=10 \
        --set-env-vars="NODE_ENV=production,DB_NAME=BD_afirma,DB_USER=postgres,DB_PORT=5432" \
        --set-cloudsql-instances="$PROJECT:$REGION:erp-afirma-db"
    
    print_success "Despliegue a PRODUCCIÓN completado"
    
    # Mostrar nueva revisión
    echo ""
    echo "Detalles:"
    gcloud run services describe $SERVICE_PROD --region=$REGION --format="value(status.url)"
}

rollback_prod() {
    print_header "ROLLBACK de PRODUCCIÓN"
    
    # Listar revisiones
    echo "Revisiones disponibles:"
    gcloud run revisions list --service=$SERVICE_PROD --region=$REGION --limit 5 --format="table(NAME,ACTIVE)"
    
    echo ""
    read -p "Ingresa el nombre de la revisión para rollback: " REVISION
    
    if [ -z "$REVISION" ]; then
        print_error "Revisión no especificada"
        return 1
    fi
    
    print_warning "Realizando rollback a: $REVISION"
    read -p "¿Continuar? (s/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_warning "Rollback cancelado"
        return 1
    fi
    
    gcloud run services update-traffic $SERVICE_PROD \
        --to-revisions=$REVISION=100 \
        --region=$REGION
    
    print_success "Rollback completado"
}

get_status() {
    print_header "Estado Actual de Servicios"
    
    echo -e "${BLUE}PRE-PRODUCCIÓN:${NC}"
    PRE_URL=$(gcloud run services describe $SERVICE_PRE --region=$REGION --format="value(status.url)")
    PRE_REV=$(gcloud run services describe $SERVICE_PRE --region=$REGION --format="value(status.latestReadyRevisionName)")
    echo "  URL: $PRE_URL"
    echo "  Revisión: $PRE_REV"
    
    echo ""
    echo -e "${BLUE}PRODUCCIÓN:${NC}"
    PROD_URL=$(gcloud run services describe $SERVICE_PROD --region=$REGION --format="value(status.url)")
    PROD_REV=$(gcloud run services describe $SERVICE_PROD --region=$REGION --format="value(status.latestReadyRevisionName)")
    echo "  URL: $PROD_URL"
    echo "  Revisión: $PROD_REV"
    
    echo ""
    echo -e "${BLUE}BASE DE DATOS:${NC}"
    gcloud sql instances describe erp-afirma-db --format="table(state,databaseVersion)"
}

compare_envs() {
    print_header "Comparación de Ambientes"
    
    echo "PRE-PRODUCCIÓN:"
    gcloud run services describe $SERVICE_PRE --region=$REGION --format="value(spec.template.spec.containers[0].env)" | tr ',' '\n'
    
    echo ""
    echo "PRODUCCIÓN:"
    gcloud run services describe $SERVICE_PROD --region=$REGION --format="value(spec.template.spec.containers[0].env)" | tr ',' '\n'
}

# Procesamiento de argumentos
case "${1:-status}" in
    validate-pre)
        check_pre_health
        ;;
    promote)
        promote_to_prod
        ;;
    rollback)
        rollback_prod
        ;;
    status)
        get_status
        ;;
    compare)
        compare_envs
        ;;
    *)
        echo "Uso: $0 {validate-pre|promote|rollback|status|compare}"
        echo ""
        echo "Comandos:"
        echo "  validate-pre  - Validar salud de PRE-PRODUCCIÓN"
        echo "  promote       - Promocionar de PRE a PRODUCCIÓN (después de validar)"
        echo "  rollback      - Revertir PRODUCCIÓN a revisión anterior"
        echo "  status        - Ver estado actual de ambos servicios"
        echo "  compare       - Comparar configuración entre ambientes"
        exit 1
        ;;
esac
