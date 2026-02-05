// Script para asignar posiciones a empleados sin position_id
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_afirma',
  password: 'Sistemas1',
  port: 5432,
});

async function asignarPosiciones() {
  try {
    console.log('🔧 Asignando posiciones a empleados...\n');

    // 1. Obtener posiciones disponibles
    const posiciones = await pool.query("SELECT id, item FROM mastercode WHERE lista = 'Puestos roles' ORDER BY id");
    console.log('📋 Posiciones disponibles:');
    posiciones.rows.forEach(pos => {
      console.log(`   ID ${pos.id}: ${pos.item}`);
    });

    // 2. Contar empleados sin posición
    const sinPosicion = await pool.query("SELECT COUNT(*) as total FROM employees_v2 WHERE position_id IS NULL");
    console.log(`\n👥 Empleados sin posición: ${sinPosicion.rows[0].total}`);

    // 3. Asignar una posición por defecto (por ejemplo, la primera disponible)
    if (posiciones.rows.length > 0) {
      const posicionDefault = posiciones.rows[0].id; // Usar la primera posición
      const nombrePosicion = posiciones.rows[0].item;
      
      console.log(`\n🔧 Asignando posición por defecto: "${nombrePosicion}" (ID: ${posicionDefault})`);
      
      const resultado = await pool.query(
        "UPDATE employees_v2 SET position_id = $1 WHERE position_id IS NULL",
        [posicionDefault]
      );
      
      console.log(`✅ ${resultado.rowCount} empleados actualizados`);

      // 4. Verificar el resultado
      console.log('\n🔄 Verificando resultado...');
      const verificacion = await pool.query(`
        SELECT 
          e.first_name,
          e.last_name,
          pos.item as position_name
        FROM employees_v2 e
        LEFT JOIN mastercode pos ON e.position_id = pos.id AND pos.lista = 'Puestos roles'
        WHERE e.position_id = $1
        ORDER BY e.id DESC
        LIMIT 5
      `, [posicionDefault]);

      console.log('📄 Empleados con la nueva posición (últimos 5):');
      verificacion.rows.forEach(emp => {
        console.log(`   ${emp.first_name} ${emp.last_name}: ${emp.position_name}`);
      });

    } else {
      console.log('❌ No hay posiciones disponibles en mastercode');
    }

  } catch (error) {
    console.error('❌ Error:', error);
  }
  
  await pool.end();
}

asignarPosiciones();