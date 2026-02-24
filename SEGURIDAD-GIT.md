# 🔐 GUÍA DE SEGURIDAD: Eliminar Credenciales del Repositorio Git

## ⚠️ SITUACIÓN ACTUAL

Se detectaron credenciales de base de datos en los siguientes archivos:
- `check-tables.js` - password: 'afirma2025'
- `check-users.js` - password: 'erp2025secure'
- `CREDENCIALES.md` - Contiene todas las credenciales
- Scripts varios con credenciales hardcodeadas

## 🚨 PELIGRO: Si ya hiciste `git push`

Si las credenciales ya fueron subidas a GitHub/GitLab, están en el historial público **PERMANENTEMENTE**.

### Acción Inmediata Requerida:

1. **CAMBIAR TODAS LAS CREDENCIALES COMPROMETIDAS INMEDIATAMENTE**
   ```bash
   # En Cloud SQL, cambiar contraseñas:
   gcloud sql users set-password postgres --password=NUEVA_PASSWORD_SEGURA --instance=erp-afirma-db
   gcloud sql users set-password erp-user --password=NUEVA_PASSWORD_SEGURA --instance=erp-afirma-db
   ```

2. **Actualizar variables de entorno en Cloud Run**
   ```bash
   gcloud run services update erp-afirma \
     --region us-central1 \
     --update-env-vars DB_PASSWORD=NUEVA_PASSWORD_SEGURA
   ```

## 🔧 LIMPIEZA DEL REPOSITORIO

### Opción 1: Limpiar Historial con BFG Repo-Cleaner (Recomendado)

```bash
# 1. Hacer backup del repositorio
git clone --mirror https://github.com/tu-usuario/tu-repo.git repo-backup

# 2. Descargar BFG desde https://rtyley.github.io/bfg-repo-cleaner/
# O con chocolatey en Windows:
choco install bfg-repo-cleaner

# 3. Crear archivo con passwords a eliminar
echo "afirma2025" > passwords.txt
echo "erp2025secure" >> passwords.txt
echo "Admin@2026" >> passwords.txt
echo "admin123" >> passwords.txt

# 4. Eliminar passwords del historial
bfg --replace-text passwords.txt repo-backup

# 5. Limpiar y forzar push
cd repo-backup
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push --force
```

### Opción 2: Usar git filter-repo (Alternativa)

```bash
# Instalar git-filter-repo
pip install git-filter-repo

# Eliminar archivo completamente del historial
git filter-repo --path CREDENCIALES.md --invert-paths

# Eliminar strings sensibles
git filter-repo --replace-text passwords.txt

# Forzar push
git push origin --force --all
```

### Opción 3: Eliminar Solo del Commit Actual (NO RECOMENDADO si ya hiciste push)

```bash
# Solo funciona si NO has hecho git push aún
git reset HEAD~1  # Deshacer último commit
git add .gitignore  # Solo agregar archivos seguros
git commit -m "Update gitignore"
```

## 📋 PREVENCIÓN: Configuración Correcta

### 1. Actualizar .gitignore

Agregar al `.gitignore`:
```
# Credenciales y secretos
CREDENCIALES.md
*.credentials
*.secret
*-credentials.*
check-*.js
create-*.js
change-*.js
grant-*.sql
recreate-*.sql

# Variables de entorno
.env
.env.*
!.env.example

# Scripts temporales con datos sensibles
temp-*.js
temp-*.sql
```

### 2. Crear archivo .env.example (plantilla)

```env
# Database Configuration (Cloud SQL)
DB_HOST=/cloudsql/PROJECT_ID:REGION:INSTANCE_NAME
DB_PORT=5432
DB_NAME=BD_afirma
DB_USER=erp-user
DB_PASSWORD=YOUR_SECURE_PASSWORD_HERE

# JWT Configuration
JWT_SECRET=YOUR_JWT_SECRET_HERE
JWT_EXPIRES_IN=1h

# Node Environment
NODE_ENV=production
API_PORT=3000
```

### 3. Usar Variables de Entorno en el Código

**ANTES (❌ MAL):**
```javascript
const client = new Client({
  host: '34.27.67.249',
  password: 'afirma2025'  // ❌ NUNCA hacer esto
});
```

**DESPUÉS (✅ BIEN):**
```javascript
const client = new Client({
  host: process.env.DB_HOST,
  password: process.env.DB_PASSWORD  // ✅ Correcto
});
```

### 4. Usar Google Secret Manager (Producción)

```bash
# Crear secretos en Google Cloud
echo -n "tu_password_super_seguro" | gcloud secrets create db-password --data-file=-

# Dar acceso al servicio de Cloud Run
gcloud secrets add-iam-policy-binding db-password \
  --member="serviceAccount:PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"

# Usar en Cloud Run
gcloud run services update erp-afirma \
  --update-secrets=DB_PASSWORD=db-password:latest
```

## 🛡️ BUENAS PRÁCTICAS DE SEGURIDAD

### ✅ HACER:
1. **Usar variables de entorno** para todas las credenciales
2. **Archivos .env en .gitignore** siempre
3. **Secretos en Secret Manager** para producción
4. **Rotar credenciales** regularmente (cada 90 días)
5. **Auditar commits** antes de push con `git diff --staged`
6. **Pre-commit hooks** para detectar credenciales
7. **Revisar el repositorio** con herramientas como `gitleaks` o `trufflehog`

### ❌ NUNCA HACER:
1. ❌ Hardcodear passwords en archivos de código
2. ❌ Subir archivos .env al repositorio
3. ❌ Compartir credenciales por Slack/Email/WhatsApp
4. ❌ Usar contraseñas simples o predecibles
5. ❌ Reutilizar contraseñas entre ambientes
6. ❌ Commit de archivos de documentación con credenciales reales

## 🔍 HERRAMIENTAS DE DETECCIÓN

### Instalar gitleaks (detector de secretos)

```bash
# Windows con chocolatey
choco install gitleaks

# Escanear repositorio
gitleaks detect --source . --verbose

# Escanear antes de commit
gitleaks protect --staged
```

### Pre-commit hook automático

Crear `.git/hooks/pre-commit`:
```bash
#!/bin/sh
# Detectar credenciales antes de commit
gitleaks protect --staged
if [ $? -eq 1 ]; then
    echo "⚠️  SECRETOS DETECTADOS! Commit bloqueado."
    exit 1
fi
```

## 📞 EN CASO DE EMERGENCIA

Si las credenciales fueron expuestas públicamente:

1. **INMEDIATO (< 5 minutos):**
   - Cambiar TODAS las contraseñas comprometidas
   - Revocar tokens de acceso
   - Verificar logs de acceso no autorizado

2. **URGENTE (< 1 hora):**
   - Limpiar historial de Git
   - Auditar accesos recientes a la BD
   - Notificar al equipo

3. **IMPORTANTE (< 24 horas):**
   - Implementar Secret Manager
   - Revisar todas las credenciales
   - Configurar alertas de seguridad

## 📚 RECURSOS ADICIONALES

- [GitHub: Removing sensitive data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- [git-filter-repo](https://github.com/newren/git-filter-repo)
- [gitleaks](https://github.com/gitleaks/gitleaks)
- [Google Secret Manager](https://cloud.google.com/secret-manager/docs)

---

**Fecha de creación:** 17 de Febrero, 2026  
**Última revisión:** 17 de Febrero, 2026
