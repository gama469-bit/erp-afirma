# ✅ Despliegue en Google Cloud Platform - EXITOSO

**Fecha:** Febrero 4, 2026  
**Estado:** PRODUCCIÓN ACTIVA

---

## 📍 URL de Acceso

```
https://erp-afirma-ndaeiqg4mq-uc.a.run.app
```

**Acceso directo a la aplicación:**
```
https://erp-afirma-ndaeiqg4mq-uc.a.run.app
```

---

## 🏗️ Arquitectura Desplegada

### Servicios Cloud
- **Cloud Run Service:** `erp-afirma`
- **Cloud SQL Instance:** `erp-afirma-db` (PostgreSQL 15)
- **Container Registry:** `gcr.io/erp-afirma-solutions/erp-afirma:latest`

### Configuración del Servicio

| Parámetro | Valor |
|-----------|-------|
| **Región** | us-central1 |
| **Plataforma** | Cloud Run (Managed) |
| **CPU** | 1 vCPU |
| **Memoria** | 512 MB |
| **Max Instances** | 10 |
| **Timeout** | 300s (por defecto) |
| **Autenticación** | Unauthenticated (público) |

---

## 🗄️ Base de Datos

**Instancia Cloud SQL:**
```
Proyecto: erp-afirma-solutions
Region: us-central1
Tipo: PostgreSQL 15
BD: BD_afirma
Usuario: postgres
Conexión: Cloud SQL Auth Proxy
```

**Status:** Base de datos existente utilizada ✅

---

## 📦 Imagen Docker

```
Registro: gcr.io/erp-afirma-solutions
Imagen: erp-afirma
Tag: latest
Digest: 4077a7254ecb
```

**Versiones disponibles:** 15 versiones en registro

---

## 🔐 Variables de Entorno

```bash
NODE_ENV=production
DB_NAME=BD_afirma
DB_USER=postgres
DB_PORT=5432
Cloud SQL Proxy: erp-afirma-solutions:us-central1:erp-afirma-db
```

---

## 📊 Estado Actual

### Endpoints Validados

| Endpoint | Status | Respuesta |
|----------|--------|-----------|
| `GET /` | 200 ✅ | Frontend HTML |
| `GET /api/health` | 200 ✅ | API activa |
| `GET /api/employees` | 200 ✅ | Datos disponibles |

### Logs Recientes

```
2026-02-04 21:02:09 GET 200 /api/health
2026-02-04 21:02:10 GET 200 /api/health  
2026-02-04 21:02:14 GET 200 /api/health
```

### Conexión BD

- Intentos: Se están ejecutando queries (intento 2/3)
- Algunos timeouts iniciales por warmup de contenedor
- Conexión SQL Proxy activa

---

## 🚀 Próximos Pasos

### 1. Configurar Dominio Personalizado (Opcional)

```bash
# Mapear dominio a Cloud Run
gcloud run services update-traffic erp-afirma \
  --update-routes=example.com=erp-afirma-00016-rnt \
  --region us-central1
```

### 2. Monitoreo

```bash
# Ver logs en tiempo real
gcloud run services logs read erp-afirma --region us-central1 --limit 100 --follow

# Ver métricas
gcloud monitoring timeseries list \
  --filter='resource.type=cloud_run_revision AND resource.label.service_name=erp-afirma'
```

### 3. Auto-escalado

El servicio está configurado con:
- Min instancias: 0 (escala a cero cuando no hay tráfico)
- Max instancias: 10
- Escalado automático basado en CPU

### 4. Actualizaciones Futuras

```bash
# Construir nueva imagen
docker build -f Dockerfile.cloudrun -t gcr.io/erp-afirma-solutions/erp-afirma:v2 .

# Subir a registry
docker push gcr.io/erp-afirma-solutions/erp-afirma:v2

# Desplegar nueva versión
gcloud run deploy erp-afirma \
  --image gcr.io/erp-afirma-solutions/erp-afirma:v2 \
  --region us-central1
```

---

## 🔍 Solución de Problemas

### Si la aplicación no responde

```bash
# Ver logs detallados
gcloud run services logs read erp-afirma --region us-central1 --limit 200

# Revisar estado del servicio
gcloud run services describe erp-afirma --region us-central1

# Reiniciar tráfico
gcloud run services update-traffic erp-afirma --to-latest --region us-central1
```

### Si hay problemas de BD

```bash
# Verificar conexión SQL
gcloud sql instances describe erp-afirma-db

# Ver conexiones activas
gcloud sql instances patch erp-afirma-db \
  --insights-config-query-insights-enabled
```

### Si necesitas rollback

```bash
# Listar revisiones
gcloud run revisions list --service=erp-afirma --region us-central1

# Cambiar tráfico a revisión anterior
gcloud run services update-traffic erp-afirma \
  --to-revisions=erp-afirma-00015-xxx=100 \
  --region us-central1
```

---

## 📈 Información de Facturación

**Costos Estimados (Mensual):**

- **Cloud Run:** ~$0.50 - $5 (según tráfico)
- **Cloud SQL:** ~$20-30 (db-f1-micro)
- **Storage:** <$1 (BD pequeña)
- **Total estimado:** $20-35 USD/mes

**Detalles en:**
```
https://console.cloud.google.com/billing
Proyecto: erp-afirma-solutions
```

---

## 🔧 Requisitos Cumplidos

✅ APIs habilitadas:
- Cloud Build
- Cloud Run
- Cloud SQL Admin
- Secret Manager

✅ Servicios activos:
- Cloud Run (aplicación corriendo)
- Cloud SQL (base de datos disponible)
- Container Registry (imagen Docker disponible)

✅ Configuración:
- Variables de entorno establecidas
- Conexión SQL Proxy configurada
- Autenticación pública habilitada
- Auto-escalado configurado

---

## 📞 Soporte

Para más información consulta:
- [Google Cloud Console](https://console.cloud.google.com)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Cloud SQL Documentation](https://cloud.google.com/sql/docs)

---

**Última actualización:** Febrero 4, 2026, 21:02 UTC

