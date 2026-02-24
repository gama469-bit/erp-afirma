require('dotenv').config();
const express = require('express');
const bodyParser = require('express').json;
const db = require('./db');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Log environment variables for debugging
console.log('🔧 Environment variables:');
console.log('  PORT:', process.env.PORT);
console.log('  NODE_ENV:', process.env.NODE_ENV);
console.log('  DB_HOST:', process.env.DB_HOST);
console.log('  DB_NAME:', process.env.DB_NAME);
console.log('  DB_USER:', process.env.DB_USER);
console.log('  DB_PASSWORD:', process.env.DB_PASSWORD ? '***hidden***' : 'NOT SET');

app.use(bodyParser());

// Configure CORS to allow frontend requests
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  next();
});

// Health endpoint
app.get('/api/health', (req, res) => res.json({ status: 'ok' }));

// Database health check
app.get('/api/health/db', async (req, res) => {
  try {
    const connectionTest = await db.testConnection();
    
    if (connectionTest.success) {
      res.json({
        status: 'success',
        database: 'connected',
        timestamp: new Date().toISOString(),
        connection_info: connectionTest.data
      });
    } else {
      res.status(503).json({
        status: 'error',
        database: 'disconnected',
        error: connectionTest.error,
        code: connectionTest.code,
        detail: connectionTest.detail,
        timestamp: new Date().toISOString()
      });
    }
  } catch (error) {
    console.error('❌ Error en health check:', error);
    res.status(503).json({
      status: 'error',
      database: 'disconnected',
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// Debug endpoint - check tables
app.get('/api/debug/tables', async (req, res) => {
  try {
    const tables = await db.query("SELECT tablename FROM pg_tables WHERE schemaname = 'public'");
    const mastercode = await db.query('SELECT COUNT(*) as count FROM mastercode');
    const employees = await db.query('SELECT COUNT(*) as count FROM employees_v2');
    
    res.json({
      tables: tables.rows.map(r => r.tablename),
      mastercode_count: mastercode.rows[0].count,
      employees_count: employees.rows[0].count
    });
  } catch (err) {
    console.error('❌ Debug tables error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ========== AUTHENTICATION API ==========

// Login endpoint (basic authentication)
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    console.log('🔐 Login attempt for:', email);
    
    // SECURITY: Credentials removed from code. Use database authentication instead.
    // Refer to server/api.js for proper authentication implementation with bcrypt.
    // TODO: Implement database authentication or remove this file if not needed.
    
    return res.status(501).json({ 
      error: 'Authentication not implemented in this server file. Use server/api.js instead.' 
    });
    
    // Generate simple token (for MVP only - use JWT in production)
    const token = Buffer.from(`${email}:${Date.now()}`).toString('base64');
    
    res.json({
      success: true,
      token,
      user: {
        email: user.email,
        role: user.role,
        name: user.name
      }
    });
  } catch (err) {
    console.error('❌ Login error:', err);
    res.status(500).json({ error: 'Error en el servidor' });
  }
});

// Get current user info
app.get('/api/auth/me', (req, res) => {
  const authHeader = req.headers['authorization'];
  
  if (!authHeader) {
    return res.status(401).json({ error: 'No autorizado' });
  }
  
  // For MVP: Basic token validation
  const token = authHeader.replace('Bearer ', '');
  
  try {
    const decoded = Buffer.from(token, 'base64').toString('utf-8');
    const email = decoded.split(':')[0];
    
    // Return mock user (for MVP)
    res.json({
      success: true,
      user: {
        email,
        role: email.includes('admin') ? 'admin' : 'rh',
        name: email.includes('admin') ? 'Administrador' : 'Usuario'
      }
    });
  } catch (err) {
    res.status(401).json({ error: 'Token inválido' });
  }
});

// Logout endpoint
app.post('/api/auth/logout', (req, res) => {
  // For MVP: Just acknowledge
  res.json({ success: true, message: 'Sesión cerrada' });
});

// ========== EMPLOYEES V2 API (NORMALIZED) ==========

// Get all employees with normalized data
app.get('/api/employees-v2', async (req, res) => {
  try {
    const query = `
      SELECT 
        e.*,
        ent.item as entity_name,
        pos.item as position_name,
        ar.item as area_name,
        proj.item as project_name,
        c.item as cell_name
      FROM employees_v2 e
      LEFT JOIN mastercode ent ON e.entity_id = ent.id AND ent.lista = 'Entidad'
      LEFT JOIN mastercode pos ON e.position_id = pos.id AND pos.lista = 'Puestos roles'
      LEFT JOIN mastercode ar ON e.area_id = ar.id AND ar.lista = 'Areas'
      LEFT JOIN mastercode proj ON e.project_id = proj.id AND proj.lista = 'Proyecto'  
      LEFT JOIN mastercode c ON e.cell_id = c.id AND c.lista = 'Celulas'
      ORDER BY e.created_at DESC
    `;
    
    const result = await db.query(query);
    res.json(result.rows);
  } catch (err) {
    console.error('❌ Error fetching employees v2:', err);
    res.status(500).json({ error: 'Error fetching employees' });
  }
});

// Create employee v2
app.post('/api/employees-v2', async (req, res) => {
  try {
    const {
      first_name, last_name, email, birth_date, employee_code, phone, personal_phone,
      position_id, entity_id, area_id, project_id, cell_id, status,
      address, exterior_number, interior_number, colonia, city, state, postal_code, country,
      curp, rfc, nss, passport, gender, marital_status, nationality, blood_type, created_by
    } = req.body;

    if (!first_name || !last_name) {
      return res.status(400).json({ error: 'first_name and last_name are required' });
    }

    const query = `
      INSERT INTO employees_v2 (
        first_name, last_name, email, birth_date, employee_code, phone, personal_phone,
        position_id, entity_id, area_id, project_id, cell_id, status,
        address, exterior_number, interior_number, colonia, city, state, postal_code, country,
        curp, rfc, nss, passport, gender, marital_status, nationality, blood_type, created_by
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30)
      RETURNING *
    `;

    const values = [
      first_name, last_name, email, birth_date, employee_code, phone, personal_phone,
      position_id, entity_id, area_id, project_id, cell_id, status,
      address, exterior_number, interior_number, colonia, city, state, postal_code, country,
      curp, rfc, nss, passport, gender, marital_status, nationality, blood_type, created_by
    ];

    const result = await db.query(query, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('❌ Error creating employee v2:', err);
    res.status(500).json({ error: 'Error creating employee' });
  }
});

// Update employee v2
app.put('/api/employees-v2/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const updateFields = req.body;
    
    const setClause = Object.keys(updateFields).map((key, index) => `${key} = $${index + 2}`).join(', ');
    const values = [id, ...Object.values(updateFields)];
    
    const query = `UPDATE employees_v2 SET ${setClause}, updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *`;
    
    const result = await db.query(query, values);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Employee not found' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('❌ Error updating employee v2:', err);
    res.status(500).json({ error: 'Error updating employee' });
  }
});

// Delete employee v2
app.delete('/api/employees-v2/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('DELETE FROM employees_v2 WHERE id = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Employee not found' });
    }
    
    res.json({ message: 'Employee deleted successfully' });
  } catch (err) {
    console.error('❌ Error deleting employee v2:', err);
    res.status(500).json({ error: 'Error deleting employee' });
  }
});

// ========== MASTERCODE API ==========

// Get mastercode by category
app.get('/api/mastercode/:category', async (req, res) => {
  try {
    const { category } = req.params;
    const result = await db.query('SELECT id, item as name, lista as category FROM mastercode WHERE lista = $1 ORDER BY item', [category]);
    res.json(result.rows);
  } catch (err) {
    console.error('❌ Error fetching mastercode:', err);
    res.status(500).json({ error: 'Error fetching mastercode' });
  }
});

// Migration endpoint (for admin use)
app.post('/api/migrate/inventory', async (req, res) => {
  try {
    console.log('🔧 Running inventory migration...');
    
    const migrationSQL = `
      -- Crear tabla de inventario de equipos
      CREATE TABLE IF NOT EXISTS inventory (
          id SERIAL PRIMARY KEY,
          equipment_type VARCHAR(100) NOT NULL,
          brand VARCHAR(100),
          model VARCHAR(100),
          serial_number VARCHAR(100) UNIQUE,
          asset_tag VARCHAR(50) UNIQUE,
          status VARCHAR(50) DEFAULT 'active',
          location VARCHAR(200),
          assigned_to INTEGER REFERENCES employees_v2(id),
          purchase_date DATE,
          purchase_price DECIMAL(10,2),
          warranty_expiry DATE,
          description TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Insertar algunos datos de ejemplo solo si no existen
      INSERT INTO inventory (equipment_type, brand, model, serial_number, asset_tag, status, location, purchase_date, purchase_price, warranty_expiry, description)
      SELECT * FROM (VALUES 
          ('Laptop', 'Dell', 'Latitude 7420', 'DL123456789', 'IT-001', 'active', 'Oficina Central', '2023-01-15'::date, 1200.00, '2026-01-15'::date, 'Laptop para desarrollo'),
          ('Monitor', 'Samsung', '24" LED', 'SM987654321', 'IT-002', 'active', 'Oficina Central', '2023-02-20'::date, 300.00, '2025-02-20'::date, 'Monitor secundario'),
          ('Mouse', 'Logitech', 'MX Master 3', 'LG456789123', 'IT-003', 'active', 'Oficina Central', '2023-03-10'::date, 80.00, '2024-03-10'::date, 'Mouse inalámbrico'),
          ('Teclado', 'Logitech', 'K380', 'LG789123456', 'IT-004', 'maintenance', 'Almacén TI', '2023-01-25'::date, 45.00, '2024-01-25'::date, 'Teclado bluetooth en mantenimiento'),
          ('Impresora', 'HP', 'LaserJet Pro', 'HP321654987', 'IT-005', 'active', 'Área Administrativa', '2022-11-30'::date, 250.00, '2024-11-30'::date, 'Impresora láser compartida')
      ) AS v(equipment_type, brand, model, serial_number, asset_tag, status, location, purchase_date, purchase_price, warranty_expiry, description)
      WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE serial_number = v.serial_number);

      -- Crear índices para mejor rendimiento
      CREATE INDEX IF NOT EXISTS idx_inventory_equipment_type ON inventory(equipment_type);
      CREATE INDEX IF NOT EXISTS idx_inventory_status ON inventory(status);
      CREATE INDEX IF NOT EXISTS idx_inventory_assigned_to ON inventory(assigned_to);
      CREATE INDEX IF NOT EXISTS idx_inventory_asset_tag ON inventory(asset_tag);
    `;

    await db.query(migrationSQL);
    console.log('✅ Inventory migration completed successfully');
    
    res.json({ 
      success: true, 
      message: 'Inventory migration completed successfully' 
    });
  } catch (error) {
    console.error('❌ Error running inventory migration:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error running inventory migration',
      details: error.message 
    });
  }
});

// ========== INVENTORY API ==========
app.get('/api/inventory', async (req, res) => {
  try {
    console.log('📦 Fetching equipment from equipment table...');
    const result = await db.query(`
      SELECT 
        e.*,
        COALESCE(emp.first_name || ' ' || emp.last_name, 'Sin asignar') as asignado_nombre
      FROM equipment e
      LEFT JOIN employees_v2 emp ON e.asignado_id = emp.id
      ORDER BY e.created_at DESC
    `);
    
    console.log(`✅ Found ${result.rows.length} equipment items`);
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error fetching equipment:', error);
    res.status(500).json({ 
      error: 'Error fetching equipment',
      details: error.message 
    });
  }
});

app.post('/api/inventory', async (req, res) => {
  try {
    console.log('📦 Creating new inventory item:', req.body);
    const {
      equipment_type, brand, model, serial_number, asset_tag,
      status, location, assigned_to, purchase_date, purchase_price,
      warranty_expiry, description
    } = req.body;

    const result = await db.query(`
      INSERT INTO inventory (
        equipment_type, brand, model, serial_number, asset_tag,
        status, location, assigned_to, purchase_date, purchase_price,
        warranty_expiry, description
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      RETURNING *
    `, [
      equipment_type, brand, model, serial_number, asset_tag,
      status || 'active', location, assigned_to || null, 
      purchase_date || null, purchase_price || null,
      warranty_expiry || null, description || null
    ]);

    console.log('✅ Created inventory item:', result.rows[0]);
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('❌ Error creating inventory item:', error);
    res.status(500).json({ 
      error: 'Error creating inventory item',
      details: error.message 
    });
  }
});

app.put('/api/inventory/:id', async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`📦 Updating inventory item ${id}:`, req.body);
    
    const {
      equipment_type, brand, model, serial_number, asset_tag,
      status, location, assigned_to, purchase_date, purchase_price,
      warranty_expiry, description
    } = req.body;

    const result = await db.query(`
      UPDATE inventory SET
        equipment_type = $1, brand = $2, model = $3, serial_number = $4,
        asset_tag = $5, status = $6, location = $7, assigned_to = $8,
        purchase_date = $9, purchase_price = $10, warranty_expiry = $11,
        description = $12, updated_at = CURRENT_TIMESTAMP
      WHERE id = $13
      RETURNING *
    `, [
      equipment_type, brand, model, serial_number, asset_tag,
      status, location, assigned_to || null, purchase_date || null,
      purchase_price || null, warranty_expiry || null, description || null, id
    ]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Inventory item not found' });
    }

    console.log('✅ Updated inventory item:', result.rows[0]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('❌ Error updating inventory item:', error);
    res.status(500).json({ 
      error: 'Error updating inventory item',
      details: error.message 
    });
  }
});

