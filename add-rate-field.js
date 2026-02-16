// Script para agregar el campo rate a project_assignments
const { Pool } = require('pg');

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'BD_afirma',
  password: process.env.DB_PASSWORD || 'Sistemas1',
  port: process.env.DB_PORT || 5432,
});

async function addRateField() {
  try {
    console.log('🔧 Agregando campo rate a project_assignments...');
    
    // Verificar si el campo ya existe
    const checkColumn = await pool.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'project_assignments' 
      AND column_name = 'rate'
    `);
    
    if (checkColumn.rows.length > 0) {
      console.log('✅ El campo rate ya existe en la tabla');
      return;
    }
    
    // Agregar el campo
    await pool.query(`
      ALTER TABLE project_assignments 
      ADD COLUMN rate NUMERIC(10,2) DEFAULT 0.00
    `);
    
    await pool.query(`
      COMMENT ON COLUMN project_assignments.rate IS 'Tarifa por hora o tarifa del recurso en este proyecto'
    `);
    
    console.log('✅ Campo rate agregado exitosamente');
    
    // Verificar la estructura final
    const columns = await pool.query(`
      SELECT column_name, data_type, column_default
      FROM information_schema.columns 
      WHERE table_name = 'project_assignments'
      ORDER BY ordinal_position
    `);
    
    console.log('\n📊 Estructura de project_assignments:');
    columns.rows.forEach(col => {
      console.log(`   - ${col.column_name}: ${col.data_type}${col.column_default ? ` (default: ${col.column_default})` : ''}`);
    });
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    throw error;
  } finally {
    await pool.end();
  }
}

addRateField()
  .then(() => {
    console.log('\n✅ ¡Proceso completado exitosamente!');
    process.exit(0);
  })
  .catch(err => {
    console.error('\n❌ Error fatal:', err);
    process.exit(1);
  });
