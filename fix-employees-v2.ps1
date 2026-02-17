# Configuración por entorno: local (default) | production
$TargetEnv = if ($args.Count -gt 0) { $args[0].ToLower() } `
             elseif ($env:APP_ENV) { $env:APP_ENV.ToLower() } `
             elseif ($env:NODE_ENV) { $env:NODE_ENV.ToLower() } `
             else { "local" }

# Solo define el modo, sin hardcodear datos de conexión
$env:NODE_ENV = if ($TargetEnv -eq "production") { "production" } else { "development" }

# Validar variables requeridas desde entorno
$requiredVars = @("DB_HOST", "DB_PORT", "DB_NAME", "DB_USER")
$missingVars = @()

foreach ($varName in $requiredVars) {
    if ([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable($varName))) {
        $missingVars += $varName
    }
}

if ($missingVars.Count -gt 0) {
    Write-Host "Faltan variables de entorno requeridas: $($missingVars -join ', ')" -ForegroundColor Red
    Write-Host "Define estas variables antes de ejecutar el script." -ForegroundColor Yellow
    exit 1
}

# Password: usar DB_PASSWORD o PGPASSWORD del entorno; pedirlo solo si no existe
if (-not $env:DB_PASSWORD -and $env:PGPASSWORD) {
    $env:DB_PASSWORD = $env:PGPASSWORD
}

if (-not $env:DB_PASSWORD) {
    $securePwd = Read-Host "Ingresa DB_PASSWORD para '$TargetEnv'" -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
    try {
        $env:DB_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
    }
}

$env:PGPASSWORD = $env:DB_PASSWORD

Write-Host "Ejecutando fix de employees_v2..." -ForegroundColor Cyan
Write-Host ""

# Instalar psql si no está disponible
$psqlPath = "C:\Program Files\PostgreSQL\16\bin\psql.exe"
if (-not (Test-Path $psqlPath)) {
    $psqlPath = "C:\Program Files\PostgreSQL\15\bin\psql.exe"
}

if (Test-Path $psqlPath) {
    Write-Host "Usando psql para ejecutar el fix..." -ForegroundColor Yellow
    & $psqlPath -h $env:DB_HOST -U $env:DB_USER -d $env:DB_NAME -f "fix-employees-v2.sql"
} else {
    Write-Host "psql no encontrado, usando Node.js..." -ForegroundColor Yellow
    
    # Crear script Node.js temporal
    $nodeScript = @"
const { Pool } = require('pg');
const fs = require('fs');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD
});

async function runFix() {
  try {
    const sql = fs.readFileSync('fix-employees-v2.sql', 'utf8');
    await pool.query(sql);
    console.log('Fix ejecutado exitosamente!');
    process.exit(0);
  } catch (err) {
    console.error('Error:', err.message);
    process.exit(1);
  }
}

runFix();
"@
    
    $nodeScript | Out-File -FilePath "temp-fix.js" -Encoding UTF8
    node temp-fix.js
    Remove-Item "temp-fix.js" -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Ahora ejecuta las migraciones nuevamente:" -ForegroundColor Cyan
Write-Host "  .\run-migrations-gcp.bat" -ForegroundColor White
Write-Host ""

pause
