-- Catálogos: áreas, proyectos y células; y relación en employees_v2
BEGIN;

-- Crear tabla areas
CREATE TABLE IF NOT EXISTS areas (
  id SERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_areas_name ON areas(name);

-- Crear tabla projects
CREATE TABLE IF NOT EXISTS projects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  area_id INTEGER REFERENCES areas(id) ON DELETE CASCADE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(name, area_id)
);
CREATE INDEX IF NOT EXISTS idx_projects_area_id ON projects(area_id);
CREATE INDEX IF NOT EXISTS idx_projects_name ON projects(name);

-- Crear tabla cells (células)
CREATE TABLE IF NOT EXISTS cells (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  area_id INTEGER REFERENCES areas(id) ON DELETE SET NULL,
  project_id INTEGER REFERENCES projects(id) ON DELETE SET NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(name, area_id, project_id)
);
CREATE INDEX IF NOT EXISTS idx_cells_area_id ON cells(area_id);
CREATE INDEX IF NOT EXISTS idx_cells_project_id ON cells(project_id);
CREATE INDEX IF NOT EXISTS idx_cells_name ON cells(name);

-- Alter employees_v2 para agregar llaves foráneas opcionales
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns WHERE table_name='employees_v2' AND column_name='area_id'
  ) THEN
    ALTER TABLE employees_v2 ADD COLUMN area_id INTEGER REFERENCES areas(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns WHERE table_name='employees_v2' AND column_name='project_id'
  ) THEN
    ALTER TABLE employees_v2 ADD COLUMN project_id INTEGER REFERENCES projects(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns WHERE table_name='employees_v2' AND column_name='cell_id'
  ) THEN
    ALTER TABLE employees_v2 ADD COLUMN cell_id INTEGER REFERENCES cells(id) ON DELETE SET NULL;
  END IF;
END$$;

-- Índices de soporte
CREATE INDEX IF NOT EXISTS idx_employees_v2_area_id ON employees_v2(area_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_project_id ON employees_v2(project_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_cell_id ON employees_v2(cell_id);

COMMIT;
