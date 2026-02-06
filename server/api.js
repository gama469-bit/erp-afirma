require('dotenv').config();
const express = require('express');
const bodyParser = require('express').json;
const db = require('./db');
const multer = require('multer');
const XLSX = require('xlsx');
const path = require('path');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

const app = express();
const PORT = process.env.API_PORT || 3000;

app.use(bodyParser());

// Configure CORS to allow frontend requests
app.use((req, res, next) => {
  // Only log non-health check requests to reduce noise
  if (!req.url.includes('/health')) {
    console.log(`🌐 CORS middleware - ${req.method} ${req.url}`);
  }
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  
  if (req.method === 'OPTIONS') {
    if (!req.url.includes('/health')) {
      console.log('✅ Handling OPTIONS request');
    }
    return res.status(200).end();
  }
  
  next();
});

// JWT Configuration
const JWT_SECRET = process.env.JWT_SECRET || 'erp-afirma-secret-key-change-in-production';
const JWT_EXPIRES_IN = '24h';

// Authentication Middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(401).json({ error: 'Token de autenticación requerido' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Token inválido o expirado' });
    }
    req.user = user;
    next();
  });
};

// Authorization Middleware - Check user has required role
const authorizeRoles = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: 'Usuario no autenticado' });
    }
    
    if (!allowedRoles.includes(req.user.role_name)) {
      return res.status(403).json({ 
        error: 'No tienes permisos para realizar esta acción',
        required_roles: allowedRoles,
        your_role: req.user.role_name
      });
    }
    
    next();
  };
};

// Configure multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({ 
  storage,
  fileFilter: (req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    if (['.xlsx', '.xls', '.csv'].includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error('Only Excel and CSV files are allowed'));
    }
  }
});

// Helpers: resolve or create entity/position by name
async function findOrCreateEntity(name) {
  if (!name) return null;
  const clean = String(name).trim();
  if (!clean) return null;
  try {
    const found = await db.query("SELECT id FROM mastercode WHERE lista = 'Entidad' AND LOWER(item) = LOWER($1) LIMIT 1", [clean]);
    if (found.rowCount > 0) return found.rows[0].id;
    const inserted = await db.query("INSERT INTO mastercode (lista, item) VALUES ('Entidad', $1) RETURNING id", [clean]);
    return inserted.rows[0].id;
  } catch (err) {
    console.error('Error resolving/creating entity', err);
    return null;
  }
}

async function findOrCreatePosition(name, entity_id) {
  if (!name) return null;
  const clean = String(name).trim();
  if (!clean) return null;
  try {
    // try matching by name (case-insensitive)
    const found = await db.query("SELECT id FROM mastercode WHERE lista = 'Puestos roles' AND LOWER(item) = LOWER($1) LIMIT 1", [clean]);
    if (found.rowCount > 0) return found.rows[0].id;
    const inserted = await db.query(
      "INSERT INTO mastercode (lista, item) VALUES ('Puestos roles', $1) RETURNING id",
      [clean]
    );
    return inserted.rows[0].id;
  } catch (err) {
    console.error('Error resolving/creating position', err);
    return null;
  }
}

// Helpers catálogo: área, proyecto y célula
async function findOrCreateArea(name) {
  if (!name) return null;
  const clean = String(name).trim();
  if (!clean) return null;
  try {
    const found = await db.query("SELECT id FROM mastercode WHERE lista = 'Areas' AND LOWER(item) = LOWER($1) LIMIT 1", [clean]);
    if (found.rowCount > 0) return found.rows[0].id;
    const ins = await db.query("INSERT INTO mastercode (lista, item) VALUES ('Areas', $1) RETURNING id", [clean]);
    return ins.rows[0].id;
  } catch (err) {
    console.error('Error resolving/creating area', err);
    return null;
  }
}
async function findOrCreateProject(name, area_id) {
  if (!name) return null;
  const clean = String(name).trim();
  if (!clean) return null;
  try {
    const found = await db.query("SELECT id FROM mastercode WHERE lista = 'Proyecto' AND LOWER(item) = LOWER($1) LIMIT 1", [clean]);
    if (found.rowCount > 0) return found.rows[0].id;
    const ins = await db.query("INSERT INTO mastercode (lista, item) VALUES ('Proyecto', $1) RETURNING id", [clean]);
    return ins.rows[0].id;
  } catch (err) {
    console.error('Error resolving/creating project', err);
    return null;
  }
}
async function findOrCreateCell(name, area_id, project_id) {
  if (!name) return null;
  const clean = String(name).trim();
  if (!clean) return null;
  try {
    const found = await db.query("SELECT id FROM mastercode WHERE lista = 'Celulas' AND LOWER(item) = LOWER($1) LIMIT 1", [clean]);
    if (found.rowCount > 0) return found.rows[0].id;
    const ins = await db.query("INSERT INTO mastercode (lista, item) VALUES ('Celulas', $1) RETURNING id", [clean]);
    return ins.rows[0].id;
  } catch (err) {
    console.error('Error resolving/creating cell', err);
    return null;
  }
}

// Date helpers
function normalizeDateInput(value) {
  if (!value) return null;
  const s = String(value).trim();
  if (!s) return null;
  // Accept YYYY-MM-DD or ISO strings
  const d = new Date(s);
  if (isNaN(d.getTime())) return null;
  // Return YYYY-MM-DD
  return d.toISOString().split('T')[0];
}

function isFutureDate(dateStr) {
  if (!dateStr) return false;
  const d = new Date(dateStr);
  if (isNaN(d.getTime())) return false;
  const today = new Date();
  // compare only date portion
  const dd = new Date(d.getFullYear(), d.getMonth(), d.getDate());
  const td = new Date(today.getFullYear(), today.getMonth(), today.getDate());
  return dd > td;
}

// Health
app.get('/api/health', (req, res) => res.json({ status: 'ok' }));

// ========== AUTHENTICATION ENDPOINTS ==========

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email y contraseña son requeridos' });
    }

    // Find user by email
    const userQuery = `
      SELECT u.*, r.name as role_name, r.permissions 
      FROM users u
      LEFT JOIN roles r ON u.role_id = r.id
      WHERE u.email = $1 AND u.status = 'Activo'
    `;
    const result = await db.query(userQuery, [email]);

    if (result.rowCount === 0) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    const user = result.rows[0];

    // Verify password
    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    // Update last login
    await db.query('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = $1', [user.id]);

    // Generate JWT
    const token = jwt.sign(
      {
        id: user.id,
        email: user.email,
        role_id: user.role_id,
        role_name: user.role_name,
        permissions: user.permissions
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    );

    // Return user info (without password hash)
    res.json({
      token,
      user: {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        role_id: user.role_id,
        role_name: user.role_name,
        permissions: user.permissions,
        employee_id: user.employee_id
      }
    });
  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({ error: 'Error al iniciar sesión' });
  }
});

// Register new user (Admin only)
app.post('/api/auth/register', authenticateToken, authorizeRoles('Administrador'), async (req, res) => {
  try {
    const { email, password, first_name, last_name, role_id, employee_id } = req.body;

    if (!email || !password || !first_name || !last_name || !role_id) {
      return res.status(400).json({ 
        error: 'Email, contraseña, nombre, apellido y rol son requeridos' 
      });
    }

    // Check if user already exists
    const existingUser = await db.query('SELECT id FROM users WHERE email = $1', [email]);
    if (existingUser.rowCount > 0) {
      return res.status(409).json({ error: 'El email ya está registrado' });
    }

    // Hash password
    const saltRounds = 10;
    const password_hash = await bcrypt.hash(password, saltRounds);

    // Create user
    const insertQuery = `
      INSERT INTO users (email, password_hash, first_name, last_name, role_id, employee_id, status)
      VALUES ($1, $2, $3, $4, $5, $6, 'Activo')
      RETURNING id, email, first_name, last_name, role_id, employee_id, status, created_at
    `;
    const result = await db.query(insertQuery, [
      email,
      password_hash,
      first_name,
      last_name,
      role_id,
      employee_id || null
    ]);

    res.status(201).json({
      message: 'Usuario creado exitosamente',
      user: result.rows[0]
    });
  } catch (error) {
    console.error('Error al registrar usuario:', error);
    res.status(500).json({ error: 'Error al crear usuario' });
  }
});

// Get current user info
app.get('/api/auth/me', authenticateToken, async (req, res) => {
  try {
    const userQuery = `
      SELECT u.id, u.email, u.first_name, u.last_name, u.role_id, u.employee_id, 
             u.status, u.last_login, r.name as role_name, r.permissions
      FROM users u
      LEFT JOIN roles r ON u.role_id = r.id
      WHERE u.id = $1
    `;
    const result = await db.query(userQuery, [req.user.id]);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error al obtener usuario:', error);
    res.status(500).json({ error: 'Error al obtener información del usuario' });
  }
});

// Logout (client-side only, just for logging)
app.post('/api/auth/logout', authenticateToken, (req, res) => {
  console.log(`🔓 Usuario ${req.user.email} cerró sesión`);
  res.json({ message: 'Sesión cerrada exitosamente' });
});

// Get all users (Admin only)
app.get('/api/auth/users', authenticateToken, authorizeRoles('Administrador'), async (req, res) => {
  try {
    const query = `
      SELECT u.id, u.email, u.first_name, u.last_name, u.role_id, u.employee_id,
             u.status, u.last_login, u.created_at, r.name as role_name
      FROM users u
      LEFT JOIN roles r ON u.role_id = r.id
      ORDER BY u.created_at DESC
    `;
    const result = await db.query(query);
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener usuarios:', error);
    res.status(500).json({ error: 'Error al obtener usuarios' });
  }
});

