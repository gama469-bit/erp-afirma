// Script directo para verificar datos de empleados
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_afirma',
  password: 'Sistemas1',
  port: 5432,
});

async function verificarDatos() {
  try {
    console.log('🔍 Verificando datos de empleados...\n');

    // Verificar mastercode
    const mastercode = await pool.query("SELECT lista, COUNT(*) as total FROM mastercode GROUP BY lista");
    console.log('📋 Datos en mastercode:');
    mastercode.rows.forEach(row => {
      console.log(`   ${row.lista}: ${row.total} items`);
    });

    // Verificar empleados con sus IDs de relación
    console.log('\n👥 Empleados y sus relaciones (últimos 5):');
    const empleados = await pool.query(`
      SELECT 
        id, first_name, last_name, entity_id, position_id, area_id, project_id, cell_id
      FROM employees_v2 
      ORDER BY id DESC 
      LIMIT 5
    `);
    
    empleados.rows.forEach(emp => {
      console.log(`   ${emp.first_name} ${emp.last_name} (ID: ${emp.id})`);
      console.log(`     entity_id: ${emp.entity_id || 'NULL'}`);
      console.log(`     position_id: ${emp.position_id || 'NULL'}`);
      console.log(`     area_id: ${emp.area_id || 'NULL'}`);
      console.log(`     project_id: ${emp.project_id || 'NULL'}`);
      console.log(`     cell_id: ${emp.cell_id || 'NULL'}`);
      console.log('');
    });

    // Probar el query de la API
    console.log('🔄 Probando query de API...');
    const apiResult = await pool.query(`
      SELECT 
        e.id,
        e.first_name,
        e.last_name,
        ent.item as entity_name,
        pos.item as position_name,
        ar.item as area_name,
        proj.item as project_name,
        c.item as cell_name
      FROM employees_v2 e
      LEFT JOIN mastercode ent ON e.entity_id = ent.id AND ent.lista = 'Entidad'
      LEFT JOIN mastercode pos ON e.position_id = pos.id AND pos.lista = 'Puestos roles'
      LEFT JOIN mastercode ar ON e.area_id = ar.id AND ar.lista = 'Areas'
      LEFT JOIN mastercode proj ON e.project_id = proj.id AND proj.lista = 'Proyecto'
      LEFT JOIN mastercode c ON e.cell_id = c.id AND c.lista = 'Celulas'
      ORDER BY e.id DESC
      LIMIT 3
    `);

    console.log('📄 Resultado del query de API:');
    apiResult.rows.forEach(emp => {
      console.log(`   ${emp.first_name} ${emp.last_name}:`);
      console.log(`     Entidad: ${emp.entity_name || 'NULL'}`);
      console.log(`     Posición: ${emp.position_name || 'NULL'}`);
      console.log(`     Área: ${emp.area_name || 'NULL'}`);
      console.log(`     Proyecto: ${emp.project_name || 'NULL'}`);
      console.log(`     Célula: ${emp.cell_name || 'NULL'}`);
      console.log('');
    });

  } catch (error) {
    console.error('❌ Error:', error);
  }
  
  await pool.end();
}

verificarDatos();