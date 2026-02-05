// Script para distribuir posiciones de forma más realista
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_afirma',
  password: 'Sistemas1',
  port: 5432,
});

async function distribuirPosiciones() {
  try {
    console.log('🔧 Distribuyendo posiciones de forma realista...\n');

    // Posiciones más comunes y sus probabilidades
    const posicionesComunes = [
      { id: 41, nombre: 'Desarrollador Junior', peso: 25 },
      { id: 113, nombre: 'Desarrollador Java', peso: 20 },
      { id: 16, nombre: 'Desarrollador WEB', peso: 15 },
      { id: 120, nombre: 'Front End', peso: 15 },
      { id: 20, nombre: 'Analista', peso: 10 },
      { id: 168, nombre: 'Tester', peso: 8 },
      { id: 46, nombre: 'Project Manager', peso: 4 },
      { id: 122, nombre: 'Gerente', peso: 3 }
    ];

    // Obtener todos los empleados
    const empleados = await pool.query("SELECT id FROM employees_v2 ORDER BY id");
    console.log(`👥 Total empleados: ${empleados.rows.length}`);

    // Distribuir posiciones
    let empleadosActualizados = 0;
    
    for (let i = 0; i < empleados.rows.length; i++) {
      const empleadoId = empleados.rows[i].id;
      
      // Seleccionar posición basada en peso/probabilidad
      const random = Math.random() * 100;
      let acumulado = 0;
      let posicionSeleccionada = posicionesComunes[0]; // fallback
      
      for (const pos of posicionesComunes) {
        acumulado += pos.peso;
        if (random <= acumulado) {
          posicionSeleccionada = pos;
          break;
        }
      }
      
      // Actualizar empleado
      await pool.query(
        "UPDATE employees_v2 SET position_id = $1 WHERE id = $2",
        [posicionSeleccionada.id, empleadoId]
      );
      
      empleadosActualizados++;
    }

    console.log(`✅ ${empleadosActualizados} empleados actualizados con distribución realista`);

    // Verificar distribución
    console.log('\n📊 Distribución final:');
    const distribucion = await pool.query(`
      SELECT 
        pos.item as position_name,
        COUNT(*) as empleados
      FROM employees_v2 e
      JOIN mastercode pos ON e.position_id = pos.id AND pos.lista = 'Puestos roles'
      GROUP BY pos.item
      ORDER BY empleados DESC
    `);

    distribucion.rows.forEach(row => {
      console.log(`   ${row.position_name}: ${row.empleados} empleados`);
    });

    // Probar query de API
    console.log('\n🔄 Probando query de API actualizado...');
    const apiResult = await pool.query(`
      SELECT 
        e.first_name,
        e.last_name,
        ent.item as entity_name,
        pos.item as position_name,
        ar.item as area_name
      FROM employees_v2 e
      LEFT JOIN mastercode ent ON e.entity_id = ent.id AND ent.lista = 'Entidad'
      LEFT JOIN mastercode pos ON e.position_id = pos.id AND pos.lista = 'Puestos roles'
      LEFT JOIN mastercode ar ON e.area_id = ar.id AND ar.lista = 'Areas'
      ORDER BY e.id DESC
      LIMIT 5
    `);

    console.log('📄 Últimos 5 empleados con datos completos:');
    apiResult.rows.forEach(emp => {
      console.log(`   ${emp.first_name} ${emp.last_name}:`);
      console.log(`     Entidad: ${emp.entity_name || 'NULL'}`);
      console.log(`     Posición: ${emp.position_name || 'NULL'}`);
      console.log(`     Área: ${emp.area_name || 'NULL'}`);
      console.log('');
    });

  } catch (error) {
    console.error('❌ Error:', error);
  }
  
  await pool.end();
}

distribuirPosiciones();