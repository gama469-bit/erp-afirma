// Test para verificar que el API usa la tabla equipment
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_afirma',
  password: 'Sistemas1',
  port: 5432,
});

async function testEquipmentAPI() {
  try {
    console.log('🧪 Probando API con tabla equipment...\n');

    // Query exacta que usa la nueva API
    const result = await pool.query(`
      SELECT 
        e.*,
        COALESCE(emp.first_name || ' ' || emp.last_name, 'Sin asignar') as asignado_nombre
      FROM equipment e
      LEFT JOIN employees_v2 emp ON e.asignado_id = emp.id
      ORDER BY e.created_at DESC
    `);

    console.log(`✅ Datos de BD: ${result.rows.length} equipos`);
    
    console.log('\n📄 Estructura de datos de equipment:');
    if (result.rows.length > 0) {
      const sample = result.rows[0];
      console.log('Campos disponibles:', Object.keys(sample));
      console.log('\nPrimer equipo:');
      console.log(`  codigo: "${sample.codigo}"`);
      console.log(`  nombre: "${sample.nombre}"`);
      console.log(`  marca: "${sample.marca}"`);
      console.log(`  modelo: "${sample.modelo}"`);
      console.log(`  serie: "${sample.serie}"`);
      console.log(`  categoria: "${sample.categoria}"`);
      console.log(`  ubicacion: "${sample.ubicacion}"`);
      console.log(`  asignado_nombre: "${sample.asignado_nombre}"`);
      console.log(`  estado: "${sample.estado}"`);
      console.log(`  valor: "${sample.valor}"`);
      console.log(`  fecha_compra: "${sample.fecha_compra}"`);
    }

    console.log('\n🔄 Mapeo para frontend:');
    result.rows.forEach((eq, index) => {
      if (index < 2) { // Solo mostrar 2 ejemplos
        console.log(`\nEquipo ${index + 1}:`);
        console.log(`  ${eq.codigo} - ${eq.nombre} ${eq.marca || ''} ${eq.modelo || ''}`);
        console.log(`  Estado: ${eq.estado} | Categoría: ${eq.categoria}`);
        console.log(`  Asignado: ${eq.asignado_nombre}`);
      }
    });

    console.log('\n✅ Test completado');

  } catch (error) {
    console.error('❌ Error:', error);
  }
  
  await pool.end();
}

testEquipmentAPI();