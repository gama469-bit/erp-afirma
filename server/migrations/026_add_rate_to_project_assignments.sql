-- Agregar campo rate (tarifa) a project_assignments
ALTER TABLE project_assignments 
ADD COLUMN IF NOT EXISTS rate NUMERIC(10,2) DEFAULT 0.00;

COMMENT ON COLUMN project_assignments.rate IS 'Tarifa por hora o tarifa del recurso en este proyecto';