// Update user (Admin only)
app.put('/api/auth/users/:id', authenticateToken, authorizeRoles('Administrador'), async (req, res) => {
  try {
    const { id } = req.params;
    const { email, first_name, last_name, role_id, employee_id, status } = req.body;

    const updateQuery = `
      UPDATE users 
      SET email = COALESCE($1, email),
          first_name = COALESCE($2, first_name),
          last_name = COALESCE($3, last_name),
          role_id = COALESCE($4, role_id),
          employee_id = COALESCE($5, employee_id),
          status = COALESCE($6, status)
      WHERE id = $7
      RETURNING id, email, first_name, last_name, role_id, employee_id, status
    `;
    
    const result = await db.query(updateQuery, [email, first_name, last_name, role_id, employee_id, status, id]);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json({
      message: 'Usuario actualizado exitosamente',
      user: result.rows[0]
    });
  } catch (error) {
    console.error('Error al actualizar usuario:', error);
    res.status(500).json({ error: 'Error al actualizar usuario' });
  }
});

// Delete user (Admin only)
app.delete('/api/auth/users/:id', authenticateToken, authorizeRoles('Administrador'), async (req, res) => {
  try {
    const { id } = req.params;

    // Don't allow deleting yourself
    if (parseInt(id) === req.user.id) {
      return res.status(400).json({ error: 'No puedes eliminar tu propia cuenta' });
    }

    const result = await db.query('DELETE FROM users WHERE id = $1 RETURNING id', [id]);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json({ message: 'Usuario eliminado exitosamente' });
  } catch (error) {
    console.error('Error al eliminar usuario:', error);
    res.status(500).json({ error: 'Error al eliminar usuario' });
  }
});

// Get all roles
app.get('/api/auth/roles', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM roles ORDER BY id');
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener roles:', error);
    res.status(500).json({ error: 'Error al obtener roles' });
  }
});

// ========== CANDIDATES ENDPOINTS ==========

// List candidates
app.get('/api/candidates', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM candidates ORDER BY id DESC');
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching candidates', err);
    res.status(500).json({ error: 'Error fetching candidates' });
  }
});

// Create candidate
app.post('/api/candidates', async (req, res) => {
  let { first_name, last_name, email, phone, position_applied, status, notes, name } = req.body;

  if (!first_name && name) {
    const parts = String(name).trim().split(/\s+/);
    first_name = parts.shift() || '';
    last_name = parts.join(' ') || '';
  }

  if (!email) {
    const base = (first_name || 'candidate').toLowerCase().replace(/[^a-z0-9]+/g, '') || 'candidate';
    const suffix = Date.now();
    email = `${base}${suffix}@temp.local`;
  }

  // validate email if provided
  if (email) {
    const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRe.test(String(email))) {
      return res.status(400).json({ error: 'Invalid email format' });
    }
  }

  try {
    const result = await db.query(
      `INSERT INTO candidates (first_name, last_name, email, phone, position_applied, status, notes)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [first_name || null, last_name || null, email, phone || null, position_applied || null, status || 'En revisión', notes || null]
    );
    return res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error inserting candidate', err);
    return res.status(500).json({ error: 'Error creating candidate' });
  }
});

// Update candidate
app.put('/api/candidates/:id', async (req, res) => {
  const id = req.params.id;
  const { first_name, last_name, email, phone, position_applied, status, notes } = req.body;
  
  // validate email if provided
  if (email) {
    const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRe.test(String(email))) {
      return res.status(400).json({ error: 'Invalid email format' });
    }
  }

  try {
    const result = await db.query(
      `UPDATE candidates SET first_name=$1, last_name=$2, email=$3, phone=$4, position_applied=$5, status=$6, notes=$7 WHERE id=$8 RETURNING *`,
      [first_name || null, last_name || null, email || null, phone || null, position_applied || null, status || null, notes || null, id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: 'Candidate not found' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error updating candidate', err);
    res.status(500).json({ error: 'Error updating candidate' });
  }
});

// Delete candidate
app.delete('/api/candidates/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await db.query('DELETE FROM candidates WHERE id = $1', [id]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'Candidate not found' });
    res.json({ success: true });
  } catch (err) {
    console.error('Error deleting candidate', err);
    res.status(500).json({ error: 'Error deleting candidate' });
  }
});

// Upload and parse Excel file for employees
app.post('/api/upload-employees', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Parse Excel file
    const workbook = XLSX.read(req.file.buffer, { type: 'buffer' });
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    const data = XLSX.utils.sheet_to_json(worksheet);

    if (data.length === 0) {
      return res.status(400).json({ error: 'No data found in Excel file' });
    }

    // Detect columns and prepare for insertion
    const results = [];
    const errors = [];

    for (let i = 0; i < data.length; i++) {
      const row = data[i];
      try {
        // Map many possible column names to our normalized fields
        // Support the client's Excel headers (Spanish)
        const rawFullName = (row['Nombre del empleado'] || row['Nombre'] || row['nombre'] || row['name'] || row['NombreEmpleado'] || '').toString().trim();
        let first_name = '';
        let last_name = '';
        if (rawFullName) {
          const parts = rawFullName.split(/\s+/);
          first_name = parts.shift() || '';
          last_name = parts.join(' ') || '';
        } else {
          first_name = (row['Nombre'] || row['nombre'] || row['first_name'] || row['First Name'] || '').toString().trim();
          last_name = (row['Apellido'] || row['apellido'] || row['last_name'] || row['Last Name'] || '').toString().trim();
        }
        // Ensure last_name is not empty to satisfy DB NOT NULL constraints
        if (!last_name) {
          last_name = '(Sin Apellido)';
        }
        
        // Get email - prioritize work email (Correo de trabajo)
        const workEmail = (row['Correo de trabajo'] || row['Correo trabajo'] || '').toString().trim();
        const personalEmail = (row['Correo electrónico personal'] || row['Correo personal'] || '').toString().trim();
        const email = workEmail || personalEmail || (first_name + '.' + last_name + '@afirma-solutions.com').toLowerCase();
        const phone = (row['Teléfono laboral'] || row['Teléfono'] || row['telefono'] || row['teléfono'] || row['phone'] || row['Phone'] || '').toString().trim();
        const personal_phone = (row['Teléfono personal'] || row['Personal Phone'] || row['personal_phone'] || row['celular'] || '').toString().trim();
        const employee_code = (row['Código'] || row['Codigo'] || row['employee_code'] || row['Código empleado'] || '').toString().trim();
        const positionName = (row['Posición'] || row['posición'] || row['position'] || row['Position'] || row['Cargo'] || row['cargo'] || '').toString().trim();
        const entityName = (row['Área'] || row['Departamento'] || row['departamento'] || row['department'] || '').toString().trim();
        const hire_date = (row['Fecha de ingreso'] || row['Fecha ingreso'] || row['Fecha contratación'] || row['hire_date'] || row['Fecha de contratación'] || row['Hire Date'] || row['hireDate'] || '').toString().trim();
        const start_date = (row['Fecha de asignación'] || row['Fecha asignación'] || row['Fecha inicio'] || row['start_date'] || row['Fecha de inicio'] || '').toString().trim();
        const birth_date = (row['Fecha nacimiento'] || row['birth_date'] || row['Fecha de nacimiento'] || '').toString().trim();
        const address = (row['Dirección'] || row['direccion'] || row['address'] || '').toString().trim();
        const city = (row['Ciudad'] || row['city'] || '').toString().trim();
        const state = (row['Estado'] || row['state'] || '').toString().trim();
        const postal_code = (row['Postal'] || row['postal_code'] || row['Código postal'] || '').toString().trim();
        const country = (row['País'] || row['Pais'] || row['country'] || '').toString().trim();
        const employment_type = (row['Tipo empleo'] || row['employment_type'] || row['Tipo de empleo'] || '').toString().trim();
        const contract_end_date = (row['Fin contrato'] || row['contract_end_date'] || '').toString().trim();
        const statusVal = (row['Estado'] || row['status'] || '').toString().trim() || 'Activo';
        // Client-specific columns
        const cliente = (row['CLIENTE'] || row['Cliente'] || row['client'] || '').toString().trim();
        const celula = (row['Célula'] || row['Celula'] || '').toString().trim();
        const proyecto = (row['Proyecto'] || row['Project'] || '').toString().trim();
        const tarifa = (row['Tarifa inicial de contratación'] || row['Tarifa'] || row['Tarifa inicial'] || '').toString().trim();
        const sgmm = (row['SGMM'] || '').toString().trim();
        const vida = (row['vida'] || row['Vida'] || '').toString().trim();
        const cpa_cpe = (row['CPA / CPE'] || row['CPA'] || row['CPE'] || '').toString().trim();
        const correo_con_cliente = (row['Correo con cliente'] || row['Correo cliente'] || '').toString().trim();
        const correo_trabajo = (row['Correo de trabajo'] || row['Correo trabajo'] || row['Correo laboral'] || row['Correo'] || row['Correo electrónico laboral'] || '').toString().trim();
        const correo_personal = (row['Correo electrónico personal'] || row['Correo personal'] || row['Personal Email'] || '').toString().trim();

        // Validate email format if provided
        if (email) {
          const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          if (!emailRe.test(String(email))) {
            errors.push({ row: i + 1, error: `Invalid email: ${email}` });
            continue;
          }
        }

        // Normalize hire_date to avoid DB check failures (coerce future dates to today)
        let hireDateForInsert = null;
        const hireNorm = normalizeDateInput(hire_date);
        if (hireNorm) {
          if (isFutureDate(hireNorm)) {
            hireDateForInsert = new Date().toISOString().split('T')[0];
          } else {
            hireDateForInsert = hireNorm;
          }
        } else {
          // If hire_date is missing or invalid, default to today
          hireDateForInsert = new Date().toISOString().split('T')[0];
        }
        // Ensure hire_date is set (required by DB)
        if (!hireDateForInsert) {
          hireDateForInsert = new Date().toISOString().split('T')[0];
        }

        // Resolve or create entity and position
        const resolvedEntityId = entityName ? await findOrCreateEntity(entityName) : null;
        const resolvedPositionId = positionName ? await findOrCreatePosition(positionName, resolvedEntityId) : null;

        let insertResult;
        try {
          insertResult = await db.query(
            `INSERT INTO employees_v2 (
               first_name, last_name, email, phone, personal_phone,
               employee_code, position_id, entity_id,
               hire_date, start_date, birth_date,
               address, city, state, postal_code, country,
               employment_type, contract_end_date, status, created_by
             ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20) RETURNING *`,
            [
              first_name || null,
              last_name || null,
              email || null,
              phone || null,
              personal_phone || null,
              employee_code || null,
              resolvedPositionId || null,
              resolvedEntityId || null,
              hireDateForInsert || null,
              start_date || null,
              birth_date || null,
              address || null,
              city || null,
              state || null,
              postal_code || null,
              country || 'Colombia',
              employment_type || 'Permanente',
              contract_end_date || null,
              statusVal || 'Activo',
              'import_excel'
            ]
          );
        } catch (e) {
          console.error('Employees_v2 INSERT error:', e.message);
          console.error('Params:', [
            first_name || null,
            last_name || null,
            email || null,
            phone || null,
            personal_phone || null,
            employee_code || null,
            resolvedPositionId || null,
            resolvedDepartmentId || null,
            hireDateForInsert || null,
            start_date || null,
            birth_date || null,
            address || null,
            city || null,
            state || null,
            postal_code || null,
            country || 'Colombia',
            employment_type || 'Permanente',
            contract_end_date || null,
            statusVal || 'Activo',
            'import_excel'
          ]);
          throw e;
        }
        results.push(insertResult.rows[0]);
        const newEmp = insertResult.rows[0];

        // After creating employee, save import metadata in employee_documents
        try {
          const meta = {
            cliente: cliente || undefined,
            celula: celula || undefined,
            proyecto: proyecto || undefined,
            sgmm: sgmm || undefined,
            vida: vida || undefined,
            cpa_cpe: cpa_cpe || undefined,
            correo_con_cliente: correo_con_cliente || undefined,
            correo_personal: correo_personal || undefined,
            original_row: row
          };
          // insert a document with type import_meta and notes as JSON
          await db.query(
            `INSERT INTO employee_documents (employee_id, document_type, notes) VALUES ($1,$2,$3)`,
            [newEmp.id, 'import_meta', JSON.stringify(meta)]
          );
        } catch (docErr) {
          console.error('Error saving import meta for employee', newEmp.id, docErr.message);
        }

        // If tarifa present and numeric, create initial salary_history
        try {
          const tarifaNum = parseFloat(String(tarifa).replace(/[^0-9\.-]+/g,''));
          if (!isNaN(tarifaNum) && tarifaNum > 0) {
            const effDate = hireDateForInsert || new Date().toISOString().split('T')[0];
            await db.query(
              `INSERT INTO salary_history (employee_id, salary_amount, currency, effective_date, reason, notes, created_by)
               VALUES ($1,$2,$3,$4,$5,$6,$7)`,
              [newEmp.id, tarifaNum, 'COP', effDate, 'Tarifa inicial importada', JSON.stringify({source_row: row}), 'import_excel']
            );
          }
        } catch (salErr) {
          console.error('Error creating salary_history for employee', newEmp.id, salErr.message);
        }
      } catch (err) {
        if (err.code === '23505') { // Unique constraint violation (duplicate email)
          errors.push({ row: i + 1, error: `Duplicate or constraint error: ${err.detail || err.message}` });
        } else {
          errors.push({ row: i + 1, error: err.message });
        }
      }
    }

    res.json({
      imported: results.length,
      total: data.length,
      results,
      errors: errors.length > 0 ? errors : null
    });
  } catch (err) {
    console.error('Error uploading employees', err);
    res.status(500).json({ error: 'Error processing file: ' + err.message });
  }
});

// Upload and parse Excel file for candidates
app.post('/api/upload-candidates', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Parse Excel file
    const workbook = XLSX.read(req.file.buffer, { type: 'buffer' });
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    const data = XLSX.utils.sheet_to_json(worksheet);

    if (data.length === 0) {
      return res.status(400).json({ error: 'No data found in Excel file' });
    }

    // Detect columns and prepare for insertion
    const results = [];
    const errors = [];

    for (let i = 0; i < data.length; i++) {
      const row = data[i];
      try {
        // Map common column names
        const first_name = row['Nombre'] || row['nombre'] || row['first_name'] || row['First Name'] || '';
        const last_name = row['Apellido'] || row['apellido'] || row['last_name'] || row['Last Name'] || '';
        const email = row['Email'] || row['email'] || row['Correo'] || row['correo'] || '';
        const phone = row['Teléfono'] || row['teléfono'] || row['phone'] || row['Phone'] || row['Telefono'] || '';
        const position_applied = row['Posición'] || row['posición'] || row['position'] || row['Position'] || row['Cargo'] || row['cargo'] || '';
        const status = row['Estado'] || row['estado'] || row['Status'] || row['status'] || 'En revisión';
        const notes = row['Notas'] || row['notas'] || row['Notes'] || row['notes'] || '';

        // Validate email format if provided
        if (email) {
          const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          if (!emailRe.test(String(email).trim())) {
            errors.push({ row: i + 1, error: `Invalid email: ${email}` });
            continue;
          }
        }

        const result = await db.query(
          `INSERT INTO candidates (first_name, last_name, email, phone, position_applied, status, notes)
           VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
          [first_name.trim() || null, last_name.trim() || null, email.trim() || null, phone.trim() || null, position_applied.trim() || null, status, notes.trim() || null]
        );
        results.push(result.rows[0]);
      } catch (err) {
        if (err.code === '23505') { // Unique constraint violation
          errors.push({ row: i + 1, error: `Email already exists: ${row.Email || row.email || row.Correo}` });
        } else {
          errors.push({ row: i + 1, error: err.message });
        }
      }
    }

    res.json({
      imported: results.length,
      total: data.length,
      results,
      errors: errors.length > 0 ? errors : null
    });
  } catch (err) {
    console.error('Error uploading candidates', err);
    res.status(500).json({ error: 'Error processing file: ' + err.message });
  }
});

