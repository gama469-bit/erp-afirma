const db = require('./db');

async function checkIDs() {
  try {
    console.log('🔍 Verificando IDs disponibles en mastercode...\n');
    
    const areas = await db.query("SELECT id, item FROM mastercode WHERE lista = 'Areas' ORDER BY id LIMIT 5");
    console.log('📊 IDs de Áreas en mastercode:');
    areas.rows.forEach(a => console.log(`  ID: ${a.id}, Nombre: ${a.item}`));
    
    const projects = await db.query("SELECT id, item FROM mastercode WHERE lista = 'Proyecto' ORDER BY id LIMIT 5");
    console.log('\n📊 IDs de Proyectos en mastercode:');
    projects.rows.forEach(p => console.log(`  ID: ${p.id}, Nombre: ${p.item}`));
    
    const positions = await db.query("SELECT id, item FROM mastercode WHERE lista = 'Puestos roles' ORDER BY id LIMIT 5");
    console.log('\n📊 IDs de Posiciones en mastercode:');
    positions.rows.forEach(p => console.log(`  ID: ${p.id}, Nombre: ${p.item}`));
    
    const entities = await db.query("SELECT id, item FROM mastercode WHERE lista = 'Entidad' ORDER BY id LIMIT 5");
    console.log('\n📊 IDs de Entidades en mastercode:');
    entities.rows.forEach(e => console.log(`  ID: ${e.id}, Nombre: ${e.item}`));
    
  } catch(err) {
    console.error('❌ Error:', err);
  } finally {
    process.exit(0);
  }
}

checkIDs();