// Test para verificar mapeo de datos del inventario
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_afirma',
  password: 'Sistemas1',
  port: 5432,
});

async function testInventoryMapping() {
  try {
    console.log('🧪 Probando mapeo de datos del inventario...\n');

    // Query exacta que usa la API
    const result = await pool.query(`
      SELECT 
        i.*,
        COALESCE(e.first_name || ' ' || e.last_name, 'Sin asignar') as assigned_to_name
      FROM inventory i
      LEFT JOIN employees_v2 e ON i.assigned_to = e.id
      ORDER BY i.created_at DESC
    `);

    console.log(`✅ Datos de BD: ${result.rows.length} equipos`);
    
    console.log('\n📄 Estructura de datos de la BD:');
    if (result.rows.length > 0) {
      const sample = result.rows[0];
      console.log('Campos disponibles:', Object.keys(sample));
      console.log('\nPrimer equipo:');
      console.log(`  equipment_type: "${sample.equipment_type}"`);
      console.log(`  brand: "${sample.brand}"`);
      console.log(`  model: "${sample.model}"`);
      console.log(`  serial_number: "${sample.serial_number}"`);
      console.log(`  asset_tag: "${sample.asset_tag}"`);
      console.log(`  status: "${sample.status}"`);
      console.log(`  location: "${sample.location}"`);
      console.log(`  assigned_to_name: "${sample.assigned_to_name}"`);
      console.log(`  purchase_price: "${sample.purchase_price}"`);
      console.log(`  purchase_date: "${sample.purchase_date}"`);
    }

    console.log('\n🔄 Mapeo esperado por el frontend:');
    result.rows.forEach((eq, index) => {
      if (index < 2) { // Solo mostrar 2 ejemplos
        console.log(`\nEquipo ${index + 1}:`);
        console.log(`  codigo: ${eq.asset_tag || eq.serial_number || ''} (asset_tag || serial_number)`);
        console.log(`  nombre: ${eq.equipment_type || ''} (equipment_type)`);
        console.log(`  marca: ${eq.brand || ''} (brand)`);
        console.log(`  modelo: ${eq.model || ''} (model)`);
        console.log(`  serie: ${eq.serial_number || ''} (serial_number)`);
        console.log(`  categoria: ${eq.equipment_type || ''} (equipment_type)`);
        console.log(`  ubicacion: ${eq.location || ''} (location)`);
        console.log(`  asignado: ${eq.assigned_to_name || ''} (assigned_to_name)`);
        console.log(`  estado: ${eq.status || 'Activo'} (status)`);
        console.log(`  valor: ${eq.purchase_price || 0} (purchase_price)`);
        console.log(`  fechaCompra: ${eq.purchase_date} (purchase_date)`);
      }
    });

    console.log('\n✅ Test completado');

  } catch (error) {
    console.error('❌ Error:', error);
  }
  
  await pool.end();
}

testInventoryMapping();