app.delete('/api/inventory/:id', async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`📦 Deleting inventory item ${id}`);

    const result = await db.query('DELETE FROM inventory WHERE id = $1 RETURNING *', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Inventory item not found' });
    }

    console.log('✅ Deleted inventory item:', result.rows[0]);
    res.json({ message: 'Inventory item deleted successfully' });
  } catch (error) {
    console.error('❌ Error deleting inventory item:', error);
    res.status(500).json({ 
      error: 'Error deleting inventory item',
      details: error.message 
    });
  }
});

// ========== MASTERCODE CATEGORIES API ==========

// Get inventory categories from mastercode
app.get('/api/mastercode/inventario-categorias', async (req, res) => {
  try {
    console.log('📂 Fetching inventory categories from mastercode...');
    const result = await db.query(`
      SELECT id, lista, item, created_at, updated_at
      FROM mastercode 
      WHERE lista = 'inventario de categoria de equipos'
      ORDER BY item
    `);
    
    console.log(`✅ Found ${result.rows.length} inventory categories`);
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error fetching inventory categories:', error);
    res.status(500).json({ 
      error: 'Error fetching inventory categories',
      details: error.message 
    });
  }
});

// Add new inventory category to mastercode
app.post('/api/mastercode/inventario-categorias', async (req, res) => {
  try {
    const { name } = req.body;
    
    if (!name || typeof name !== 'string' || name.trim() === '') {
      return res.status(400).json({ error: 'Category name is required' });
    }
    
    const categoryName = name.trim();
    console.log('➕ Adding new inventory category:', categoryName);
    
    // Check if category already exists
    const existingResult = await db.query(`
      SELECT id FROM mastercode 
      WHERE lista = 'inventario de categoria de equipos' AND LOWER(item) = LOWER($1)
    `, [categoryName]);
    
    if (existingResult.rows.length > 0) {
      return res.status(409).json({ error: 'Category already exists' });
    }
    
    // Insert new category
    const insertResult = await db.query(`
      INSERT INTO mastercode (lista, item, created_at, updated_at)
      VALUES ('inventario de categoria de equipos', $1, NOW(), NOW())
      RETURNING *
    `, [categoryName]);
    
    console.log('✅ New category added:', insertResult.rows[0]);
    res.status(201).json(insertResult.rows[0]);
  } catch (error) {
    console.error('❌ Error adding inventory category:', error);
    res.status(500).json({ 
      error: 'Error adding inventory category',
      details: error.message 
    });
  }
});