// ============ ENTITIES ENDPOINTS (formerly departments) ============

// Get all entities from mastercode
app.get('/api/entities', async (req, res) => {
  console.log('📝 GET /api/entities endpoint called');
  try {
    console.log('🔍 Querying mastercode for entities...');
    const result = await db.query("SELECT id, item as name FROM mastercode WHERE lista = 'Entidad' ORDER BY item");
    console.log(`✅ Found ${result.rows.length} entities`);
    res.json(result.rows);
  } catch (err) {
    console.error('❌ Error fetching entities:', err);
    res.status(500).json({ error: 'Error fetching entities' });
  }
});

// Backward compatible route
app.get('/api/departments', async (req, res) => {
  try {
    const result = await db.query("SELECT id, item as name FROM mastercode WHERE lista = 'Entidad' ORDER BY item");
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching entities', err);
    res.status(500).json({ error: 'Error fetching entities' });
  }
});

// Create entity in mastercode
app.post('/api/entities', async (req, res) => {
  console.log('📝 POST /api/entities endpoint called with body:', req.body);
  const { name } = req.body;
  try {
    console.log('🔍 Inserting new entity into mastercode...');
    const result = await db.query(
      "INSERT INTO mastercode (lista, item) VALUES ('Entidad', $1) RETURNING id, item as name",
      [name]
    );
    console.log('✅ Entity created successfully:', result.rows[0]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('❌ Error creating entity:', err);
    res.status(500).json({ error: 'Error creating entity' });
  }
});

// Update entity
app.put('/api/entities/:id', async (req, res) => {
  const id = req.params.id;
  const { name } = req.body;
  try {
    const r = await db.query(
      "UPDATE mastercode SET item = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND lista = 'Entidad' RETURNING id, item as name",
      [name, id]
    );
    if (r.rowCount === 0) return res.status(404).json({ error: 'Entity not found' });
    res.json(r.rows[0]);
  } catch (err) {
    console.error('Error updating entity', err);
    res.status(500).json({ error: 'Error updating entity' });
  }
});

// Delete entity
app.delete('/api/entities/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const r = await db.query("DELETE FROM mastercode WHERE id = $1 AND lista = 'Entidad'", [id]);
    if (r.rowCount === 0) return res.status(404).json({ error: 'Entity not found' });
    res.json({ success: true });
  } catch (err) {
    console.error('Error deleting entity', err);
    res.status(500).json({ error: 'Error deleting entity' });
  }
});

