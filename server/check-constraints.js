const db = require('./db');

async function checkConstraints() {
  try {
    console.log('🔍 Verificando foreign key constraints en employees_v2...\n');
    
    const result = await db.query(`
      SELECT conname, confrelid::regclass as foreign_table 
      FROM pg_constraint 
      WHERE conrelid = 'employees_v2'::regclass AND contype = 'f'
    `);
    
    console.log('📋 Foreign key constraints encontradas:');
    result.rows.forEach(row => {
      console.log(`  ${row.conname} -> ${row.foreign_table}`);
    });
    
    console.log('\n🔧 Verificando si existen constraints hacia mastercode...');
    const mastercodeConstraints = await db.query(`
      SELECT conname 
      FROM pg_constraint 
      WHERE conrelid = 'employees_v2'::regclass 
      AND contype = 'f' 
      AND confrelid = 'mastercode'::regclass
    `);
    
    console.log(`✅ Constraints hacia mastercode: ${mastercodeConstraints.rows.length}`);
    mastercodeConstraints.rows.forEach(row => {
      console.log(`  ${row.conname}`);
    });
    
  } catch(err) {
    console.error('❌ Error:', err.message);
  } finally {
    process.exit(0);
  }
}

checkConstraints();