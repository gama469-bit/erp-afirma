// Script para ejecutar migraciones en Cloud Run usando Cloud SQL Proxy
// Se ejecutará después del deploy como parte del CI/CD

const { Pool } = require('pg');

const config = {
  // Cloud Run usa unix socket cuando está configurado con Cloud SQL Proxy
  // Pero para ejecutar desde GitHub Actions, usamos la IP pública
  host: process.env.DB_HOST || '34.27.67.249',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'BD_afirma',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'afirma2025',
  ssl: false,
  connectionTimeoutMillis: 15000
};

const migrations = [
  '031_add_celula_and_costo_to_projects.sql',
  '032_add_costo_ot_to_orders_of_work.sql',
  '033_fix_null_costo_ot.sql',
  '034_add_ot_id_to_project_assignments.sql',
  '035_create_licitaciones.sql'
];

async function runMigrations() {
  console.log('\n🔄 Ejecutando migraciones en producción...\n');
  console.log('📍 Host:', config.host);
  console.log('📍 Database:', config.database);
  console.log('');

  const pool = new Pool(config);
  let appliedCount = 0;
  let skippedCount = 0;

  try {
    // Test conexión
    await pool.query('SELECT NOW()');
    console.log('✅ Conexión a base de datos exitosa\n');

    for (const migration of migrations) {
      console.log(`📄 Procesando: ${migration}...`);
      
      const fs = require('fs');
      const path = require('path');
      const migrationPath = path.join(__dirname, 'server', 'migrations', migration);
      
      if (!fs.existsSync(migrationPath)) {
        console.log(`   ⚠️  Archivo no encontrado, saltando`);
        skippedCount++;
        continue;
      }

      const sql = fs.readFileSync(migrationPath, 'utf8');
      
      try {
        await pool.query(sql);
        console.log(`   ✅ Aplicada exitosamente`);
        appliedCount++;
      } catch (err) {
        // Si el error es porque ya existe la tabla/columna, es OK
        if (err.message.includes('already exists') || 
            err.message.includes('ya existe') ||
            err.message.includes('duplicate')) {
          console.log(`   ℹ️  Ya aplicada previamente (saltando)`);
          skippedCount++;
        } else {
          console.error(`   ❌ Error: ${err.message}`);
          throw err;
        }
      }
    }

    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('📊 RESUMEN DE MIGRACIONES');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log(`✅ Aplicadas:     ${appliedCount}`);
    console.log(`ℹ️  Ya existentes: ${skippedCount}`);
    console.log(`📁 Total:         ${migrations.length}`);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    await pool.end();
    process.exit(0);
  } catch (err) {
    console.error('\n❌ ERROR ejecutando migraciones:', err.message);
    await pool.end();
    process.exit(1);
  }
}

runMigrations();
