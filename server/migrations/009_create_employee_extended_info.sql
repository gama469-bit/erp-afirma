-- Migración 009: Crear tablas normalizadas para información bancaria y contratación

-- Tabla para información bancaria de empleados
CREATE TABLE IF NOT EXISTS employee_banking_info (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
    bank_name VARCHAR(255) NOT NULL,
    account_holder_name VARCHAR(255) NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    clabe_interbancaria VARCHAR(18),
    clabe_document_path VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, is_active) -- Solo una cuenta activa por empleado
);

-- Tabla para esquemas de contratación (catálogo)
CREATE TABLE IF NOT EXISTS contract_schemes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para tipos de contrato (catálogo)
CREATE TABLE IF NOT EXISTS contract_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para información de contratación de empleados
CREATE TABLE IF NOT EXISTS employee_contracts (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
    contract_type_id INTEGER REFERENCES contract_types(id),
    obra VARCHAR(255),
    contract_document_path VARCHAR(500),
    contract_scheme_id INTEGER REFERENCES contract_schemes(id),
    initial_rate DECIMAL(12,2),
    gross_monthly_salary DECIMAL(12,2),
    net_monthly_salary DECIMAL(12,2),
    company_cost DECIMAL(12,2),
    start_date DATE,
    end_date DATE,
    termination_reason TEXT,
    is_rehireable BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Extender tabla employees_v2 con campos de dirección
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS address_street VARCHAR(255);
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS address_city VARCHAR(100);
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS address_state VARCHAR(100);
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS address_postal_code VARCHAR(20);
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS address_country VARCHAR(100) DEFAULT 'México';

-- Índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_employee_banking_employee_id ON employee_banking_info(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_banking_active ON employee_banking_info(employee_id, is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_employee_contracts_employee_id ON employee_contracts(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_contracts_active ON employee_contracts(employee_id, is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_employee_contracts_dates ON employee_contracts(start_date, end_date);

-- Seed inicial para esquemas y tipos de contrato
INSERT INTO contract_schemes (name, description) VALUES 
('Nómina', 'Empleado en nómina tradicional'),
('Honorarios', 'Esquema de honorarios profesionales'),
('Mixto', 'Esquema mixto nómina + honorarios'),
('Outsourcing', 'Esquema de tercerización')
ON CONFLICT (name) DO NOTHING;

INSERT INTO contract_types (name, description) VALUES 
('Indefinido', 'Contrato por tiempo indefinido'),
('Temporal', 'Contrato temporal o por obra determinada'),
('Proyecto', 'Contrato por proyecto específico'),
('Práctica', 'Contrato de práctica profesional'),
('Consultoría', 'Contrato de consultoría externa')
ON CONFLICT (name) DO NOTHING;

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_employee_banking_info_updated_at ON employee_banking_info;
CREATE TRIGGER update_employee_banking_info_updated_at 
    BEFORE UPDATE ON employee_banking_info 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_employee_contracts_updated_at ON employee_contracts;
CREATE TRIGGER update_employee_contracts_updated_at 
    BEFORE UPDATE ON employee_contracts 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();