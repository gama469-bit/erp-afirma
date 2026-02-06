const { Pool } = require('pg');

// Array de configuraciones a probar
const configs = [
  { name: 'Sin contraseña', password: '' },
  { name: 'Sistemas1', password: 'Sistemas1' },
  { name: 'postgres (por defecto)', password: 'postgres' },
  { name: 'admin', password: 'admin' },
  { name: '123456', password: '123456' },
];

console.log('🔍 Probando acceso a PostgreSQL...\n');

async function testConnection(config) {
  return new Promise((resolve) => {
    const pool = new Pool({
      host: 'localhost',
      port: 5432,
      database: 'postgres',
      user: 'postgres',
      password: config.password,
      connectionTimeoutMillis: 3000,
    });

    pool.query('SELECT 1', (err, result) => {
      pool.end();
      if (err) {
        resolve({ ...config, status: '❌ FALLÓ', error: err.message.split('\n')[0] });
      } else {
        resolve({ ...config, status: '✅ ÉXITO' });
      }
    });
  });
}

async function runTests() {
  for (const config of configs) {
    const result = await testConnection(config);
    console.log(`${result.status} | "${result.password || '(vacía)'}" - ${result.name}`);
    if (result.error) {
      console.log(`       Error: ${result.error}\n`);
    } else {
      console.log('       ✨ ¡Esta contraseña funciona!\n');
    }
  }
}

runTests().catch(console.error);