// Backward compatible create
app.post('/api/departments', async (req, res) => {
  const { name, description } = req.body;
  try {
    const result = await db.query(
      'INSERT INTO entities (name, description) VALUES ($1, $2) RETURNING *',
      [name, description || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating entity', err);
    res.status(500).json({ error: 'Error creating entity' });
  }
});

// ============ POSITIONS ENDPOINTS ============

// Get all positions with department info
// ==================== UNIFIED MASTERCODE API ====================

// Get items by lista type (unified catalog API)
app.get('/api/mastercode/:lista', async (req, res) => {
  const { lista } = req.params;
  console.log(`📝 GET /api/mastercode/${lista} endpoint called`);
  
  try {
    console.log(`🔍 Querying mastercode for lista: ${lista}`);
    const result = await db.query(
      'SELECT id, item as name FROM mastercode WHERE lista = $1 ORDER BY item',
      [lista]
    );
    console.log(`✅ Found ${result.rows.length} items for lista: ${lista}`);
    res.json(result.rows);
  } catch (err) {
    console.error(`❌ Error fetching mastercode for lista ${lista}:`, err);
    res.status(500).json({ error: `Error fetching ${lista}` });
  }
});

// Create item in mastercode
app.post('/api/mastercode/:lista', async (req, res) => {
  const { lista } = req.params;
  const { name } = req.body;
  console.log(`📝 POST /api/mastercode/${lista} endpoint called with body:`, req.body);
  
  try {
    console.log(`🔍 Inserting new item into mastercode for lista: ${lista}`);
    const result = await db.query(
      'INSERT INTO mastercode (lista, item) VALUES ($1, $2) RETURNING id, item as name',
      [lista, name]
    );
    console.log(`✅ Item created successfully for lista ${lista}:`, result.rows[0]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(`❌ Error creating item in mastercode for lista ${lista}:`, err);
    res.status(500).json({ error: `Error creating ${lista}` });
  }
});

// Update item in mastercode
app.put('/api/mastercode/:lista/:id', async (req, res) => {
  const { lista, id } = req.params;
  const { name } = req.body;
  
  try {
    const result = await db.query(
      'UPDATE mastercode SET item = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND lista = $3 RETURNING id, item as name',
      [name, id, lista]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: `${lista} item not found` });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(`Error updating mastercode item for lista ${lista}:`, err);
    res.status(500).json({ error: `Error updating ${lista}` });
  }
});

// Delete item from mastercode
app.delete('/api/mastercode/:lista/:id', async (req, res) => {
  const { lista, id } = req.params;
  
  try {
    const result = await db.query(
      'DELETE FROM mastercode WHERE id = $1 AND lista = $2',
      [id, lista]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: `${lista} item not found` });
    }
    res.json({ success: true });
  } catch (err) {
    console.error(`Error deleting mastercode item for lista ${lista}:`, err);
    res.status(500).json({ error: `Error deleting ${lista}` });
  }
});

// ==================== BACKWARD COMPATIBLE APIs ====================

// Positions API (now uses mastercode)
app.get('/api/positions', async (req, res) => {
  try {
    const result = await db.query(
      "SELECT id, item as name FROM mastercode WHERE lista = 'Puestos roles' ORDER BY item"
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching positions', err);
    res.status(500).json({ error: 'Error fetching positions' });
  }
});

// Create position
app.post('/api/positions', async (req, res) => {
  const { name } = req.body;
  try {
    const result = await db.query(
      "INSERT INTO mastercode (lista, item) VALUES ('Puestos roles', $1) RETURNING id, item as name",
      [name]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating position', err);
    res.status(500).json({ error: 'Error creating position' });
  }
});

// Update position
app.put('/api/positions/:id', async (req, res) => {
  const id = req.params.id;
  const { name } = req.body;
  try {
    const r = await db.query(
      "UPDATE mastercode SET item = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND lista = 'Puestos roles' RETURNING id, item as name",
      [name, id]
    );
    if (r.rowCount === 0) return res.status(404).json({ error: 'Position not found' });
    res.json(r.rows[0]);
  } catch (err) {
    console.error('Error updating position', err);
    res.status(500).json({ error: 'Error updating position' });
  }
});

// Delete position
app.delete('/api/positions/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const r = await db.query("DELETE FROM mastercode WHERE id = $1 AND lista = 'Puestos roles'", [id]);
    if (r.rowCount === 0) return res.status(404).json({ error: 'Position not found' });
    res.json({ success: true });
  } catch (err) {
    console.error('Error deleting position', err);
    res.status(500).json({ error: 'Error deleting position' });
  }
});

// === ÁREAS ===
app.get('/api/areas', async (req, res) => {
  try {
    const r = await db.query("SELECT id, item as name FROM mastercode WHERE lista = 'Areas' ORDER BY item");
    res.json(r.rows);
  } catch (err) {
    console.error('Error fetching areas', err);
    res.status(500).json({ error: 'Error fetching areas' });
  }
});
app.post('/api/areas', async (req, res) => {
  const { name } = req.body;
  try {
    const r = await db.query("INSERT INTO mastercode (lista, item) VALUES ('Areas', $1) RETURNING id, item as name", [name]);
    res.status(201).json(r.rows[0]);
  } catch (err) {
    console.error('Error creating area', err);
    res.status(500).json({ error: 'Error creating area' });
  }
});

// Update area
app.put('/api/areas/:id', async (req, res) => {
  const id = req.params.id;
  const { name } = req.body;
  try {
    const r = await db.query(
      "UPDATE mastercode SET item = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND lista = 'Areas' RETURNING id, item as name",
      [name, id]
    );
    if (r.rowCount === 0) return res.status(404).json({ error: 'Area not found' });
    res.json(r.rows[0]);
  } catch (err) {
    console.error('Error updating area', err);
    res.status(500).json({ error: 'Error updating area' });
  }
});

// Delete area
app.delete('/api/areas/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const r = await db.query("DELETE FROM mastercode WHERE id = $1 AND lista = 'Areas'", [id]);
    if (r.rowCount === 0) return res.status(404).json({ error: 'Area not found' });
    res.json({ success: true });
  } catch (err) {
    console.error('Error deleting area', err);
    res.status(500).json({ error: 'Error deleting area' });
  }
});

// === CÉLULAS ===
app.get('/api/cells', async (req, res) => {
  try {
    const r = await db.query("SELECT id, item as name FROM mastercode WHERE lista = 'Celulas' ORDER BY item");
    res.json(r.rows);
  } catch (err) {
    console.error('Error fetching cells', err);
    res.status(500).json({ error: 'Error fetching cells' });
  }
});
app.post('/api/cells', async (req, res) => {
  const { name } = req.body;
  try {
    const r = await db.query("INSERT INTO mastercode (lista, item) VALUES ('Celulas', $1) RETURNING id, item as name", [name]);
    res.status(201).json(r.rows[0]);
  } catch (err) {
    console.error('Error creating cell', err);
    res.status(500).json({ error: 'Error creating cell' });
  }
});

// Update cell
app.put('/api/cells/:id', async (req, res) => {
  const id = req.params.id;
  const { name } = req.body;
  try {
    const r = await db.query(
      "UPDATE mastercode SET item = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND lista = 'Celulas' RETURNING id, item as name",
      [name, id]
    );
    if (r.rowCount === 0) return res.status(404).json({ error: 'Cell not found' });
    res.json(r.rows[0]);
  } catch (err) {
    console.error('Error updating cell', err);
    res.status(500).json({ error: 'Error updating cell' });
  }
});

// Delete cell
app.delete('/api/cells/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const r = await db.query("DELETE FROM mastercode WHERE id = $1 AND lista = 'Celulas'", [id]);
    if (r.rowCount === 0) return res.status(404).json({ error: 'Cell not found' });
    res.json({ success: true });
  } catch (err) {
    console.error('Error deleting cell', err);
    res.status(500).json({ error: 'Error deleting cell' });
  }
});

// ============ EMPLOYEES V2 ENDPOINTS (NORMALIZED) ============

// Create employee (new normalized structure)
app.post('/api/employees-v2', async (req, res) => {
  const {
    first_name, last_name, email, phone, personal_phone,
    employee_code, position_id, entity_id,
    hire_date, start_date, birth_date,
    address, exterior_number, interior_number, colonia, city, state, postal_code, country,
    employment_type, contract_end_date, status, created_by,
    area_id, project_id, cell_id, area, project, cell,
    curp, rfc, nss, passport, gender, marital_status, nationality, blood_type
  } = req.body;

  // Validate email format
  if (email) {
    const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRe.test(String(email))) {
      return res.status(400).json({ error: 'Invalid email format' });
    }
  }

  try {
    // Resolve entity_id and position_id when names are provided
    let resolvedEntityId = entity_id || req.body.department_id || null;
    let resolvedPositionId = position_id || null;
    let resolvedAreaId = area_id || null;
    let resolvedProjectId = project_id || null;
    let resolvedCellId = cell_id || null;

    if (!resolvedEntityId && (req.body.entity || req.body.department)) {
      resolvedEntityId = await findOrCreateEntity(req.body.entity || req.body.department);
    }

    if (!resolvedPositionId && req.body.position) {
      resolvedPositionId = await findOrCreatePosition(req.body.position, resolvedEntityId);
    }
    if (!resolvedAreaId && (area || req.body.area)) {
      resolvedAreaId = await findOrCreateArea(area || req.body.area);
    }
    if (!resolvedProjectId && (project || req.body.project)) {
      if (!resolvedAreaId && (area || req.body.area)) {
        resolvedAreaId = await findOrCreateArea(area || req.body.area);
      }
      resolvedProjectId = await findOrCreateProject(project || req.body.project, resolvedAreaId);
    }
    if (!resolvedCellId && (cell || req.body.cell)) {
      if (!resolvedAreaId && (area || req.body.area)) {
        resolvedAreaId = await findOrCreateArea(area || req.body.area);
      }
      if (!resolvedProjectId && (project || req.body.project)) {
        resolvedProjectId = await findOrCreateProject(project || req.body.project, resolvedAreaId);
      }
      resolvedCellId = await findOrCreateCell(cell || req.body.cell, resolvedAreaId, resolvedProjectId);
    }

    // Normalize and validate hire_date: don't allow future dates
    const hireDateNormalized = normalizeDateInput(hire_date) || new Date().toISOString().split('T')[0];
    if (isFutureDate(hireDateNormalized)) {
      return res.status(400).json({ error: 'hire_date cannot be a future date' });
    }

    const result = await db.query(
      `INSERT INTO employees_v2 (
        first_name, last_name, email, phone, personal_phone,
        employee_code, position_id, entity_id,
        area_id, project_id, cell_id,
        hire_date, start_date, birth_date,
        address, exterior_number, interior_number, colonia, city, state, postal_code, country,
        employment_type, contract_end_date, status, created_by,
        curp, rfc, nss, passport, gender, marital_status, nationality, blood_type
      ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34)
      RETURNING *`,
      [
        first_name, last_name, email, phone || null, personal_phone || null,
        employee_code || null, resolvedPositionId || null, resolvedEntityId || null,
        resolvedAreaId || null, resolvedProjectId || null, resolvedCellId || null,
        hireDateNormalized, start_date || null, birth_date || null,
        address || null, exterior_number || null, interior_number || null, colonia || null, 
        city || null, state || null, postal_code || null, country || 'Colombia',
        employment_type || 'Permanente', contract_end_date || null,
        status || 'Activo', created_by || 'system',
        curp || null, rfc || null, nss || null, passport || null,
        gender || null, marital_status || null, nationality || null, blood_type || null
      ]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating employee', err);
    res.status(500).json({ error: 'Error creating employee: ' + err.message });
  }
});

