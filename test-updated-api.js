// Test rápido para verificar la API con posiciones actualizadas
const fetch = require('node-fetch');

async function testAPIActualizada() {
  try {
    console.log('🧪 Probando API con posiciones actualizadas...\n');

    // Test 1: API de empleados
    const empleados = await fetch('http://localhost:3000/api/employees-v2');
    const empleadosData = await empleados.json();
    
    console.log(`👥 Total empleados: ${empleadosData.length}`);
    console.log('\n📄 Primeros 3 empleados:');
    empleadosData.slice(0, 3).forEach((emp, index) => {
      console.log(`${index + 1}. ${emp.first_name} ${emp.last_name}`);
      console.log(`   Entidad: ${emp.entity_name || 'No asignada'}`);
      console.log(`   Posición: ${emp.position_name || 'No asignada'}`);
      console.log(`   Área: ${emp.area_name || 'No asignada'}`);
      console.log(`   Proyecto: ${emp.project_name || 'No asignado'}`);
      console.log('');
    });

    // Test 2: Verificar que no hay posiciones NULL
    const sinPosicion = empleadosData.filter(emp => !emp.position_name || emp.position_name === 'NULL');
    console.log(`🔍 Empleados sin posición: ${sinPosicion.length}`);

    if (sinPosicion.length > 0) {
      console.log('❌ Aún hay empleados sin posición:');
      sinPosicion.slice(0, 3).forEach(emp => {
        console.log(`   ${emp.first_name} ${emp.last_name}`);
      });
    } else {
      console.log('✅ Todos los empleados tienen posición asignada');
    }

    // Test 3: Estadísticas de posiciones
    const posiciones = {};
    empleadosData.forEach(emp => {
      if (emp.position_name && emp.position_name !== 'NULL') {
        posiciones[emp.position_name] = (posiciones[emp.position_name] || 0) + 1;
      }
    });

    console.log('\n📊 Distribución de posiciones:');
    Object.entries(posiciones)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 8)
      .forEach(([posicion, count]) => {
        console.log(`   ${posicion}: ${count} empleados`);
      });

    console.log('\n✅ Test completado');

  } catch (error) {
    console.error('❌ Error:', error);
  }
}

testAPIActualizada();