// Delete inventory category from mastercode
app.delete('/api/mastercode/inventario-categorias/:id', async (req, res) => {
  try {
    const { id } = req.params;
    console.log('🗑️ Deleting inventory category with ID:', id);
    
    // Check if category exists
    const existingResult = await db.query(`
      SELECT * FROM mastercode 
      WHERE id = $1 AND lista = 'inventario de categoria de equipos'
    `, [id]);
    
    if (existingResult.rows.length === 0) {
      return res.status(404).json({ error: 'Category not found' });
    }
    
    // Delete category
    const deleteResult = await db.query(`
      DELETE FROM mastercode 
      WHERE id = $1 AND lista = 'inventario de categoria de equipos'
      RETURNING *
    `, [id]);
    
    console.log('✅ Category deleted:', deleteResult.rows[0]);
    res.json({ 
      message: 'Category deleted successfully',
      deleted: deleteResult.rows[0]
    });
  } catch (error) {
    console.error('❌ Error deleting inventory category:', error);
    res.status(500).json({ 
      error: 'Error deleting inventory category',
      details: error.message 
    });
  }
});

// ========== GENERAL MASTERCODE API ==========

// Get items from any mastercode list
app.get('/api/mastercode/:lista', async (req, res) => {
  try {
    const { lista } = req.params;
    console.log(`📂 Fetching items from mastercode list: ${lista}`);
    
    const result = await db.query(`
      SELECT id, lista, item, created_at, updated_at
      FROM mastercode 
      WHERE lista = $1
      ORDER BY item
    `, [lista]);
    
    console.log(`✅ Found ${result.rows.length} items in list '${lista}'`);
    res.json(result.rows);
  } catch (error) {
    console.error(`❌ Error fetching mastercode list '${req.params.lista}':`, error);
    res.status(500).json({ 
      error: 'Error fetching mastercode list',
      details: error.message 
    });
  }
});

