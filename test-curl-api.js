// Test usando cURL para verificar la API
const { execSync } = require('child_process');

try {
  console.log('🧪 Probando API con cURL...\n');

  // Probar API de empleados
  console.log('👥 Probando /api/employees-v2...');
  const curlCommand = 'curl -s http://localhost:3000/api/employees-v2';
  const result = execSync(curlCommand, { encoding: 'utf-8' });
  
  const empleados = JSON.parse(result);
  console.log(`✅ Total empleados: ${empleados.length}`);
  
  console.log('\n📄 Primeros 3 empleados:');
  empleados.slice(0, 3).forEach((emp, index) => {
    console.log(`${index + 1}. ${emp.first_name} ${emp.last_name}`);
    console.log(`   Entidad: ${emp.entity_name || 'No asignada'}`);
    console.log(`   Posición: ${emp.position_name || 'No asignada'}`);
    console.log(`   Área: ${emp.area_name || 'No asignada'}`);
    console.log('');
  });

  // Verificar posiciones
  const sinPosicion = empleados.filter(emp => !emp.position_name || emp.position_name === 'NULL');
  console.log(`🔍 Empleados sin posición: ${sinPosicion.length}`);
  
  if (sinPosicion.length === 0) {
    console.log('✅ Todos los empleados tienen posición asignada');
  } else {
    console.log('❌ Hay empleados sin posición');
  }

  // Distribución de posiciones
  const posiciones = {};
  empleados.forEach(emp => {
    if (emp.position_name && emp.position_name !== 'NULL') {
      posiciones[emp.position_name] = (posiciones[emp.position_name] || 0) + 1;
    }
  });

  console.log('\n📊 Top 5 posiciones:');
  Object.entries(posiciones)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 5)
    .forEach(([posicion, count]) => {
      console.log(`   ${posicion}: ${count} empleados`);
    });

  console.log('\n✅ API funcionando correctamente');

} catch (error) {
  console.error('❌ Error:', error.message);
}