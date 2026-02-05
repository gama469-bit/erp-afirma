const { Pool } = require('pg');

const db = new Pool({
  host: 'localhost',
  port: 5432,
  user: 'postgres',
  password: 'Sistemas1',
  database: 'BD_afirma'
});

async function testDatabase() {
  try {
    console.log('🔍 Verificando tabla mastercode...');
    
    // Verificar si la tabla existe
    const tableExists = await db.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'mastercode'
      );
    `);
    
    if (!tableExists.rows[0].exists) {
      console.log('❌ La tabla mastercode no existe');
      process.exit(1);
    }
    
    console.log('✅ Tabla mastercode existe');
    
    // Contar elementos por lista
    const result = await db.query('SELECT lista, COUNT(*) as count FROM mastercode GROUP BY lista ORDER BY lista');
    console.log('📊 Contenido de mastercode:');
    result.rows.forEach(row => {
      console.log(`  ${row.lista}: ${row.count} items`);
    });
    
    // Probar consulta específica que usa el endpoint
    const entities = await db.query("SELECT id, item as name FROM mastercode WHERE lista = 'Entidad' ORDER BY item LIMIT 3");
    console.log('🏢 Primeras 3 entidades:');
    entities.rows.forEach(row => {
      console.log(`  ID: ${row.id}, Name: ${row.name}`);
    });
    
    console.log('✅ Base de datos funcionando correctamente');
    
  } catch (err) {
    console.error('❌ Error:', err.message);
    console.error(err);
  } finally {
    await db.end();
  }
}

testDatabase();