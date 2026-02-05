// Test simple para verificar API de inventario
console.log('🧪 Probando API de inventario...');

// Simular petición HTTP
async function testInventoryAPI() {
  try {
    const http = require('http');
    
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: '/api/inventory',
      method: 'GET'
    };

    return new Promise((resolve, reject) => {
      const req = http.request(options, (res) => {
        let data = '';

        res.on('data', (chunk) => {
          data += chunk;
        });

        res.on('end', () => {
          if (res.statusCode === 200) {
            const result = JSON.parse(data);
            console.log(`✅ API responde: ${result.length} items encontrados`);
            if (result.length > 0) {
              console.log(`📄 Primer item: ${result[0].equipment_type} ${result[0].brand || ''} ${result[0].model || ''}`);
              console.log(`   Estado: ${result[0].status}`);
              console.log(`   Ubicación: ${result[0].location || 'N/A'}`);
            }
            resolve(result);
          } else {
            reject(new Error(`HTTP ${res.statusCode}`));
          }
        });
      });

      req.on('error', (err) => {
        reject(err);
      });

      req.end();
    });

  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

testInventoryAPI()
  .then(() => console.log('✅ Test completado'))
  .catch(err => console.error('❌ Test falló:', err.message));