// Add new item to mastercode list
app.post('/api/mastercode/:lista', async (req, res) => {
  try {
    const { lista } = req.params;
    const { name } = req.body;
    
    if (!name || typeof name !== 'string' || name.trim() === '') {
      return res.status(400).json({ error: 'Item name is required' });
    }
    
    const itemName = name.trim();
    console.log(`➕ Adding new item to list '${lista}': ${itemName}`);
    
    // Check if item already exists in this list
    const existingResult = await db.query(`
      SELECT id FROM mastercode 
      WHERE lista = $1 AND LOWER(item) = LOWER($2)
    `, [lista, itemName]);
    
    if (existingResult.rows.length > 0) {
      return res.status(409).json({ error: 'Item already exists in this list' });
    }
    
    // Insert new item
    const insertResult = await db.query(`
      INSERT INTO mastercode (lista, item, created_at, updated_at)
      VALUES ($1, $2, NOW(), NOW())
      RETURNING *
    `, [lista, itemName]);
    
    console.log(`✅ New item added to '${lista}':`, insertResult.rows[0]);
    res.status(201).json(insertResult.rows[0]);
  } catch (error) {
    console.error(`❌ Error adding item to mastercode list '${req.params.lista}':`, error);
    res.status(500).json({ 
      error: 'Error adding item to mastercode list',
      details: error.message 
    });
  }
});

