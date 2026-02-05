# 🚀 Despliegue Escalonado - PRE y PRODUCCIÓN

**Fecha:** Febrero 4, 2026  
**Estado:** ✅ AMBOS AMBIENTES ACTIVOS

---

## 📍 URLs de Acceso

### PRE-PRODUCCIÓN (Staging)
```
https://erp-afirma-pre-ndaeiqg4mq-uc.a.run.app
```
**Uso:** Testing, validación de features, ambiente seguro antes de producción

### PRODUCCIÓN
```
https://erp-afirma-ndaeiqg4mq-uc.a.run.app
```
**Uso:** Ambiente de usuarios finales en vivo

---

## 🏗️ Arquitectura Distribuida

### Servicio PRE-PRODUCCIÓN
```
Nombre: erp-afirma-pre
Revisión: erp-afirma-pre-00001-z8b
Región: us-central1
Ambiente: NODE_ENV=staging
CPU: 1 vCPU
Memoria: 512 MB
Max Instancias: 5 (menos recursos)
Status: ✅ ACTIVO
```

### Servicio PRODUCCIÓN
```
Nombre: erp-afirma
Revisión: erp-afirma-00017-ttx
Región: us-central1
Ambiente: NODE_ENV=production
CPU: 1 vCPU
Memoria: 512 MB
Max Instancias: 10 (más recursos)
Status: ✅ ACTIVO
```

### Recursos Compartidos
```
Base de Datos: BD_afirma (Cloud SQL)
Imagen Docker: gcr.io/erp-afirma-solutions/erp-afirma:latest
Proyecto: erp-afirma-solutions
```

---

## 📊 Estado Actual

### PRE-PRODUCCIÓN
| Componente | Status |
|-----------|--------|
| Frontend | ✅ 200 OK |
| API Health | ✅ 200 OK |
| Base de Datos | ✅ Conectada |
| Último Request | 2026-02-04 21:05:13 |

### PRODUCCIÓN
| Componente | Status |
|-----------|--------|
| Frontend | ✅ 200 OK |
| API Health | ✅ 200 OK |
| Base de Datos | ✅ Conectada |
| Revisión Actual | 00017-ttx |

---

## 🔄 Flujo de Despliegue Recomendado

```
┌─────────────────────────┐
│   Código Local          │
│   (Desarrollo)          │
└────────────┬────────────┘
             │ git commit & push
             ▼
┌─────────────────────────┐
│   GitHub/GitLab         │
│   (Repositorio)         │
└────────────┬────────────┘
             │ Cloud Build trigger
             ▼
┌─────────────────────────┐
│   Container Registry    │
│   (Docker Image)        │
└────────────┬────────────┘
             │
        ┌────┴────┐
        │          │
        ▼          ▼
  ┌──────────┐  ┌──────────────┐
  │    PRE   │  │  PRODUCCIÓN  │
  │  Cloud   │  │   Cloud      │
  │   Run    │  │    Run       │
  └──────────┘  └──────────────┘
     Testing      En vivo
     Staging      Usuarios
```

---

## ✅ Checklist de Validación PRE-PRODUCCIÓN

Antes de promover a PRODUCCIÓN, validar:

```bash
# 1. Frontend carga correctamente
curl -s https://erp-afirma-pre-ndaeiqg4mq-uc.a.run.app | grep -q "ERP AFIRMA" && echo "✅ Frontend OK"

# 2. API responde
curl -s https://erp-afirma-pre-ndaeiqg4mq-uc.a.run.app/api/health | grep -q "200" && echo "✅ API OK"

# 3. Base de datos conecta
gcloud run services logs read erp-afirma-pre --region us-central1 --limit 50 | grep -q "Query ejecutada"

# 4. No hay errores 500
gcloud run services logs read erp-afirma-pre --region us-central1 --limit 100 | grep "500" || echo "✅ Sin errores 500"
```

---

## 🚀 Promover a PRODUCCIÓN

**Opción A: Manual (Después de validar en PRE)**

```bash
# 1. Validar PRE
gcloud run services logs read erp-afirma-pre --region us-central1 --limit 20

# 2. Si TODO está OK, desplegar la misma imagen a PRODUCCIÓN
gcloud run deploy erp-afirma \
  --image gcr.io/erp-afirma-solutions/erp-afirma:latest \
  --region us-central1 \
  --set-env-vars "NODE_ENV=production,DB_NAME=BD_afirma,DB_USER=postgres,DB_PORT=5432"

# 3. Validar PRODUCCIÓN
curl https://erp-afirma-ndaeiqg4mq-uc.a.run.app/api/health
```

**Opción B: Automática (CI/CD)**

1. Crear webhook en Cloud Build
2. Configurar trigger para:
   - Push a rama `develop` → Deploy a PRE
   - Push a rama `main/master` → Deploy a PROD

---

## 📋 Proceso de Cambios Recomendado

### Flujo Típico:

```
1. Desarrollo
   └─ Crear rama feature/xxx
   └─ Hacer cambios y commit

2. Testing Local
   └─ npm run dev:all
   └─ Validar en http://localhost:8082

3. Push a GitHub
   └─ git push origin feature/xxx
   └─ Crear Pull Request

4. Merge a Develop
   └─ Automático: Deploy a erp-afirma-pre
   └─ Testing en https://erp-afirma-pre-ndaeiqg4mq-uc.a.run.app

5. Merge a Main
   └─ Automático: Deploy a erp-afirma
   └─ En vivo en https://erp-afirma-ndaeiqg4mq-uc.a.run.app

6. Monitoreo
   └─ gcloud run services logs read erp-afirma --region us-central1 --follow
```

