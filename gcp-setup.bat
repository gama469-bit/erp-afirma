@echo off
echo 🌐 Setup inicial para Google Cloud Platform
echo =========================================

echo.
echo 📋 Este script te ayudará a configurar tu proyecto para Google Cloud
echo.

REM Verificar si gcloud está instalado
gcloud --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Google Cloud CLI no está instalado
    echo.
    echo 📥 Descarga e instala desde:
    echo    https://cloud.google.com/sdk/docs/install
    echo.
    echo    Después de instalar, reinicia esta terminal y ejecuta este script de nuevo.
    pause
    exit /b 1
) else (
    echo ✅ Google Cloud CLI encontrado
)

echo.
echo 🔐 Iniciando proceso de autenticación...
echo    Se abrirá tu navegador para autenticarte
pause

gcloud auth login

echo.
echo 📝 Configurando proyecto...

REM Pedir ID del proyecto
set /p PROJECT_ID=Ingresa un ID único para tu proyecto (ej: mi-erp-afirma-123): 

if "%PROJECT_ID%"=="" (
    echo ❌ ID de proyecto es requerido
    pause
    exit /b 1
)

REM Crear proyecto
echo 🏗️ Creando proyecto '%PROJECT_ID%'...
gcloud projects create %PROJECT_ID% --name="ERP Afirma"

if %errorlevel% neq 0 (
    echo ⚠️ El proyecto ya existe o hubo un error
    echo 🔄 Configurando proyecto existente...
)

gcloud config set project %PROJECT_ID%

echo.
echo 💳 Configuración de facturación requerida...
echo    Ve a: https://console.cloud.google.com/billing
echo    1. Vincular este proyecto a una cuenta de facturación
echo    2. Nuevas cuentas obtienen $300 de créditos gratuitos
echo.
pause

REM Actualizar archivos de configuración
echo 🔧 Actualizando archivos de configuración...

REM Actualizar deploy-gcp.bat
powershell -Command "(Get-Content deploy-gcp.bat) -replace 'tu-project-id', '%PROJECT_ID%' | Set-Content deploy-gcp.bat"

REM Actualizar app.yaml
powershell -Command "(Get-Content app.yaml) -replace 'TU_PROJECT_ID', '%PROJECT_ID%' | Set-Content app.yaml"

REM Actualizar cloudrun-service.yaml
powershell -Command "(Get-Content cloudrun-service.yaml) -replace 'TU_PROJECT_ID', '%PROJECT_ID%' | Set-Content cloudrun-service.yaml"

echo.
echo ✅ Configuración inicial completada!
echo.
echo 📋 Próximos pasos:
echo.
echo 1. 💳 Configurar facturación en Google Cloud Console
echo 2. 🚀 Ejecutar despliegue: deploy-gcp.bat
echo 3. ⏳ Esperar ~5-10 minutos para el despliegue completo
echo 4. 🌐 Acceder a tu aplicación en la URL proporcionada
echo.
echo 📖 Para instrucciones detalladas, lee: GOOGLE-CLOUD-DEPLOY.md
echo.

pause