// Delete item from mastercode list
app.delete('/api/mastercode/:lista/:id', async (req, res) => {
  try {
    const { lista, id } = req.params;
    console.log(`🗑️ Deleting item ID ${id} from list '${lista}'`);
    
    // Check if item exists in the specified list
    const existingResult = await db.query(`
      SELECT * FROM mastercode 
      WHERE id = $1 AND lista = $2
    `, [id, lista]);
    
    if (existingResult.rows.length === 0) {
      return res.status(404).json({ error: 'Item not found in this list' });
    }
    
    // Delete item
    const deleteResult = await db.query(`
      DELETE FROM mastercode 
      WHERE id = $1 AND lista = $2
      RETURNING *
    `, [id, lista]);
    
    console.log(`✅ Item deleted from '${lista}':`, deleteResult.rows[0]);
    res.json({ 
      message: 'Item deleted successfully',
      deleted: deleteResult.rows[0]
    });
  } catch (error) {
    console.error(`❌ Error deleting item from mastercode list '${req.params.lista}':`, error);
    res.status(500).json({ 
      error: 'Error deleting item from mastercode list',
      details: error.message 
    });
  }
});

// Get all available lists
app.get('/api/mastercode', async (req, res) => {
  try {
    console.log('📋 Fetching all mastercode lists');
    
    const result = await db.query(`
      SELECT lista, COUNT(*) as count 
      FROM mastercode 
      GROUP BY lista 
      ORDER BY lista
    `);
    
    console.log(`✅ Found ${result.rows.length} different lists`);
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error fetching mastercode lists:', error);
    res.status(500).json({ 
      error: 'Error fetching mastercode lists',
      details: error.message 
    });
  }
});

