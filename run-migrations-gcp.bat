@echo off
echo.
echo ============================================
echo   Ejecutar Migraciones en Cloud SQL
echo ============================================
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0run-migrations-gcp.ps1"
