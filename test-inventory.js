// Test para verificar que la API de inventario funciona
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_afirma',
  password: 'Sistemas1',
  port: 5432,
});

async function testInventoryAPI() {
  try {
    console.log('🧪 Probando API de inventario...\n');

    // Probar la query que usa la API
    const result = await pool.query(`
      SELECT 
        i.*,
        COALESCE(e.first_name || ' ' || e.last_name, e.nombres || ' ' || e.apellidos, 'Sin asignar') as assigned_to_name
      FROM inventory i
      LEFT JOIN employees_v2 e ON i.assigned_to = e.id
      ORDER BY i.created_at DESC
    `);

    console.log(`✅ Inventario encontrado: ${result.rows.length} items`);
    
    console.log('\n📄 Equipos (estructura para frontend):');
    result.rows.slice(0, 3).forEach((item, index) => {
      console.log(`${index + 1}. ${item.equipment_type} ${item.brand || ''} ${item.model || ''}`);
      console.log(`   Serial: ${item.serial_number || 'N/A'}`);
      console.log(`   Asset Tag: ${item.asset_tag || 'N/A'}`);
      console.log(`   Estado: ${item.status || 'N/A'}`);
      console.log(`   Ubicación: ${item.location || 'N/A'}`);
      console.log(`   Asignado a: ${item.assigned_to_name || 'N/A'}`);
      console.log(`   Precio: ${item.purchase_price || 'N/A'}`);
      console.log('');
    });

    // Verificar campos que espera el frontend
    const item = result.rows[0];
    if (item) {
      console.log('🔍 Mapeo de campos para el frontend:');
      console.log(`   equipment_type -> categoria/nombre: "${item.equipment_type}"`);
      console.log(`   brand -> marca: "${item.brand}"`);
      console.log(`   model -> modelo: "${item.model}"`);
      console.log(`   serial_number -> serie: "${item.serial_number}"`);
      console.log(`   asset_tag -> codigo: "${item.asset_tag}"`);
      console.log(`   status -> estado: "${item.status}"`);
      console.log(`   location -> ubicacion: "${item.location}"`);
      console.log(`   assigned_to_name -> asignado: "${item.assigned_to_name}"`);
      console.log(`   purchase_price -> valor: "${item.purchase_price}"`);
    }

    console.log('\n✅ Test completado');

  } catch (error) {
    console.error('❌ Error:', error);
  }
  
  await pool.end();
}

testInventoryAPI();