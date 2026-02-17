-- Tabla mejorada de empleados con relaciones normalizadas
CREATE TABLE IF NOT EXISTS employees_v2 (
  id SERIAL PRIMARY KEY,
  -- Datos personales
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  phone VARCHAR(20),
  personal_phone VARCHAR(20),
  
  -- Datos de empresa
  employee_code VARCHAR(20) UNIQUE,
  position_id INTEGER REFERENCES positions(id) ON DELETE SET NULL,
  entity_id INTEGER REFERENCES entities(id) ON DELETE SET NULL,
  
  -- Fechas
  hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
  start_date DATE,
  birth_date DATE,
  
  -- Información de contacto
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  postal_code VARCHAR(10),
  country VARCHAR(100) DEFAULT 'Colombia',
  
  -- Información contractual
  employment_type VARCHAR(50) DEFAULT 'Permanente', -- Permanente, Temporal, Contratista
  contract_end_date DATE,
  
  -- Estado
  status VARCHAR(50) DEFAULT 'Activo', -- Activo, Inactivo, En licencia, Suspendido
  
  -- Auditoría
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by VARCHAR(100),
  updated_by VARCHAR(100),
  
  -- Constraints
  CONSTRAINT valid_email CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
  CONSTRAINT valid_phone CHECK (phone IS NULL OR phone ~ '^[0-9\-\+\(\)]{7,}$'),
  CONSTRAINT hire_date_not_future CHECK (hire_date <= CURRENT_DATE),
  CONSTRAINT valid_employment_type CHECK (employment_type IN ('Permanente', 'Temporal', 'Contratista')),
  CONSTRAINT valid_status CHECK (status IN ('Activo', 'Inactivo', 'En licencia', 'Suspendido'))
);

-- Crear índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_employees_v2_email ON employees_v2(email);
CREATE INDEX IF NOT EXISTS idx_employees_v2_employee_code ON employees_v2(employee_code);
CREATE INDEX IF NOT EXISTS idx_employees_v2_position ON employees_v2(position_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_entity ON employees_v2(entity_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_status ON employees_v2(status);
CREATE INDEX idx_employees_v2_hire_date ON employees_v2(hire_date);
CREATE INDEX idx_employees_v2_first_name ON employees_v2(first_name);
CREATE INDEX idx_employees_v2_last_name ON employees_v2(last_name);

-- Crear índice FULLTEXT para búsquedas por nombre completo (opcional, requiere extensión)
CREATE INDEX idx_employees_v2_fullname ON employees_v2 USING btree (lower(first_name || ' ' || last_name));
