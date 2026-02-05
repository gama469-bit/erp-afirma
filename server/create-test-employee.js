const db = require('./db');

async function createTestEmployee() {
  try {
    // Primero verificar la estructura de la tabla
    console.log('📋 Verificando estructura de employees_v2...');
    const structure = await db.query(
      `SELECT column_name, data_type, is_nullable 
       FROM information_schema.columns 
       WHERE table_name = 'employees_v2' 
       ORDER BY ordinal_position`
    );
    
    console.log('Columnas disponibles:');
    structure.rows.forEach(col => {
      console.log(`  ${col.column_name}: ${col.data_type} (${col.is_nullable === 'YES' ? 'NULL' : 'NOT NULL'})`);
    });
    
    // Crear empleado de prueba
    console.log('\n✨ Creando empleado de prueba...');
    const result = await db.query(
      `INSERT INTO employees_v2 (first_name, last_name, email, phone, status, created_by) 
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      ['María', 'González Test', 'maria.gonzalez.test@afirma.solutions', '5512345678', 'Activo', 'test-script']
    );
    
    console.log('✅ Empleado creado en employees_v2:');
    console.log('ID:', result.rows[0].id);
    console.log('Nombre:', result.rows[0].first_name, result.rows[0].last_name);
    console.log('Email:', result.rows[0].email);
    console.log('ID guardado para pruebas:', result.rows[0].id);
    
  } catch(err) {
    console.error('❌ Error:', err.message);
    console.error('Stack:', err.stack);
  } finally {
    process.exit(0);
  }
}

createTestEmployee();