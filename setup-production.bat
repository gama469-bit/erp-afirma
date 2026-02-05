@echo off
REM Setup script para preparar el proyecto para despliegue

echo 🚀 Setup ERP Afirma para Produccion
echo ===================================

echo.
echo 📋 Prerequisitos necesarios:
echo - Git (https://git-scm.com/download/win)
echo - Node.js 18+ (ya instalado)
echo - Cuenta GitHub
echo - Heroku CLI (opcional): https://devcenter.heroku.com/articles/heroku-cli

echo.
echo 🔍 Verificando Git...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git no está instalado. Descargalo de: https://git-scm.com/download/win
    echo    Después de instalarlo, reinicia esta terminal y ejecuta este script de nuevo.
    pause
    exit /b 1
) else (
    echo ✅ Git está instalado
)

echo.
echo 📦 Verificando dependencias del proyecto...
if not exist node_modules (
    echo 🔄 Instalando dependencias...
    npm install
) else (
    echo ✅ Dependencias ya instaladas
)

echo.
echo 🗂️ Configurando archivos de despliegue...
if not exist .env (
    echo 🔧 Creando archivo .env desde .env.example...
    copy .env.example .env
    echo ⚠️  IMPORTANTE: Edita el archivo .env con tus configuraciones de producción
)

echo.
echo 🔄 Inicializando repositorio Git...
git init >nul 2>&1
git add . >nul 2>&1

echo.
echo 📝 Haciendo commit inicial...
git commit -m "Initial commit: ERP Afirma ready for production" >nul 2>&1

echo.
echo ✅ Setup completado!
echo.
echo 📋 Próximos pasos:
echo.
echo 1. 🌐 Crear repositorio en GitHub:
echo    - Ve a: https://github.com/new
echo    - Nombre: erp-afirma
echo    - Descripción: Sistema ERP Afirma - Gestión empresarial
echo    - Público o Privado (tu elección)
echo    - NO inicializar con README (ya tienes uno)
echo.
echo 2. 🔗 Conectar con GitHub:
echo    git remote add origin https://github.com/TU-USUARIO/erp-afirma.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo 3. 🚀 Desplegar:
echo    - Para Heroku: Sigue la sección Heroku en DEPLOYMENT.md
echo    - Para VPS: Sigue la sección VPS en DEPLOYMENT.md
echo    - Para Docker: npm run docker:run
echo.
echo 📖 Lee DEPLOYMENT.md para instrucciones completas de despliegue
echo.

pause