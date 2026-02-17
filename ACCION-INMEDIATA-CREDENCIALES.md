# 🚨 ACCIONES INMEDIATAS - Credenciales Expuestas

## ✅ Estado Actual

**Archivos con credenciales rastreados por Git:**
- `create-admin-user.js` ⚠️ (contiene referencia a Admin@2026)

**Archivos NO rastreados (seguros por ahora):**
- `check-tables.js` ✅
- `check-users.js` ✅  
- `change-admin-password.js` ✅
- `create-rh-user.js` ✅
- `CREDENCIALES.md` ✅

## 🎯 PLAN DE ACCIÓN RÁPIDO

### Paso 1: Detener cualquier commit/push pendiente ⏸️

```bash
# NO HAGAS GIT PUSH hasta completar todos los pasos
```

### Paso 2: Actualizar .gitignore ✅ COMPLETADO

El archivo `.gitignore` ya fue actualizado para incluir:
- CREDENCIALES.md
- Scripts de utilidad (check-*, create-*, change-*)
- Archivos SQL temporales

### Paso 3: Remover archivos sensibles del tracking

```powershell
# Remover create-admin-user.js del tracking de Git
# (El archivo se mantiene local, solo deja de ser rastreado)
git rm --cached create-admin-user.js

# Confirmar cambios
git commit -m "Remove sensitive files from tracking and update gitignore"
```

### Paso 4: Verificar que .gitignore funciona

```powershell
# Ejecutar script de escaneo
.\scan-credentials.ps1

# O manualmente verificar:
git status
# No deberían aparecer archivos sensibles
```

### Paso 5: Cambiar Credenciales (SI YA HICISTE GIT PUSH)

**Si las credenciales YA fueron subidas a GitHub/GitLab:**

```powershell
# 1. Cambiar password de postgres en Cloud SQL
& "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" sql users set-password postgres --password=NUEVA_PASSWORD_SEGURA_123! --instance=erp-afirma-db

# 2. Cambiar password de erp-user en Cloud SQL  
& "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" sql users set-password erp-user --password=NUEVA_PASSWORD_SEGURA_456! --instance=erp-afirma-db

# 3. Actualizar Cloud Run con nuevas credenciales
& "C:\Users\Aurora Flores\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" run services update erp-afirma --region us-central1 --update-env-vars "DB_PASSWORD=NUEVA_PASSWORD_SEGURA_456!"

# 4. Cambiar contraseña del usuario admin en la aplicación
# Ejecutar: node change-admin-password.js
# Y modificar el script para usar la nueva contraseña
```

### Paso 6: Limpiar Historial de Git (SI YA HICISTE GIT PUSH)

**Opción A: BFG Repo-Cleaner (Más fácil)**

```powershell
# 1. Instalar BFG
choco install bfg-repo-cleaner

# 2. Crear lista de passwords a eliminar
@"
afirma2025
erp2025secure
Admin@2026
admin123
"@ | Out-File -Encoding ASCII passwords.txt

# 3. Hacer backup
git clone --mirror https://github.com/TU-USUARIO/TU-REPO.git repo-backup

# 4. Limpiar historial
cd repo-backup
bfg --replace-text ..\passwords.txt

# 5. Forzar limpieza
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 6. Forzar push (CUIDADO: esto reescribe el historial)
git push --force
```

**Opción B: Hacerlo Manual con git filter-branch**

```powershell
# Remover archivo del historial completo
git filter-branch --force --index-filter `
  "git rm --cached --ignore-unmatch create-admin-user.js" `
  --prune-empty --tag-name-filter cat -- --all

# Forzar push
git push origin --force --all
```

## 📊 RESUMEN DE ARCHIVOS CREADOS

He creado los siguientes archivos para ayudarte:

1. **SEGURIDAD-GIT.md** - Guía completa de seguridad y limpieza
2. **.env.example** - Plantilla para variables de entorno
3. **scan-credentials.ps1** - Script para escanear credenciales
4. **.gitignore actualizado** - Previene futuros problemas

## ⚡ COMANDOS RÁPIDOS

### Limpieza Básica (si NO hiciste git push aún)

```powershell
# 1. Remover del tracking
git rm --cached create-admin-user.js CREDENCIALES.md

# 2. Commit
git commit -m "Remove sensitive files and update gitignore"

# 3. Verificar
git status
```

### Verificación Final

```powershell
# Escanear credenciales
.\scan-credentials.ps1

# Ver qué archivos están siendo rastreados
git ls-files | Select-String -Pattern "credential|password|secret"

# Debería retornar nada o muy poco
```

## 🔐 PRÓXIMOS PASOS

1. ✅ Ejecutar `git rm --cached create-admin-user.js`
2. ✅ Hacer commit con los cambios del .gitignore
3. ⚠️ SI hiciste push: Cambiar TODAS las credenciales
4. ⚠️ SI hiciste push: Limpiar historial con BFG
5. ✅ Usar `.env` para futuras credenciales
6. ✅ Revisar antes de cada push con `.\scan-credentials.ps1`

## 📞 ¿Necesitas Ayuda?

Si ya subiste las credenciales a GitHub/GitLab:
1. **PRIORIDAD 1**: Cambia las contraseñas AHORA
2. **PRIORIDAD 2**: Limpia el historial (ver SEGURIDAD-GIT.md)
3. **PRIORIDAD 3**: Configura Google Secret Manager

---

**Fecha:** 17 de Febrero, 2026  
**Estado:** ⚠️ Acción requerida
