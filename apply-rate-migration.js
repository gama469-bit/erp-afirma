const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_afirma',
  password: 'password',
  port: 5432,
});

async function applyMigration() {
  try {
    console.log('🔧 Aplicando migración: Agregar campo rate a project_assignments...');
    
    const result = await pool.query(`
      ALTER TABLE project_assignments 
      ADD COLUMN IF NOT EXISTS rate NUMERIC(10,2) DEFAULT 0.00;
    `);
    
    console.log('✅ Campo rate agregado exitosamente a project_assignments');
    
    // Verificar que se agregó
    const verify = await pool.query(`
      SELECT column_name, data_type, column_default
      FROM information_schema.columns
      WHERE table_name = 'project_assignments' AND column_name = 'rate';
    `);
    
    if (verify.rows.length > 0) {
      console.log('✅ Verificación exitosa:', verify.rows[0]);
    } else {
      console.log('⚠️  No se pudo verificar la columna');
    }
    
  } catch (error) {
    if (error.message.includes('ya existe')) {
      console.log('ℹ️  La columna rate ya existe en project_assignments');
    } else {
      console.error('❌ Error:', error.message);
    }
  } finally {
    await pool.end();
    console.log('✅ Proceso completado');
  }
}

applyMigration();
