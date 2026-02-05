# 📚 Referencia Rápida - Comandos Útiles

## 🚀 Acciones Principales

### Ver Estado Actual
```powershell
# Windows PowerShell
.\scripts\promote.ps1 -Action status

# Linux/Mac Bash
./scripts/promote.sh status
```

### Validar PRE antes de Promocionar
```powershell
.\scripts\promote.ps1 -Action validate-pre
./scripts/promote.sh validate-pre
```

### Promocionar a PRODUCCIÓN
```powershell
.\scripts\promote.ps1 -Action promote
./scripts/promote.sh promote
```

### Revertir PRODUCCIÓN
```powershell
.\scripts\promote.ps1 -Action rollback
./scripts/promote.sh rollback
```

---

## 🔍 Diagnóstico y Monitoreo

### Ver Estado de Servicios
```bash
gcloud run services list --region us-central1
gcloud run services describe erp-afirma --region us-central1
gcloud run services describe erp-afirma-pre --region us-central1
```

### Ver Logs en Vivo

**PRE-PRODUCCIÓN:**
```bash
gcloud run services logs read erp-afirma-pre --region us-central1 --follow
```

**PRODUCCIÓN:**
```bash
gcloud run services logs read erp-afirma --region us-central1 --follow
```

**Últimas N líneas:**
```bash
gcloud run services logs read erp-afirma --region us-central1 --limit 50
```

### Ver Revisiones
```bash
gcloud run revisions list --service=erp-afirma --region us-central1
gcloud run revisions list --service=erp-afirma-pre --region us-central1
```

### Ver Base de Datos
```bash
gcloud sql instances describe erp-afirma-db
gcloud sql databases list --instance=erp-afirma-db
```

---

## 🔧 Operaciones de Actualización

### Actualizar Variables de Entorno
```bash
# Actualizar una variable
gcloud run services update erp-afirma \
  --region us-central1 \
  --update-env-vars KEY=VALUE

# Actualizar múltiples
gcloud run services update erp-afirma \
  --region us-central1 \
  --update-env-vars KEY1=VALUE1,KEY2=VALUE2
```

### Actualizar Límites de Instancias
```bash
# Aumentar a 20 instancias máximo
gcloud run services update erp-afirma \
  --region us-central1 \
  --max-instances=20

# Establecer instancia mínima
gcloud run services update erp-afirma \
  --region us-central1 \
  --min-instances=1
```

### Actualizar Límite de Tiempo
```bash
# Aumentar timeout a 600 segundos
gcloud run services update erp-afirma \
  --region us-central1 \
  --timeout=600
```

### Cambiar Imagen Docker
```bash
# Desplegar nueva versión
gcloud run deploy erp-afirma \
  --image gcr.io/erp-afirma-solutions/erp-afirma:v2 \
  --region us-central1
```

---

## 🔀 Gestión de Tráfico

### Split de Tráfico (Canary Deployment)
```bash
# 90% a revisión actual, 10% a nueva
gcloud run services update-traffic erp-afirma \
  --to-revisions=erp-afirma-00017-ttx=90,erp-afirma-00018-abc=10 \
  --region us-central1
```

### Cambiar a Revisión Anterior
```bash
# Cambiar 100% a revisión anterior
gcloud run services update-traffic erp-afirma \
  --to-revisions=erp-afirma-00016-xyz=100 \
  --region us-central1
```

### Cambiar a Latest
```bash
gcloud run services update-traffic erp-afirma \
  --to-latest \
  --region us-central1
```

---

## 🐳 Gestión de Docker

### Listar Imágenes
```bash
gcloud container images list
gcloud container images list-tags gcr.io/erp-afirma-solutions/erp-afirma
```

### Etiquetar Nueva Imagen
```bash
docker tag erp-afirma gcr.io/erp-afirma-solutions/erp-afirma:v2
docker push gcr.io/erp-afirma-solutions/erp-afirma:v2
```

### Eliminar Imagen (¡CUIDADO!)
```bash
gcloud container images delete gcr.io/erp-afirma-solutions/erp-afirma:old-tag --quiet
```

---

## 🗄️ Operaciones de Base de Datos

### Crear Backup Manual
```bash
gcloud sql backups create --instance=erp-afirma-db
```

### Listar Backups
```bash
gcloud sql backups list --instance=erp-afirma-db
```

### Restaurar desde Backup
```bash
gcloud sql backups restore BACKUP_ID \
  --backup-configuration=default \
  --instance=erp-afirma-db
```

