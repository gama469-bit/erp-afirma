const http = require('http');

http.get('http://127.0.0.1:3000/api/equipment', res => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => {
    const equipos = JSON.parse(data);
    
    console.log('📊 ESTADÍSTICAS DE EQUIPOS IMPORTADOS:');
    console.log(`Total equipos: ${equipos.length}`);
    
    const categorias = {};
    const estados = {};
    const marcas = {};
    const empleadosAsignados = equipos.filter(eq => eq.asignado_nombre);
    
    equipos.forEach(eq => {
      categorias[eq.categoria] = (categorias[eq.categoria] || 0) + 1;
      estados[eq.estado] = (estados[eq.estado] || 0) + 1;
      if (eq.marca) marcas[eq.marca] = (marcas[eq.marca] || 0) + 1;
    });
    
    console.log(`\n📦 Por Categorías:`);
    Object.entries(categorias).forEach(([cat, count]) => 
      console.log(`  ${cat}: ${count}`)
    );
    
    console.log(`\n🏷️ Por Estado:`);
    Object.entries(estados).forEach(([estado, count]) => 
      console.log(`  ${estado}: ${count}`)
    );
    
    console.log(`\n🏭 Top 5 Marcas:`);
    Object.entries(marcas)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .forEach(([marca, count]) => 
        console.log(`  ${marca}: ${count}`)
      );
    
    console.log(`\n👥 Asignaciones:`);
    console.log(`  Equipos asignados: ${empleadosAsignados.length}`);
    console.log(`  Equipos sin asignar: ${equipos.length - empleadosAsignados.length}`);
    
    console.log(`\n📋 Ejemplos de equipos:`);
    equipos.slice(0, 3).forEach(eq => {
      console.log(`  ${eq.codigo}: ${eq.nombre} (${eq.marca || 'Sin marca'}) - ${eq.asignado_nombre || 'Sin asignar'}`);
    });
  });
});