const { query } = require('./server/db');

async function checkProjectsIds() {
  try {
    console.log('🔍 Checking actual projects in database...\n');
    
    const result = await query(`
      SELECT id, name, area_id, created_at 
      FROM projects 
      ORDER BY id 
      LIMIT 10
    `);
    
    console.log('📋 Projects in database:');
    result.rows.forEach(p => {
      console.log(`  ID: ${p.id} | Name: ${p.name}`);
    });
    
    console.log(`\n✅ Total projects: ${result.rows.length}`);
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

checkProjectsIds();
