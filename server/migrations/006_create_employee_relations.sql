-- Tabla de auditoría de cambios en empleados
CREATE TABLE IF NOT EXISTS employee_audit_log (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
  action VARCHAR(50) NOT NULL, -- INSERT, UPDATE, DELETE
  field_name VARCHAR(100),
  old_value TEXT,
  new_value TEXT,
  changed_by VARCHAR(100),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para auditoría
CREATE INDEX idx_audit_employee_id ON employee_audit_log(employee_id);
CREATE INDEX idx_audit_changed_at ON employee_audit_log(changed_at);
CREATE INDEX idx_audit_action ON employee_audit_log(action);

-- Tabla de contactos de emergencia
CREATE TABLE IF NOT EXISTS emergency_contacts (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
  contact_name VARCHAR(100) NOT NULL,
  relationship VARCHAR(50), -- Familiar, Amigo, etc.
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(120),
  address TEXT,
  priority INT DEFAULT 1, -- 1 = principal, 2 = secundario
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_emergency_contacts_employee_id ON emergency_contacts(employee_id);

-- Tabla de documentos de empleado
CREATE TABLE IF NOT EXISTS employee_documents (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
  document_type VARCHAR(100), -- Cédula, Pasaporte, Licencia, etc.
  document_number VARCHAR(50),
  issue_date DATE,
  expiry_date DATE,
  document_file_path VARCHAR(255),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_employee_documents_employee_id ON employee_documents(employee_id);
CREATE INDEX idx_employee_documents_type ON employee_documents(document_type);

-- Tabla de historial de salarios
CREATE TABLE IF NOT EXISTS salary_history (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
  salary_amount DECIMAL(12,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'COP',
  effective_date DATE NOT NULL,
  reason VARCHAR(255), -- Aumento, Ajuste anual, etc.
  notes TEXT,
  created_by VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_salary_history_employee_id ON salary_history(employee_id);
CREATE INDEX idx_salary_history_effective_date ON salary_history(effective_date);