// Get all employees v2 with related info
app.get('/api/employees-v2', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT e.*,
              mp.item as position_name,
              me.item as entity_name,
              ma.item as area_name,
              mpr.item as project_name,
              mc.item as cell_name
       FROM employees_v2 e
       LEFT JOIN mastercode mp ON e.position_id = mp.id AND mp.lista = 'Puestos roles'
       LEFT JOIN mastercode me ON e.entity_id = me.id AND me.lista = 'Entidad'
       LEFT JOIN mastercode ma ON e.area_id = ma.id AND ma.lista = 'Areas'
       LEFT JOIN mastercode mpr ON e.project_id = mpr.id AND mpr.lista = 'Proyecto'
       LEFT JOIN mastercode mc ON e.cell_id = mc.id AND mc.lista = 'Celulas'
       ORDER BY e.created_at DESC`
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching employees', err);
    res.status(500).json({ error: 'Error fetching employees' });
  }
});

// Get single employee v2
app.get('/api/employees-v2/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await db.query(
      `SELECT e.*,
              mp.item as position_name,
              me.item as entity_name,
              ma.item as area_name,
              mpr.item as project_name,
              mc.item as cell_name
       FROM employees_v2 e
       LEFT JOIN mastercode mp ON e.position_id = mp.id AND mp.lista = 'Puestos roles'
       LEFT JOIN mastercode me ON e.entity_id = me.id AND me.lista = 'Entidad'
       LEFT JOIN mastercode ma ON e.area_id = ma.id AND ma.lista = 'Areas'
       LEFT JOIN mastercode mpr ON e.project_id = mpr.id AND mpr.lista = 'Proyecto'
       LEFT JOIN mastercode mc ON e.cell_id = mc.id AND mc.lista = 'Celulas'
       WHERE e.id = $1`,
      [id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: 'Employee not found' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error fetching employee', err);
    res.status(500).json({ error: 'Error fetching employee' });
  }
});

// Update employee v2
app.put('/api/employees-v2/:id', async (req, res) => {
  const id = req.params.id;
  const {
    first_name, last_name, email, phone, personal_phone,
    employee_code, position_id, entity_id,
    hire_date, start_date, birth_date,
    address, exterior_number, interior_number, colonia, city, state, postal_code, country,
    employment_type, contract_end_date, status, updated_by,
    area_id, project_id, cell_id, area, project, cell,
    curp, rfc, nss, passport, gender, marital_status, nationality, blood_type
  } = req.body;
  const hireDateNorm = normalizeDateInput(hire_date);
  if (hireDateNorm && isFutureDate(hireDateNorm)) return res.status(400).json({ error: 'hire_date cannot be a future date' });
  const startDateNorm = normalizeDateInput(start_date);
  if (email) {
    const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRe.test(String(email))) return res.status(400).json({ error: 'Invalid email format' });
  }
  try {
    let resolvedEntityId = entity_id || req.body.department_id || null;
    let resolvedPositionId = position_id || null;
    let resolvedAreaId = area_id || null;
    let resolvedProjectId = project_id || null;
    let resolvedCellId = cell_id || null;
    if (!resolvedEntityId && (req.body.entity || req.body.department)) {
      resolvedEntityId = await findOrCreateEntity(req.body.entity || req.body.department);
    }
    if (!resolvedPositionId && req.body.position) {
      resolvedPositionId = await findOrCreatePosition(req.body.position, resolvedEntityId);
    }
    if (!resolvedAreaId && (area || req.body.area)) {
      resolvedAreaId = await findOrCreateArea(area || req.body.area);
    }
    if (!resolvedProjectId && (project || req.body.project)) {
      if (!resolvedAreaId && (area || req.body.area)) {
        resolvedAreaId = await findOrCreateArea(area || req.body.area);
      }
      resolvedProjectId = await findOrCreateProject(project || req.body.project, resolvedAreaId);
    }
    if (!resolvedCellId && (cell || req.body.cell)) {
      if (!resolvedAreaId && (area || req.body.area)) {
        resolvedAreaId = await findOrCreateArea(area || req.body.area);
      }
      if (!resolvedProjectId && (project || req.body.project)) {
        resolvedProjectId = await findOrCreateProject(project || req.body.project, resolvedAreaId);
      }
        resolvedCellId = await findOrCreateCell(cell || req.body.cell, resolvedAreaId, resolvedProjectId);
    }
    const result = await db.query(
      `UPDATE employees_v2 SET
        first_name = COALESCE($1, first_name),
        last_name = COALESCE($2, last_name),
        email = COALESCE($3, email),
        phone = COALESCE($4, phone),
        personal_phone = COALESCE($5, personal_phone),
        employee_code = COALESCE($6, employee_code),
        position_id = COALESCE($7, position_id),
        entity_id = COALESCE($8, entity_id),
        area_id = COALESCE($9, area_id),
        project_id = COALESCE($10, project_id),
        cell_id = COALESCE($11, cell_id),
        start_date = COALESCE($12, start_date),
        birth_date = COALESCE($13, birth_date),
        address = COALESCE($14, address),
        exterior_number = COALESCE($15, exterior_number),
        interior_number = COALESCE($16, interior_number),
        colonia = COALESCE($17, colonia),
        city = COALESCE($18, city),
        state = COALESCE($19, state),
        postal_code = COALESCE($20, postal_code),
        country = COALESCE($21, country),
        employment_type = COALESCE($22, employment_type),
        contract_end_date = COALESCE($23, contract_end_date),
        status = COALESCE($24, status),
        curp = COALESCE($25, curp),
        rfc = COALESCE($26, rfc),
        nss = COALESCE($27, nss),
        passport = COALESCE($28, passport),
        gender = COALESCE($29, gender),
        marital_status = COALESCE($30, marital_status),
        nationality = COALESCE($31, nationality),
        blood_type = COALESCE($32, blood_type),
        updated_by = $33,
        updated_at = CURRENT_TIMESTAMP
       WHERE id = $34
       RETURNING *`,
      [
        first_name, last_name, email, phone, personal_phone,
        employee_code, resolvedPositionId, resolvedEntityId,
        resolvedAreaId, resolvedProjectId, resolvedCellId,
        startDateNorm || start_date || null, birth_date || null,
        address, exterior_number, interior_number, colonia, city, state, postal_code, country,
        employment_type, contract_end_date, status,
        curp, rfc, nss, passport, gender, marital_status, nationality, blood_type,
        updated_by || 'system', id
      ]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: 'Employee not found' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error updating employee', err);
    res.status(500).json({ error: 'Error updating employee' });
  }
});

// Delete employee v2 (soft delete - cambiar estado a Inactivo)
app.delete('/api/employees-v2/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await db.query(
      `UPDATE employees_v2 SET status = 'Inactivo', updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *`,
      [id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: 'Employee not found' });
    res.json({ success: true, message: 'Employee marked as inactive', employee: result.rows[0] });
  } catch (err) {
    console.error('Error deleting employee', err);
    res.status(500).json({ error: 'Error deleting employee' });
  }
});

// Get salary history for an employee
app.get('/api/employees-v2/:id/salary-history', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await db.query(
      'SELECT * FROM salary_history WHERE employee_id = $1 ORDER BY effective_date DESC',
      [id]
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching salary history', err);
    res.status(500).json({ error: 'Error fetching salary history' });
  }
});

// Add salary record
app.post('/api/employees-v2/:id/salary', async (req, res) => {
  const id = req.params.id;
  const { salary_amount, currency, effective_date, reason, notes, created_by } = req.body;
  try {
    const result = await db.query(
      `INSERT INTO salary_history (employee_id, salary_amount, currency, effective_date, reason, notes, created_by)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [id, salary_amount, currency || 'COP', effective_date, reason || null, notes || null, created_by || 'system']
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error adding salary record', err);
    res.status(500).json({ error: 'Error adding salary record' });
  }
});

// Get emergency contacts for an employee
app.get('/api/employees-v2/:id/emergency-contacts', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await db.query(
      'SELECT * FROM emergency_contacts WHERE employee_id = $1 ORDER BY priority',
      [id]
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching emergency contacts', err);
    res.status(500).json({ error: 'Error fetching emergency contacts' });
  }
});