// ========== CANDIDATES API ==========

// Get candidates
app.get('/api/candidates', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM candidates ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (err) {
    console.error('❌ Error fetching candidates:', err);
    res.status(500).json({ error: 'Error fetching candidates' });
  }
});

// Create candidate
app.post('/api/candidates', async (req, res) => {
  try {
    const { first_name, last_name, email, phone, position_applied, status, notes } = req.body;

    if (!first_name || !last_name || !position_applied) {
      return res.status(400).json({ error: 'first_name, last_name and position_applied are required' });
    }

    const query = `
      INSERT INTO candidates (first_name, last_name, email, phone, position_applied, status, notes)
      VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *
    `;

    const result = await db.query(query, [first_name, last_name, email, phone, position_applied, status, notes]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('❌ Error creating candidate:', err);
    res.status(500).json({ error: 'Error creating candidate' });
  }
});

// Update candidate
app.put('/api/candidates/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { first_name, last_name, email, phone, position_applied, status, notes } = req.body;

    const query = `
      UPDATE candidates 
      SET first_name = $2, last_name = $3, email = $4, phone = $5, position_applied = $6, status = $7, notes = $8, updated_at = CURRENT_TIMESTAMP
      WHERE id = $1 RETURNING *
    `;

    const result = await db.query(query, [id, first_name, last_name, email, phone, position_applied, status, notes]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Candidate not found' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('❌ Error updating candidate:', err);
    res.status(500).json({ error: 'Error updating candidate' });
  }
});

// Delete candidate
app.delete('/api/candidates/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('DELETE FROM candidates WHERE id = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Candidate not found' });
    }
    
    res.json({ message: 'Candidate deleted successfully' });
  } catch (err) {
    console.error('❌ Error deleting candidate:', err);
    res.status(500).json({ error: 'Error deleting candidate' });
  }
});

// Import API routes from api.js
require('./api')(app);

// Serve static frontend files from the project's `src` folder
app.use(express.static(path.join(__dirname, '..', 'src')));

// Fallback to index.html for SPA root path
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'src', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
