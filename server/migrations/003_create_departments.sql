-- Crear tabla de departamentos
CREATE TABLE IF NOT EXISTS departments (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  manager_id INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agregar índice en name para búsquedas rápidas
CREATE INDEX idx_departments_name ON departments(name);

-- Insertar departamentos comunes
INSERT INTO departments (name, description) VALUES
  ('Desarrollo', 'Equipo de desarrollo de software'),
  ('Diseño', 'Equipo de UX/UI y diseño gráfico'),
  ('Gestión', 'Equipo de dirección y gestión'),
  ('Recursos Humanos', 'Departamento de recursos humanos'),
  ('Finanzas', 'Departamento de finanzas'),
  ('Ventas', 'Equipo de ventas'),
  ('Soporte', 'Equipo de soporte técnico')
ON CONFLICT DO NOTHING;