// Add emergency contact
app.post('/api/employees-v2/:id/emergency-contacts', async (req, res) => {
  const id = req.params.id;
  const { contact_name, relationship, phone, email, address, priority } = req.body;
  try {
    const result = await db.query(
      `INSERT INTO emergency_contacts (employee_id, contact_name, relationship, phone, email, address, priority)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [id, contact_name, relationship || null, phone, email || null, address || null, priority || 1]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error adding emergency contact', err);
    res.status(500).json({ error: 'Error adding emergency contact' });
  }
});

// === INFORMACIÓN BANCARIA ===

// Get employee banking info
app.get('/api/employees-v2/:id/banking', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await db.query(
      `SELECT * FROM employee_banking_info WHERE employee_id = $1 AND is_active = true`,
      [id]
    );
    res.json(result.rows[0] || null);
  } catch (err) {
    console.error('Error fetching banking info', err);
    res.status(500).json({ error: 'Error fetching banking info' });
  }
});

// Create/Update employee banking info
app.post('/api/employees-v2/:id/banking', async (req, res) => {
  const id = req.params.id;
  const { bank_name, account_holder_name, account_number, clabe_interbancaria } = req.body;
  try {
    // Deactivate existing banking info
    await db.query(
      'UPDATE employee_banking_info SET is_active = false WHERE employee_id = $1',
      [id]
    );
    
    // Insert new banking info
    const result = await db.query(
      `INSERT INTO employee_banking_info (employee_id, bank_name, account_holder_name, account_number, clabe_interbancaria)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [id, bank_name, account_holder_name, account_number, clabe_interbancaria]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error saving banking info', err);
    res.status(500).json({ error: 'Error saving banking info' });
  }
});

// === INFORMACIÓN CONTRACTUAL ===

// Get contract schemes (catalog)
app.get('/api/contract-schemes', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM contract_schemes ORDER BY name');
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching contract schemes', err);
    res.status(500).json({ error: 'Error fetching contract schemes' });
  }
});

// Get contract types (catalog)
app.get('/api/contract-types', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM contract_types ORDER BY name');
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching contract types', err);
    res.status(500).json({ error: 'Error fetching contract types' });
  }
});

// Get employee contracts
app.get('/api/employees-v2/:id/contracts', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await db.query(
      `SELECT ec.*, ct.name as contract_type_name, cs.name as contract_scheme_name
       FROM employee_contracts ec
       LEFT JOIN contract_types ct ON ec.contract_type_id = ct.id
       LEFT JOIN contract_schemes cs ON ec.contract_scheme_id = cs.id
       WHERE ec.employee_id = $1
       ORDER BY ec.start_date DESC`,
      [id]
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching contracts', err);
    res.status(500).json({ error: 'Error fetching contracts' });
  }
});

// Get current active contract
app.get('/api/employees-v2/:id/contracts/current', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await db.query(
      `SELECT ec.*, ct.name as contract_type_name, cs.name as contract_scheme_name
       FROM employee_contracts ec
       LEFT JOIN contract_types ct ON ec.contract_type_id = ct.id
       LEFT JOIN contract_schemes cs ON ec.contract_scheme_id = cs.id
       WHERE ec.employee_id = $1 AND ec.is_active = true
       ORDER BY ec.start_date DESC
       LIMIT 1`,
      [id]
    );
    res.json(result.rows[0] || null);
  } catch (err) {
    console.error('Error fetching current contract', err);
    res.status(500).json({ error: 'Error fetching current contract' });
  }
});

// Create employee contract
app.post('/api/employees-v2/:id/contracts', async (req, res) => {
  const employee_id = req.params.id;
  const {
    contract_type_id, obra, contract_scheme_id, initial_rate,
    gross_monthly_salary, net_monthly_salary, company_cost,
    start_date, end_date, termination_reason, is_rehireable
  } = req.body;
  
  try {
    // Si se marca como activo, desactivar contratos previos
    if (req.body.is_active) {
      await db.query(
        'UPDATE employee_contracts SET is_active = false WHERE employee_id = $1',
        [employee_id]
      );
    }

    const result = await db.query(
      `INSERT INTO employee_contracts 
       (employee_id, contract_type_id, obra, contract_scheme_id, initial_rate, 
        gross_monthly_salary, net_monthly_salary, company_cost, start_date, 
        end_date, termination_reason, is_rehireable, is_active)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) 
       RETURNING *`,
      [employee_id, contract_type_id, obra, contract_scheme_id, initial_rate,
       gross_monthly_salary, net_monthly_salary, company_cost, start_date,
       end_date, termination_reason, is_rehireable, req.body.is_active || false]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating contract', err);
    res.status(500).json({ error: 'Error creating contract' });
  }
});

// Update employee contract
app.put('/api/employees-v2/:employeeId/contracts/:contractId', async (req, res) => {
  const { employeeId, contractId } = req.params;
  const {
    contract_type_id, obra, contract_scheme_id, initial_rate,
    gross_monthly_salary, net_monthly_salary, company_cost,
    start_date, end_date, termination_reason, is_rehireable, is_active
  } = req.body;

  try {
    // Si se activa este contrato, desactivar otros
    if (is_active) {
      await db.query(
        'UPDATE employee_contracts SET is_active = false WHERE employee_id = $1 AND id != $2',
        [employeeId, contractId]
      );
    }

    const result = await db.query(
      `UPDATE employee_contracts SET 
       contract_type_id = $1, obra = $2, contract_scheme_id = $3, initial_rate = $4,
       gross_monthly_salary = $5, net_monthly_salary = $6, company_cost = $7,
       start_date = $8, end_date = $9, termination_reason = $10, 
       is_rehireable = $11, is_active = $12, updated_at = CURRENT_TIMESTAMP
       WHERE id = $13 AND employee_id = $14
       RETURNING *`,
      [contract_type_id, obra, contract_scheme_id, initial_rate,
       gross_monthly_salary, net_monthly_salary, company_cost,
       start_date, end_date, termination_reason, is_rehireable, is_active,
       contractId, employeeId]
    );
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Contract not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error updating contract', err);
    res.status(500).json({ error: 'Error updating contract' });
  }
});

// Update employee address
app.put('/api/employees-v2/:id/address', async (req, res) => {
  const id = req.params.id;
  const { address_street, address_city, address_state, address_postal_code, address_country } = req.body;
  
  try {
    const result = await db.query(
      `UPDATE employees_v2 SET 
       address_street = $1, address_city = $2, address_state = $3, 
       address_postal_code = $4, address_country = $5, updated_at = CURRENT_TIMESTAMP
       WHERE id = $6 RETURNING *`,
      [address_street, address_city, address_state, address_postal_code, address_country || 'México', id]
    );
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Employee not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error updating address', err);
    res.status(500).json({ error: 'Error updating address' });
  }
});

// ============================================
// EQUIPMENT API ENDPOINTS
// ============================================

// Get all equipment with employee info
app.get('/api/equipment', async (req, res) => {
  try {
    console.log('📦 Getting equipment list');
    const result = await db.query(`
      SELECT 
        e.*,
        emp.first_name,
        emp.last_name,
        CONCAT(emp.first_name, ' ', emp.last_name) as asignado_nombre
      FROM equipment e
      LEFT JOIN employees_v2 emp ON e.asignado_id = emp.id
      ORDER BY e.codigo
    `);
    
    console.log(`✅ Found ${result.rows.length} equipment items`);
    res.json(result.rows);
  } catch (err) {
    console.error('❌ Error fetching equipment:', err);
    res.status(500).json({ error: 'Error fetching equipment' });
  }
});

// Get single equipment by ID
app.get('/api/equipment/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query(`
      SELECT 
        e.*,
        emp.first_name,
        emp.last_name,
        CONCAT(emp.first_name, ' ', emp.last_name) as asignado_nombre
      FROM equipment e
      LEFT JOIN employees_v2 emp ON e.asignado_id = emp.id
      WHERE e.id = $1
    `, [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Equipment not found' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('❌ Error fetching equipment:', err);
    res.status(500).json({ error: 'Error fetching equipment' });
  }
});

// Create new equipment
app.post('/api/equipment', async (req, res) => {
  try {
    const {
      codigo, nombre, marca, modelo, serie, categoria,
      ubicacion, asignado_id, estado, valor, fecha_compra, observaciones
    } = req.body;
    
    console.log('📦 Creating new equipment:', { codigo, nombre, categoria });
    
    // Validate required fields
    if (!codigo || !nombre || !categoria) {
      return res.status(400).json({ error: 'Required fields: codigo, nombre, categoria' });
    }
    
    // Check if codigo already exists
    const existing = await db.query('SELECT id FROM equipment WHERE codigo = $1', [codigo]);
    if (existing.rows.length > 0) {
      return res.status(400).json({ error: 'Equipment code already exists' });
    }
    
    const result = await db.query(`
      INSERT INTO equipment (
        codigo, nombre, marca, modelo, serie, categoria,
        ubicacion, asignado_id, estado, valor, fecha_compra, observaciones
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      RETURNING *
    `, [
      codigo, nombre, marca, modelo, serie, categoria,
      ubicacion, asignado_id || null, estado || 'Activo',
      valor || null, fecha_compra || null, observaciones
    ]);
    
    console.log('✅ Equipment created:', result.rows[0]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('❌ Error creating equipment:', err);
    res.status(500).json({ error: 'Error creating equipment' });
  }
});

// Update equipment
app.put('/api/equipment/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const {
      codigo, nombre, marca, modelo, serie, categoria,
      ubicacion, asignado_id, estado, valor, fecha_compra, observaciones
    } = req.body;
    
    console.log('📦 Updating equipment:', { id, codigo, nombre });
    
    // Validate required fields
    if (!codigo || !nombre || !categoria) {
      return res.status(400).json({ error: 'Required fields: codigo, nombre, categoria' });
    }
    
    // Check if codigo already exists (exclude current record)
    const existing = await db.query('SELECT id FROM equipment WHERE codigo = $1 AND id != $2', [codigo, id]);
    if (existing.rows.length > 0) {
      return res.status(400).json({ error: 'Equipment code already exists' });
    }
    
    const result = await db.query(`
      UPDATE equipment SET
        codigo = $1, nombre = $2, marca = $3, modelo = $4, serie = $5,
        categoria = $6, ubicacion = $7, asignado_id = $8, estado = $9,
        valor = $10, fecha_compra = $11, observaciones = $12,
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $13
      RETURNING *
    `, [
      codigo, nombre, marca, modelo, serie, categoria,
      ubicacion, asignado_id || null, estado || 'Activo',
      valor || null, fecha_compra || null, observaciones, id
    ]);
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Equipment not found' });
    }
    
    console.log('✅ Equipment updated:', result.rows[0]);
    res.json(result.rows[0]);
  } catch (err) {
    console.error('❌ Error updating equipment:', err);
    res.status(500).json({ error: 'Error updating equipment' });
  }
});

// Delete equipment
app.delete('/api/equipment/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('DELETE FROM equipment WHERE id = $1 RETURNING *', [id]);
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Equipment not found' });
    }
    
    console.log('✅ Equipment deleted:', result.rows[0]);
    res.json({ message: 'Equipment deleted successfully', equipment: result.rows[0] });
  } catch (err) {
    console.error('❌ Error deleting equipment:', err);
    res.status(500).json({ error: 'Error deleting equipment' });
  }
});

// ============================================
// VACATION API ENDPOINTS
// ============================================

// Get all vacations
app.get('/api/vacations', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT id, employee_id, employee_name, start_date, end_date, status, created_at 
       FROM employee_vacations 
       ORDER BY created_at DESC`
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching vacations:', err);
    res.status(500).json({ error: 'Error fetching vacations' });
  }
});

