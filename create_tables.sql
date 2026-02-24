-- Script completo para crear todas las tablas del ERP Afirma
-- Ejecutar en Cloud SQL

\c BD_afirma;

-- 1. Tabla de empleados (legacy)
CREATE TABLE IF NOT EXISTS employees (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  position VARCHAR(100),
  start_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla de candidatos
CREATE TABLE IF NOT EXISTS candidates (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20),
  position_applied VARCHAR(100) NOT NULL,
  status VARCHAR(50) DEFAULT 'En revisión', 
  notes TEXT,
  application_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT valid_status CHECK (status IN ('En revisión', 'Entrevista', 'Oferta', 'Rechazado', 'Contratado'))
);

-- 3. Tabla mastercode (catálogos)
CREATE TABLE IF NOT EXISTS mastercode (
  id SERIAL PRIMARY KEY,
  category VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(category, name)
);

-- 4. Tabla de tipos de contrato
CREATE TABLE IF NOT EXISTS contract_types (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabla de esquemas de contrato  
CREATE TABLE IF NOT EXISTS contract_schemes (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Tabla de empleados v2 (normalizada)
CREATE TABLE IF NOT EXISTS employees_v2 (
  id SERIAL PRIMARY KEY,
  -- Datos personales
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(120),
  phone VARCHAR(20),
  personal_phone VARCHAR(20),
  birth_date DATE,
  
  -- Datos de empresa
  employee_code VARCHAR(20) UNIQUE,
  position_id INTEGER,
  entity_id INTEGER,
  area_id INTEGER,
  project_id INTEGER,
  cell_id INTEGER,
  
  -- Direccion
  address VARCHAR(255),
  exterior_number VARCHAR(10),
  interior_number VARCHAR(10),
  colonia VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(100),
  postal_code VARCHAR(10),
  country VARCHAR(100) DEFAULT 'México',
  
  -- Expediente
  curp VARCHAR(18),
  rfc VARCHAR(13),
  nss VARCHAR(11),
  passport VARCHAR(20),
  gender VARCHAR(1) CHECK (gender IN ('M', 'F')),
  marital_status VARCHAR(20),
  nationality VARCHAR(50),
  blood_type VARCHAR(5),
  
  -- Estado y fechas
  status VARCHAR(50) DEFAULT 'Activo',
  hire_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by VARCHAR(100)
);

-- 7. Tabla de contratos de empleados
CREATE TABLE IF NOT EXISTS employee_contracts (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
  contract_type_id INTEGER REFERENCES contract_types(id),
  obra VARCHAR(255),
  contract_scheme_id INTEGER REFERENCES contract_schemes(id),
  initial_rate DECIMAL(10,2),
  gross_monthly_salary DECIMAL(10,2),
  net_monthly_salary DECIMAL(10,2),
  company_cost DECIMAL(10,2),
  start_date DATE,
  end_date DATE,
  termination_reason TEXT,
  is_rehireable BOOLEAN DEFAULT TRUE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Tabla de información bancaria
CREATE TABLE IF NOT EXISTS employee_banking (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
  bank_name VARCHAR(100),
  account_holder_name VARCHAR(200),
  account_number VARCHAR(50),
  clabe_interbancaria VARCHAR(18),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(employee_id)
);

-- Insertar datos básicos de mastercode
INSERT INTO mastercode (category, name) VALUES
('Entidad', 'Corporativo'),
('Entidad', 'Filial México'),
('Entidad', 'Filial Colombia'),
('Puestos roles', 'Desarrollador Senior'),
('Puestos roles', 'Analista de Sistemas'),
('Puestos roles', 'Gerente de Proyecto'),
('Puestos roles', 'Administrador de BD'),
('Areas', 'Desarrollo'),
('Areas', 'Sistemas'),
('Areas', 'Administración'),
('Areas', 'Recursos Humanos'),
('Proyecto', 'ERP Afirma'),
('Proyecto', 'Sistema Comercial'),
('Proyecto', 'Portal Web'),
('Celulas', 'Backend'),
('Celulas', 'Frontend'),
('Celulas', 'DevOps'),
('Celulas', 'QA')
ON CONFLICT (category, name) DO NOTHING;

-- Insertar tipos de contrato básicos
INSERT INTO contract_types (name, description) VALUES
('Indefinido', 'Contrato por tiempo indefinido'),
('Temporal', 'Contrato temporal con fecha de fin'),
('Obra', 'Contrato por obra determinada'),
('Servicios Profesionales', 'Contrato de prestación de servicios')
ON CONFLICT (name) DO NOTHING;

-- Insertar esquemas de contrato básicos  
INSERT INTO contract_schemes (name, description) VALUES
('Nómina', 'Empleado en nómina tradicional'),
('Honorarios', 'Pago por honorarios'),
('Mixto', 'Esquema mixto nómina/honorarios'),
('Outsourcing', 'Esquema de tercerización')
ON CONFLICT (name) DO NOTHING;

-- Crear índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_employees_v2_position_id ON employees_v2(position_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_entity_id ON employees_v2(entity_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_status ON employees_v2(status);
CREATE INDEX IF NOT EXISTS idx_candidates_status ON candidates(status);
CREATE INDEX IF NOT EXISTS idx_mastercode_category ON mastercode(category);
CREATE INDEX IF NOT EXISTS idx_employee_contracts_employee_id ON employee_contracts(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_contracts_is_active ON employee_contracts(is_active);

-- Confirmar creación
SELECT 'Tablas creadas exitosamente' as resultado;
\dt