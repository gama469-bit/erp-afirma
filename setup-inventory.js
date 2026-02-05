// Script para verificar y crear la tabla de inventario
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_afirma',
  password: 'Sistemas1',
  port: 5432,
});

async function setupInventory() {
  try {
    console.log('📦 Configurando tabla de inventario...\n');

    // 1. Verificar si la tabla existe
    const tableExists = await pool.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' AND table_name = 'inventory'
      );
    `);
    
    console.log(`📋 ¿Tabla inventory existe? ${tableExists.rows[0].exists}`);

    if (!tableExists.rows[0].exists) {
      console.log('🔧 Creando tabla de inventario...');
      
      await pool.query(`
        CREATE TABLE IF NOT EXISTS inventory (
          id SERIAL PRIMARY KEY,
          equipment_type VARCHAR(100) NOT NULL,
          brand VARCHAR(100),
          model VARCHAR(100),
          serial_number VARCHAR(100) UNIQUE,
          asset_tag VARCHAR(50),
          status VARCHAR(50) DEFAULT 'Disponible',
          location VARCHAR(100),
          assigned_to INTEGER REFERENCES employees_v2(id),
          purchase_date DATE,
          purchase_price DECIMAL(12,2),
          warranty_expiry DATE,
          description TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      `);
      
      console.log('✅ Tabla de inventario creada');
      
      // Crear índices
      await pool.query(`
        CREATE INDEX IF NOT EXISTS idx_inventory_equipment_type ON inventory(equipment_type);
        CREATE INDEX IF NOT EXISTS idx_inventory_status ON inventory(status);
        CREATE INDEX IF NOT EXISTS idx_inventory_assigned_to ON inventory(assigned_to);
        CREATE INDEX IF NOT EXISTS idx_inventory_asset_tag ON inventory(asset_tag);
      `);
      
      console.log('✅ Índices creados');
    }

    // 2. Verificar si tiene datos
    const count = await pool.query('SELECT COUNT(*) FROM inventory');
    console.log(`📊 Equipos en inventario: ${count.rows[0].count}`);

    if (count.rows[0].count == 0) {
      console.log('🔧 Insertando datos de ejemplo...');
      
      await pool.query(`
        INSERT INTO inventory (equipment_type, brand, model, serial_number, asset_tag, status, location, purchase_date, purchase_price, description)
        VALUES 
        ('Laptop', 'Dell', 'Latitude 5520', 'DL001234', 'LAP001', 'Disponible', 'Oficina Principal', '2023-01-15', 1200.00, 'Laptop para desarrollo'),
        ('Monitor', 'Samsung', 'LC24F390F', 'SM005678', 'MON001', 'Asignado', 'Oficina Principal', '2023-02-20', 250.00, 'Monitor 24 pulgadas'),
        ('Mouse', 'Logitech', 'MX Master 3', 'LG009876', 'MOU001', 'Disponible', 'Almacén', '2023-03-10', 80.00, 'Mouse inalámbrico'),
        ('Teclado', 'Corsair', 'K70 RGB', 'CR001122', 'TEC001', 'En reparación', 'Almacén', '2023-01-30', 150.00, 'Teclado mecánico'),
        ('Impresora', 'HP', 'LaserJet Pro M404n', 'HP334455', 'IMP001', 'Disponible', 'Oficina Principal', '2022-12-05', 300.00, 'Impresora láser');
      `);
      
      console.log('✅ Datos de ejemplo insertados');
    }

    // 3. Mostrar datos
    const sample = await pool.query(`
      SELECT 
        equipment_type, brand, model, status, location
      FROM inventory 
      ORDER BY id 
      LIMIT 5
    `);
    
    console.log('\n📄 Equipos en inventario:');
    sample.rows.forEach(item => {
      console.log(`   ${item.equipment_type} ${item.brand} ${item.model} - ${item.status} (${item.location})`);
    });

    console.log('\n✅ Inventario configurado correctamente');

  } catch (error) {
    console.error('❌ Error:', error);
  }
  
  await pool.end();
}

setupInventory();