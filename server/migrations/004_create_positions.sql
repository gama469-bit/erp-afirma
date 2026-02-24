-- Crear tabla de puestos/posiciones
CREATE TABLE IF NOT EXISTS positions (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
  salary_min DECIMAL(10,2),
  salary_max DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agregar índices
CREATE INDEX idx_positions_name ON positions(name);
CREATE INDEX idx_positions_department_id ON positions(department_id);

-- Insertar posiciones comunes
INSERT INTO positions (name, description, department_id) VALUES
  ('Desarrollador Senior', 'Desarrollador con experiencia en backend', 1),
  ('Desarrollador Junior', 'Desarrollador en formación', 1),
  ('DevOps Engineer', 'Especialista en infraestructura y deployment', 1),
  ('Diseñador UX/UI', 'Diseñador de interfaz y experiencia de usuario', 2),
  ('Diseñador Gráfico', 'Diseño gráfico y branding', 2),
  ('Project Manager', 'Gestor de proyectos', 3),
  ('Director Ejecutivo', 'Dirección ejecutiva', 3),
  ('Especialista RRHH', 'Gestión de recursos humanos', 4),
  ('Contabilista', 'Gestión contable y financiera', 5),
  ('Ejecutivo de Ventas', 'Vendedor de productos y servicios', 6),
  ('Técnico de Soporte', 'Soporte técnico a clientes', 7)
ON CONFLICT DO NOTHING;
