const { Pool } = require('pg');

console.log('🔧 Iniciando configuración de base de datos...');
console.log('🌍 NODE_ENV:', process.env.NODE_ENV);

// Configuración base para desarrollo local
let dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'BD_afirma',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'admin',
  ssl: false,
  connectionTimeoutMillis: 10000,
  idleTimeoutMillis: 30000,
  max: 10
};

console.log('📊 Configuración final:', {
  user: dbConfig.user,
  host: dbConfig.host,
  database: dbConfig.database,
  port: dbConfig.port,
  ssl: dbConfig.ssl ? 'enabled' : 'disabled',
  password: dbConfig.password ? 'configured' : 'no password'
});

const pool = new Pool(dbConfig);

// Manejo de eventos del pool
pool.on('connect', (client) => {
  console.log('✅ Nueva conexión establecida a la base de datos');
});

pool.on('acquire', (client) => {
  console.log('🔄 Cliente de BD adquirido del pool');
});

pool.on('error', (err, client) => {
  console.error('❌ Error en el pool de BD:', err);
  console.error('🔍 Detalles del error:', {
    message: err.message,
    code: err.code,
    severity: err.severity,
    detail: err.detail
  });
});

pool.on('remove', (client) => {
  console.log('🗑️ Cliente removido del pool');
});

// Función de prueba de conexión
async function testConnection() {
  try {
    console.log('🔍 Probando conexión a la base de datos...');
    const client = await pool.connect();
    const result = await client.query('SELECT NOW() as current_time, current_database() as db_name, current_user as user_name');
    console.log('✅ Conexión exitosa:', result.rows[0]);
    client.release();
    return { success: true, data: result.rows[0] };
  } catch (err) {
    console.error('❌ Error de conexión:', err);
    return { 
      success: false, 
      error: err.message,
      code: err.code,
      detail: err.detail
    };
  }
}

// Función mejorada de query con retry
async function queryWithRetry(text, params, retries = 3) {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      console.log(`🔄 Ejecutando query (intento ${attempt}/${retries})`);
      const result = await pool.query(text, params);
      console.log('✅ Query ejecutada exitosamente');
      return result;
    } catch (err) {
      console.error(`❌ Error en intento ${attempt}:`, err.message);
      
      if (attempt === retries) {
        throw err;
      }
      
      // Esperar antes del siguiente intento
      await new Promise(resolve => setTimeout(resolve, 1000 * attempt));
    }
  }
}

module.exports = {
  query: queryWithRetry,
  testConnection,
  pool,
};
