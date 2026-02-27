-- Agregar campo ot_id a project_assignments para asignaciones específicas a OTs
-- Permite asignaciones a nivel de OT (cuando ot_id tiene valor) o proyecto (cuando ot_id es NULL)

ALTER TABLE project_assignments 
ADD COLUMN IF NOT EXISTS ot_id INTEGER REFERENCES orders_of_work(id) ON DELETE CASCADE;

-- Agregar allocation_percentage si no existe (para compatibilidad)
ALTER TABLE project_assignments 
ADD COLUMN IF NOT EXISTS allocation_percentage NUMERIC(5,2) DEFAULT 100;

-- Índice para mejorar el rendimiento de consultas por OT
CREATE INDEX IF NOT EXISTS idx_project_assignments_ot_id ON project_assignments(ot_id);

-- Comentarios para documentación
COMMENT ON COLUMN project_assignments.ot_id IS 'ID de la orden de trabajo específica (NULL = asignación directa a proyecto)';
COMMENT ON COLUMN project_assignments.allocation_percentage IS 'Porcentaje de dedicación del recurso (0-100)';