// Get single vacation
app.get('/api/vacations/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query(
      `SELECT id, employee_id, employee_name, start_date, end_date, status, created_at 
       FROM employee_vacations 
       WHERE id = $1`,
      [id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Vacation not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error fetching vacation:', err);
    res.status(500).json({ error: 'Error fetching vacation' });
  }
});

// Create vacation
app.post('/api/vacations', async (req, res) => {
  const { employee_id, employee_name, start_date, end_date, status } = req.body;
  
  // Validate required fields
  if (!employee_id || !start_date || !end_date) {
    return res.status(400).json({ error: 'Required fields: employee_id, start_date, end_date' });
  }
  
  try {
    const result = await db.query(
      `INSERT INTO employee_vacations (employee_id, employee_name, start_date, end_date, status)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, employee_id, employee_name, start_date, end_date, status, created_at`,
      [employee_id, employee_name || null, start_date, end_date, status || 'Pendiente']
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating vacation:', err);
    res.status(500).json({ error: 'Error creating vacation' });
  }
});

// Update vacation
app.put('/api/vacations/:id', async (req, res) => {
  const { id } = req.params;
  const { employee_id, employee_name, start_date, end_date, status } = req.body;
  
  try {
    const result = await db.query(
      `UPDATE employee_vacations 
       SET employee_id = $1, employee_name = $2, start_date = $3, end_date = $4, status = $5, updated_at = CURRENT_TIMESTAMP
       WHERE id = $6
       RETURNING id, employee_id, employee_name, start_date, end_date, status, created_at`,
      [employee_id || null, employee_name || null, start_date || null, end_date || null, status || 'Pendiente', id]
    );
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Vacation not found' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error updating vacation:', err);
    res.status(500).json({ error: 'Error updating vacation' });
  }
});

// Delete vacation
app.delete('/api/vacations/:id', async (req, res) => {
  const { id } = req.params;
  
  try {
    const result = await db.query(
      `DELETE FROM employee_vacations WHERE id = $1 RETURNING id`,
      [id]
    );
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Vacation not found' });
    }
    
    res.json({ success: true, message: 'Vacation deleted successfully' });
  } catch (err) {
    console.error('Error deleting vacation:', err);
    res.status(500).json({ error: 'Error deleting vacation' });
  }
});

// ==================== PROYECTOS ====================

// Get all projects
app.get('/api/projects', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT p.id, p.name, p.area_id, p.description, p.created_at,
              mc.item as area_name
       FROM projects p
       LEFT JOIN mastercode mc ON p.area_id = mc.id AND mc.lista = 'Areas'
       ORDER BY p.created_at DESC`
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching projects:', err);
    res.status(500).json({ error: 'Error fetching projects' });
  }
});

// Get all project assignments (for general assignments view) - MUST BE BEFORE /:id route
app.get('/api/projects/assignments', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT pa.id, pa.project_id, pa.employee_id, pa.role, pa.start_date, pa.end_date, pa.hours_allocated,
              e.first_name, e.last_name, e.email, e.employee_code,
              p.name as project_name,
              mc_position.item as position,
              mc_area.item as area,
              mc_entity.item as entity,
              CASE 
                WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE THEN true
                ELSE false
              END as is_active,
              CASE
                WHEN pa.end_date IS NULL THEN 'Sin fecha fin'
                WHEN pa.end_date >= CURRENT_DATE THEN 'Activo'
                ELSE 'Finalizado'
              END as status
       FROM project_assignments pa
       INNER JOIN employees_v2 e ON pa.employee_id = e.id
       INNER JOIN projects p ON pa.project_id = p.id
       LEFT JOIN mastercode mc_position ON e.position_id = mc_position.id
       LEFT JOIN mastercode mc_area ON e.area_id = mc_area.id
       LEFT JOIN mastercode mc_entity ON e.entity_id = mc_entity.id
       ORDER BY pa.start_date DESC, e.first_name, e.last_name`
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching all assignments:', err);
    res.status(500).json({ error: 'Error fetching assignments' });
  }
});

// Get project assignments for specific project - MUST BE BEFORE /:id route
app.get('/api/projects/:id/assignments', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query(
      `SELECT pa.id, pa.project_id, pa.employee_id, pa.role, pa.start_date, pa.end_date, pa.hours_allocated,
              e.first_name, e.last_name, e.email, e.employee_code,
              mc_position.item as position,
              mc_area.item as area,
              mc_entity.item as entity,
              CASE 
                WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE THEN true
                ELSE false
              END as is_active,
              CASE
                WHEN pa.end_date IS NULL THEN 'Sin fecha fin'
                WHEN pa.end_date >= CURRENT_DATE THEN 'Activo'
                ELSE 'Finalizado'
              END as status
       FROM project_assignments pa
       INNER JOIN employees_v2 e ON pa.employee_id = e.id
       LEFT JOIN mastercode mc_position ON e.position_id = mc_position.id
       LEFT JOIN mastercode mc_area ON e.area_id = mc_area.id
       LEFT JOIN mastercode mc_entity ON e.entity_id = mc_entity.id
       WHERE pa.project_id = $1
       ORDER BY pa.start_date DESC, e.first_name, e.last_name`,
      [id]
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching project assignments:', err);
    res.status(500).json({ error: 'Error fetching project assignments' });
  }
});

// Get single project
app.get('/api/projects/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query(
      `SELECT p.id, p.name, p.area_id, p.description, p.created_at,
              mc.item as area_name
       FROM projects p
       LEFT JOIN mastercode mc ON p.area_id = mc.id AND mc.lista = 'Areas'
       WHERE p.id = $1`,
      [id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Project not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error fetching project:', err);
    res.status(500).json({ error: 'Error fetching project' });
  }
});

// Create project
app.post('/api/projects', async (req, res) => {
  const { name, description, area_id } = req.body;
  
  if (!name) {
    return res.status(400).json({ error: 'Required field: name' });
  }
  
  try {
    const result = await db.query(
      `INSERT INTO projects (name, area_id, description)
       VALUES ($1, $2, $3)
       RETURNING id, name, area_id, description, created_at`,
      [name, area_id || null, description || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating project:', err);
    res.status(500).json({ error: 'Error creating project' });
  }
});

// Update project
app.put('/api/projects/:id', async (req, res) => {
  const { id } = req.params;
  const { name, description, area_id } = req.body;
  
  try {
    const result = await db.query(
      `UPDATE projects 
       SET name = COALESCE($1, name), 
           area_id = COALESCE($2, area_id), 
           description = COALESCE($3, description)
       WHERE id = $4
       RETURNING id, name, area_id, description, created_at`,
      [name || null, area_id || null, description || null, id]
    );
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Project not found' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error updating project:', err);
    res.status(500).json({ error: 'Error updating project' });
  }
});

// Delete project
app.delete('/api/projects/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('DELETE FROM projects WHERE id = $1', [id]);
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Project not found' });
    }
    
    res.json({ success: true, message: 'Project deleted successfully' });
  } catch (err) {
    console.error('Error deleting project:', err);
    res.status(500).json({ error: 'Error deleting project' });
  }
});

// Add employee to project
app.post('/api/projects/:id/assignments', async (req, res) => {
  const { id } = req.params;
  const { employee_id, role, start_date, end_date, hours_allocated } = req.body;
  
  if (!employee_id) {
    return res.status(400).json({ error: 'Required field: employee_id' });
  }
  
  try {
    // VALIDACIÓN: Verificar que el empleado no tenga asignaciones activas
    const activeAssignments = await db.query(
      `SELECT pa.id, p.name as project_name, pa.start_date, pa.end_date
       FROM project_assignments pa
       INNER JOIN projects p ON pa.project_id = p.id
       WHERE pa.employee_id = $1 
       AND (pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE)`,
      [employee_id]
    );
    
    if (activeAssignments.rowCount > 0) {
      const activeProject = activeAssignments.rows[0];
      return res.status(409).json({ 
        error: 'El empleado ya tiene una asignación activa',
        details: {
          message: `El empleado ya está asignado al proyecto "${activeProject.project_name}"`,
          conflicting_assignment: {
            project_name: activeProject.project_name,
            start_date: activeProject.start_date,
            end_date: activeProject.end_date
          }
        }
      });
    }
    
    // Si no hay conflictos, proceder con la asignación
    const result = await db.query(
      `INSERT INTO project_assignments (project_id, employee_id, role, start_date, end_date, hours_allocated)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING id, project_id, employee_id, role, start_date, end_date, hours_allocated, created_at`,
      [id, employee_id, role || null, start_date || null, end_date || null, hours_allocated || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating project assignment:', err);
    res.status(500).json({ error: 'Error creating project assignment' });
  }
});

// Update project assignment
app.put('/api/projects/assignments/:assignmentId', async (req, res) => {
  const { assignmentId } = req.params;
  const { role, start_date, end_date, hours_allocated } = req.body;
  
  try {
    const result = await db.query(
      `UPDATE project_assignments 
       SET role = COALESCE($1, role),
           start_date = COALESCE($2, start_date),
           end_date = COALESCE($3, end_date),
           hours_allocated = COALESCE($4, hours_allocated)
       WHERE id = $5
       RETURNING *`,
      [role, start_date, end_date, hours_allocated, assignmentId]
    );
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Assignment not found' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error updating assignment:', err);
    res.status(500).json({ error: 'Error updating assignment' });
  }
});

// Remove employee from project
app.delete('/api/projects/:projectId/assignments/:assignmentId', async (req, res) => {
  const { assignmentId } = req.params;
  try {
    const result = await db.query('DELETE FROM project_assignments WHERE id = $1', [assignmentId]);
    
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Assignment not found' });
    }
    
    res.json({ success: true, message: 'Assignment deleted successfully' });
  } catch (err) {
    console.error('Error deleting assignment:', err);
    res.status(500).json({ error: 'Error deleting assignment' });
  }
});

