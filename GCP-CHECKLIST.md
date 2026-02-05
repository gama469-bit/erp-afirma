# 🚀 Checklist: Despliegue en Google Cloud

## ✅ Preparación (5 min)

- [ ] **Cuenta Google Cloud creada**
  - Ir a: https://cloud.google.com/
  - Usar Gmail existente o crear nueva cuenta

- [ ] **Google Cloud CLI instalado**
  - Windows: https://cloud.google.com/sdk/docs/install
  - Verificar: `gcloud --version`

- [ ] **Facturación habilitada**
  - Nuevas cuentas: $300 créditos gratis
  - Ir a: https://console.cloud.google.com/billing

---

## ⚙️ Configuración (5 min)

- [ ] **Ejecutar setup inicial**
  ```bash
  .\gcp-setup.bat
  ```

- [ ] **Autenticarse en gcloud**
  - Se abre navegador automáticamente
  - Seleccionar cuenta de Google

- [ ] **Crear/seleccionar proyecto**
  - ID único (ej: mi-erp-afirma-123)
  - Se crea automáticamente

---

## 🚀 Despliegue (10-15 min)

- [ ] **Ejecutar script de despliegue**
  ```bash
  .\deploy-gcp.bat
  ```

- [ ] **Esperar mientras se:**
  - Habilitan APIs necesarias
  - Crea instancia PostgreSQL 
  - Construye imagen Docker
  - Despliega en Cloud Run

- [ ] **Obtener URL final**
  - Se muestra al final del script
  - Formato: `https://erp-afirma-xxxxx.run.app`

---

## 🔧 Verificación (2 min)

- [ ] **Probar aplicación**
  - Abrir URL en navegador
  - Verificar que carga correctamente
  - Probar crear/editar empleado

- [ ] **Ejecutar migraciones** (si es necesario)
  ```bash
  gcloud run jobs execute migrate-job
  ```

---

## 🌍 Opcional: Dominio personalizado

- [ ] **Comprar dominio** (ej: GoDaddy, Namecheap)

- [ ] **Mapear dominio en Google Cloud**
  ```bash
  gcloud run domain-mappings create \
      --service=erp-afirma \
      --domain=tu-dominio.com
  ```

- [ ] **Configurar DNS**
  - Agregar registros que Google Cloud indique
  - Esperar propagación (5-60 min)

---

## 📊 Monitoreo

- [ ] **Configurar alertas**
  - Ir a: https://console.cloud.google.com/monitoring
  - Crear alertas por errores/uso

- [ ] **Revisar costos**
  - Ir a: https://console.cloud.google.com/billing
  - Configurar alertas de presupuesto

---

## ⏱️ Tiempo total estimado: 20-30 minutos

## 💰 Costo estimado: $15-30/mes

## 📞 Soporte
- Documentación completa: `GOOGLE-CLOUD-DEPLOY.md`
- Google Cloud Support: https://cloud.google.com/support
- Community: https://stackoverflow.com/questions/tagged/google-cloud-platform

---

## 🎉 ¡Listo!

Tu ERP Afirma estará ejecutándose en Google Cloud con:
- ✅ Escalado automático
- ✅ HTTPS incluido
- ✅ Base de datos PostgreSQL
- ✅ Backup automático
- ✅ Monitoreo incluido
- ✅ 99.95% uptime SLA