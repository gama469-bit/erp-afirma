-- Agregar columnas CELULA y COSTO ASIGNADO a la tabla projects
-- Migración 031: Relación de proyecto con célula organizacional y presupuesto asignado

-- 1. Agregar columna celula_id (relación con mastercode lista='Celulas')
ALTER TABLE projects ADD COLUMN IF NOT EXISTS celula_id INTEGER;

-- 2. Crear FK a mastercode para celula
ALTER TABLE projects 
  ADD CONSTRAINT fk_projects_celula 
  FOREIGN KEY (celula_id) 
  REFERENCES mastercode(id) 
  ON DELETE SET NULL;

-- 3. Agregar índice para mejor performance en búsquedas por célula
CREATE INDEX IF NOT EXISTS idx_projects_celula_id ON projects(celula_id);

-- 4. Agregar columna costo_asignado (monto asignado de venta)
ALTER TABLE projects ADD COLUMN IF NOT EXISTS costo_asignado NUMERIC(15, 2);

-- 5. Comentarios para documentación
COMMENT ON COLUMN projects.celula_id IS 'ID de la célula organizacional a la que pertenece el proyecto (FK a mastercode lista=Celulas)';
COMMENT ON COLUMN projects.costo_asignado IS 'Monto asignado de venta del proyecto (presupuesto inicial)';

-- 6. Eliminar columnas geográficas innecesarias (si existen)
ALTER TABLE projects DROP COLUMN IF EXISTS city CASCADE;
ALTER TABLE projects DROP COLUMN IF EXISTS state CASCADE;
ALTER TABLE projects DROP COLUMN IF EXISTS country CASCADE;