// Get assignments by employee (project history)
app.get('/api/employees/:id/assignments', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query(
      `SELECT 
        pa.id,
        pa.project_id,
        p.name as project_name,
        p.description as project_description,
        p.status as project_status,
        pa.role as role_in_project,
        pa.start_date,
        pa.end_date,
        pa.hours_allocated,
        CASE 
          WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE THEN true 
          ELSE false 
        END as is_active,
        pa.created_at
      FROM project_assignments pa
      INNER JOIN projects p ON pa.project_id = p.id
      WHERE pa.employee_id = $1
      ORDER BY pa.start_date DESC`,
      [id]
    );
    
    // Calculate summary
    const activeAssignments = result.rows.filter(a => a.is_active);
    const completedAssignments = result.rows.filter(a => !a.is_active);
    const totalHours = result.rows.reduce((sum, a) => sum + (parseFloat(a.hours_allocated) || 0), 0);
    const activeHours = activeAssignments.reduce((sum, a) => sum + (parseFloat(a.hours_allocated) || 0), 0);
    
    res.json({
      assignments: result.rows,
      summary: {
        total_projects: result.rows.length,
        active_projects: activeAssignments.length,
        completed_projects: completedAssignments.length,
        total_hours_allocated: totalHours,
        active_hours: activeHours,
        average_hours_per_week: result.rows.length > 0 ? (totalHours / result.rows.length).toFixed(2) : 0
      }
    });
  } catch (err) {
    console.error('Error fetching employee assignments:', err);
    res.status(500).json({ error: 'Error fetching employee assignments' });
  }
});

// Get unassigned employees (resources on bench)
app.get('/api/employees/unassigned', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT 
        e.id,
        CONCAT(e.first_name, ' ', e.last_name) as nombre_completo,
        e.email,
        e.status,
        pos.item as position_name,
        area.item as area_name,
        ent.item as entity_name,
        MAX(pa.end_date) as last_assignment_end,
        CASE 
          WHEN MAX(pa.end_date) IS NOT NULL 
          THEN CURRENT_DATE - MAX(pa.end_date) 
          ELSE NULL 
        END as days_without_project
      FROM employees_v2 e
      LEFT JOIN mastercode pos ON e.position_id = pos.id
      LEFT JOIN mastercode area ON e.area_id = area.id
      LEFT JOIN mastercode ent ON e.entity_id = ent.id
      LEFT JOIN project_assignments pa ON e.id = pa.employee_id
      WHERE e.status = 'Activo'
      GROUP BY e.id, e.first_name, e.last_name, e.email, e.status, pos.item, area.item, ent.item
      HAVING COUNT(CASE 
        WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE 
        THEN 1 
      END) = 0
      ORDER BY last_assignment_end DESC NULLS LAST`,
      []
    );
    
    res.json({
      bench_resources: result.rows,
      total_available: result.rows.length
    });
  } catch (err) {
    console.error('Error fetching unassigned employees:', err);
    res.status(500).json({ error: 'Error fetching unassigned employees' });
  }
});

// ========== REPORTES ==========

// Reporte: Recursos agrupados por Proyecto
app.get('/api/reports/resources-by-project', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT 
        p.id as project_id,
        p.name as project_name,
        p.area_id,
        mc_area.item as area_name,
        COUNT(DISTINCT pa.employee_id) as total_resources,
        COUNT(DISTINCT CASE 
          WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE 
          THEN pa.employee_id 
        END) as active_resources,
        COALESCE(SUM(CASE 
          WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE 
          THEN pa.hours_allocated 
        END), 0) as total_active_hours,
        json_agg(
          json_build_object(
            'employee_id', e.id,
            'employee_name', e.first_name || ' ' || e.last_name,
            'position', mc_position.item,
            'role', pa.role,
            'start_date', pa.start_date,
            'end_date', pa.end_date,
            'hours_allocated', pa.hours_allocated,
            'is_active', CASE 
              WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE 
              THEN true 
              ELSE false 
            END
          ) ORDER BY pa.start_date DESC
        ) as resources
       FROM projects p
       LEFT JOIN mastercode mc_area ON p.area_id = mc_area.id AND mc_area.lista = 'Areas'
       LEFT JOIN project_assignments pa ON p.id = pa.project_id
       LEFT JOIN employees_v2 e ON pa.employee_id = e.id
       LEFT JOIN mastercode mc_position ON e.position_id = mc_position.id
       GROUP BY p.id, p.name, p.area_id, mc_area.item
       ORDER BY p.name`
    );
    
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching resources by project report:', err);
    res.status(500).json({ error: 'Error generating report' });
  }
});

// Reporte: Proyectos agrupados por Recurso
app.get('/api/reports/projects-by-resource', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT 
        e.id as employee_id,
        e.first_name || ' ' || e.last_name as employee_name,
        e.employee_code,
        mc_position.item as position,
        mc_area.item as area,
        mc_entity.item as entity,
        e.status as employee_status,
        COUNT(DISTINCT pa.project_id) as total_projects,
        COUNT(DISTINCT CASE 
          WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE 
          THEN pa.project_id 
        END) as active_projects,
        COALESCE(SUM(CASE 
          WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE 
          THEN pa.hours_allocated 
        END), 0) as total_active_hours,
        json_agg(
          json_build_object(
            'project_id', p.id,
            'project_name', p.name,
            'role', pa.role,
            'start_date', pa.start_date,
            'end_date', pa.end_date,
            'hours_allocated', pa.hours_allocated,
            'is_active', CASE 
              WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE 
              THEN true 
              ELSE false 
            END
          ) ORDER BY pa.start_date DESC
        ) FILTER (WHERE pa.id IS NOT NULL) as projects
       FROM employees_v2 e
       LEFT JOIN project_assignments pa ON e.id = pa.employee_id
       LEFT JOIN projects p ON pa.project_id = p.id
       LEFT JOIN mastercode mc_position ON e.position_id = mc_position.id
       LEFT JOIN mastercode mc_area ON e.area_id = mc_area.id
       LEFT JOIN mastercode mc_entity ON e.entity_id = mc_entity.id
       WHERE e.status = 'Activo'
       GROUP BY e.id, e.first_name, e.last_name, e.employee_code, 
                mc_position.item, mc_area.item, mc_entity.item, e.status
       ORDER BY employee_name`
    );
    
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching projects by resource report:', err);
    res.status(500).json({ error: 'Error generating report' });
  }
});

// Reporte: Resumen general de asignaciones
app.get('/api/reports/assignment-summary', async (req, res) => {
  try {
    const summary = await db.query(
      `SELECT 
        (SELECT COUNT(*) FROM employees_v2 WHERE status = 'Activo') as total_active_employees,
        (SELECT COUNT(*) FROM projects) as total_active_projects,
        (SELECT COUNT(DISTINCT employee_id) FROM project_assignments 
         WHERE end_date IS NULL OR end_date >= CURRENT_DATE) as employees_with_active_assignments,
        (SELECT COUNT(DISTINCT project_id) FROM project_assignments 
         WHERE end_date IS NULL OR end_date >= CURRENT_DATE) as projects_with_active_assignments,
        (SELECT COUNT(*) FROM employees_v2 e
         WHERE e.status = 'Activo' 
         AND NOT EXISTS (
           SELECT 1 FROM project_assignments pa 
           WHERE pa.employee_id = e.id 
           AND (pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE)
         )) as employees_in_bench,
        (SELECT COALESCE(SUM(hours_allocated), 0) FROM project_assignments
         WHERE end_date IS NULL OR end_date >= CURRENT_DATE) as total_active_hours`
    );
    
    // Proyectos con más recursos
    const topProjects = await db.query(
      `SELECT p.name, COUNT(DISTINCT pa.employee_id) as resource_count
       FROM projects p
       INNER JOIN project_assignments pa ON p.id = pa.project_id
       WHERE pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE
       GROUP BY p.id, p.name
       ORDER BY resource_count DESC
       LIMIT 5`
    );
    
    // Recursos más activos
    const topResources = await db.query(
      `SELECT 
        e.first_name || ' ' || e.last_name as employee_name,
        COUNT(DISTINCT pa.project_id) as project_count,
        COALESCE(SUM(pa.hours_allocated), 0) as total_hours
       FROM employees_v2 e
       INNER JOIN project_assignments pa ON e.id = pa.employee_id
       WHERE pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE
       GROUP BY e.id, e.first_name, e.last_name
       ORDER BY total_hours DESC
       LIMIT 5`
    );
    
    res.json({
      summary: summary.rows[0],
      top_projects: topProjects.rows,
      top_resources: topResources.rows
    });
  } catch (err) {
    console.error('Error fetching assignment summary:', err);
    res.status(500).json({ error: 'Error generating summary' });
  }
});

app.listen(PORT, '127.0.0.1', () => {
  console.log(`API server listening on port ${PORT}`);
});