### Ejecutar Migraciones
```bash
# Conectar a la BD
gcloud sql connect erp-afirma-db --user=postgres

# O via Cloud SQL Proxy
cloud_sql_proxy -instances=erp-afirma-solutions:us-central1:erp-afirma-db=tcp:5432
```

---

## 📊 Métricas y Facturas

### Ver Facturación
```bash
gcloud billing accounts list
gcloud billing budgets list
```

### Costos Estimados
```bash
gcloud compute instances list --zones=us-central1 --format="table(name,zone,machineType,status)" --filter="name:erp-afirma"
```

### Ver Uso de Servicios
```bash
gcloud compute usage-records list
```

---

## 🔐 Seguridad

### Habilitar Autenticación en PRE
```bash
gcloud run deploy erp-afirma-pre \
  --no-allow-unauthenticated \
  --region us-central1
```

### Agregar Política de Seguridad (Cloud Armor)
```bash
gcloud compute security-policies create erp-afirma-policy \
  --type CLOUD_ARMOR

gcloud compute security-policies rules create 1000 \
  --security-policy erp-afirma-policy \
  --action=allow
```

### Ver y Gestionar Secretos
```bash
gcloud secrets list
gcloud secrets create db-password --data-file=- < password.txt
gcloud secrets versions access latest --secret=db-password
```

---

## 🎯 Troubleshooting

### El servicio no responde
```bash
# 1. Ver estado
gcloud run services describe erp-afirma --region us-central1

# 2. Ver logs de error
gcloud run services logs read erp-afirma --region us-central1 --limit 100 | grep -i error

# 3. Verificar conectividad a BD
gcloud sql instances describe erp-afirma-db

# 4. Reiniciar tráfico
gcloud run services update-traffic erp-afirma --to-latest --region us-central1
```

### Problema de Conexión a BD
```bash
# Ver errores de conexión
gcloud run services logs read erp-afirma --region us-central1 | grep -i "connection\|timeout"

# Verificar que la BD está corriendo
gcloud sql instances describe erp-afirma-db --format="value(state)"

# Verificar credenciales
gcloud sql users list --instance=erp-afirma-db
```

### Cloud Run Scale a Cero (Sin Tráfico)
```bash
# Esto es NORMAL. Cloud Run escala a cero cuando no hay tráfico.
# No hay acción necesaria.
# Se escala automáticamente cuando llega una request.
```

---

## 📋 Tareas Programadas

### Crear Job de Backup Automático
```bash
gcloud scheduler jobs create app-engine backup-db \
  --schedule="0 2 * * *" \
  --http-method=POST \
  --uri="https://www.googleapis.com/sql/v1/projects/PROJECT/instances/erp-afirma-db/backups"
```

### Crear Job de Salud
```bash
gcloud scheduler jobs create app-engine health-check \
  --schedule="*/5 * * * *" \
  --http-method=GET \
  --uri="https://erp-afirma-ndaeiqg4mq-uc.a.run.app/api/health"
```

---

## 💡 Tips y Mejores Prácticas

### 1. Usar Aliases para Comandos Largos
```bash
# En tu .bashrc o PowerShell profile
alias gcp-status="gcloud run services list --region us-central1"
alias gcp-logs="gcloud run services logs read erp-afirma --region us-central1 --follow"
alias gcp-promote=".\scripts\promote.ps1"
```

### 2. Guardar Configuración por Defecto
```bash
gcloud config set project erp-afirma-solutions
gcloud config set run/region us-central1
gcloud config set core/account tu@email.com
```

### 3. Usar Output JSON para Scripting
```bash
gcloud run services describe erp-afirma --format=json | jq '.status.url'
```

### 4. Automatizar con Cloud Build
```bash
# Crear trigger automático para rama develop
gcloud builds triggers create github \
  --name=deploy-to-pre \
  --repo-name=tu-repo \
  --branch-pattern="develop" \
  --build-config=cloudbuild.yaml
```

---

## 🎓 Documentación Relacionada

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Cloud SQL Documentation](https://cloud.google.com/sql/docs)
- [gcloud CLI Reference](https://cloud.google.com/sdk/gcloud/reference)
- [Container Registry Documentation](https://cloud.google.com/container-registry/docs)

---

## 📞 Soporte

**Comando para obtener ayuda:**
```bash
# Ayuda general de gcloud
gcloud --help

# Ayuda específica
gcloud run --help
gcloud run services --help
gcloud run deploy --help
```

---

**Última actualización:** Febrero 4, 2026

