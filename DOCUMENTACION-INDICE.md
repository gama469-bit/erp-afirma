# 📖 ÍNDICE DE DOCUMENTACIÓN - ERP AFIRMA

**Última actualización:** Febrero 4, 2026  
**Versión:** 1.0.0 - Producción  
**Estado:** ✅ OPERACIONAL

---

## 🚀 INICIO RÁPIDO

Si es tu primera vez, comienza aquí:

1. **[ESTADO-DESPLIEGUE.md](ESTADO-DESPLIEGUE.md)** ⭐ **LÉEME PRIMERO**
   - Resumen visual del despliegue
   - URLs de acceso
   - Estado actual
   - Verificación rápida

2. **[RESUMEN-DESPLIEGUE.md](RESUMEN-DESPLIEGUE.md)**
   - Dashboard de servicios
   - Uso rápido
   - Flujo de trabajo típico
   - Checklist de validación

---

## 📚 DOCUMENTACIÓN COMPLETA

### Despliegue y Configuración

#### [DESPLIEGUE-ESCALONADO-PRE-PROD.md](DESPLIEGUE-ESCALONADO-PRE-PROD.md)
Guía completa del despliegue con dos ambientes:
- URLs de acceso PRE y PROD
- Arquitectura distribuida
- Proceso de validación
- Flujo de promoción
- Manejo de rollbacks
- Seguridad y buenas prácticas

#### [DESPLIEGUE-GCP-EXITOSO.md](DESPLIEGUE-GCP-EXITOSO.md)
Detalles técnicos del despliegue inicial:
- Configuración de Cloud Run
- Cloud SQL setup
- Variables de entorno
- Endpoints validados
- Troubleshooting

### Referencia Técnica

#### [TECNOLOGIAS.md](TECNOLOGIAS.md)
Stack tecnológico completo:
- Arquitectura de 3 capas
- Dependencias (backend, frontend)
- PostgreSQL y schema
- Despliegue (Docker, PM2, Cloud)
- Patrones de código
- Requisitos del sistema

#### [REFERENCIA-COMANDOS.md](REFERENCIA-COMANDOS.md)
Referencia rápida de comandos gcloud:
- Acciones principales
- Diagnóstico y monitoreo
- Operaciones de actualización
- Gestión de tráfico
- Docker y Container Registry
- Base de datos
- Security
- Troubleshooting
- Tips y mejores prácticas

---

## 🛠️ SCRIPTS Y HERRAMIENTAS

### Windows (PowerShell)

#### [scripts/promote.ps1](scripts/promote.ps1)
Script de promoción automática PRE → PROD:
```powershell
# Ver status
.\scripts\promote.ps1 -Action status

# Validar PRE
.\scripts\promote.ps1 -Action validate-pre

# Promocionar a PROD
.\scripts\promote.ps1 -Action promote

# Revertir PROD
.\scripts\promote.ps1 -Action rollback

# Comparar configuración
.\scripts\promote.ps1 -Action compare
```

#### [scripts/verify-deployment.ps1](scripts/verify-deployment.ps1)
Verificación rápida del despliegue:
```powershell
.\scripts\verify-deployment.ps1
```

### Linux/Mac (Bash)

#### [scripts/promote.sh](scripts/promote.sh)
Script equivalente en Bash:
```bash
chmod +x scripts/promote.sh
./scripts/promote.sh validate-pre
./scripts/promote.sh promote
./scripts/promote.sh status
```

---

## 🌐 URLs DE ACCESO

### PRE-PRODUCCIÓN (Testing/Staging)
```
https://erp-afirma-pre-ndaeiqg4mq-uc.a.run.app
```
- Ambiente seguro para validar cambios
- Auto-escalado: 0-5 instancias
- BD compartida con PROD (seguro: datos prueba)

### PRODUCCIÓN
```
https://erp-afirma-ndaeiqg4mq-uc.a.run.app
```
- Ambiente para usuarios finales
- Auto-escalado: 0-10 instancias
- BD compartida con PRE (datos en vivo)

### API Health Checks
- **PRE:** `/api/health` en URL PRE
- **PROD:** `/api/health` en URL PROD

---

## 📊 FLUJO DE TRABAJO

```
DESARROLLO LOCAL
   ↓
   npm run dev:all
   ↓
GIT COMMIT & PUSH
   ↓
   develop → PRE-PRODUCCIÓN
   main    → PRODUCCIÓN
   ↓
TESTING EN PRE
   ↓
   .\scripts\promote.ps1 -Action validate-pre
   ↓
PROMOCIÓN A PROD
   ↓
   .\scripts\promote.ps1 -Action promote
   ↓
MONITOREO EN VIVO
   ↓
   gcloud run services logs read erp-afirma --follow
   ↓
ROLLBACK SI NECESARIO
   ↓
   .\scripts\promote.ps1 -Action rollback
```

---

## 🔍 VERIFICACIÓN RÁPIDA

### Estado General
```bash
.\scripts\promote.ps1 -Action status
```

### Validar PRE Antes de Promocionar
```bash
.\scripts\promote.ps1 -Action validate-pre
```

### Ver Logs en Vivo
```bash
# PRE
gcloud run services logs read erp-afirma-pre --region us-central1 --follow

# PROD
gcloud run services logs read erp-afirma --region us-central1 --follow
```

### Rollback Rápido
```bash
.\scripts\promote.ps1 -Action rollback
```

---

## 📈 OPERACIONES COMUNES

