// Script para validar que todas las migraciones de reclutamiento fueron aplicadas correctamente
const db = require('./server/db');

async function validateMigrations() {
  console.log('🔍 Validando migraciones de reclutamiento...\n');
  
  try {
    // 1. Verificar columnas
    console.log('📋 Verificando columnas en tabla candidates...');
    const columnsCheck = await db.query(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_name = 'candidates' 
      AND column_name IN ('recruited_by', 'hired_date')
      ORDER BY column_name;
    `);
    
    if (columnsCheck.rows.length === 2) {
      console.log('✅ Columnas encontradas:');
      columnsCheck.rows.forEach(col => {
        console.log(`   - ${col.column_name}: ${col.data_type}`);
      });
    } else {
      console.log('❌ Faltan columnas:');
      const found = new Set(columnsCheck.rows.map(r => r.column_name));
      ['recruited_by', 'hired_date'].forEach(col => {
        if (!found.has(col)) console.log(`   ❌ ${col}`);
      });
      throw new Error('Migraciones incompletas');
    }
    
    // 2. Verificar índices
    console.log('\n🔎 Verificando índices en tabla candidates...');
    const indexesCheck = await db.query(`
      SELECT indexname FROM pg_indexes 
      WHERE tablename = 'candidates' 
      AND indexname LIKE 'idx_candidates_%'
      ORDER BY indexname;
    `);
    
    const expectedIndexes = [
      'idx_candidates_status',
      'idx_candidates_recruited_by',
      'idx_candidates_hired_date'
    ];
    
    const foundIndexes = new Set(indexesCheck.rows.map(r => r.indexname));
    let allIndexesFound = true;
    
    expectedIndexes.forEach(idx => {
      if (foundIndexes.has(idx)) {
        console.log(`   ✅ ${idx}`);
      } else {
        console.log(`   ❌ ${idx}`);
        allIndexesFound = false;
      }
    });
    
    if (!allIndexesFound) {
      throw new Error('Faltan índices');
    }
    
    // 3. Prueba de inserción
    console.log('\n🧪 Probando inserción de datos...');
    
    const testInsert = await db.query(`
      INSERT INTO candidates 
      (first_name, last_name, email, position_applied, status, recruited_by, hired_date)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id, recruited_by, hired_date;
    `, [
      'Test',
      'Migration',
      'test-migration-' + Date.now() + '@example.com',
      'Developer',
      'Contratado',
      'test-user',
      new Date().toISOString().split('T')[0]
    ]);
    
    if (testInsert.rows.length > 0) {
      const record = testInsert.rows[0];
      console.log('✅ Inserción exitosa:');
      console.log(`   - ID: ${record.id}`);
      console.log(`   - recruited_by: ${record.recruited_by}`);
      console.log(`   - hired_date: ${record.hired_date}`);
      
      // Limpiar dato de prueba
      await db.query('DELETE FROM candidates WHERE id = $1', [record.id]);
      console.log('✅ Datos de prueba limpios');
    }
    
    // Resumen
    console.log('\n' + '='.repeat(50));
    console.log('✨ ¡Todas las validaciones pasaron!');
    console.log('='.repeat(50));
    console.log('\n✅ Sistema listo para usar recruitment tracking:');
    console.log('   - Columnas added correctamente');
    console.log('   - Índices creados');
    console.log('   - Datos se guardan correctamente');
    console.log('\n🚀 Puedes comenzar a usar las nuevas features');
    
    process.exit(0);
  } catch (err) {
    console.error('\n' + '='.repeat(50));
    console.error('❌ ERROR EN VALIDACIÓN');
    console.error('='.repeat(50));
    console.error(err.message);
    console.error('\n📝 Por favor ejecuta:');
    console.error('   npm run migrate');
    console.error('   O');
    console.error('   node server/migrate.js');
    process.exit(1);
  }
}

validateMigrations();
