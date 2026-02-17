// Script para arreglar la tabla mastercode
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD
});

async function fixMastercode() {
  try {
    console.log('Verificando estructura de mastercode...');
    
    // Verificar si la tabla existe
    const tableCheck = await pool.query(`
      SELECT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_name = 'mastercode'
      ) as exists
    `);
    
    console.log('Tabla mastercode existe:', tableCheck.rows[0].exists);
    
    if (tableCheck.rows[0].exists) {
      // Ver las columnas actuales
      const cols = await pool.query(`
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = 'mastercode'
      `);
      
      console.log('Columnas actuales:', cols.rows);
      
      // Eliminar y recrear
      console.log('Eliminando tabla mastercode...');
      await pool.query('DROP TABLE IF EXISTS mastercode CASCADE');
    }
    
    // Crear tabla correcta
    console.log('Creando mastercode con estructura correcta...');
    await pool.query(`
      CREATE TABLE mastercode (
        id SERIAL PRIMARY KEY,
        lista VARCHAR(50) NOT NULL,
        item VARCHAR(200) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    // Crear índices
    console.log('Creando índices...');
    await pool.query('CREATE INDEX idx_mastercode_lista ON mastercode(lista)');
    await pool.query('CREATE INDEX idx_mastercode_lista_item ON mastercode(lista, item)');
    
    console.log('✅ Mastercode arreglado exitosamente!');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error:', err.message);
    process.exit(1);
  }
}

fixMastercode();