---

## 🔙 Rollback (Si algo sale mal)

### Rollback Inmediato en PRODUCCIÓN

```bash
# 1. Ver revisiones anteriores
gcloud run revisions list --service=erp-afirma --region us-central1 --limit 5

# 2. Cambiar tráfico a revisión anterior
gcloud run services update-traffic erp-afirma \
  --to-revisions=erp-afirma-00016-rnt=100 \
  --region us-central1

# 3. Validar
curl https://erp-afirma-ndaeiqg4mq-uc.a.run.app/api/health
```

### Rollback en PRE (Safe)

```bash
gcloud run services update-traffic erp-afirma-pre \
  --to-revisions=<revision-anterior>=100 \
  --region us-central1
```

---

## 📊 Monitoreo en Tiempo Real

### Ver logs en vivo

```bash
# PRE-PRODUCCIÓN
gcloud run services logs read erp-afirma-pre --region us-central1 --follow

# PRODUCCIÓN
gcloud run services logs read erp-afirma --region us-central1 --follow

# Ambos
gcloud run services logs read --region us-central1 --follow | grep -E "erp-afirma"
```

### Métricas

```bash
# Ver tráfico actual
gcloud run services describe erp-afirma --region us-central1 --format=json | jq '.status.traffic'

# Ver últimas 100 líneas con errores
gcloud run services logs read erp-afirma --region us-central1 --limit 100 | grep -i error
```

---

## 🔐 Seguridad y Buenas Prácticas

### ✅ Implementado
- [x] Ambientes separados (PRE y PROD)
- [x] Base de datos compartida pero validada en PRE primero
- [x] AUTO-escalado en ambos
- [x] Cloud SQL Proxy para conexión segura
- [x] Variables de entorno separadas

### 🔒 Recomendaciones Adicionales

```bash
# 1. Proteger PRE con autenticación
gcloud run deploy erp-afirma-pre \
  --image gcr.io/erp-afirma-solutions/erp-afirma:latest \
  --no-allow-unauthenticated \
  --region us-central1

# 2. Usar Cloud Armor para DDoS
gcloud compute security-policies create erp-afirma-policy \
  --type CLOUD_ARMOR

# 3. Habilitar Cloud Trace
gcloud run services update erp-afirma \
  --enable-trace-support \
  --region us-central1

# 4. Configurar alertas
gcloud alpha monitoring policies create \
  --notification-channels=<CHANNEL_ID> \
  --display-name="ERP Afirma - Error Rate"
```

---

## 💰 Costos Estimados (Mensual)

### PRE-PRODUCCIÓN (Max 5 instancias)
- Cloud Run: ~$0.25 - $2
- Cloud SQL: Compartida
- **Total PRE: $0.25 - $2 USD**

### PRODUCCIÓN (Max 10 instancias)
- Cloud Run: ~$0.50 - $5
- Cloud SQL: ~$20-30
- **Total PROD: $20.50 - $35 USD**

**Total Mensual Estimado: $21-37 USD**

---

## 🎯 Próximos Pasos

1. **Configurar CI/CD:**
   ```bash
   # Crear Cloud Build triggers automáticos
   gcloud builds create \
     --name=deploy-to-pre \
     --trigger=github \
     --branch-pattern="develop"
   ```

2. **Agregar dominio personalizado:**
   ```bash
   # Pre: pre.tudominio.com
   # Prod: app.tudominio.com
   ```

3. **Configurar monitoreo:**
   - Alertas en Cloud Monitoring
   - Logs en Cloud Logging
   - Traces en Cloud Trace

4. **Backup automático de BD:**
   ```bash
   gcloud sql backups create --instance=erp-afirma-db
   ```

---

## 📞 Comandos Útiles

### Información General
```bash
gcloud run services list --region us-central1
gcloud run revisions list --service=erp-afirma --region us-central1
gcloud sql instances describe erp-afirma-db
```

### Logs y Debugging
```bash
gcloud run services logs read erp-afirma --region us-central1 --limit 50
gcloud run services logs read erp-afirma-pre --region us-central1 --limit 50
```

### Actualizar
```bash
gcloud run deploy erp-afirma --region us-central1 --update-env-vars KEY=VALUE
```

### Eliminar (¡CUIDADO!)
```bash
gcloud run services delete erp-afirma --region us-central1
gcloud run services delete erp-afirma-pre --region us-central1
```

---

## 📈 Dashboard Recomendado

Crear dashboard en Cloud Console:

```
+──────────────────────────────────────+
│     ERP AFIRMA - Producción          │
├──────────────────────────────────────+
│ Cloud Run Requests/sec: [PRE] [PROD] │
│ Error Rate: [PRE] [PROD]             │
│ Latency: [PRE] [PROD]                │
│ CPU Usage: [PRE] [PROD]              │
│ Memory Usage: [PRE] [PROD]           │
│ Cloud SQL Connections: [ACTIVE]      │
└──────────────────────────────────────+
```

---

**Última actualización:** Febrero 4, 2026, 21:06 UTC  
**Estado:** ✅ PRODUCCIÓN ESCALADA CON PRE-AMBIENTE