### Actualizar Configuración
```bash
gcloud run services update erp-afirma \
  --update-env-vars KEY=VALUE \
  --region us-central1
```

### Cambiar Límites de Instancias
```bash
gcloud run services update erp-afirma \
  --max-instances=20 \
  --region us-central1
```

### Ver Revisiones
```bash
gcloud run revisions list --service=erp-afirma --region us-central1
```

### Crear Backup BD
```bash
gcloud sql backups create --instance=erp-afirma-db
```

---

## 🔐 SEGURIDAD

### Estándar Implementado
- [x] Autenticación Cloud SQL vía Proxy
- [x] Ambientes separados (PRE/PROD)
- [x] Variables de entorno seguras
- [x] CORS configurado
- [x] SSL/TLS automático

### Recomendaciones Adicionales
Ver sección "Seguridad" en [REFERENCIA-COMANDOS.md](REFERENCIA-COMANDOS.md)

---

## 💰 COSTOS

### Estimado Mensual
- **Cloud Run PRE:** $0.25 - $2.00
- **Cloud Run PROD:** $0.50 - $5.00
- **Cloud SQL:** $20.00 - $30.00
- **Storage:** < $1.00
- **TOTAL:** $21-38 USD/mes

### Ahorro
- $300 USD de créditos gratuitos = ~8 meses incluido

---

## 🆘 TROUBLESHOOTING

### La aplicación no responde
→ Ver "Troubleshooting Rápido" en [ESTADO-DESPLIEGUE.md](ESTADO-DESPLIEGUE.md)

### Problema con base de datos
→ Ver "Problema de Conexión a BD" en [REFERENCIA-COMANDOS.md](REFERENCIA-COMANDOS.md)

### Quiero revertir a versión anterior
→ Ver "Rollback" en [DESPLIEGUE-ESCALONADO-PRE-PROD.md](DESPLIEGUE-ESCALONADO-PRE-PROD.md)

### Logs muestran errores
→ Ver "Ver logs en vivo" en cualquier documento de referencia

---

## 📞 RECURSOS EXTERNOS

### Google Cloud
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Cloud SQL Documentation](https://cloud.google.com/sql/docs)
- [gcloud CLI Reference](https://cloud.google.com/sdk/gcloud/reference)
- [Cloud Console](https://console.cloud.google.com)

### Proyecto
- Proyecto GCP: `erp-afirma-solutions`
- Región: `us-central1`
- Repositorio: GitHub
- BD: PostgreSQL 15

---

## 📋 DOCUMENTACIÓN POR TÓPICO

### Para Desarrolladores
1. [TECNOLOGIAS.md](TECNOLOGIAS.md) - Entender el stack
2. [REFERENCIA-COMANDOS.md](REFERENCIA-COMANDOS.md) - Comandos útiles
3. Documentación inline en código

### Para DevOps/Operaciones
1. [DESPLIEGUE-ESCALONADO-PRE-PROD.md](DESPLIEGUE-ESCALONADO-PRE-PROD.md) - Procedimientos
2. [scripts/promote.ps1](scripts/promote.ps1) - Automatización
3. [REFERENCIA-COMANDOS.md](REFERENCIA-COMANDOS.md) - Operaciones

### Para Stakeholders/Ejecutivos
1. [ESTADO-DESPLIEGUE.md](ESTADO-DESPLIEGUE.md) - Resumen visual
2. [RESUMEN-DESPLIEGUE.md](RESUMEN-DESPLIEGUE.md) - Dashboard

### Para QA/Testing
1. [DESPLIEGUE-ESCALONADO-PRE-PROD.md](DESPLIEGUE-ESCALONADO-PRE-PROD.md) - Ambiente de testing
2. [ESTADO-DESPLIEGUE.md](ESTADO-DESPLIEGUE.md) - Verificación

---

## 🔄 ACTUALIZAR DOCUMENTACIÓN

Cuando ocurran cambios:

1. **Nueva versión de imagen Docker:**
   → Actualizar digests en [ESTADO-DESPLIEGUE.md](ESTADO-DESPLIEGUE.md)

2. **Nuevo endpoint API:**
   → Agregar a [REFERENCIA-COMANDOS.md](REFERENCIA-COMANDOS.md)

3. **Cambio de arquitectura:**
   → Actualizar [TECNOLOGIAS.md](TECNOLOGIAS.md)

4. **Nuevo procedimiento operacional:**
   → Agregar a [DESPLIEGUE-ESCALONADO-PRE-PROD.md](DESPLIEGUE-ESCALONADO-PRE-PROD.md)

---

## ✅ CHECKLIST DE LECTURA

Para nuevos miembros del equipo:

- [ ] Leer [ESTADO-DESPLIEGUE.md](ESTADO-DESPLIEGUE.md)
- [ ] Revisar [RESUMEN-DESPLIEGUE.md](RESUMEN-DESPLIEGUE.md)
- [ ] Estudiar [TECNOLOGIAS.md](TECNOLOGIAS.md)
- [ ] Consultar [REFERENCIA-COMANDOS.md](REFERENCIA-COMANDOS.md)
- [ ] Probar scripts en `scripts/`
- [ ] Validar acceso a URLs
- [ ] Revisar logs en Cloud Console

---

## 📝 NOTA IMPORTANTE

**Toda esta documentación está en español y en formato Markdown.**

Para visualizar mejor:
- GitHub: Renderiza automáticamente
- VS Code: Extensión "Markdown Preview Enhanced"
- Local: Cualquier editor de texto

**Última revisión:** Febrero 4, 2026, 21:06 UTC

