const { query } = require('./server/db');

async function checkEmployeesV2() {
  try {
    console.log('🔍 Checking employees_v2 table structure...');
    
    const result = await query(`
      SELECT column_name, data_type, is_nullable 
      FROM information_schema.columns 
      WHERE table_name = 'employees_v2' 
      ORDER BY ordinal_position
    `);
    
    console.log('\n📋 employees_v2 columns:');
    result.rows.forEach(col => {
      console.log(`  - ${col.column_name} (${col.data_type}) ${col.is_nullable === 'NO' ? 'NOT NULL' : 'NULL'}`);
    });
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

checkEmployeesV2();
