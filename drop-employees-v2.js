// Script para limpiar la tabla employees_v2
require('dotenv').config();
const db = require('./db');

async function dropTable() {
  try {
    console.log('🗑️ Eliminando tabla employees_v2...');
    await db.query('DROP TABLE IF EXISTS employees_v2 CASCADE;');
    console.log('✅ Tabla eliminada correctamente');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error:', err.message);
    process.exit(1);
  }
}

dropTable();
